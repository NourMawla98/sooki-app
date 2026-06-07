import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../../backend_integration/apis/orders_api.dart';
import '../../../../services/address_service.dart';
import '../../../../services/cart_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_primary_button.dart';
import '_cart_surface_theme.dart';

class CartSummary extends StatefulWidget {
  final CartService cartService;
  final VoidCallback onCheckout;

  const CartSummary({
    super.key,
    required this.cartService,
    required this.onCheckout,
  });

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotsController;

  double? _deliveryFee;
  bool _loadingFee = false;
  double _lastFetchedSubtotal = -1;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();
    widget.cartService.addListener(_onCartChanged);
    _fetchFee();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    widget.cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    final sub = widget.cartService.subtotal;
    if (sub != _lastFetchedSubtotal) _fetchFee();
  }

  Future<void> _fetchFee() async {
    if (widget.cartService.isEmpty) {
      setState(() {
        _deliveryFee = 0.0;
        _loadingFee = false;
        _lastFetchedSubtotal = widget.cartService.subtotal;
      });
      return;
    }

    final addressService = GetIt.instance<AddressService>();
    if (addressService.addresses.isEmpty) {
      await addressService.loadFromServer();
    }
    final addressId = addressService.selectedId;
    if (addressId == null) return;

    final subtotal = widget.cartService.subtotal;
    _lastFetchedSubtotal = subtotal;
    setState(() => _loadingFee = true);

    final api = GetIt.instance<OrdersApi>();
    final result = await api.getDeliveryFee(
      addressId: addressId,
      cartTotal: subtotal,
    );

    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loadingFee = false),
      (fee) => setState(() {
        _deliveryFee = fee;
        _loadingFee = false;
      }),
    );
  }

  double get _effectiveShipping {
    if (_deliveryFee != null) return _deliveryFee!;
    return widget.cartService.shippingCost;
  }

  double get _effectiveTotal {
    final raw = widget.cartService.subtotal +
        _effectiveShipping -
        widget.cartService.promoDiscount;
    return raw < 0 ? 0 : raw;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.cartService, ThemeService.instance]),
      builder: (context, _) {
        final c = CartSurfaceColors.of(
          isDark: ThemeService.instance.isDarkMode,
        );
        final subtotal = widget.cartService.subtotal;
        final promoDiscount = widget.cartService.promoDiscount;
        final itemCount = widget.cartService.itemCount;
        final hasPromo = widget.cartService.hasPromo;

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
                      _ShippingRow(
                        loadingFee: _loadingFee,
                        deliveryFee: _deliveryFee,
                        fallback: widget.cartService.shippingCost,
                        dotsController: _dotsController,
                        labelColor: c.textMute,
                        valueColor: c.text,
                      ),
                      if (hasPromo) ...[
                        const SizedBox(height: 6),
                        _SummaryRow(
                          label: 'Promo · ${widget.cartService.promoCode}',
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
                        total: _effectiveTotal,
                        surfaceColors: c,
                      ),
                      const SizedBox(height: 12),
                      AuroraPrimaryButton(
                        text: 'Proceed to checkout',
                        onPressed: widget.onCheckout,
                        height: 40,
                        borderRadius: 10,
                        textStyle: AppTextStyles.buttonMedium.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                          color: AppColors.white,
                        ),
                      ),
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

// ─── Shipping row with dots loader ──────────────────────────────────────
class _ShippingRow extends StatelessWidget {
  final bool loadingFee;
  final double? deliveryFee;
  final double fallback;
  final AnimationController dotsController;
  final Color labelColor;
  final Color valueColor;

  const _ShippingRow({
    required this.loadingFee,
    required this.deliveryFee,
    required this.fallback,
    required this.dotsController,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget valueWidget;
    if (loadingFee) {
      valueWidget = _DotsLoader(controller: dotsController, color: valueColor);
    } else {
      final fee = deliveryFee ?? fallback;
      final text = fee == 0.0 ? 'Free' : '\$${fee.toStringAsFixed(2)}';
      valueWidget = Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: fee == 0.0 ? AppColors.auroraPink : valueColor,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Shipping',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        valueWidget,
      ],
    );
  }
}

// ─── Animated dots loader ────────────────────────────────────────────────
class _DotsLoader extends AnimatedWidget {
  final Color color;

  const _DotsLoader({
    required AnimationController controller,
    required this.color,
  }) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    final controller = listenable as AnimationController;
    final step = (controller.value * 3).floor();
    final dots = '.' * (step + 1);
    return SizedBox(
      width: 24,
      child: Text(
        dots,
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
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

// ─── Trust row ──────────────────────────────────────────────────────────
class _TrustRow extends StatelessWidget {
  final CartSurfaceColors surfaceColors;

  const _TrustRow({required this.surfaceColors});

  @override
  Widget build(BuildContext context) {
    final items = [
      (FontAwesomeIcons.shieldHalved, 'Secure'),
      (FontAwesomeIcons.bolt, 'Fast'),
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
