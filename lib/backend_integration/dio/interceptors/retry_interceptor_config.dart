import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

/// Creates a retry interceptor with smart retry logic
///
/// Configuration:
/// - Retries: 2 attempts
/// - Retry delays: 200ms, 500ms (exponential backoff)
/// - Retryable status codes: 401 (for token refresh scenarios)
/// - Automatically retries on network errors and timeouts
RetryInterceptor createRetryInterceptor(Dio dio) {
  return RetryInterceptor(
    dio: dio,
    logPrint: (message) {
      // Log retry attempts for debugging
      // print('[Retry] $message');
    },
    retries: 2,
    retryDelays: const [
      Duration(milliseconds: 200),
      Duration(milliseconds: 500),
    ],
    // Retry 401 errors (useful for token refresh scenarios)
    retryableExtraStatuses: {401},
  );
}
