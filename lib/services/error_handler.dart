import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

import 'toast_service.dart';

/// Universal error handler for non-Dio async failures (file I/O, parsing, etc.).
/// API/network errors are handled globally by [ErrorInterceptor].
class AppErrorHandler {
  AppErrorHandler._();

  static void handle(dynamic error, {String? message}) {
    final msg = message ?? _messageFor(error);
    ToastService.instance.showError(msg);
  }

  static String _messageFor(dynamic error) {
    if (error is SocketException || error is HttpException) {
      return tr('error.no_internet');
    }
    if (error is TimeoutException) return tr('error.timeout');
    return tr('error.generic');
  }
}
