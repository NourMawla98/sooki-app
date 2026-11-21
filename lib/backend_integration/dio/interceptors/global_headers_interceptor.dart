import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../services/app_version_gate.dart';

/// Interceptor that adds global headers to all API requests
///
/// Headers included:
/// - X-App-Name: which Sooki app is calling, so the backend can check its
///   version
/// - X-App-Version: Application version
/// - X-Platform: android or ios on a phone; Web, macOS and the like elsewhere
/// - X-Platform-Version: OS/Platform version
class GlobalHeadersInterceptor extends Interceptor {
  /// App version (e.g. "1.0.0"), captured once at startup from
  /// package_info_plus. `onRequest` is synchronous, so the value is cached
  /// here rather than fetched per request. Falls back until [init] runs.
  static String appVersion = '1.0.0';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-App-Name'] = AppVersionGate.appName;
    options.headers['X-App-Version'] = appVersion;
    options.headers['X-Platform'] = _getPlatform();
    options.headers['X-Currency'] = 'USD';
    if (!kIsWeb) {
      options.headers['X-Platform-Version'] = _getPlatformVersion();
    }
    super.onRequest(options, handler);
  }

  /// The platform name the version gate knows, android or ios, or empty on
  /// anything else.
  static String get versionPlatform {
    if (kIsWeb) return '';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return '';
  }

  /// Get the current platform name. Phones send the lowercase names the
  /// backend's version gate matches.
  String _getPlatform() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Get the platform version
  String _getPlatformVersion() {
    try {
      return Platform.operatingSystemVersion;
    } catch (_) {
      return 'Unknown';
    }
  }
}
