import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

/// Extracts a user-facing error message from a [DioException].
///
/// Used by [executeRequest] to populate the [ApiFailure] message.
/// Toast display is handled globally by [ErrorInterceptor] — callers
/// must not show an additional toast from this message.
class ApiErrorHandler {
  const ApiErrorHandler._();

  static String extractErrorMessage(Object error) {
    if (error is String) return error;
    if (error is! DioException) return tr('error.generic');

    if (error.error is SocketException) return tr('error.no_internet');

    if ({
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionTimeout,
      DioExceptionType.connectionError,
    }.contains(error.type)) {
      return tr('error.timeout');
    }

    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }

    return tr('error.generic');
  }
}
