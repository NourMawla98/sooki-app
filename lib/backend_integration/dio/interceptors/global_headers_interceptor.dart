import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor that adds global headers to all API requests
///
/// Headers included:
/// - X-App-Version: Application version
/// - X-Platform: iOS, Android, Web, etc.
/// - X-Platform-Version: OS/Platform version
class GlobalHeadersInterceptor extends Interceptor {
  /// App version (e.g. "1.0.0"), captured once at startup from
  /// package_info_plus. `onRequest` is synchronous, so the value is cached
  /// here rather than fetched per request. Falls back until [init] runs.
  static String appVersion = '1.0.0';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-App-Version'] = appVersion;
    options.headers['X-Platform'] = _getPlatform();
    options.headers['X-Currency'] = 'USD';
    if (!kIsWeb) {
      options.headers['X-Platform-Version'] = _getPlatformVersion();
    }
    super.onRequest(options, handler);
  }

  /// Get the current platform name
  String _getPlatform() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
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
