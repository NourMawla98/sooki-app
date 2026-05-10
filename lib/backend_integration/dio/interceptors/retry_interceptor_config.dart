import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

/// Creates a retry interceptor with smart retry logic
///
/// Configuration:
/// - Retries: 2 attempts
/// - Retry delays: 200ms, 500ms (exponential backoff)
/// - Automatically retries on network errors and timeouts
/// - 401 is NOT retried here — handled by AuthInterceptor
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
    retryableExtraStatuses: {},
  );
}
