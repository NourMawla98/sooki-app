import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';

/// Frosted glass card used on aurora surfaces (sign-in, sign-up, home hero).
/// Listens to [ThemeService] so the fill + border glow flip on dark/light
/// toggle. In dark mode the border is aurora pink; in light mode it is aurora
/// purple, each with a matching soft outer glow.
class AuroraGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blurSigma;

  const AuroraGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 24,
    this.blurSigma = 24,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final borderColor =
            (isDark ? AppColors.auroraPink : AppColors.auroraPurple)
                .withValues(alpha: 0.35);
        final glowColor =
            (isDark ? AppColors.auroraPink : AppColors.auroraPurple)
                .withValues(alpha: 0.18);
        final fillColor =
            isDark ? AppColors.auroraGlass : AppColors.auroraLightGlass;

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: glowColor,
                    blurRadius: 30,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
