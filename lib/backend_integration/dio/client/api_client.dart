import 'package:dio/dio.dart';

import '../interceptors/global_headers_interceptor.dart';
import '../interceptors/retry_interceptor_config.dart';

/// DI key for the API client
const String apiClientKey = 'apiClient';

/// Default request timeout duration
const Duration defaultTimeout = Duration(seconds: 30);

/// Creates and configures a Dio client for API requests
///
/// Includes:
/// - Global headers (app version, etc.)
/// - Retry logic for failed requests
/// - Timeout configuration
/// - JSON content type by default
Dio createApiClient({
  required String baseUrl,
  Duration? connectTimeout,
  Duration? receiveTimeout,
  Duration? sendTimeout,
}) {
  final dio = Dio();

  // Configure base options
  dio.options = dio.options.copyWith(
    baseUrl: baseUrl,
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
    connectTimeout: connectTimeout ?? defaultTimeout,
    receiveTimeout: receiveTimeout ?? defaultTimeout,
    sendTimeout: sendTimeout ?? defaultTimeout,
  );

  // Add interceptors
  dio.interceptors.addAll([
    // Global headers (app version, platform, etc.)
    GlobalHeadersInterceptor(),

    // Retry logic for failed requests
    createRetryInterceptor(dio),

    // Add auth interceptor here when needed
    // AuthInterceptor(),
  ]);

  return dio;
}
