import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../backend_integration/apis/items_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../backend_integration/dtos/order/order_detail_dto.dart';
import '../../../backend_integration/dtos/order/order_item_dto.dart';
import '../../../enums/order_status.dart';
import '../../../services/orders_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/dialogs/aurora_confirm_sheet.dart';
import '../../reusable_components/input_fields/aurora_input_field.dart';
import '../splash/widgets/aurora_glow_blob.dart';

const _kStepLabels = ['Processing', 'Packaged', 'Out for delivery', 'Delivered'];

const _months = [
  '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _fmtDate(DateTime dt) => '${_months[dt.month]} ${dt.day}, ${dt.year}';

// ── Screen ────────────────────────────────────────────────────────────────────

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final int orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderDetailDto? _detail;
  bool _loading = true;
  bool _hasError = false;
  bool _cancelling = false;
  bool _confirming = false;

  OrdersService get _service => GetIt.instance<OrdersService>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _hasError = false; });
    final result = await _service.getOrderDetail(widget.orderId);
    if (!mounted) return;
    result.fold(
      (_) => setState(() { _loading = false; _hasError = true; }),
      (dto) => setState(() { _loading = false; _detail = dto; }),
    );
  }

  Future<void> _cancel() async {
    final detail = _detail;
    if (detail == null || _cancelling) return;
    final confirmed = await showAuroraConfirmSheet(
      context,
      title: 'Cancel order?',
      subtitle: 'This action cannot be undone.',
      icon: FontAwesomeIcons.ban,
      confirmLabel: 'Cancel order',
      confirmColor: AppColors.auroraRed,
    );
    if (!confirmed || !mounted) return;
    setState(() => _cancelling = true);
    final result = await _service.cancelOrder(detail.id);
    if (!mounted) return;
    setState(() => _cancelling = false);
    if (result.success) {
      if (result.message.isNotEmpty) ToastService.instance.showSuccess(result.message);
      await _load();
    }
  }

  Future<void> _confirmReceipt() async {
    final detail = _detail;
    if (detail == null || _confirming) return;
    setState(() => _confirming = true);
    final result = await _service.confirmReceipt(detail.id);
    if (!mounted) return;
    setState(() => _confirming = false);
    if (result.success) {
      if (result.message.isNotEmpty) ToastService.instance.showSuccess(result.message);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final titleColor = isDark ? AppColors.white : AppColors.auroraDeepBase;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
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
                            'Order detail',
                            style: AppTextStyles.dsBodyBold.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.auroraPurple,
                              ),
                            )
                          : _hasError
                              ? _ErrorState(onRetry: _load, isDark: isDark)
                              : RefreshIndicator(
                                  onRefresh: _load,
                                  color: AppColors.auroraPink,
                                  child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(
                                        14, 0, 14, 32),
                                    child: _Body(
                                      detail: _detail!,
                                      isDark: isDark,
                                      cancelling: _cancelling,
                                      confirming: _confirming,
                                      onCancel: _cancel,
                                      onConfirmReceipt: _confirmReceipt,
                                    ),
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

// ── Body ──────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({
    required this.detail,
    required this.isDark,
    required this.cancelling,
    required this.confirming,
    required this.onCancel,
    required this.onConfirmReceipt,
  });

  final OrderDetailDto detail;
  final bool isDark;
  final bool cancelling;
  final bool confirming;
  final VoidCallback onCancel;
  final VoidCallback onConfirmReceipt;

  @override
  Widget build(BuildContext context) {
    final status = OrderStatus.fromInt(detail.status);
    final progressStep = status.progressStep;

    return Column(
      children: [
        _HeroCard(detail: detail, status: status, progressStep: progressStep, isDark: isDark),
        const SizedBox(height: 12),
        _ItemsCard(items: detail.items, isDark: isDark, orderStatus: detail.status),
        const SizedBox(height: 12),
        _SummaryCard(detail: detail, isDark: isDark),
        const SizedBox(height: 12),
        _AddressCard(detail: detail, isDark: isDark),
        const SizedBox(height: 12),
        _PaymentCard(detail: detail, isDark: isDark),
        if (detail.customerNote != null && detail.customerNote!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _NoteCard(note: detail.customerNote!, isDark: isDark),
        ],

        // Action buttons
        if (status.isInProgress && status != OrderStatus.outForDelivery) ...[
          const SizedBox(height: 20),
          _CancelButton(cancelling: cancelling, onCancel: onCancel, isDark: isDark),
        ],
        if (status == OrderStatus.outForDelivery) ...[
          const SizedBox(height: 20),
          AuroraPrimaryButton(
            text: 'Confirm receipt',
            isLoading: confirming,
            onPressed: onConfirmReceipt,
          ),
        ],
      ],
    );
  }
}

// ── Hero card ─────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.detail,
    required this.status,
    required this.progressStep,
    required this.isDark,
  });

  final OrderDetailDto detail;
  final OrderStatus status;
  final int? progressStep;
  final bool isDark;

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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.trackingNumber,
                      style: AppTextStyles.dsBodyBold.copyWith(
                        color: numColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_fmtDate(detail.createdAt)} · ${detail.items.length} items',
                      style: AppTextStyles.dsMuted.copyWith(
                        color: metaColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(status: status),
            ],
          ),

          // Progress tracker — shown only for non-closed orders
          if (progressStep != null) ...[
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 14),
              color: dividerColor,
            ),
            _HorizontalTracker(filledCount: progressStep!, isDark: isDark),
          ],
        ],
      ),
    );
  }
}

// ── Status pill ───────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.accentColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        status.label.toUpperCase(),
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
    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(2 * _kStepLabels.length - 1, (idx) {
          if (idx.isEven) return _buildStep(idx ~/ 2);
          return Expanded(child: _buildLine(idx ~/ 2));
        }),
      ),
    );
  }

  Widget _buildStep(int i) {
    final isFilled = i < filledCount;
    final labelColor = isFilled
        ? (isDark
            ? AppColors.white.withValues(alpha: 0.75)
            : AppColors.auroraDeepBase.withValues(alpha: 0.65))
        : (isDark
            ? AppColors.white.withValues(alpha: 0.28)
            : AppColors.auroraDeepBase.withValues(alpha: 0.28));
    final iconColor = isFilled
        ? AppColors.white
        : isDark
            ? AppColors.white.withValues(alpha: 0.22)
            : AppColors.auroraPurple.withValues(alpha: 0.22);

    return SizedBox(
      width: 28,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled
                  ? null
                  : isDark
                      ? AppColors.white.withValues(alpha: 0.06)
                      : AppColors.auroraPurple.withValues(alpha: 0.06),
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
            ),
            child: Center(
              child: FaIcon(_stepIcon(i), size: 11, color: iconColor),
            ),
          ),
          Positioned(
            top: 33,
            left: -40,
            right: -40,
            child: Text(
              _kStepLabels[i],
              style: AppTextStyles.dsMuted.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: labelColor,
              ),
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(int i) {
    final lineFilled = i < filledCount - 1;
    return Container(
      height: 2,
      margin: const EdgeInsets.only(top: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        gradient: lineFilled
            ? const LinearGradient(
                colors: [AppColors.auroraPurple, AppColors.auroraElectricBlue],
              )
            : null,
        color: lineFilled
            ? null
            : isDark
                ? AppColors.white.withValues(alpha: 0.07)
                : AppColors.auroraPurple.withValues(alpha: 0.10),
      ),
    );
  }

  FaIconData _stepIcon(int i) {
    switch (i) {
      case 0: return FontAwesomeIcons.rotate;
      case 1: return FontAwesomeIcons.box;
      case 2: return FontAwesomeIcons.truck;
      default: return FontAwesomeIcons.circleCheck;
    }
  }
}

// ── Items card ────────────────────────────────────────────────────────────────

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.items, required this.isDark, required this.orderStatus});
  final List<OrderItemDto> items;
  final bool isDark;
  final int orderStatus;

  bool get _canReview => OrderStatus.fromInt(orderStatus).isDelivered;

  void _showReviewDialog(BuildContext context, OrderItemDto item) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => _WriteReviewDialog(item: item),
    );
  }

  static const _gradients = [
    [AppColors.auroraPink, AppColors.auroraPurple],
    [AppColors.auroraPurple, AppColors.auroraElectricBlue],
    [AppColors.auroraElectricBlue, AppColors.verifiedGreen],
    [AppColors.auroraGold, AppColors.auroraRed],
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final muteColor = isDark
        ? AppColors.white.withValues(alpha: 0.38)
        : AppColors.auroraDeepBase.withValues(alpha: 0.38);
    final divColor = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.07);

    return _SectionCard(
      title: 'ITEMS ORDERED',
      isDark: isDark,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final isLast = i == items.length - 1;
          final pair = _gradients[i % _gradients.length];

          return Column(
            children: [
              Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 46,
                      height: 46,
                      child: item.imageUrl != null
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, err, stack) =>
                                  _GradThumb(pair: pair),
                            )
                          : _GradThumb(pair: pair),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.itemTitle,
                          style: AppTextStyles.dsBodyBold.copyWith(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.colorName} · ${item.sizeName} · Qty ${item.quantity}',
                          style: AppTextStyles.dsMuted.copyWith(
                            color: muteColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.dsBodyBold.copyWith(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
              if (_canReview) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () => _showReviewDialog(context, item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.auroraGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.solidStar, size: 11, color: AppColors.auroraGold),
                          const SizedBox(width: 6),
                          Text(
                            'Write a review',
                            style: AppTextStyles.dsMuted.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.auroraGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              if (!isLast) ...[
                const SizedBox(height: 10),
                Container(height: 1, color: divColor),
                const SizedBox(height: 10),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _GradThumb extends StatelessWidget {
  const _GradThumb({required this.pair});
  final List<Color> pair;

  @override
  Widget build(BuildContext context) {
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

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.detail, required this.isDark});
  final OrderDetailDto detail;
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
          _PriceRow(label: 'Subtotal',
              value: '\$${detail.subtotal.toStringAsFixed(2)}',
              labelColor: labelColor, valColor: valColor),
          const SizedBox(height: 6),
          _PriceRow(
              label: 'Delivery fee',
              value: detail.deliveryFee == 0.0
                  ? 'Free'
                  : '\$${detail.deliveryFee.toStringAsFixed(2)}',
              labelColor: labelColor,
              valColor: detail.deliveryFee == 0.0
                  ? AppColors.verifiedGreen
                  : valColor),
          if (detail.discountAmount > 0) ...[
            const SizedBox(height: 6),
            _PriceRow(
                label: 'Discount',
                value: '−\$${detail.discountAmount.toStringAsFixed(2)}',
                labelColor: labelColor,
                valColor: AppColors.auroraPink),
          ],
          const SizedBox(height: 10),
          Container(height: 1, color: dividerColor),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: AppTextStyles.dsBodyBold.copyWith(
                      color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                      fontSize: 13, fontWeight: FontWeight.w800)),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: AppColors.auroraGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                blendMode: BlendMode.srcIn,
                child: Text(
                  '\$${detail.totalAmount.toStringAsFixed(2)}',
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
        Text(label,
            style: AppTextStyles.dsMuted
                .copyWith(color: labelColor, fontSize: 12, fontWeight: FontWeight.w500)),
        Text(value,
            style: AppTextStyles.dsBodyBold
                .copyWith(color: valColor, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// ── Address card ──────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.detail, required this.isDark});
  final OrderDetailDto detail;
  final bool isDark;

  String get _addressLines {
    final parts = <String>[];
    if (detail.street != null) parts.add(detail.street!);
    if (detail.building != null) parts.add(detail.building!);
    if (detail.floor != null) parts.add('Floor ${detail.floor}');
    final cityLine = [detail.city, if (detail.area != null) detail.area!].join(', ');
    parts.add(cityLine);
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final muteColor = isDark
        ? AppColors.white.withValues(alpha: 0.38)
        : AppColors.auroraDeepBase.withValues(alpha: 0.38);

    return _SectionCard(
      title: 'DELIVERY ADDRESS',
      isDark: isDark,
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.auroraPurple.withValues(alpha: 0.12),
              border: Border.all(
                  color: AppColors.auroraPurple.withValues(alpha: 0.18)),
            ),
            child: Center(
              child: FaIcon(FontAwesomeIcons.locationDot,
                  size: 14, color: AppColors.auroraPurple),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      detail.customerName,
                      style: AppTextStyles.dsBodyBold.copyWith(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                    if (detail.addressLabel != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.auroraPurple.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          detail.addressLabel!,
                          style: AppTextStyles.dsMuted.copyWith(
                              color: AppColors.auroraPurple,
                              fontSize: 10,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _addressLines,
                  style: AppTextStyles.dsMuted.copyWith(
                      color: muteColor, fontSize: 11, fontWeight: FontWeight.w500),
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
  const _PaymentCard({required this.detail, required this.isDark});
  final OrderDetailDto detail;
  final bool isDark;

  String get _methodLabel =>
      detail.paymentMethod == 1 ? 'Cash on delivery' : 'Unknown';

  String get _statusLabel {
    switch (detail.paymentStatus) {
      case 1: return 'Pending';
      case 2: return 'Paid';
      case 3: return 'Failed';
      case 4: return 'Refunded';
      default: return 'Unknown';
    }
  }

  Color get _statusColor {
    switch (detail.paymentStatus) {
      case 2: return AppColors.verifiedGreen;
      case 3: return AppColors.auroraRed;
      case 4: return AppColors.auroraGold;
      default: return AppColors.auroraGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;

    return _SectionCard(
      title: 'PAYMENT',
      isDark: isDark,
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.auroraPurple.withValues(alpha: 0.12),
              border: Border.all(
                  color: AppColors.auroraPurple.withValues(alpha: 0.18)),
            ),
            child: Center(
              child: FaIcon(FontAwesomeIcons.moneyBill,
                  size: 14, color: AppColors.auroraPurple),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _methodLabel,
                  style: AppTextStyles.dsBodyBold.copyWith(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 1),
                Text(
                  _statusLabel,
                  style: AppTextStyles.dsMuted.copyWith(
                      color: _statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Note card ─────────────────────────────────────────────────────────────────

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note, required this.isDark});
  final String note;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final muteColor = isDark
        ? AppColors.white.withValues(alpha: 0.55)
        : AppColors.auroraDeepBase.withValues(alpha: 0.55);

    return _SectionCard(
      title: 'DELIVERY NOTE',
      isDark: isDark,
      child: Text(
        note,
        style: AppTextStyles.dsMuted.copyWith(
            color: muteColor, fontSize: 13, height: 1.5),
      ),
    );
  }
}

// ── Cancel button ─────────────────────────────────────────────────────────────

class _CancelButton extends StatelessWidget {
  const _CancelButton({
    required this.cancelling,
    required this.onCancel,
    required this.isDark,
  });
  final bool cancelling;
  final VoidCallback onCancel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cancelling ? null : onCancel,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.auroraRed.withValues(alpha: isDark ? 0.08 : 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppColors.auroraRed.withValues(alpha: isDark ? 0.22 : 0.18)),
        ),
        child: Center(
          child: cancelling
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: AppColors.auroraRed,
                    strokeWidth: 2,
                  ),
                )
              : Text(
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

// ── Error state ───────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry, required this.isDark});
  final VoidCallback onRetry;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final muteColor = isDark
        ? AppColors.white.withValues(alpha: 0.38)
        : AppColors.auroraDeepBase.withValues(alpha: 0.38);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.circleExclamation,
                size: 36,
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.18)
                    : AppColors.auroraPurple.withValues(alpha: 0.18)),
            const SizedBox(height: 16),
            Text('Failed to load order',
                style: AppTextStyles.dsBodyBold.copyWith(
                    color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Pull to refresh or tap retry',
                style: AppTextStyles.dsMuted
                    .copyWith(color: muteColor, fontSize: 13)),
            const SizedBox(height: 20),
            AuroraPrimaryButton(text: 'Retry', onPressed: onRetry),
          ],
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.dsFieldLabel.copyWith(color: labelColor)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Write review dialog ───────────────────────────────────────────────────────

class _WriteReviewDialog extends StatefulWidget {
  const _WriteReviewDialog({required this.item});
  final OrderItemDto item;

  @override
  State<_WriteReviewDialog> createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<_WriteReviewDialog> {
  int _rating = 0;
  final _bodyCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) return;
    setState(() => _loading = true);
    final result = await serviceLocator<ItemsApi>().submitReview(
      widget.item.itemId,
      rating: _rating,
      body: _bodyCtrl.text.trim(),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      (_) {},
      (message) {
        if (message.isNotEmpty) ToastService.instance.showSuccess(message);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark ? AppColors.auroraDeepBase : AppColors.white;
        final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final mutedColor = (isDark ? AppColors.white : AppColors.auroraDeepBase).withValues(alpha: 0.45);
        final borderColor = isDark
            ? AppColors.white.withValues(alpha: 0.10)
            : AppColors.auroraPurple.withValues(alpha: 0.18);

        return Dialog(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Write a review',
                  style: AppTextStyles.heading3.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.item.itemTitle,
                  style: AppTextStyles.dsMuted.copyWith(
                    fontSize: 12,
                    color: mutedColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Star rating picker
                Row(
                  children: List.generate(5, (i) {
                    final filled = i < _rating;
                    return GestureDetector(
                      onTap: () => setState(() => _rating = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FaIcon(
                          filled ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                          size: 28,
                          color: filled ? AppColors.auroraGold : borderColor,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                AuroraInputField(
                  controller: _bodyCtrl,
                  hint: 'Share your thoughts (optional)',
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 20),
                AuroraPrimaryButton(
                  text: 'Submit review',
                  onPressed: _rating > 0 ? _submit : null,
                  isLoading: _loading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
