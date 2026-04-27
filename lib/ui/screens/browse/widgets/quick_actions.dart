import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/route_constants.dart';
import '../../../../services/theme_service.dart';
import '../../../../services/toast_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_gradient_text.dart';

/// Section 6 — Quick Actions. Four circular glass bubbles that shortcut to
/// the user's most-used utilities (Track Order, Wishlist, Reorder, Settings).
/// Rewards is intentionally omitted — it's already a bottom nav tab.
///
/// Each bubble has a distinct subtle animation tied to its meaning:
///   - Track: pulsing blue glow (live order)
///   - Wishlist: heart beat + badge bounce (unread price drops)
///   - Reorder: slow continuous rotation (matches the rotate icon)
///   - Settings: vertical Y-axis twirl (gear flip)
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuroraGradientText(
                'Quick Actions',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _Bubble(
                      icon: FontAwesomeIcons.locationCrosshairs,
                      label: 'Track',
                      accent: AppColors.auroraElectricBlue,
                      isDark: isDark,
                      anim: _BubbleAnim.pulseGlow,
                      onTap: () => _showComingSoon(context, 'Track Order'),
                    ),
                  ),
                  Expanded(
                    child: _Bubble(
                      icon: FontAwesomeIcons.heart,
                      label: 'Wishlist',
                      accent: AppColors.auroraPink,
                      isDark: isDark,
                      badgeCount: 3,
                      anim: _BubbleAnim.heartBeat,
                      onTap: () => _showComingSoon(context, 'Wishlist'),
                    ),
                  ),
                  Expanded(
                    child: _Bubble(
                      icon: FontAwesomeIcons.rotate,
                      label: 'Reorder',
                      accent: AppColors.verifiedGreen,
                      isDark: isDark,
                      anim: _BubbleAnim.slowRotate,
                      onTap: () => _showComingSoon(context, 'Reorder'),
                    ),
                  ),
                  Expanded(
                    child: _Bubble(
                      icon: FontAwesomeIcons.gear,
                      label: 'Settings',
                      accent: AppColors.auroraGold,
                      isDark: isDark,
                      anim: _BubbleAnim.breathe,
                      onTap: () => Navigator.pushNamed(context, settingsScreenRoute),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showComingSoon(BuildContext context, String action) {
    ToastService.instance.showSuccess('$action — coming soon');
  }
}


enum _BubbleAnim { none, pulseGlow, heartBeat, slowRotate, breathe }

class _Bubble extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final Color accent;
  final bool isDark;
  final int? badgeCount;
  final _BubbleAnim anim;
  final VoidCallback onTap;

  const _Bubble({
    required this.icon,
    required this.label,
    required this.accent,
    required this.isDark,
    required this.onTap,
    this.badgeCount,
    this.anim = _BubbleAnim.none,
  });

  @override
  State<_Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<_Bubble>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulse;

  @override
  void initState() {
    super.initState();
    final anim = widget.anim;
    if (anim == _BubbleAnim.none) return;
    _pulse = AnimationController(
      vsync: this,
      duration: _durationFor(anim),
    )..repeat(reverse: anim != _BubbleAnim.slowRotate && anim != _BubbleAnim.breathe);
  }

  Duration _durationFor(_BubbleAnim anim) {
    switch (anim) {
      case _BubbleAnim.pulseGlow:
        return const Duration(milliseconds: 2000);
      case _BubbleAnim.heartBeat:
        return const Duration(milliseconds: 1100);
      case _BubbleAnim.slowRotate:
        return const Duration(milliseconds: 8000);
      case _BubbleAnim.breathe:
        return const Duration(milliseconds: 3000);
      case _BubbleAnim.none:
        return Duration.zero;
    }
  }

  @override
  void dispose() {
    _pulse?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bubbleSize = 52.0;
    final labelColor = widget.accent;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: bubbleSize + 12,
            height: bubbleSize + 8,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                _buildBubble(bubbleSize),
                if (widget.badgeCount != null && widget.badgeCount! > 0)
                  Positioned(
                    top: 0,
                    right: 6,
                    child: _buildBadge(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            style: AppTextStyles.captionSmall.copyWith(
              color: labelColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(double size) {
    final icon = _buildAnimatedIcon();

    if (widget.anim == _BubbleAnim.pulseGlow && _pulse != null) {
      return AnimatedBuilder(
        animation: _pulse!,
        builder: (context, _) {
          final t = _pulse!.value;
          final glowAlpha = 0.18 + 0.22 * t;
          return _bubbleContainer(size, glowAlpha: glowAlpha, child: icon);
        },
      );
    }
    return _bubbleContainer(size, glowAlpha: 0, child: icon);
  }

  Widget _buildAnimatedIcon() {
    final iconWidget = FaIcon(
      widget.icon,
      size: 18,
      color: widget.accent,
    );

    if (_pulse == null) return iconWidget;

    switch (widget.anim) {
      case _BubbleAnim.heartBeat:
        return AnimatedBuilder(
          animation: _pulse!,
          builder: (context, child) {
            final scale = 1 + 0.14 * Curves.easeInOut.transform(_pulse!.value);
            return Transform.scale(scale: scale, child: child);
          },
          child: iconWidget,
        );
      case _BubbleAnim.slowRotate:
        return AnimatedBuilder(
          animation: _pulse!,
          builder: (context, child) => Transform.rotate(
            angle: _pulse!.value * 2 * math.pi,
            child: child,
          ),
          child: iconWidget,
        );
      case _BubbleAnim.breathe:
        return AnimatedBuilder(
          animation: _pulse!,
          builder: (context, child) {
            final angle = _pulse!.value * 2 * math.pi;
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: iconWidget,
        );
      case _BubbleAnim.pulseGlow:
      case _BubbleAnim.none:
        return iconWidget;
    }
  }

  Widget _bubbleContainer(
    double size, {
    required double glowAlpha,
    required Widget child,
  }) {
    final isDark = widget.isDark;
    final fill = isDark
        ? AppColors.white.withValues(alpha: 0.05)
        : AppColors.primaryPurple.withValues(alpha: 0.05);
    final borderColor = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.primaryPurple.withValues(alpha: 0.18);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
        boxShadow: glowAlpha > 0
            ? [
                BoxShadow(
                  color: widget.accent.withValues(alpha: glowAlpha),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: Center(child: child),
    );
  }

  Widget _buildBadge() {
    Widget badge = _Badge(count: widget.badgeCount!, isDark: widget.isDark);
    // Bounce the badge in time with the heart beat so the pink "3" feels
    // linked to the beating heart icon.
    if (widget.anim == _BubbleAnim.heartBeat && _pulse != null) {
      badge = AnimatedBuilder(
        animation: _pulse!,
        builder: (context, child) {
          final scale = 1 + 0.10 * Curves.easeInOut.transform(_pulse!.value);
          return Transform.scale(scale: scale, child: child);
        },
        child: badge,
      );
    }
    return badge;
  }
}

class _Badge extends StatelessWidget {
  final int count;
  final bool isDark;
  const _Badge({required this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Badge "cut-out" border matches the section background so the pill
    // reads as floating above the bubble in either theme.
    final cutoutColor =
        isDark ? AppColors.auroraDeepBase : AppColors.white;

    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.auroraPink,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: cutoutColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraPink.withValues(alpha: 0.45),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$count',
          style: AppTextStyles.captionSmall.copyWith(
            color: AppColors.white,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
