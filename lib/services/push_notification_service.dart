import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../backend_integration/apis/notifications_api.dart';
import '../backend_integration/dtos/notification/notification_dto.dart';
import '../enums/notification_type.dart';
import '../routes/route_constants.dart';
import '../ui/reusable_components/notification_heads_up/notification_heads_up.dart';
import 'notification_service.dart';
import 'toast_service.dart';

/// Top-level background/terminated message handler.
///
/// Must be a top-level (or static) function annotated with
/// `@pragma('vm:entry-point')` so it survives tree-shaking and can run in its
/// own isolate. The OS renders the tray notification automatically; we only
/// need Firebase initialised here. Tap routing is handled when the app opens.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No Firebase calls needed beyond delivery; the system tray shows the
  // notification. Kept intentionally minimal to avoid isolate setup cost.
}

/// Owns the FCM lifecycle: permission, token registration with the backend,
/// refresh, and incoming-message routing.
///
/// Device-token registration works for both guest and customer JWTs, so
/// [init] is safe to call right after auth/session restore.
class PushNotificationService {
  static final instance = PushNotificationService._();
  PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  NotificationsApi get _api => GetIt.instance<NotificationsApi>();

  bool _initialized = false;
  String? _token;
  StreamSubscription<String>? _refreshSub;

  /// Request permission, register this device's token, and wire message
  /// listeners. Idempotent.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await _messaging.requestPermission();

      _token = await _messaging.getToken();
      if (_token != null) await _register(_token!);

      _refreshSub = _messaging.onTokenRefresh.listen((token) {
        _token = token;
        _register(token);
      });

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

      // App launched from terminated state by tapping a notification.
      final initial = await _messaging.getInitialMessage();
      if (initial != null) _onMessageOpened(initial);
    } catch (e) {
      // Never let push setup crash startup (e.g. missing Play Services).
      debugPrint('PushNotificationService.init failed: $e');
    }
  }

  /// Re-bind the current token to whoever the JWT now identifies. [init] is
  /// one-shot, so a login that happens after startup still leaves the token
  /// attached to the guest record until this runs.
  Future<void> registerCurrentToken() async {
    final token = _token ?? await _messaging.getToken();
    if (token == null) return;
    _token = token;
    await _register(token);
  }

  /// Remove this device's token from the backend. Call on logout, while the
  /// current (customer) JWT is still active.
  Future<void> unregister() async {
    final token = _token ?? await _messaging.getToken();
    if (token == null) return;
    await _api.removeDeviceToken(token: token);
  }

  Future<void> _register(String token) async {
    await _api.registerDeviceToken(token: token, platform: _platform);
  }

  /// BE `PlatformEnum`: Android = 1, iOS = 2.
  int get _platform => Platform.isIOS ? 2 : 1;

  void _onForegroundMessage(RemoteMessage message) {
    // Keep the bell badge + inbox fresh.
    NotificationService.instance.fetchNotifications();

    // Show the in-app heads-up card (only when there's something to display).
    if (message.notification == null) return;
    NotificationHeadsUp.show(
      notification: _toDto(message),
      onTap: () {
        _markRead(message);
        _route(message);
      },
    );
  }

  void _onMessageOpened(RemoteMessage message) {
    // Tap from background/terminated → mark read + deep-link.
    _markRead(message);
    _route(message);
  }

  /// Build a display model from the FCM message's notification + data payload.
  NotificationDto _toDto(RemoteMessage message) {
    final data = message.data;
    return NotificationDto(
      id: int.tryParse('${data['notificationId']}') ?? 0,
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      type: int.tryParse('${data['type']}') ?? 0,
      referenceId: int.tryParse('${data['referenceId']}'),
      sentAt: DateTime.now(),
    );
  }

  /// Mark the notification read on the server using the `notificationId` data
  /// key (absent for broadcasts — skipped).
  void _markRead(RemoteMessage message) {
    final id = int.tryParse('${message.data['notificationId']}');
    if (id == null || id <= 0) return;
    _api.markRead(id);
    NotificationService.instance.fetchUnreadCount();
  }

  /// Deep-link by `type` + `referenceId`: order/dispatch updates open the order,
  /// everything else (broadcasts, unknown) opens the inbox.
  void _route(RemoteMessage message) {
    final navigator = ToastService.navigatorKey.currentState;
    if (navigator == null) return;

    final data = message.data;
    final type = NotificationType.fromInt(int.tryParse('${data['type']}'));
    final referenceId = int.tryParse('${data['referenceId']}');

    if (type.isOrderRelated && referenceId != null) {
      navigator.pushNamed(orderDetailScreenRoute, arguments: referenceId);
    } else {
      navigator.pushNamed(notificationsScreenRoute);
    }
  }

  void dispose() {
    _refreshSub?.cancel();
  }
}
