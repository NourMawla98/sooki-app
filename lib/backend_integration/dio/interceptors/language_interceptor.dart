import 'package:dio/dio.dart';

import '../../../services/language_service.dart';

/// Interceptor that adds the X-Language header to all API requests.
class LanguageInterceptor extends Interceptor {
  final LanguageService _languageService;

  LanguageInterceptor(this._languageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Language'] = _languageService.languageBackendValue;
    super.onRequest(options, handler);
  }
}
