import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/address/address_dto.dart';
import '../dtos/address/address_request_dto.dart';

@injectable
class AddressApi {
  final Dio _dio;

  AddressApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, List<AddressDto>>> getAddresses() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/addresses',
      operationName: 'getAddresses',
      successParser: (response) {
        final raw = response.data['data'];
        return raw is List
            ? raw.whereType<Map<String, dynamic>>().map(AddressDto.fromJson).toList()
            : <AddressDto>[];
      },
    );
  }

  Future<Either<ApiFailure, AddressDto>> getAddressById(int id) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/addresses/$id',
      operationName: 'getAddressById',
      successParser: (response) =>
          AddressDto.fromJson(response.data['data'] as Map<String, dynamic>),
    );
  }

  Future<Either<ApiFailure, String>> createAddress(AddressRequestDto dto) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'customer/addresses',
      body: dto.toJson(),
      operationName: 'createAddress',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  Future<Either<ApiFailure, String>> editAddress(int id, AddressRequestDto dto) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.put,
      path: 'customer/addresses/$id',
      body: dto.toJson(),
      operationName: 'editAddress',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  Future<Either<ApiFailure, String>> deleteAddress(int id) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.delete,
      path: 'customer/addresses/$id',
      operationName: 'deleteAddress',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  Future<Either<ApiFailure, String>> setDefault(int id) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.put,
      path: 'customer/addresses/$id/set-default',
      operationName: 'setDefaultAddress',
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }
}
