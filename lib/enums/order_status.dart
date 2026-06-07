import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../themes/app_colors.dart';

enum OrderStatus {
  processing,
  outForDelivery,
  delivered,
  received,
  cancelled,
  rejected,
  refunded,
  packaged,
  deliveryFailed;

  static OrderStatus fromInt(int v) {
    switch (v) {
      case 1: return processing;
      case 2: return outForDelivery;
      case 3: return delivered;
      case 4: return received;
      case 5: return cancelled;
      case 6: return rejected;
      case 7: return refunded;
      case 8: return packaged;
      case 9: return deliveryFailed;
      default: return processing;
    }
  }

  bool get isInProgress => this == processing || this == packaged || this == outForDelivery;
  bool get isDelivered => this == delivered || this == received;
  bool get isClosed => this == cancelled || this == rejected || this == refunded || this == deliveryFailed;

  /// 1-based step for the 4-step progress tracker. Null for closed statuses.
  int? get progressStep {
    switch (this) {
      case processing:    return 1;
      case packaged:      return 2;
      case outForDelivery: return 3;
      case delivered:
      case received:      return 4;
      default:            return null;
    }
  }

  String get label {
    switch (this) {
      case processing:    return 'Processing';
      case outForDelivery: return 'Out for delivery';
      case delivered:     return 'Delivered';
      case received:      return 'Received';
      case cancelled:     return 'Cancelled';
      case rejected:      return 'Rejected';
      case refunded:      return 'Refunded';
      case packaged:      return 'Packaged';
      case deliveryFailed: return 'Delivery failed';
    }
  }

  Color get accentColor {
    switch (this) {
      case processing:
      case packaged:
        return AppColors.auroraPurple;
      case outForDelivery:
        return AppColors.auroraElectricBlue;
      case delivered:
      case received:
        return AppColors.verifiedGreen;
      case refunded:
        return AppColors.auroraGold;
      case cancelled:
      case rejected:
      case deliveryFailed:
        return AppColors.auroraRed;
    }
  }

  FaIconData get icon {
    switch (this) {
      case processing:    return FontAwesomeIcons.rotate;
      case packaged:      return FontAwesomeIcons.box;
      case outForDelivery: return FontAwesomeIcons.truck;
      case delivered:     return FontAwesomeIcons.circleCheck;
      case received:      return FontAwesomeIcons.handHoldingHeart;
      case cancelled:     return FontAwesomeIcons.ban;
      case rejected:      return FontAwesomeIcons.ban;
      case refunded:      return FontAwesomeIcons.rotateLeft;
      case deliveryFailed: return FontAwesomeIcons.circleExclamation;
    }
  }
}
