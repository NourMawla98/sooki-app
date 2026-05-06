import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../routes/route_constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/toast_service.dart';

class ErrorInterceptor extends Interceptor {
  final AuthService _authService;

  ErrorInterceptor(this._authService);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = _resolveMessage(err);

    if (err.response?.statusCode == 401) {
      _authService.signOut();
      ToastService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        signInScreenRoute,
        (_) => false,
      );
    } else {
      ToastService.instance.showError(message);
    }

    handler.next(err);
  }

  String _resolveMessage(DioException err) {
    if (err.error is SocketException) return tr('error.no_internet');

    if ({
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionTimeout,
      DioExceptionType.connectionError,
    }.contains(err.type)) {
      return tr('error.timeout');
    }

    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }

    return tr('error.generic');
  }
}
