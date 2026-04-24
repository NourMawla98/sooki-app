import 'package:flutter/material.dart';

import '../../../../themes/app_colors.dart';

/// Theme-aware glass colors shared across cart pills + sheets.
class CartSurfaceColors {
  final Color glassFill;
  final Color glassBorder;
  final Color chipFill;
  final Color chipBorder;
  final Color text;
  final Color textMute;
  final Color textMute2;
  final Color textMute3;
  final Color divider;
  final Color sheet;
  final Color sheetTop;

  const CartSurfaceColors({
    required this.glassFill,
    required this.glassBorder,
    required this.chipFill,
    required this.chipBorder,
    required this.text,
    required this.textMute,
    required this.textMute2,
    required this.textMute3,
    required this.divider,
    required this.sheet,
    required this.sheetTop,
  });

  factory CartSurfaceColors.of({required bool isDark}) {
    if (isDark) {
      return CartSurfaceColors(
        glassFill: AppColors.white.withValues(alpha: 0.03),
        glassBorder: AppColors.white.withValues(alpha: 0.08),
        chipFill: AppColors.white.withValues(alpha: 0.04),
        chipBorder: AppColors.white.withValues(alpha: 0.10),
        text: AppColors.white,
        textMute: AppColors.white.withValues(alpha: 0.55),
        textMute2: AppColors.white.withValues(alpha: 0.35),
        textMute3: AppColors.white.withValues(alpha: 0.22),
        divider: AppColors.white.withValues(alpha: 0.06),
        sheet: AppColors.auroraDeepBase.withValues(alpha: 0.96),
        sheetTop: AppColors.white.withValues(alpha: 0.06),
      );
    }
    return CartSurfaceColors(
      glassFill: AppColors.white.withValues(alpha: 0.75),
      glassBorder: AppColors.auroraPurple.withValues(alpha: 0.16),
      chipFill: AppColors.white,
      chipBorder: AppColors.auroraPurple.withValues(alpha: 0.18),
      text: AppColors.auroraDeepBase,
      textMute: AppColors.auroraDeepBase.withValues(alpha: 0.65),
      textMute2: AppColors.auroraDeepBase.withValues(alpha: 0.45),
      textMute3: AppColors.auroraDeepBase.withValues(alpha: 0.30),
      divider: AppColors.auroraDeepBase.withValues(alpha: 0.08),
      sheet: AppColors.white.withValues(alpha: 0.96),
      sheetTop: AppColors.auroraPurple.withValues(alpha: 0.12),
    );
  }
}
