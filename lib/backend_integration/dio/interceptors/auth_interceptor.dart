// import 'package:dio/dio.dart';
//
// /// Interceptor for handling authentication tokens
// ///
// /// Features:
// /// - Adds Bearer token to request headers
// /// - Intercepts 401 errors and refreshes token
// /// - Retries failed requests with new token
// ///
// /// TODO: Implement when authentication is ready
// class AuthInterceptor extends Interceptor {
//   // TODO: Inject auth service/token manager via DI
//   // final AuthService _authService;
//   //
//   // AuthInterceptor(this._authService);
//
//   @override
//   Future<void> onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     // TODO: Get token from auth service
//     // final String? token = await _authService.getAccessToken();
//     //
//     // if (token != null && token.isNotEmpty) {
//     //   options.headers['Authorization'] = 'Bearer $token';
//     // }
//
//     super.onRequest(options, handler);
//   }
//
//   @override
//   Future<void> onError(
//     DioException err,
//     ErrorInterceptorHandler handler,
//   ) async {
//     // TODO: Handle token refresh on 401 errors
//     // if (err.response?.statusCode == 401) {
//     //   // Check if this is already a refresh token request
//     //   if (err.requestOptions.path.contains('refresh-token')) {
//     //     // Token refresh failed - sign out user
//     //     return handler.reject(err);
//     //   }
//     //
//     //   try {
//     //     // Refresh the token
//     //     final newToken = await _authService.refreshToken();
//     //
//     //     if (newToken != null) {
//     //       // Update the failed request with new token
//     //       err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
//     //
//     //       // Retry the request
//     //       final response = await Dio().fetch(err.requestOptions);
//     //       return handler.resolve(response);
//     //     }
//     //   } catch (refreshError) {
//     //     // Refresh failed - sign out user
//     //     return handler.reject(err);
//     //   }
//     // }
//
//     super.onError(err, handler);
//   }
// }
