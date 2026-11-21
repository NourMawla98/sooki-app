import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/backend_integration/dio/client/request_executor.dart';

/// The Deals tab shows the sign in view, not an error, when the session is
/// missing or no longer allowed.

ApiFailure _failure(int? status) {
  final options = RequestOptions(path: 'customer/deals');
  return (
    message: 'failed',
    error: DioException(
      requestOptions: options,
      response: status == null
          ? null
          : Response(requestOptions: options, statusCode: status),
    ),
  );
}

void main() {
  test('401 and 403 are auth failures', () {
    expect(isAuthFailure(_failure(401)), isTrue);
    expect(isAuthFailure(_failure(403)), isTrue);
  });

  test('other failures are not', () {
    expect(isAuthFailure(_failure(500)), isFalse);
    expect(isAuthFailure(_failure(null)), isFalse);
    expect(isAuthFailure((message: 'x', error: Exception('x'))), isFalse);
  });
}
