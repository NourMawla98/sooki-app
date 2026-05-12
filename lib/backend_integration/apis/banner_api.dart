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
  /// Returns a list with one banner for the given type, or empty if none configured.
  Future<Either<ApiFailure, List<BannerDto>>> getBanners({
    required BannerType type,
  }) async {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/banners',
      queryParameters: {'Type': type.value},
      operationName: 'getBanners',
      successParser: (response) {
        final data = response.data['data'];
        if (data == null) return <BannerDto>[];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(BannerDto.fromJson)
              .toList();
        }
        return <BannerDto>[];
      },
    );
  }
}
