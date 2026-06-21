import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/profile/profile_dto.dart';

@injectable
class ProfileApi {
  final Dio _dio;

  ProfileApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, ProfileDto>> getProfile() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/profile',
      operationName: 'getProfile',
      successParser: (response) {
        final data = response.data['data'];
        return ProfileDto.fromJson(data as Map<String, dynamic>);
      },
    );
  }

  Future<Either<ApiFailure, ({int ordersCount, int wishlistCount, int points})>> getStats() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/profile/stats',
      operationName: 'getProfileStats',
      successParser: (response) {
        final data = response.data['data'] as Map<String, dynamic>;
        return (
          ordersCount: data['ordersCount'] as int? ?? 0,
          wishlistCount: data['wishlistCount'] as int? ?? 0,
          points: data['points'] as int? ?? 0,
        );
      },
    );
  }

  Future<Either<ApiFailure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.put,
      path: 'customer/profile/change-password',
      operationName: 'changePassword',
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
      successParser: (response) => (response.data['message'] as String?) ?? '',
    );
  }

  Future<Either<ApiFailure, String>> deleteAccount() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.delete,
      path: 'customer/profile',
      operationName: 'deleteAccount',
      successParser: (response) => (response.data['message'] as String?) ?? '',
    );
  }

  Future<Either<ApiFailure, String>> updateProfile({
    required String firstName,
    required String lastName,
    String? phoneCountryCode,
    String? phoneNumber,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.put,
      path: 'customer/profile',
      operationName: 'updateProfile',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'phoneCountryCode': ?phoneCountryCode,
        if (phoneNumber != null && phoneNumber.isNotEmpty) 'phoneNumber': phoneNumber,
      },
      successParser: (response) {
        return (response.data['message'] as String?) ?? 'Profile updated';
      },
    );
  }
}
