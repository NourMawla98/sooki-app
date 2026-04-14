import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';

/// Circular aurora-gradient badge showing a `-XX%` discount.
/// Used as floating background decoration on aurora surfaces.
class AuroraDiscountBadge extends StatelessWidget {
  final int percent;
  final double size;

  const AuroraDiscountBadge({
    super.key,
    required this.percent,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: AppColors.auroraCartButtonGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraPink.withValues(alpha: 0.45),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '-$percent%',
        style: TextStyle(
          fontSize: size * 0.28,
          fontWeight: FontWeight.w900,
          color: AppColors.white,
          letterSpacing: 0.5,
          height: 1.0,
        ),
      ),
    );
  }
}
