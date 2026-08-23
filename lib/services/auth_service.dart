import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../backend_integration/dio/client/api_error_handler.dart';
import '../config/app_config.dart';
import 'language_service.dart';
import 'push_notification_service.dart';
import 'token_service.dart';

/// Tracks identity state (guest vs customer) derived from the stored JWT.
/// Every user always has a JWT — guest on first launch, customer after login.
class AuthService extends ChangeNotifier {
  bool _isCustomer = false;
  bool _isGuest = false;

  /// True when the user is a registered, logged-in customer.
  bool get isSignedIn => _isCustomer;
  bool get isCustomer => _isCustomer;

  /// True when the user is browsing as an anonymous guest.
  bool get isGuest => _isGuest;

  final _secureStorage = const FlutterSecureStorage();

  /// Run at startup. Ensures a valid JWT is always in storage.
  Future<void> restoreSession() async {
    final token = await TokenService.instance.getAccessToken();

    if (token == null) {
      await _runGuestAuth();
      return;
    }

    final expiresAt = await TokenService.instance.getAccessTokenExpiresAt();
    final nearExpiry = expiresAt == null ||
        DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));

    if (nearExpiry) {
      final refreshed = await _silentRefresh();
      if (!refreshed) await _runGuestAuth();
      return;
    }

    _applyToken(token);
    notifyListeners();
  }

  /// Called after successful login or register — saves the customer token pair.
  Future<void> signIn(Map<String, dynamic> tokenData) async {
    await _saveTokenData(tokenData);
    _isCustomer = true;
    _isGuest = false;
    // Everything the startup sync did under the guest JWT has to be redone
    // now that the customer JWT is live, or the account keeps the language
    // and the device token of whoever came before.
    if (GetIt.instance.isRegistered<LanguageService>()) {
      unawaited(GetIt.instance<LanguageService>().syncToBackend());
    }
    unawaited(PushNotificationService.instance.registerCurrentToken());
    notifyListeners();
  }

  /// Called after logout.
  /// If [guestTokenData] is provided (from logout API response), saves those tokens.
  /// Otherwise clears tokens and runs guest auth as fallback.
  Future<void> signOut({Map<String, dynamic>? guestTokenData}) async {
    // Unbind this device's push token while the customer JWT is still active.
    try {
      await PushNotificationService.instance.unregister();
    } catch (_) {
      // Best-effort — never block logout on token removal.
    }

    if (guestTokenData != null) {
      await _saveTokenData(guestTokenData);
      _isCustomer = false;
      _isGuest = true;
      notifyListeners();
    } else {
      await TokenService.instance.clearTokens();
      try {
        await _runGuestAuth();
      } catch (_) {
        // Guest auth failed as post-logout fallback — app stays in cleared state.
      }
    }
  }

  // ─── Token helpers ─────────────────────────────────────────────────────────

  void _applyToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return;
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final claims = jsonDecode(payload) as Map<String, dynamic>;
      final userType = claims['user_type'] as String?;
      _isCustomer = userType == 'customer';
      _isGuest = userType == 'guest';
    } catch (_) {
      _isCustomer = false;
      _isGuest = false;
    }
  }

  Future<void> _saveTokenData(Map<String, dynamic> data) async {
    await TokenService.instance.saveTokenPair(
      accessToken: (data['accessToken'] as String?) ?? '',
      refreshToken: (data['refreshToken'] as String?) ?? '',
      accessTokenExpiresAt: data['accessTokenExpiresAt'] as String?,
      refreshTokenExpiresAt: data['refreshTokenExpiresAt'] as String?,
    );
  }

  // ─── Silent refresh ─────────────────────────────────────────────────────────

  Future<bool> _silentRefresh() async {
    final refreshToken = await TokenService.instance.getRefreshToken();
    if (refreshToken == null) return false;
    try {
      final dio = _bareDio();
      final response = await dio.post(
        'auth/customer/refresh',
        data: {'refreshToken': refreshToken},
      );
      final body = response.data;
      if (body is Map<String, dynamic>) {
        final data = body['data'];
        if (data is Map<String, dynamic>) {
          await _saveTokenData(data);
          final newToken = data['accessToken'] as String?;
          if (newToken != null) _applyToken(newToken);
          notifyListeners();
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  // ─── Guest auth ─────────────────────────────────────────────────────────────

  Future<void> _runGuestAuth() async {
    try {
      final deviceId = await _getOrCreateDeviceId();
      final deviceModel = await _getDeviceModel();
      final deviceOs = await _getDeviceOs();
      final signature = _computeSignature(deviceId, deviceModel, deviceOs);

      final dio = _bareDio();
      final response = await dio.post(
        'auth/customer/guest',
        data: {
          'deviceId': deviceId,
          'deviceModel': deviceModel,
          'deviceOs': deviceOs,
        },
        options: Options(headers: {
          'X-App-Signature': signature,
          'X-Language': 'en',
        }),
      );

      final body = response.data;
      if (body is Map<String, dynamic>) {
        final data = body['data'];
        if (data is Map<String, dynamic>) {
          await _saveTokenData(data);
          _isGuest = true;
          _isCustomer = false;
          notifyListeners();
        }
      }
    } catch (e) {
      throw Exception(ApiErrorHandler.extractErrorMessage(e));
    }
  }

  // ─── Device info ────────────────────────────────────────────────────────────

  Future<String> _getOrCreateDeviceId() async {
    const key = 'sooki_device_id';
    final stored = await _secureStorage.read(key: key);
    if (stored != null) return stored;
    final id = _generateUuid();
    await _secureStorage.write(key: key, value: id);
    return id;
  }

  String _generateUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  Future<String> _getDeviceModel() async {
    try {
      final plugin = DeviceInfoPlugin();
      if (Platform.isAndroid) return (await plugin.androidInfo).model;
      if (Platform.isIOS) return (await plugin.iosInfo).model;
    } catch (_) {}
    return 'unknown';
  }

  Future<String> _getDeviceOs() async {
    try {
      final plugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final info = await plugin.androidInfo;
        return 'Android ${info.version.release}';
      }
      if (Platform.isIOS) {
        final info = await plugin.iosInfo;
        return 'iOS ${info.systemVersion}';
      }
    } catch (_) {}
    return 'unknown';
  }

  String _computeSignature(String deviceId, String deviceModel, String deviceOs) {
    final input = '$deviceId|$deviceModel|$deviceOs';
    final key = utf8.encode(AppConfig.appSecret);
    final data = utf8.encode(input);
    return Hmac(sha256, key).convert(data).toString();
  }

  Dio _bareDio() => Dio(BaseOptions(
        baseUrl: AppConfig.baseUrl,
        contentType: Headers.jsonContentType,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
}
