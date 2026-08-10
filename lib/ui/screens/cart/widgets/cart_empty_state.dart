import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

class CartEmptyState extends StatefulWidget {
  const CartEmptyState({super.key});

  @override
  State<CartEmptyState> createState() => _CartEmptyStateState();
}

class _CartEmptyStateState extends State<CartEmptyState>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _glowCtrl;
  late final AnimationController _orbit1Ctrl;
  late final AnimationController _orbit2Ctrl;
  late final AnimationController _orbit3Ctrl;

  late final Animation<double> _floatY;
  late final Animation<double> _glowScale;
  late final Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _orbit1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _orbit2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    )..repeat();

    _orbit3Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat();

    _floatY = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _glowScale = Tween<double>(
      begin: 1.0,
      end: 1.10,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    _glowOpacity = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    _orbit1Ctrl.dispose();
    _orbit2Ctrl.dispose();
    _orbit3Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final headingColor = isDark
            ? AppColors.white
            : AppColors.auroraDeepBase;
        final subColor = isDark
            ? AppColors.white.withValues(alpha: 0.40)
            : AppColors.auroraDeepBase.withValues(alpha: 0.40);

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BagIllustration(
                  floatY: _floatY,
                  glowScale: _glowScale,
                  glowOpacity: _glowOpacity,
                  orbit1: _orbit1Ctrl,
                  orbit2: _orbit2Ctrl,
                  orbit3: _orbit3Ctrl,
                ),

                const SizedBox(height: 28),

                ShaderMask(
                  shaderCallback: (bounds) =>
                      const LinearGradient(
                        colors: AppColors.auroraGradient,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'cart_empty_state.your_cart'.tr(),
                    style: AppTextStyles.dsSectionLabel.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'cart_empty_state.nothing_here_yet'.tr(),
                  style: AppTextStyles.dsH2.copyWith(
                    color: headingColor,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'cart_empty_state.add_items_hint'.tr(),
                  style: AppTextStyles.dsMuted.copyWith(
                    color: subColor,
                    fontSize: 13,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Bag illustration with glow + orbit dots + float ──────────────────────────

class _BagIllustration extends StatelessWidget {
  final Animation<double> floatY;
  final Animation<double> glowScale;
  final Animation<double> glowOpacity;
  final AnimationController orbit1;
  final AnimationController orbit2;
  final AnimationController orbit3;

  const _BagIllustration({
    required this.floatY,
    required this.glowScale,
    required this.glowOpacity,
    required this.orbit1,
    required this.orbit2,
    required this.orbit3,
  });

  @override
  Widget build(BuildContext context) {
    const wrapSize = 140.0;
    const center = wrapSize / 2;
    // Orbit radii matching the mockup
    const r1 = 58.0, r2 = 62.0, r3 = 55.0;
    // Starting angles (0°, 120°, 240° in radians)
    const a1Start = 0.0;
    const a2Start = 2 * pi / 3;
    const a3Start = 4 * pi / 3;

    return SizedBox(
      width: wrapSize,
      height: wrapSize,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          floatY,
          glowScale,
          glowOpacity,
          orbit1,
          orbit2,
          orbit3,
        ]),
        builder: (context, _) {
          // Dot positions
          final a1 = a1Start + 2 * pi * orbit1.value;
          final a2 = a2Start + 2 * pi * orbit2.value;
          final a3 = a3Start + 2 * pi * orbit3.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing glow
              Opacity(
                opacity: glowOpacity.value,
                child: Transform.scale(
                  scale: glowScale.value,
                  child: Container(
                    width: wrapSize,
                    height: wrapSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.auroraPink.withValues(alpha: 0.18),
                          AppColors.auroraPurple.withValues(alpha: 0.10),
                          AppColors.auroraPurple.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // Orbit dot 1 — pink
              Positioned(
                left: center + r1 * cos(a1) - 3.5,
                top: center + r1 * sin(a1) - 3.5,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.auroraPink,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Orbit dot 2 — blue
              Positioned(
                left: center + r2 * cos(a2) - 2.5,
                top: center + r2 * sin(a2) - 2.5,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.auroraElectricBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Orbit dot 3 — green
              Positioned(
                left: center + r3 * cos(a3) - 2.0,
                top: center + r3 * sin(a3) - 2.0,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.verifiedGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Floating bag
              Transform.translate(
                offset: Offset(0, floatY.value),
                child: CustomPaint(
                  size: const Size(72, 72),
                  painter: _BagPainter(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Bag stroke painter ────────────────────────────────────────────────────────

class _BagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shader = const LinearGradient(
      colors: AppColors.auroraGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final bodyPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round;

    final smilePaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Scale from 72×72 viewBox to actual size
    final sx = size.width / 72;
    final sy = size.height / 72;

    // Bag body: M14 28 h44 l-5 30 H19 Z
    final body = Path()
      ..moveTo(14 * sx, 28 * sy)
      ..lineTo(58 * sx, 28 * sy)
      ..lineTo(53 * sx, 58 * sy)
      ..lineTo(19 * sx, 58 * sy)
      ..close();
    canvas.drawPath(body, bodyPaint);

    // Handle: M24 28 v-6 arc to (48,22) r=12 sweep CW, v6
    final handle = Path()
      ..moveTo(24 * sx, 28 * sy)
      ..lineTo(24 * sx, 22 * sy)
      ..arcToPoint(
        Offset(48 * sx, 22 * sy),
        radius: Radius.circular(12 * sx),
        clockwise: true,
      )
      ..lineTo(48 * sx, 28 * sy);
    canvas.drawPath(handle, bodyPaint);

    // Smile: M28 44 Q36 50 44 44
    final smile = Path()
      ..moveTo(28 * sx, 44 * sy)
      ..quadraticBezierTo(36 * sx, 50 * sy, 44 * sx, 44 * sy);
    canvas.drawPath(smile, smilePaint);
  }

  @override
  bool shouldRepaint(_BagPainter _) => false;
}
