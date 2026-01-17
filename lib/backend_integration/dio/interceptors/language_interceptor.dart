import 'package:dio/dio.dart';

import '../../../services/language_service.dart';

/// Interceptor that adds Language query parameter to all API requests
///
/// Automatically injects the current app language to every API call,
/// so individual API methods don't need to handle language manually.
class LanguageInterceptor extends Interceptor {
  final LanguageService _languageService;

  LanguageInterceptor(this._languageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add language to query params for every request
    options.queryParameters['Language'] = _languageService.languageBackendValue;
    super.onRequest(options, handler);
  }
}
