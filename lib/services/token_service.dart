import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  TokenService._();
  static final instance = TokenService._();

  final _storage = const FlutterSecureStorage();

  static const _accessKey = 'accessToken';
  static const _refreshKey = 'refreshToken';
  static const _accessExpiresKey = 'accessTokenExpiresAt';
  static const _refreshExpiresKey = 'refreshTokenExpiresAt';

  Future<void> saveTokenPair({
    required String accessToken,
    required String refreshToken,
    String? accessTokenExpiresAt,
    String? refreshTokenExpiresAt,
  }) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: accessToken),
      _storage.write(key: _refreshKey, value: refreshToken),
      if (accessTokenExpiresAt != null)
        _storage.write(key: _accessExpiresKey, value: accessTokenExpiresAt),
      if (refreshTokenExpiresAt != null)
        _storage.write(key: _refreshExpiresKey, value: refreshTokenExpiresAt),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);

  Future<DateTime?> getAccessTokenExpiresAt() async {
    final raw = await _storage.read(key: _accessExpiresKey);
    if (raw == null) return null;
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessKey),
      _storage.delete(key: _refreshKey),
      _storage.delete(key: _accessExpiresKey),
      _storage.delete(key: _refreshExpiresKey),
    ]);
  }
}
