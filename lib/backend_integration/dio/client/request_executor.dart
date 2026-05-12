import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

import 'api_error_handler.dart';

/// Type alias for API failures containing user-friendly message and original error
typedef ApiFailure = ({String message, Object error});

/// Extension to check if an API failure was caused by request cancellation
extension ApiFailureExtension on ApiFailure {
  bool get isCancelled =>
      error is DioException &&
      (error as DioException).type == DioExceptionType.cancel;
}

/// Executes an API request with automatic error handling and logging
///
/// Returns [Either<ApiFailure, T>] where:
/// - Left: Contains error information (user message + original error)
/// - Right: Contains the successfully parsed response
///
/// Example:
/// ```dart
/// final result = await executeRequest<List<User>>(
///   client: dio,
///   method: HttpMethod.get,
///   path: 'users',
///   successParser: (response) {
///     return (response.data as List)
///       .map((json) => User.fromJson(json))
///       .toList();
///   },
///   operationName: 'fetchUsers',
/// );
/// ```
Future<Either<ApiFailure, T>> executeRequest<T>({
  required Dio client,
  required HttpMethod method,
  required String path,
  required T Function(Response response) successParser,
  required String operationName,
  Map<String, dynamic>? queryParameters,
  dynamic body,
  Map<String, dynamic>? headers,
  Map<String, dynamic>? extra,
  String? customErrorMessage,
  CancelToken? cancelToken,
  Logger? logger,
}) async {
  Response? response;
  final String methodName = method.value;

  // Log request details
  logger?.d(
    '[$operationName] Making $methodName request to $path',
  );

  try {
    response = await client.request(
      path,
      queryParameters: queryParameters,
      data: body,
      options: Options(
        headers: {...client.options.headers, ...?headers},
        method: methodName,
        extra: extra,
      ),
      cancelToken: cancelToken,
    );

    // Check for successful status codes (2xx)
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      logger?.d('[$operationName] Request successful: ${response.statusCode}');
      return right(successParser(response));
    } else {
      // Non-2xx status code - treat as error
      final errorMessage = _extractErrorFromResponse(response);

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: errorMessage,
        type: DioExceptionType.badResponse,
      );
    }
  } catch (error) {
    logger?.e('[$operationName] Request failed: $error');

    final String errorMessage = customErrorMessage ??
        ApiErrorHandler.extractErrorMessage(error);

    return left((message: errorMessage, error: error));
  }
}

/// Extracts error message from response data
String _extractErrorFromResponse(Response response) {
  try {
    final data = response.data;

    if (data is Map<String, dynamic>) {
      // Check for common error message fields
      if (data.containsKey('ErrorMessage')) {
        return data['ErrorMessage'] as String;
      }
      if (data.containsKey('message')) {
        return data['message'] as String;
      }
      if (data.containsKey('error')) {
        return data['error'] as String;
      }
    }

    return 'Request failed with status ${response.statusCode}';
  } catch (_) {
    return 'Request failed with status ${response.statusCode}';
  }
}

/// HTTP methods enum for type safety
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE'),
  head('HEAD'),
  options('OPTIONS');

  const HttpMethod(this.value);
  final String value;
}
