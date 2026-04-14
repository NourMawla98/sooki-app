import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';

/// Circular aurora-gradient FAB used as the center "Shop" button on the
/// bottom nav bar. Pulses via a subtle scale + glow-shadow loop. No border
/// ring — pure gradient circle.
class AuroraShoppingFab extends StatefulWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final double size;

  const AuroraShoppingFab({
    super.key,
    required this.onTap,
    this.isSelected = false,
    this.size = 60,
  });

  @override
  State<AuroraShoppingFab> createState() => _AuroraShoppingFabState();
}

class _AuroraShoppingFabState extends State<AuroraShoppingFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          final glowAlpha = 0.35 + (0.15 * _controller.value);
          return Transform.scale(
            scale: _pulse.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: AppColors.auroraCartButtonGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.auroraElectricBlue
                        .withValues(alpha: glowAlpha),
                    blurRadius: 25 + (10 * _controller.value),
                    spreadRadius: 1,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: FaIcon(
                FontAwesomeIcons.bagShopping,
                size: widget.size * 0.4,
                color: widget.isSelected
                    ? AppColors.auroraElectricBlue
                    : AppColors.white,
                shadows: widget.isSelected
                    ? [
                        Shadow(
                          color: AppColors.auroraElectricBlue
                              .withValues(alpha: 0.7),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
