import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

enum OrderStatus {
  processing,
  shipped,
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.processing: return 'Processing';
      case OrderStatus.shipped:    return 'Shipped';
      case OrderStatus.delivered:  return 'Delivered';
      case OrderStatus.cancelled:  return 'Cancelled';
    }
  }

  Color get accentColor {
    switch (this) {
      case OrderStatus.processing: return AppColors.auroraPurple;
      case OrderStatus.shipped:    return AppColors.auroraElectricBlue;
      case OrderStatus.delivered:  return AppColors.verifiedGreen;
      case OrderStatus.cancelled:  return AppColors.auroraRed;
    }
  }
}
