import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../routes/route_constants.dart';
import '../../../services/cart_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/number_localization.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/aurora/aurora_secondary_button.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class OrderSuccessArgs {
  final int? orderId;
  final String orderNumber;
  final String estimatedDelivery;
  final String paymentMethod;

  const OrderSuccessArgs({
    this.orderId,
    this.orderNumber = '',
    this.estimatedDelivery = '2-5 business days',
    this.paymentMethod = 'Cash on delivery',
  });
}

class OrderSuccessScreen extends StatefulWidget {
  final OrderSuccessArgs args;

  const OrderSuccessScreen({
    super.key,
    this.args = const OrderSuccessArgs(),
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

// ── Confetti data model ──────────────────────────────────────────────────────

class _ConfettiPiece {
  final double x;
  final double phase;
  final double speed;
  final Color color;
  final double size;
  final bool isCircle;

  const _ConfettiPiece({
    required this.x,
    required this.phase,
    required this.speed,
    required this.color,
    required this.size,
    required this.isCircle,
  });
}

// ── Confetti painter ─────────────────────────────────────────────────────────

class _ConfettiPainter extends CustomPainter {
  final double animValue;
  final List<_ConfettiPiece> pieces;

  const _ConfettiPainter({required this.animValue, required this.pieces});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final piece in pieces) {
      final progress = (animValue * piece.speed + piece.phase) % 1.0;
      final y = progress * (size.height + 20) - 10;
      final x = piece.x * size.width;
      final opacity = progress > 0.8 ? (1.0 - progress) / 0.2 : 1.0;

      paint.color = piece.color.withValues(alpha: opacity.clamp(0.0, 1.0));

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * 4 * pi);

      if (piece.isCircle) {
        canvas.drawCircle(Offset.zero, piece.size / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero,
                width: piece.size,
                height: piece.size),
            const Radius.circular(1.5),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.animValue != animValue;
}

// ── Screen state ─────────────────────────────────────────────────────────────

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _confettiCtrl;
  late final AnimationController _emojiCtrl;
  late final Animation<double> _emojiBounce;
  late final List<_ConfettiPiece> _pieces;

  static const _confettiColors = <Color>[
    AppColors.auroraPink,
    AppColors.auroraPurple,
    AppColors.auroraElectricBlue,
    AppColors.verifiedGreen,
    AppColors.auroraGold,
    AppColors.auroraRed,
    AppColors.white,
  ];

  @override
  void initState() {
    super.initState();

    final rng = Random();
    _pieces = List.generate(55, (_) => _ConfettiPiece(
          x: rng.nextDouble(),
          phase: rng.nextDouble(),
          speed: 0.6 + rng.nextDouble() * 0.4,
          color: _confettiColors[rng.nextInt(_confettiColors.length)],
          size: 5.0 + rng.nextDouble() * 5.0,
          isCircle: rng.nextBool(),
        ));

    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _emojiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _emojiBounce = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _emojiCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _emojiCtrl.dispose();
    super.dispose();
  }

  void _continueShopping() {
    GetIt.instance<CartService>().clearCart();
    Navigator.pushNamedAndRemoveUntil(context, mainScreenRoute, (_) => false);
  }

  void _trackOrder() {
    final id = widget.args.orderId;
    if (id != null) {
      Navigator.of(context)
        ..popUntil((route) => route.isFirst)
        ..pushNamed(orderDetailScreenRoute, arguments: id);
    } else {
      Navigator.of(context)
        ..popUntil((route) => route.isFirst)
        ..pushNamed(ordersScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final headingColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final subColor = isDark
            ? AppColors.white.withValues(alpha: 0.42)
            : AppColors.auroraDeepBase.withValues(alpha: 0.42);
        final cardFill = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.auroraPurple.withValues(alpha: 0.03);
        final cardBorder = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.auroraPurple.withValues(alpha: 0.10);
        final dividerColor = isDark
            ? AppColors.white.withValues(alpha: 0.05)
            : AppColors.auroraPurple.withValues(alpha: 0.07);
        final labelColor = isDark
            ? AppColors.white.withValues(alpha: 0.38)
            : AppColors.auroraDeepBase.withValues(alpha: 0.38);
        final valueColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final closeColor = isDark ? AppColors.white : AppColors.auroraDeepBase;

        return Scaffold(
          backgroundColor: bg,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -100,
                right: -100,
                size: 280,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -100,
                left: -100,
                size: 300,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),

              // Confetti
              AnimatedBuilder(
                animation: _confettiCtrl,
                builder: (context, _) => CustomPaint(
                  painter: _ConfettiPainter(
                    animValue: _confettiCtrl.value,
                    pieces: _pieces,
                  ),
                  size: Size.infinite,
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // Close button row
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 16, 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.xmark,
                              size: 18,
                              color: closeColor,
                            ),
                            onPressed: _continueShopping,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 32),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),

                            // Celebration emoji with glow + bounce
                            _EmojiCelebration(bounceAnim: _emojiBounce),

                            const SizedBox(height: 28),

                            // Aurora gradient eyebrow
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
                                'order_success_screen.order_confirmed'.tr(),
                                style: AppTextStyles.dsSectionLabel.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'order_success_screen.on_its_way_title'.tr(),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.dsH2.copyWith(
                                color: headingColor,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'order_success_screen.received_subtitle'.tr(),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.dsMuted.copyWith(
                                color: subColor,
                                fontSize: 13,
                                height: 1.55,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Order info card
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: cardFill,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: cardBorder),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  _OrderRow(
                                    label: 'order_success_screen.order_number'.tr(),
                                    // Tracking number is an identifier the
                                    // shopper reads back to support, so its
                                    // digits stay Western.
                                    value: widget.args.orderNumber,
                                    valueColor: AppColors.auroraPurple,
                                    labelColor: labelColor,
                                    dividerColor: dividerColor,
                                    isFirst: true,
                                  ),
                                  _OrderRow(
                                    label: 'order_success_screen.estimated_delivery'.tr(),
                                    value: localizedDigits(
                                        widget.args.estimatedDelivery),
                                    valueColor: valueColor,
                                    labelColor: labelColor,
                                    dividerColor: dividerColor,
                                  ),
                                  _OrderRow(
                                    label: 'order_success_screen.payment'.tr(),
                                    value: widget.args.paymentMethod,
                                    valueColor: AppColors.verifiedGreen,
                                    labelColor: labelColor,
                                    dividerColor: dividerColor,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            AuroraPrimaryButton(
                              text: 'order_success_screen.track_my_order'.tr(),
                              onPressed: _trackOrder,
                            ),
                            const SizedBox(height: 12),
                            AuroraSecondaryButton(
                              text: 'order_success_screen.continue_shopping'.tr(),
                              onPressed: _continueShopping,
                            ),
                          ],
                        ),
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

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _EmojiCelebration extends StatelessWidget {
  final Animation<double> bounceAnim;

  const _EmojiCelebration({required this.bounceAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bounceAnim,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, bounceAnim.value),
        child: child,
      ),
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.auroraPink.withValues(alpha: 0.22),
                    AppColors.auroraPurple.withValues(alpha: 0.12),
                    AppColors.auroraPurple.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            const Text('🎉', style: TextStyle(fontSize: 56)),
          ],
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final Color labelColor;
  final Color dividerColor;
  final bool isFirst;

  const _OrderRow({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.labelColor,
    required this.dividerColor,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFirst) Divider(color: dividerColor, height: 1, thickness: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.dsCTA.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.dsCTA.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
