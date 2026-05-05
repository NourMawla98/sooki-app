import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Category pill using the "Hollow Neon Border" treatment.
///
/// - **Unselected:** glass fill + muted border
/// - **Selected:** 2px aurora-gradient border whose colors continuously sweep
///   around the perimeter, giving a "circumference moving" neon effect
///
/// Shared between the Browse screen's New Arrivals section and the Shopping
/// screen's L1 row so both read as the same design family.
class AuroraCategoryL1Pill extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  /// When true, the unselected state renders as a faded secondary-button style
  /// (gradient border + surface fill at reduced opacity) instead of glass fill.
  final bool disabledStyleWhenUnselected;

  const AuroraCategoryL1Pill({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.disabledStyleWhenUnselected = false,
  });

  @override
  State<AuroraCategoryL1Pill> createState() => _AuroraCategoryL1PillState();
}

class _AuroraCategoryL1PillState extends State<AuroraCategoryL1Pill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotator;

  @override
  void initState() {
    super.initState();
    _rotator = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.isSelected) _rotator.repeat();
  }

  @override
  void didUpdateWidget(covariant AuroraCategoryL1Pill old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !_rotator.isAnimating) {
      _rotator.repeat();
    } else if (!widget.isSelected && _rotator.isAnimating) {
      _rotator.stop();
    }
  }

  @override
  void dispose() {
    _rotator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final isSel = widget.isSelected;

        final unselectedTextColor = isDark
            ? AppColors.white.withValues(alpha: 0.65)
            : AppColors.primaryPurple;

        Widget buildContent({required Color color}) => Container(
              height: 32,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                widget.label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontSize: 11,
                  fontWeight: isSel ? FontWeight.w800 : FontWeight.w700,
                  letterSpacing: 0.3,
                  height: 1.0,
                ),
              ),
            );

        Widget buildGradientContent() => Container(
              height: 32,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: AppColors.auroraGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                blendMode: BlendMode.srcIn,
                child: Text(
                  widget.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                    height: 1.0,
                  ),
                ),
              ),
            );

        if (!isSel && widget.disabledStyleWhenUnselected) {
          return GestureDetector(
            onTap: widget.onTap,
            child: Opacity(
              opacity: 0.42,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.auroraGradient,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.auroraDeepBase
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(4.5),
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: AppColors.auroraGradient,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      blendMode: BlendMode.srcIn,
                      child: Text(
                        widget.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: widget.onTap,
          child: isSel
              ? RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _rotator,
                    builder: (context, child) => CustomPaint(
                      painter: _RotatingBorderPainter(
                        angle: _rotator.value * 2 * math.pi,
                      ),
                      child: child,
                    ),
                    child: buildGradientContent(),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.04)
                        : AppColors.primaryPurple.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.15)
                          : AppColors.primaryPurple.withValues(alpha: 0.35),
                    ),
                  ),
                  child: buildContent(color: unselectedTextColor),
                ),
        );
      },
    );
  }
}

/// Paints a rounded-rect outline using a [SweepGradient] whose rotation is
/// driven by [angle]. Animating `angle` from 0 → 2π on repeat makes the
/// gradient colors appear to travel around the perimeter.
class _RotatingBorderPainter extends CustomPainter {
  final double angle;
  static const double _borderRadius = 6;
  static const double _strokeWidth = 2;

  _RotatingBorderPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    // Inset by half the stroke so the stroke doesn't clip the edges.
    const inset = _strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(_borderRadius),
    );

    final shader = SweepGradient(
      colors: const [
        AppColors.auroraPink,
        AppColors.auroraPurple,
        AppColors.auroraElectricBlue,
        AppColors.auroraPurple,
        AppColors.auroraPink,
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(angle),
    ).createShader(rect);

    final paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_RotatingBorderPainter old) => old.angle != angle;
}
