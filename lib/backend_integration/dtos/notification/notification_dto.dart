import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../enums/notification_type.dart';

part 'notification_dto.freezed.dart';
part 'notification_dto.g.dart';

/// A single inbox notification as returned by
/// `GET /customer/notifications` (BE `NotificationCustomerResponseDTO`).
@Freezed(toJson: false, fromJson: true)
abstract class NotificationDto with _$NotificationDto {
  const NotificationDto._();

  const factory NotificationDto({
    required int id,
    required String title,
    required String body,
    required int type,
    int? referenceId,
    @Default(false) bool isRead,
    required DateTime sentAt,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  /// Strongly-typed category (with [NotificationType.unknown] fallback).
  NotificationType get notificationType => NotificationType.fromInt(type);

  /// Whether [sentAt] falls on the current local day (drives Today/Earlier grouping).
  bool get isToday {
    final now = DateTime.now();
    final local = sentAt.toLocal();
    return now.year == local.year &&
        now.month == local.month &&
        now.day == local.day;
  }

  /// Short relative timestamp, e.g. "Just now", "5m ago", "3h ago",
  /// "Yesterday", or "Jun 12".
  String get relativeLabel {
    final local = sentAt.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (isToday) return '${diff.inHours}h ago';

    final yesterday = now.subtract(const Duration(days: 1));
    if (local.year == yesterday.year &&
        local.month == yesterday.month &&
        local.day == yesterday.day) {
      return 'Yesterday';
    }

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[local.month - 1]} ${local.day}';
  }
}
