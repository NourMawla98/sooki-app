import 'package:dio/dio.dart';

import '../../../routes/route_constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/toast_service.dart';
import '../../../services/token_service.dart';

class AuthInterceptor extends Interceptor {
  final AuthService _authService;
  final Dio _dio;

  bool _isRefreshing = false;
  final _pending = <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  AuthInterceptor({required AuthService authService, required Dio dio})
      : _authService = authService,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenService.instance.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) return handler.next(err);

    // Refresh call itself failed → sign out, no retry
    if (err.requestOptions.path.contains('auth/customer/refresh')) {
      await _forceSignOut();
      return handler.reject(err);
    }

    // Already retried with a fresh token and still got 401 → sign out
    if (err.requestOptions.extra['isRetry'] == true) {
      await _forceSignOut();
      return handler.reject(err);
    }

    // Another refresh is in progress — queue this request
    if (_isRefreshing) {
      _pending.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;
    final newToken = await _tryRefresh();
    _isRefreshing = false;

    if (newToken != null) {
      await _retryRequest(err.requestOptions, newToken, handler);
      for (final p in _pending) {
        await _retryRequest(p.options, newToken, p.handler);
      }
    } else {
      await _forceSignOut();
      handler.reject(err);
      for (final p in _pending) {
        p.handler.reject(err);
      }
    }
    _pending.clear();
  }

  Future<void> _retryRequest(
    RequestOptions options,
    String newToken,
    ErrorInterceptorHandler handler,
  ) async {
    options.headers['Authorization'] = 'Bearer $newToken';
    options.extra['isRetry'] = true;
    try {
      final response = await _dio.fetch(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<String?> _tryRefresh() async {
    final refreshToken = await TokenService.instance.getRefreshToken();
    if (refreshToken == null) return null;

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          contentType: Headers.jsonContentType,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      final response = await refreshDio.post(
        'auth/customer/refresh',
        data: {'refreshToken': refreshToken},
      );

      final body = response.data;
      if (body is Map<String, dynamic>) {
        final data = body['data'];
        if (data is Map<String, dynamic>) {
          final newAccess = data['accessToken'] as String?;
          final newRefresh = data['refreshToken'] as String?;
          if (newAccess != null && newRefresh != null) {
            await TokenService.instance.saveTokens(
              accessToken: newAccess,
              refreshToken: newRefresh,
            );
            return newAccess;
          }
        }
      }
    } catch (_) {}

    return null;
  }

  Future<void> _forceSignOut() async {
    await _authService.signOut();
    ToastService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      signInScreenRoute,
      (_) => false,
    );
  }
}
