import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/item/color_dto.dart';

@injectable
class ColorsApi {
  final Dio _dio;

  ColorsApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, List<ColorDto>>> getColors() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/colors',
      operationName: 'getColors',
      successParser: (response) {
        final data = response.data['data'];
        if (data == null) return <ColorDto>[];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(ColorDto.fromJson)
              .toList();
        }
        return <ColorDto>[];
      },
    );
  }
}
