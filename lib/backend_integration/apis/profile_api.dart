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
        if (phoneCountryCode != null) 'phoneCountryCode': phoneCountryCode,
        if (phoneNumber != null && phoneNumber.isNotEmpty) 'phoneNumber': phoneNumber,
      },
      successParser: (response) {
        return (response.data['message'] as String?) ?? 'Profile updated';
      },
    );
  }
}
