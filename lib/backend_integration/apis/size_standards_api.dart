import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/item/size_standard_dto.dart';

@injectable
class SizeStandardsApi {
  final Dio _dio;

  SizeStandardsApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, List<SizeStandardDto>>> getSizeStandards() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/size-standards',
      operationName: 'getSizeStandards',
      successParser: (response) {
        final data = response.data['data'];
        if (data == null) return <SizeStandardDto>[];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(SizeStandardDto.fromJson)
              .toList();
        }
        return <SizeStandardDto>[];
      },
    );
  }
}
