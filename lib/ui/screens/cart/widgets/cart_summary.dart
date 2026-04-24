import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/cart_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '_cart_surface_theme.dart';

class CartSummary extends StatelessWidget {
  final CartService cartService;
  final VoidCallback onCheckout;

  const CartSummary({
    super.key,
    required this.cartService,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([cartService, ThemeService.instance]),
      builder: (context, _) {
        final c = CartSurfaceColors.of(
          isDark: ThemeService.instance.isDarkMode,
        );
        final subtotal = cartService.subtotal;
        final shipping = cartService.shippingCost;
        final promoDiscount = cartService.promoDiscount;
        final total = cartService.total;
        final itemCount = cartService.itemCount;
        final hasPromo = cartService.hasPromo;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: c.sheet,
            border: Border(top: BorderSide(color: c.sheetTop, width: 1)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Stack(
              children: [
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _AuroraBarLine(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SummaryRow(
                        label: 'Subtotal',
                        value: '\$${subtotal.toStringAsFixed(2)}',
                        labelColor: c.textMute,
                        valueColor: c.text,
                      ),
                      const SizedBox(height: 6),
                      _SummaryRow(
                        label: 'Shipping',
                        value: '\$${shipping.toStringAsFixed(2)}',
                        labelColor: c.textMute,
                        valueColor: c.text,
                      ),
                      if (hasPromo) ...[
                        const SizedBox(height: 6),
                        _SummaryRow(
                          label: 'Promo · ${cartService.promoCode}',
                          value: '−\$${promoDiscount.toStringAsFixed(2)}',
                          labelColor: c.textMute,
                          valueColor: AppColors.auroraPink,
                        ),
                      ],
                      const SizedBox(height: 10),
                      _DashedDivider(color: c.divider),
                      const SizedBox(height: 10),
                      _TotalRow(
                        itemCount: itemCount,
                        total: total,
                        surfaceColors: c,
                      ),
                      const SizedBox(height: 12),
                      _CheckoutCta(onTap: onCheckout),
                      const SizedBox(height: 10),
                      _TrustRow(surfaceColors: c),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Animated aurora bar line ───────────────────────────────────────────
class _AuroraBarLine extends StatefulWidget {
  const _AuroraBarLine();

  @override
  State<_AuroraBarLine> createState() => _AuroraBarLineState();
}

class _AuroraBarLineState extends State<_AuroraBarLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final shift = _controller.value * 2 - 1;
              return Align(
                alignment: Alignment(shift, 0),
                widthFactor: 2,
                child: const SizedBox(
                  height: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.auroraElectricBlue,
                          AppColors.auroraPurple,
                          AppColors.auroraPink,
                          AppColors.auroraElectricBlue,
                        ],
                      ),
                    ),
                    child: SizedBox(width: 500),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Generic label/value row ────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ─── Total row ──────────────────────────────────────────────────────────
class _TotalRow extends StatelessWidget {
  final int itemCount;
  final double total;
  final CartSurfaceColors surfaceColors;

  const _TotalRow({
    required this.itemCount,
    required this.total,
    required this.surfaceColors,
  });

  @override
  Widget build(BuildContext context) {
    final itemLabel = itemCount == 1 ? 'item' : 'items';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'Total',
              style: AppTextStyles.heading3.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: surfaceColors.text,
                letterSpacing: -0.1,
              ),
              children: [
                TextSpan(
                  text: '   · $itemCount $itemLabel',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: surfaceColors.textMute2,
                  ),
                ),
              ],
            ),
          ),
        ),
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            colors: [AppColors.auroraPink, AppColors.auroraElectricBlue],
          ).createShader(rect),
          child: Text(
            '\$${total.toStringAsFixed(2)}',
            style: AppTextStyles.heading2.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Dashed divider ─────────────────────────────────────────────────────
class _DashedDivider extends StatelessWidget {
  final Color color;

  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Aurora gradient checkout CTA with shimmer ──────────────────────────
class _CheckoutCta extends StatefulWidget {
  final VoidCallback onTap;

  const _CheckoutCta({required this.onTap});

  @override
  State<_CheckoutCta> createState() => _CheckoutCtaState();
}

class _CheckoutCtaState extends State<_CheckoutCta>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      duration: const Duration(milliseconds: 2600),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.auroraCartButtonGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.auroraPurple.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: AppColors.auroraPink.withValues(alpha: 0.16),
              blurRadius: 14,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _shimmer,
                builder: (context, _) {
                  // Shimmer sweeps left-to-right across the button.
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final t = _shimmer.value;
                      final width = constraints.maxWidth * 0.4;
                      final travel = constraints.maxWidth + width;
                      final x = (t * travel) - width;
                      return Positioned(
                        left: x,
                        top: 0,
                        bottom: 0,
                        width: width,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                AppColors.white.withValues(alpha: 0.30),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.lock,
                      size: 9,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'PROCEED TO CHECKOUT',
                      style: AppTextStyles.buttonMedium.copyWith(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 7),
                    FaIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 9,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Trust row ──────────────────────────────────────────────────────────
class _TrustRow extends StatelessWidget {
  final CartSurfaceColors surfaceColors;

  const _TrustRow({required this.surfaceColors});

  @override
  Widget build(BuildContext context) {
    final items = [
      (FontAwesomeIcons.shieldHalved, 'Secure'),
      (FontAwesomeIcons.rotateLeft, 'Easy returns'),
      (FontAwesomeIcons.moneyBillWave, 'Cash on delivery'),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Row(
            children: [
              FaIcon(items[i].$1, size: 10, color: surfaceColors.textMute2),
              const SizedBox(width: 5),
              Text(
                items[i].$2,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: surfaceColors.textMute2,
                ),
              ),
            ],
          ),
          if (i < items.length - 1) const SizedBox(width: 14),
        ],
      ],
    );
  }
}
