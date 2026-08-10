import 'package:easy_localization/easy_localization.dart';
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
  /// "Yesterday", or "Jun 12" (localized).
  String get relativeLabel {
    final local = sentAt.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);

    if (diff.inMinutes < 1) return 'time.just_now'.tr();
    if (diff.inMinutes < 60) {
      return 'time.minutes_ago'.tr(namedArgs: {'n': '${diff.inMinutes}'});
    }
    if (isToday) {
      return 'time.hours_ago'.tr(namedArgs: {'n': '${diff.inHours}'});
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (local.year == yesterday.year &&
        local.month == yesterday.month &&
        local.day == yesterday.day) {
      return 'time.yesterday'.tr();
    }

    final monthShort = 'time.month_short.${local.month}'.tr();
    return 'time.short_date'
        .tr(namedArgs: {'day': '${local.day}', 'month': monthShort});
  }
}
