import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../splash/widgets/aurora_glow_blob.dart';

// Horizontal tracker step labels (4 steps)
const _kHSteps = ['Placed', 'Processing', 'Shipped', 'Delivered'];

// ── Screen ────────────────────────────────────────────────────────────────────

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.order});
  final MockOrderDetail order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int get _hFilledCount => widget.order.timelineStep.clamp(0, 4);

  bool get _canCancel =>
      widget.order.status == 'Processing' || widget.order.status == 'Shipped';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final titleColor = isDark ? AppColors.white : AppColors.auroraDeepBase;

        return Scaffold(
          backgroundColor: bg,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -100, right: -100, size: 260,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.18 : 0.08,
              ),
              AuroraGlowBlob(
                bottom: -100, left: -100, size: 280,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.16 : 0.07,
              ),
              SafeArea(
                child: Column(
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
                          const SizedBox(width: 4),
                          Text(
                            'Order Detail',
                            style: AppTextStyles.dsBodyBold.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Scrollable body
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 32),
                        child: Column(
                          children: [
                            _HeroCard(
                              order: widget.order,
                              isDark: isDark,
                              hFilledCount: _hFilledCount,
                            ),
                            const SizedBox(height: 12),
                            _ItemsCard(order: widget.order, isDark: isDark),
                            const SizedBox(height: 12),
                            _SummaryCard(order: widget.order, isDark: isDark),
                            const SizedBox(height: 12),
                            _AddressCard(isDark: isDark),
                            const SizedBox(height: 12),
                            _PaymentCard(isDark: isDark),
                            if (_canCancel) ...[
                              const SizedBox(height: 16),
                              _CancelButton(isDark: isDark),
                            ],
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

// ── Hero card ─────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.order,
    required this.isDark,
    required this.hFilledCount,
  });
  final MockOrderDetail order;
  final bool isDark;
  final int hFilledCount;

  @override
  Widget build(BuildContext context) {
    final cardFill = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.auroraPurple.withValues(alpha: 0.03);
    final cardBorder = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.auroraPurple.withValues(alpha: 0.09);
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.07)
        : AppColors.auroraPurple.withValues(alpha: 0.08);
    final numColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final metaColor = isDark
        ? AppColors.white.withValues(alpha: 0.38)
        : AppColors.auroraDeepBase.withValues(alpha: 0.38);

    return Container(
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Subtle glow blob inside hero card
            Positioned(
              top: -50, right: -50,
              child: Container(
                width: 180, height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: order.statusColor.withValues(alpha: isDark ? 0.18 : 0.10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order # + status pill
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.id,
                              style: AppTextStyles.dsBodyBold.copyWith(
                                color: numColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${order.date} · ${order.items.length} items',
                              style: AppTextStyles.dsMuted.copyWith(
                                color: metaColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusPill(status: order.status, color: order.statusColor),
                    ],
                  ),
                  // Divider
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    color: dividerColor,
                  ),
                  // Horizontal step tracker
                  _HorizontalTracker(filledCount: hFilledCount, isDark: isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status pill ───────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.color});
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.dsCTA.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Horizontal step tracker ───────────────────────────────────────────────────

class _HorizontalTracker extends StatelessWidget {
  const _HorizontalTracker({required this.filledCount, required this.isDark});
  final int filledCount;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_kHSteps.length, (i) {
        final isFilled = i < filledCount;
        final isCurrent = i == filledCount - 1 && filledCount < _kHSteps.length;
        final isLast = i == _kHSteps.length - 1;
        final dotColor = isFilled
            ? null // gradient applied below
            : isDark
                ? AppColors.white.withValues(alpha: 0.06)
                : AppColors.auroraPurple.withValues(alpha: 0.06);
        final labelStyle = AppTextStyles.dsMuted.copyWith(
          fontSize: 9,
          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w700,
          color: isFilled
              ? (isDark
                  ? AppColors.white.withValues(alpha: 0.75)
                  : AppColors.auroraDeepBase.withValues(alpha: 0.65))
              : (isDark
                  ? AppColors.white.withValues(alpha: 0.28)
                  : AppColors.auroraDeepBase.withValues(alpha: 0.28)),
        );

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // Dot
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFilled ? null : dotColor,
                            gradient: isFilled
                                ? const LinearGradient(
                                    colors: AppColors.auroraGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            border: isFilled
                                ? null
                                : Border.all(
                                    color: isDark
                                        ? AppColors.white.withValues(alpha: 0.10)
                                        : AppColors.auroraPurple.withValues(alpha: 0.14),
                                  ),
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: AppColors.auroraPink.withValues(alpha: 0.45),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isFilled
                              ? Center(
                                  child: FaIcon(
                                    i == filledCount - 1 && !isCurrent
                                        ? FontAwesomeIcons.check
                                        : _hStepIcon(i),
                                    size: 11,
                                    color: AppColors.white,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 5),
                        Text(_kHSteps[i], style: labelStyle),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          gradient: isFilled && i < filledCount - 1
                              ? const LinearGradient(
                                  colors: [AppColors.auroraPurple, AppColors.auroraElectricBlue],
                                )
                              : null,
                          color: (!isFilled || i >= filledCount - 1)
                              ? (isDark
                                  ? AppColors.white.withValues(alpha: 0.07)
                                  : AppColors.auroraPurple.withValues(alpha: 0.10))
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  FaIconData _hStepIcon(int i) {
    switch (i) {
      case 0: return FontAwesomeIcons.check;
      case 1: return FontAwesomeIcons.gear;
      case 2: return FontAwesomeIcons.truck;
      default: return FontAwesomeIcons.boxOpen;
    }
  }
}

// ── Items card ────────────────────────────────────────────────────────────────

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.order, required this.isDark});
  final MockOrderDetail order;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'ITEMS ORDERED',
      isDark: isDark,
      child: Column(
        children: List.generate(order.items.length, (i) {
          final item = order.items[i];
          final isLast = i == order.items.length - 1;
          final thumbGradients = [
            [AppColors.auroraPink, AppColors.auroraPurple],
            [AppColors.auroraPurple, AppColors.auroraElectricBlue],
            [AppColors.auroraElectricBlue, AppColors.verifiedGreen],
          ];
          final g = thumbGradients[i % 3];
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: g,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: AppTextStyles.dsBodyBold.copyWith(
                            color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Size ${item.size} · Qty ${item.quantity}',
                          style: AppTextStyles.dsMuted.copyWith(
                            color: isDark
                                ? AppColors.white.withValues(alpha: 0.38)
                                : AppColors.auroraDeepBase.withValues(alpha: 0.38),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTextStyles.dsBodyBold.copyWith(
                      color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.06)
                      : AppColors.auroraPurple.withValues(alpha: 0.07),
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        }),
      ),
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.order, required this.isDark});
  final MockOrderDetail order;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final valColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final labelColor = isDark
        ? AppColors.white.withValues(alpha: 0.45)
        : AppColors.auroraDeepBase.withValues(alpha: 0.45);
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.07);

    return _SectionCard(
      title: 'ORDER SUMMARY',
      isDark: isDark,
      child: Column(
        children: [
          _PriceRow(
            label: 'Subtotal',
            value: '\$${order.subtotal.toStringAsFixed(2)}',
            labelColor: labelColor,
            valColor: valColor,
          ),
          const SizedBox(height: 6),
          _PriceRow(
            label: 'Shipping',
            value: order.shipping == 0.0 ? 'Free' : '\$${order.shipping.toStringAsFixed(2)}',
            labelColor: labelColor,
            valColor: valColor,
          ),
          const SizedBox(height: 6),
          _PriceRow(
            label: 'Tax',
            value: '\$${order.tax.toStringAsFixed(2)}',
            labelColor: labelColor,
            valColor: valColor,
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: dividerColor),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.dsBodyBold.copyWith(
                  color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: AppColors.auroraGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                blendMode: BlendMode.srcIn,
                child: Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: AppTextStyles.dsBodyBold.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valColor,
  });
  final String label;
  final String value;
  final Color labelColor;
  final Color valColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.dsMuted.copyWith(color: labelColor, fontSize: 12, fontWeight: FontWeight.w500)),
        Text(value, style: AppTextStyles.dsBodyBold.copyWith(color: valColor, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// ── Address card ──────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'DELIVERY ADDRESS',
      isDark: isDark,
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  AppColors.auroraPurple.withValues(alpha: 0.14),
                  AppColors.auroraElectricBlue.withValues(alpha: 0.09),
                ],
              ),
              border: Border.all(color: AppColors.auroraPurple.withValues(alpha: 0.18)),
            ),
            child: Center(
              child: FaIcon(FontAwesomeIcons.locationDot, size: 14, color: AppColors.auroraPurple),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nour Mawla',
                  style: AppTextStyles.dsBodyBold.copyWith(
                    color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                    fontSize: 13, fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Hamra St, Beirut, Lebanon',
                  style: AppTextStyles.dsMuted.copyWith(
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.38)
                        : AppColors.auroraDeepBase.withValues(alpha: 0.38),
                    fontSize: 11, fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Payment card ──────────────────────────────────────────────────────────────

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'PAYMENT',
      isDark: isDark,
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  AppColors.auroraPurple.withValues(alpha: 0.14),
                  AppColors.auroraElectricBlue.withValues(alpha: 0.09),
                ],
              ),
              border: Border.all(color: AppColors.auroraPurple.withValues(alpha: 0.18)),
            ),
            child: Center(
              child: FaIcon(FontAwesomeIcons.moneyBill, size: 14, color: AppColors.auroraPurple),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash on Delivery',
                  style: AppTextStyles.dsBodyBold.copyWith(
                    color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                    fontSize: 13, fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Pay when you receive your order',
                  style: AppTextStyles.dsMuted.copyWith(
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.38)
                        : AppColors.auroraDeepBase.withValues(alpha: 0.38),
                    fontSize: 11, fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cancel button ─────────────────────────────────────────────────────────────

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.auroraRed.withValues(alpha: isDark ? 0.08 : 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.auroraRed.withValues(alpha: isDark ? 0.22 : 0.18),
          ),
        ),
        child: Center(
          child: Text(
            'CANCEL ORDER',
            style: AppTextStyles.dsCTA.copyWith(
              color: AppColors.auroraRed,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared section card ───────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.isDark,
    required this.child,
  });
  final String title;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cardFill = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.auroraPurple.withValues(alpha: 0.03);
    final cardBorder = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.auroraPurple.withValues(alpha: 0.09);
    final labelColor = isDark
        ? AppColors.white.withValues(alpha: 0.35)
        : AppColors.auroraPurple.withValues(alpha: 0.55);

    return Container(
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.dsFieldLabel.copyWith(color: labelColor),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Mock data models ──────────────────────────────────────────────────────────

class MockOrderDetail {
  const MockOrderDetail({
    required this.id,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.statusIcon,
    required this.timelineStep,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
  });

  final String id;
  final String date;
  final String status;
  final Color statusColor;
  final FaIconData statusIcon;
  final int timelineStep; // 1-4
  final List<MockOrderItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
}

class MockOrderItem {
  const MockOrderItem({
    required this.name,
    required this.quantity,
    required this.size,
    required this.price,
  });

  final String name;
  final int quantity;
  final String size;
  final double price;
}
