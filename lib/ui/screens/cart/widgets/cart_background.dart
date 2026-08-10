import 'package:flutter/material.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';

/// Electric-Aurora cart background. Four-stop linear gradient + two soft
/// radial blobs (blue top-right, pink bottom-left) that gently pulse.
/// Theme-aware, pointer-ignoring, intended to sit behind the cart body.
class CartBackground extends StatefulWidget {
  const CartBackground({super.key});

  @override
  State<CartBackground> createState() => _CartBackgroundState();
}

class _CartBackgroundState extends State<CartBackground>
    with TickerProviderStateMixin {
  late final AnimationController _blueController;
  late final AnimationController _pinkController;
  late final Animation<double> _blueScale;
  late final Animation<double> _pinkScale;

  @override
  void initState() {
    super.initState();
    _blueController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
    _pinkController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..repeat(reverse: true);

    _blueScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _blueController, curve: Curves.easeInOut),
    );
    _pinkScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pinkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _blueController.dispose();
    _pinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final gradientColors = isDark
            ? AppColors.cartBackgroundGradientDark
            : AppColors.cartBackgroundGradientLight;
        final decorOpacity = isDark ? 0.14 : 0.18;

        return IgnorePointer(
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                    stops: const [0.0, 0.35, 0.65, 1.0],
                  ),
                ),
              ),
              Opacity(
                opacity: decorOpacity,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      top: -80,
                      right: -80,
                      child: ScaleTransition(
                        scale: _blueScale,
                        child: _Blob(
                          size: 260,
                          color: AppColors.auroraElectricBlue,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -100,
                      left: -100,
                      child: ScaleTransition(
                        scale: _pinkScale,
                        child: _Blob(size: 280, color: AppColors.auroraPink),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;

  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
          stops: const [0.0, 0.65],
        ),
      ),
    );
  }
}
