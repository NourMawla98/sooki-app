import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Small dark-glass rectangular chip showing a price (e.g. `$24.99`).
/// Used as floating background decoration on aurora surfaces (splash, home
/// hero). The [accent] drives the 1px border and a soft outer glow.
class AuroraPriceTag extends StatelessWidget {
  final String price;
  final Color accent;

  const AuroraPriceTag({
    super.key,
    required this.price,
    this.accent = AppColors.auroraElectricBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.auroraGlass,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent, width: 1),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.35),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(price, style: AppTextStyles.auroraMonoPrice),
    );
  }
}
