import 'package:flutter/material.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/number_localization.dart';

/// Small badge indicator for notifications, positioned on the top-right corner
/// of a parent widget.
///
/// - Default: a plain circular dot (used as a generic "has activity" marker).
/// - When [count] is provided and `> 0`: renders a gently pulsing aurora-pink
///   count pill showing the number, capped at `99+`. A theme-matched ring
///   "cuts" it out of the icon underneath.
class NotificationDotBadge extends StatelessWidget {
  final bool show;
  final double size;

  /// When non-null, render a numeric badge instead of a plain dot.
  /// A value `<= 0` renders nothing.
  final int? count;

  const NotificationDotBadge({
    super.key,
    this.show = true,
    this.size = 8.0,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    final value = count;
    if (value == null) {
      // Plain dot (existing behaviour).
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.accentRed,
          shape: BoxShape.circle,
        ),
      );
    }

    if (value <= 0) return const SizedBox.shrink();
    return _CountBadge(value: value);
  }
}

/// Aurora-pink count pill with a soft breathing pulse to draw the eye.
class _CountBadge extends StatefulWidget {
  final int value;

  const _CountBadge({required this.value});

  @override
  State<_CountBadge> createState() => _CountBadgeState();
}

class _CountBadgeState extends State<_CountBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    final ringColor = isDark ? AppColors.auroraDeepBase : AppColors.white;
    final label = widget.value > 99
        ? '${localizedNumber(99)}+'
        : localizedNumber(widget.value);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_ctrl.value);
        return Transform.scale(
          scale: 1.0 + 0.08 * t,
          child: Container(
            constraints: const BoxConstraints(minWidth: 16),
            height: 16,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: AppColors.auroraPink,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ringColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.auroraPink.withValues(alpha: 0.55 * (1 - t)),
                  blurRadius: 2 + 7 * t,
                  spreadRadius: 0.5 * t,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          height: 1.0,
        ),
      ),
    );
  }
}
