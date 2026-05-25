import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/location/location_item_dto.dart';

@injectable
class LocationApi {
  final Dio _dio;

  LocationApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, List<LocationItemDto>>> getCountries() =>
      _fetchList('locations/countries', 'getCountries');

  Future<Either<ApiFailure, List<LocationItemDto>>> getProvinces(int countryId) =>
      _fetchList('locations/countries/$countryId/provinces', 'getProvinces');

  Future<Either<ApiFailure, List<LocationItemDto>>> getCities(int provinceId) =>
      _fetchList('locations/provinces/$provinceId/cities', 'getCities');

  Future<Either<ApiFailure, List<LocationItemDto>>> getAreas(int cityId) =>
      _fetchList('locations/cities/$cityId/areas', 'getAreas');

  Future<Either<ApiFailure, List<LocationItemDto>>> _fetchList(
      String path, String operationName) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: path,
      operationName: operationName,
      successParser: (response) {
        final raw = response.data['data'];
        return raw is List
            ? raw
                .whereType<Map<String, dynamic>>()
                .map(LocationItemDto.fromJson)
                .toList()
            : <LocationItemDto>[];
      },
    );
  }
}
