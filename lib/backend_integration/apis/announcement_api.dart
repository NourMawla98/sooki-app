import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';

@injectable
class AnnouncementApi {
  final Dio _dio;

  AnnouncementApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, List<String>>> getAnnouncements() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/announcements',
      operationName: 'getAnnouncements',
      successParser: (response) {
        final body = response.data;
        if (body is! Map<String, dynamic>) return [];
        final data = body['data'];
        if (data is! List) return [];
        return data
            .whereType<Map<String, dynamic>>()
            .map((e) => e['message'] as String? ?? '')
            .where((msg) => msg.isNotEmpty)
            .toList();
      },
    );
  }
}
