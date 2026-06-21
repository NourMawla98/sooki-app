import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../dio/client/api_client.dart';
import '../dio/client/request_executor.dart';
import '../dtos/notification/notification_dto.dart';

typedef NotificationsPage = ({
  List<NotificationDto> items,
  int totalCount,
  bool isLastPage,
});

/// Customer notification endpoints (`/api/customer/notifications`).
///
/// The whole controller accepts both Guest and Customer JWTs, so device-token
/// registration and inbox reads work for any authenticated session.
@injectable
class NotificationsApi {
  final Dio _dio;

  NotificationsApi(@Named(apiClientKey) this._dio);

  /// Register this device's FCM token with the backend.
  Future<Either<ApiFailure, String>> registerDeviceToken({
    required String token,
    required int platform,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.post,
      path: 'customer/notifications/device-token',
      body: {'token': token, 'platform': platform},
      operationName: 'registerDeviceToken',
      // Background concern — never surface a toast on failure.
      extra: const {'silentError': true},
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  /// Remove this device's FCM token (call on logout).
  Future<Either<ApiFailure, String>> removeDeviceToken({
    required String token,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.delete,
      path: 'customer/notifications/device-token',
      body: {'token': token},
      operationName: 'removeDeviceToken',
      extra: const {'silentError': true},
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  /// Paginated inbox.
  Future<Either<ApiFailure, NotificationsPage>> getInbox({
    int page = 1,
    int pageSize = 20,
  }) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/notifications',
      queryParameters: {'page': page, 'pageSize': pageSize},
      operationName: 'getInbox',
      extra: const {'silentError': true},
      successParser: (response) {
        final body = response.data as Map<String, dynamic>;
        final isLastPage = body['isLastPage'] as bool? ?? true;
        final totalCount = body['totalCount'] as int? ?? 0;
        final rawItems = body['data'];
        final items = rawItems is List
            ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(NotificationDto.fromJson)
                .toList()
            : <NotificationDto>[];
        return (items: items, totalCount: totalCount, isLastPage: isLastPage);
      },
    );
  }

  /// Mark a single notification as read.
  Future<Either<ApiFailure, String>> markRead(int id) {
    return executeRequest(
      client: _dio,
      method: HttpMethod.put,
      path: 'customer/notifications/$id/read',
      operationName: 'markRead',
      extra: const {'silentError': true},
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  /// Mark every notification as read.
  Future<Either<ApiFailure, String>> markAllRead() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.put,
      path: 'customer/notifications/read-all',
      operationName: 'markAllRead',
      extra: const {'silentError': true},
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['message'] as String? ?? '',
    );
  }

  /// Unread count for the bell badge.
  Future<Either<ApiFailure, int>> getUnreadCount() {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'customer/notifications/unread-count',
      operationName: 'getUnreadCount',
      extra: const {'silentError': true},
      successParser: (r) =>
          (r.data as Map<String, dynamic>?)?['data'] as int? ?? 0,
    );
  }
}
