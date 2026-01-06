import 'dart:io';

import 'package:dio/dio.dart';

/// Centralized error handling for API requests
class ApiErrorHandler {
  const ApiErrorHandler._();

  // User-friendly error messages
  static const String defaultError = 'Something went wrong. Please try again.';
  static const String sessionExpired =
      'Your session has expired. Please sign in again.';
  static const String connectionTimeout =
      'Connection timed out. Please check your internet and try again.';
  static const String networkError =
      'Unable to connect. Please check your internet connection.';
  static const String serverError = 'Server error. Please try again later.';

  /// Extracts a user-friendly error message from any error object
  static String extractErrorMessage(Object error) {
    // Handle string errors directly
    if (error is String) return error;

    // Handle Dio exceptions
    if (error is! DioException) return defaultError;

    final dioException = error;

    // Network/Socket errors
    if (dioException.error is SocketException) return networkError;

    // Timeout errors
    if ({
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionTimeout,
      DioExceptionType.connectionError,
    }.contains(dioException.type)) {
      return connectionTimeout;
    }

    // Authentication errors
    if (dioException.response?.statusCode == 401) return sessionExpired;

    // Server errors (5xx)
    if (dioException.response?.statusCode != null &&
        dioException.response!.statusCode! >= 500) {
      return serverError;
    }

    // Try to extract error message from response
    try {
      final responseData = dioException.response?.data;

      // Check for ErrorMessage field (backend convention)
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('ErrorMessage')) {
        return responseData['ErrorMessage'] as String;
      }

      // Check for message field (common convention)
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('message')) {
        return responseData['message'] as String;
      }

      return defaultError;
    } catch (_) {
      return defaultError;
    }
  }
}
