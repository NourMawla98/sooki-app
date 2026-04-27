import 'dart:async';
import 'dart:io';

import 'toast_service.dart';

/// Universal error handler. Call [AppErrorHandler.handle] anywhere an async
/// operation can fail. It maps known error types to friendly messages and
/// surfaces them via the toast system.
class AppErrorHandler {
  AppErrorHandler._();

  /// Shows an error toast. Pass a custom [message] to override the default
  /// mapping, or pass only [error] to let the handler choose the message.
  static void handle(dynamic error, {String? message}) {
    final msg = message ?? _messageFor(error);
    ToastService.instance.showError(msg);
  }

  static String _messageFor(dynamic error) {
    if (error is SocketException || error is HttpException) {
      return 'No internet connection.';
    }
    if (error is TimeoutException) {
      return 'Request timed out. Try again.';
    }
    if (error is FormatException) {
      return 'Received an unexpected response.';
    }
    return 'Something went wrong. Please try again.';
  }
}
