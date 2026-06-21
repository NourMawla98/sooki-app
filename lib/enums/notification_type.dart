import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Notification categories returned by the backend.
///
/// Mirrors BE `NotificationTypeEnum` (1=OrderUpdate, 2=DispatchUpdate,
/// 3=Broadcast). [unknown] is a safety fallback so a value the app does not
/// recognise yet (e.g. a new BE type) still renders with a sensible icon
/// instead of breaking.
enum NotificationType {
  orderUpdate,
  dispatchUpdate,
  broadcast,
  unknown;

  static NotificationType fromInt(int? value) {
    switch (value) {
      case 1:
        return orderUpdate;
      case 2:
        return dispatchUpdate;
      case 3:
        return broadcast;
      default:
        return unknown;
    }
  }

  /// True for types that point at a specific order via `referenceId`.
  bool get isOrderRelated =>
      this == orderUpdate || this == dispatchUpdate;

  FaIconData get icon {
    switch (this) {
      case orderUpdate:
        return FontAwesomeIcons.boxOpen;
      case dispatchUpdate:
        return FontAwesomeIcons.truckFast;
      case broadcast:
        return FontAwesomeIcons.bullhorn;
      case unknown:
        return FontAwesomeIcons.bell;
    }
  }
}
