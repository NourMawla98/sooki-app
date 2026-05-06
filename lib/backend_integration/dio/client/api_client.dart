import 'package:dio/dio.dart';

import '../../../services/auth_service.dart';
import '../../../services/language_service.dart';
import '../interceptors/error_interceptor.dart';
import '../interceptors/global_headers_interceptor.dart';
import '../interceptors/language_interceptor.dart';
import '../interceptors/retry_interceptor_config.dart';

/// DI key for the API client
const String apiClientKey = 'apiClient';

/// Default request timeout duration
const Duration defaultTimeout = Duration(seconds: 30);

Dio createApiClient({
  required String baseUrl,
  required LanguageService languageService,
  required AuthService authService,
  Duration? connectTimeout,
  Duration? receiveTimeout,
  Duration? sendTimeout,
}) {
  final dio = Dio();

  dio.options = dio.options.copyWith(
    baseUrl: baseUrl,
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
    connectTimeout: connectTimeout ?? defaultTimeout,
    receiveTimeout: receiveTimeout ?? defaultTimeout,
    sendTimeout: sendTimeout ?? defaultTimeout,
  );

  dio.interceptors.addAll([
    GlobalHeadersInterceptor(),
    LanguageInterceptor(languageService),
    createRetryInterceptor(dio),
    ErrorInterceptor(authService),
    // AuthInterceptor() — uncomment when JWT auth is implemented
  ]);

  return dio;
}
