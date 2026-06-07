import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/notification/notification_preferences_dto.dart';

@injectable
class NotificationPreferencesApi {
  final Dio _dio;

  NotificationPreferencesApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, NotificationPreferencesDto>> getPreferences() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/profile/notifications',
      operationName: 'getNotificationPreferences',
      successParser: (response) {
        final data = response.data['data'] as Map<String, dynamic>;
        return NotificationPreferencesDto.fromJson(data);
      },
    );
  }

  Future<Either<ApiFailure, String>> updatePreferences(
    NotificationPreferencesDto dto,
  ) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.put,
      path: 'customer/profile/notifications',
      body: dto.toJson(),
      operationName: 'updateNotificationPreferences',
      successParser: (response) =>
          (response.data['message'] as String?) ?? '',
    );
  }
}
