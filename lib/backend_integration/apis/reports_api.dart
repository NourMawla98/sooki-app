import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';

@injectable
class ReportsApi {
  final Dio _dio;

  ReportsApi(@Named(apiClientKey) this._dio);

  /// Submit a customer report/complaint (`POST customer/reports`).
  /// Customer-only on the backend. Returns the BE's translated success message.
  Future<Either<ApiFailure, String>> createReport({
    required int category,
    required String subject,
    required String description,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'customer/reports',
      body: {
        'category': category,
        'subject': subject,
        'description': description,
      },
      operationName: 'createReport',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }
}
