import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../backend_integration/dtos/order/place_order_request_dto.dart';
import '../../../routes/route_constants.dart';
import '../../../services/address_service.dart';
import '../../../services/cart_service.dart';
import '../../../services/orders_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/input_fields/aurora_input_field.dart';
import '../cart/widgets/address_pill.dart';
import '../order_success/order_success_screen.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _noteController = TextEditingController();
  bool _placing = false;

  AddressService get _addressService => GetIt.instance<AddressService>();
  CartService get _cartService => GetIt.instance<CartService>();
  OrdersService get _ordersService => GetIt.instance<OrdersService>();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_placing || _addressService.selectedAddress == null) return;
    setState(() => _placing = true);

    final dto = PlaceOrderRequestDto(
      customerAddressId: _addressService.selectedAddress!.id,
      customerNote: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    final result = await _ordersService.placeOrder(dto);
    if (!mounted) return;
    setState(() => _placing = false);

    if (result != null) {
      await _cartService.clearCart();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        orderSuccessScreenRoute,
        arguments: OrderSuccessArgs(
          orderId: result.orderId,
          orderNumber: result.trackingNumber,
          estimatedDelivery: '2–5 business days',
          paymentMethod: 'Cash on delivery',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        ThemeService.instance,
        _addressService,
        _cartService,
      ]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final titleColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final hasAddress = _addressService.selectedAddress != null;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -100, right: -100, size: 260,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -100, left: -100, size: 280,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.arrowLeft,
                                size: 18, color: iconColor),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Text(
                            'Checkout',
                            style: AppTextStyles.dsH2.copyWith(
                              color: titleColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionLabel(label: 'Delivery address', isDark: isDark),
                            const AddressPill(),
                            if (!hasAddress) ...[
                              const SizedBox(height: 8),
                              _NoAddressWarning(),
                            ],

                            _SectionLabel(label: 'Order summary', isDark: isDark),
                            _OrderSummaryCard(
                              cartService: _cartService,
                              isDark: isDark,
                            ),

                            _SectionLabel(label: 'Payment method', isDark: isDark),
                            _PaymentCard(isDark: isDark),

                            _SectionLabel(
                              label: 'Delivery note',
                              isDark: isDark,
                              optional: true,
                            ),
                            AuroraInputField(
                              controller: _noteController,
                              hint: 'Any special instructions for delivery?',
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sticky bottom bar
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _StickyBar(
                  isDark: isDark,
                  placing: _placing,
                  enabled: hasAddress,
                  onPlace: _placeOrder,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  final bool optional;

  const _SectionLabel({
    required this.label,
    required this.isDark,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? AppColors.white.withValues(alpha: 0.38)
        : AppColors.auroraPurple.withValues(alpha: 0.45);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.dsSectionLabel.copyWith(
              color: color,
              fontSize: 11,
            ),
          ),
          if (optional) ...[
            const SizedBox(width: 6),
            Text(
              '(optional)',
              style: AppTextStyles.dsMuted.copyWith(
                fontSize: 10,
                color: color.withValues(alpha: 0.65),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── No address warning ────────────────────────────────────────────────────────

class _NoAddressWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.auroraRed.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.auroraRed.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.triangleExclamation,
            size: 12,
            color: AppColors.auroraRed,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Please select a delivery address to continue',
              style: AppTextStyles.dsMuted.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.auroraRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Order summary card ────────────────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  final CartService cartService;
  final bool isDark;

  const _OrderSummaryCard({
    required this.cartService,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final fill = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.white;
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.auroraPurple.withValues(alpha: 0.12);
    final divider = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.08);
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final muteColor = isDark
        ? AppColors.white.withValues(alpha: 0.40)
        : AppColors.auroraPurple.withValues(alpha: 0.55);

    final items = cartService.displayItems;

    return Container(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          // Items
          ...items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            return Column(
              children: [
                if (i > 0)
                  Divider(height: 1, thickness: 1, color: divider,
                      indent: 14, endIndent: 14),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  child: Row(
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 38,
                          height: 38,
                          child: item.imageUrl != null
                              ? Image.network(
                                  item.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, err, stack) =>
                                      _GradientThumb(index: i),
                                )
                              : _GradientThumb(index: i),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: AppTextStyles.dsBody.copyWith(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.colorName} · ${item.sizeName} · Qty ${item.quantity}',
                              style: AppTextStyles.dsMuted.copyWith(
                                fontSize: 10.5,
                                color: muteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${item.lineTotal.toStringAsFixed(2)}',
                        style: AppTextStyles.dsBody.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

          // Totals
          Divider(height: 1, thickness: 1, color: divider),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              children: [
                _TotalRow(
                  label: 'Subtotal',
                  value: '\$${cartService.subtotal.toStringAsFixed(2)}',
                  isDark: isDark,
                ),
                const SizedBox(height: 5),
                _TotalRow(
                  label: 'Delivery fee',
                  value: 'Free',
                  valueColor: AppColors.verifiedGreen,
                  isDark: isDark,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: _DashedDivider(color: divider),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTextStyles.dsBody.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (rect) => const LinearGradient(
                        colors: [AppColors.auroraPink, AppColors.auroraElectricBlue],
                      ).createShader(rect),
                      child: Text(
                        '\$${cartService.subtotal.toStringAsFixed(2)}',
                        style: AppTextStyles.dsH2.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                          letterSpacing: -0.5,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isDark;

  const _TotalRow({
    required this.label,
    required this.value,
    this.valueColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark
        ? AppColors.white.withValues(alpha: 0.45)
        : AppColors.auroraPurple.withValues(alpha: 0.55);
    final vColor = valueColor ??
        (isDark ? AppColors.white : AppColors.auroraDeepBase);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.dsMuted.copyWith(
                fontSize: 12.5, color: labelColor)),
        Text(value,
            style: AppTextStyles.dsBody.copyWith(
                fontSize: 13, fontWeight: FontWeight.w700, color: vColor)),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashW = 4.0, gap = 4.0;
        final count = (constraints.maxWidth / (dashW + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => SizedBox(
              width: dashW,
              height: 1,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            ),
          ),
        );
      },
    );
  }
}

class _GradientThumb extends StatelessWidget {
  final int index;
  const _GradientThumb({required this.index});

  static const _gradients = [
    [AppColors.auroraPink, AppColors.auroraPurple],
    [AppColors.auroraPurple, AppColors.auroraElectricBlue],
    [AppColors.auroraElectricBlue, AppColors.verifiedGreen],
    [AppColors.auroraGold, AppColors.auroraRed],
  ];

  @override
  Widget build(BuildContext context) {
    final pair = _gradients[index % _gradients.length];
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: pair,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}

// ── Payment card ──────────────────────────────────────────────────────────────

class _PaymentCard extends StatelessWidget {
  final bool isDark;
  const _PaymentCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final fill = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.white;
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.auroraPurple.withValues(alpha: 0.12);
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final muteColor = isDark
        ? AppColors.white.withValues(alpha: 0.40)
        : AppColors.auroraPurple.withValues(alpha: 0.50);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.auroraPurple.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: FaIcon(
              FontAwesomeIcons.moneyBill,
              size: 15,
              color: AppColors.auroraPurple,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash on delivery',
                  style: AppTextStyles.dsBody.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pay when your order arrives',
                  style: AppTextStyles.dsMuted.copyWith(
                    fontSize: 10.5,
                    color: muteColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.auroraPurple.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ONLY',
              style: AppTextStyles.dsMuted.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: AppColors.auroraPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sticky bottom bar ─────────────────────────────────────────────────────────

class _StickyBar extends StatelessWidget {
  final bool isDark;
  final bool placing;
  final bool enabled;
  final VoidCallback onPlace;

  const _StickyBar({
    required this.isDark,
    required this.placing,
    required this.enabled,
    required this.onPlace,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            bg.withValues(alpha: 0),
            bg,
          ],
          stops: const [0.0, 0.45],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: SafeArea(
        top: false,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.45,
          child: AuroraPrimaryButton(
            text: 'Place order',
            isLoading: placing,
            onPressed: enabled ? onPlace : () {},
          ),
        ),
      ),
    );
  }
}
