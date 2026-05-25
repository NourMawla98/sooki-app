import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../services/cart_service.dart';
import '../../services/theme_service.dart';
import '../../themes/themes.dart';
import '../reusable_components/aurora/aurora_bar_line.dart';

/// Bottom navigation bar with the Electric Aurora "Glow Bar" treatment:
/// aurora glass background, animated 2px aurora gradient line on top, 5
/// slots (Browse / Deals / Shop-FAB-gap / Loyalty / Cart). The Shop FAB
/// itself is rendered in the Scaffold's `floatingActionButton` slot with
/// `FloatingActionButtonLocation.centerDocked` — the middle tab is a
/// visual gap so the FAB can dock over it with full hit-test coverage.
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static final _cart = GetIt.instance<CartService>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService.instance, _cart]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final cartCount = _cart.itemCount;
        final barBg = isDark
            ? AppColors.auroraDeepBase.withValues(alpha: 0.95)
            : AppColors.white.withValues(alpha: 0.95);
        final inactiveColor = isDark
            ? AppColors.white
            : AppColors.primaryPurple.withValues(alpha: 0.5);
        final activeColor = AppColors.auroraElectricBlue;
        final shadowColor = isDark
            ? AppColors.black.withValues(alpha: 0.45)
            : AppColors.black.withValues(alpha: 0.08);

        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: barBg,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuroraBarLine(),
                  SafeArea(
                    top: false,
                    child: SizedBox(
                      height: 68,
                      child: Row(
                        children: [
                          _NavTab(
                            icon: FontAwesomeIcons.house,
                            label: 'Browse',
                            isActive: currentIndex == 0,
                            activeColor: activeColor,
                            inactiveColor: inactiveColor,
                            isDark: isDark,
                            onTap: () => onTap(0),
                          ),
                          _NavTab(
                            icon: FontAwesomeIcons.bolt,
                            label: 'Deals',
                            isActive: currentIndex == 1,
                            activeColor: activeColor,
                            inactiveColor: inactiveColor,
                            isDark: isDark,
                            onTap: () => onTap(1),
                          ),
                          // Visual gap the docked Shop FAB sits over.
                          const Expanded(child: SizedBox.shrink()),
                          _NavTab(
                            icon: FontAwesomeIcons.gavel,
                            label: 'Auction',
                            isActive: currentIndex == 3,
                            activeColor: activeColor,
                            inactiveColor: inactiveColor,
                            isDark: isDark,
                            onTap: () => onTap(3),
                          ),
                          _NavTab(
                            icon: FontAwesomeIcons.cartShopping,
                            label: 'Cart',
                            isActive: currentIndex == 4,
                            activeColor: activeColor,
                            inactiveColor: inactiveColor,
                            isDark: isDark,
                            badgeCount: cartCount > 0 ? cartCount : null,
                            onTap: () => onTap(4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavTab extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final bool isDark;
  final int? badgeCount;
  final VoidCallback onTap;

  const _NavTab({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.isDark,
    required this.onTap,
    this.badgeCount,
  });

  @override
  State<_NavTab> createState() => _NavTabState();
}

class _NavTabState extends State<_NavTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    duration: const Duration(milliseconds: 1600),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _NavTab old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !_pulse.isAnimating) {
      _pulse.forward(from: 0).then((_) => _pulse.repeat(reverse: true));
    } else if (!widget.isActive && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive ? widget.activeColor : widget.inactiveColor;
    final cutoutColor =
        widget.isDark ? AppColors.auroraDeepBase : AppColors.white;
    return Expanded(
      child: InkWell(
        onTap: widget.onTap,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, _) {
            final t = _pulse.value;
            final baseAlpha = widget.isDark ? 0.35 : 0.20;
            final peakAlpha = widget.isDark ? 0.75 : 0.45;
            final alpha = baseAlpha + (peakAlpha - baseAlpha) * t;
            final iconBlur = 6 + 8 * t;
            final labelBlur = 4 + 6 * t;
            final scale = 1 + 0.08 * t;
            final glowShadow = Shadow(
              color: widget.activeColor.withValues(alpha: alpha),
              blurRadius: iconBlur,
            );
            final labelShadow = Shadow(
              color: widget.activeColor.withValues(alpha: alpha * 0.9),
              blurRadius: labelBlur,
            );
            return Transform.scale(
              scale: widget.isActive ? scale : 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 32,
                    height: 26,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        FaIcon(
                          widget.icon,
                          size: 20,
                          color: color,
                          shadows: widget.isActive ? [glowShadow] : null,
                        ),
                        if (widget.badgeCount != null)
                          Positioned(
                            top: -2,
                            right: 0,
                            child: _NavBadge(
                              count: widget.badgeCount!,
                              cutoutColor: cutoutColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: (widget.isActive
                            ? AppTextStyles.navLabelActive
                            : AppTextStyles.navLabel)
                        .copyWith(
                      color: color,
                      shadows: widget.isActive ? [labelShadow] : null,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavBadge extends StatelessWidget {
  final int count;
  final Color cutoutColor;

  const _NavBadge({required this.count, required this.cutoutColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
      padding: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: AppColors.auroraPink,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: cutoutColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraPink.withValues(alpha: 0.45),
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : '$count',
          style: AppTextStyles.captionSmall.copyWith(
            color: AppColors.white,
            fontSize: 8,
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
