import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/banner/banner_dto.dart';
import '../../enums/banner_type.dart';

/// API service for banner operations
@injectable
class BannerApi {
  final Dio _dio;

  BannerApi(@Named(apiClientKey) this._dio);

  /// Fetches banners for a specific banner type
  Future<Either<ApiFailure, List<BannerDto>>> getBanners({
    required BannerType type,
  }) async {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'client/banners',
      queryParameters: {'Type': type.value},
      operationName: 'getBanners',
      successParser: (response) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        return data
            .map((json) => BannerDto.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
