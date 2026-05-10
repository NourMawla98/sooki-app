import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';

@injectable
class AuthApi {
  final Dio _dio;

  AuthApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'auth/customer/login',
      body: {'email': email, 'password': password},
      operationName: 'login',
      successParser: (response) {
        final body = response.data;
        if (body is Map<String, dynamic>) return body;
        return <String, dynamic>{};
      },
    );
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> requestPasswordReset({
    required String email,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'auth/customer/request-password-reset',
      body: {'email': email},
      operationName: 'requestPasswordReset',
      successParser: (response) {
        final body = response.data;
        if (body is Map<String, dynamic>) return body;
        return <String, dynamic>{};
      },
    );
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'auth/customer/reset-password',
      body: {
        'token': token,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
      operationName: 'resetPassword',
      successParser: (response) {
        final body = response.data;
        if (body is Map<String, dynamic>) return body;
        return <String, dynamic>{};
      },
    );
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> resendVerification({
    required String email,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'auth/customer/resend-verification',
      body: {'email': email},
      operationName: 'resendVerification',
      successParser: (response) {
        final body = response.data;
        if (body is Map<String, dynamic>) return body;
        return <String, dynamic>{};
      },
    );
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> logout({
    required String refreshToken,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'auth/customer/logout',
      body: {'refreshToken': refreshToken},
      operationName: 'logout',
      successParser: (response) {
        final body = response.data;
        if (body is Map<String, dynamic>) return body;
        return <String, dynamic>{};
      },
    );
  }

  Future<Either<ApiFailure, Map<String, dynamic>>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneCountryCode,
    required String phoneNumber,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'auth/customer/register',
      body: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneCountryCode': phoneCountryCode,
        'phoneNumber': phoneNumber,
      },
      operationName: 'register',
      successParser: (response) {
        final body = response.data;
        if (body is Map<String, dynamic>) return body;
        return <String, dynamic>{};
      },
    );
  }
}
