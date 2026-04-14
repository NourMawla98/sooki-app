import 'package:flutter/material.dart';

import '../services/theme_service.dart';
import 'app_colors.dart';

/// Theme-aware palette for non-aurora screens.
///
/// Each getter returns the appropriate [AppColors] constant for the current
/// [isDark] value. Instances are cheap — construct one per `build` via the
/// [BuildContext.themed] extension rather than storing as a field.
///
/// To extend: add a new getter here, pick a light-mode and dark-mode color
/// from [AppColors], update `themed_colors_test.dart`. Never introduce a
/// hex literal — all theme-aware colors must resolve to existing [AppColors]
/// constants so a global palette change remains a one-file edit.
class ThemedColors {
  final bool isDark;

  const ThemedColors({required this.isDark});

  // ─── Surfaces ────────────────────────────────────────────────────────────
  Color get background =>
      isDark ? AppColors.darkBackground : AppColors.backgroundLight;

  Color get surface =>
      isDark ? AppColors.darkSurface : AppColors.white;

  Color get elevatedSurface =>
      isDark ? AppColors.darkElevatedSurface : AppColors.gray50;

  // ─── Text ────────────────────────────────────────────────────────────────
  Color get textPrimary =>
      isDark ? AppColors.white : AppColors.primaryPurple;

  Color get textSecondary =>
      isDark ? AppColors.gray300 : AppColors.gray600;

  Color get textTertiary => AppColors.gray400;

  Color get textOnAccent => AppColors.white;

  // ─── Lines ───────────────────────────────────────────────────────────────
  Color get border =>
      isDark ? AppColors.darkBorder : AppColors.gray200;

  Color get divider =>
      isDark ? AppColors.darkBorder : AppColors.gray100;

  // ─── Icons / AppBar foreground ──────────────────────────────────────────
  Color get scaffoldForeground =>
      isDark ? AppColors.white : AppColors.primaryPurple;
}

/// `context.themed` returns a [ThemedColors] driven by [ThemeService].
///
/// Use inside a `ListenableBuilder(listenable: ThemeService.instance, ...)`
/// at the screen root so rebuilds happen on toggle. Outside such a builder
/// the screen will still render correctly, but will not re-render when the
/// user flips the theme.
extension BuildContextThemed on BuildContext {
  ThemedColors get themed =>
      ThemedColors(isDark: ThemeService.instance.isDarkMode);
}
