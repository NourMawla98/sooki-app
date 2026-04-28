import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../enums/order_status.dart';
import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/order_card/order_card.dart';
import '../splash/widgets/aurora_glow_blob.dart';
import 'order_detail_screen.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

class _Order {
  final String id;
  final String date;
  final OrderStatus status;
  final int itemCount;
  final double total;
  final List<List<Color>> thumbnails;
  final int timelineStep;

  const _Order({
    required this.id,
    required this.date,
    required this.status,
    required this.itemCount,
    required this.total,
    required this.thumbnails,
    required this.timelineStep,
  });

  MockOrderDetail toDetail() {
    final items = List.generate(
      itemCount,
      (i) => MockOrderItem(
        name: ['Summer Dress', 'Casual Top', 'Sneakers', 'Handbag',
            'Smart Watch'][i % 5],
        quantity: 1,
        size: ['S', 'M', 'L', 'XL'][i % 4],
        price: total / itemCount,
      ),
    );
    return MockOrderDetail(
      id: id,
      date: date,
      status: status.label,
      statusColor: status.accentColor,
      statusIcon: _iconForStatus(status),
      timelineStep: timelineStep,
      items: items,
      subtotal: total * 0.85,
      shipping: total > 50 ? 0.0 : 4.99,
      tax: total * 0.08,
      total: total,
    );
  }

  static FaIconData _iconForStatus(OrderStatus s) {
    switch (s) {
      case OrderStatus.processing: return FontAwesomeIcons.gear;
      case OrderStatus.shipped:    return FontAwesomeIcons.truck;
      case OrderStatus.delivered:  return FontAwesomeIcons.circleCheck;
      case OrderStatus.cancelled:  return FontAwesomeIcons.circleXmark;
    }
  }
}

const _mockOrders = [
  _Order(
    id: '#SOO-00148',
    date: 'Apr 28, 2026',
    status: OrderStatus.processing,
    itemCount: 5,
    total: 124.50,
    timelineStep: 2,
    thumbnails: [
      [AppColors.auroraPink, AppColors.auroraPurple],
      [AppColors.auroraPurple, AppColors.auroraElectricBlue],
      [AppColors.auroraElectricBlue, AppColors.verifiedGreen],
    ],
  ),
  _Order(
    id: '#SOO-00145',
    date: 'Apr 24, 2026',
    status: OrderStatus.shipped,
    itemCount: 2,
    total: 38.00,
    timelineStep: 3,
    thumbnails: [
      [AppColors.auroraGold, AppColors.auroraRed],
      [AppColors.auroraTeal, AppColors.auroraPurple],
    ],
  ),
  _Order(
    id: '#SOO-00142',
    date: 'Apr 18, 2026',
    status: OrderStatus.delivered,
    itemCount: 3,
    total: 67.25,
    timelineStep: 4,
    thumbnails: [
      [AppColors.verifiedGreen, AppColors.auroraElectricBlue],
      [AppColors.auroraPink, AppColors.auroraGold],
      [AppColors.auroraPurple, AppColors.auroraRed],
    ],
  ),
  _Order(
    id: '#SOO-00139',
    date: 'Apr 10, 2026',
    status: OrderStatus.cancelled,
    itemCount: 1,
    total: 22.00,
    timelineStep: 1,
    thumbnails: [
      [AppColors.auroraRed, AppColors.auroraPurple],
    ],
  ),
  _Order(
    id: '#SOO-00133',
    date: 'Mar 30, 2026',
    status: OrderStatus.delivered,
    itemCount: 4,
    total: 214.95,
    timelineStep: 4,
    thumbnails: [
      [AppColors.auroraPurple, AppColors.auroraPink],
      [AppColors.auroraElectricBlue, AppColors.auroraTeal],
      [AppColors.auroraGold, AppColors.verifiedGreen],
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrderStatus? _filter; // null = Active (processing + shipped)

  List<_Order> get _filtered {
    if (_filter == null) {
      return _mockOrders
          .where((o) =>
              o.status == OrderStatus.processing ||
              o.status == OrderStatus.shipped)
          .toList();
    }
    return _mockOrders.where((o) => o.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final titleColor =
            isDark ? AppColors.white : AppColors.auroraDeepBase;

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
                          const SizedBox(width: 4),
                          Text(
                            'Orders',
                            style: AppTextStyles.heading3.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Count badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: AppColors.auroraGradient,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_mockOrders.length}',
                              style: AppTextStyles.dsCTA.copyWith(
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Filter tabs
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Row(
                        children: [
                          _FilterTab(
                            label: 'Active',
                            isActive: _filter == null,
                            onTap: () => setState(() => _filter = null),
                          ),
                          const SizedBox(width: 8),
                          _FilterTab(
                            label: 'Delivered',
                            isActive: _filter == OrderStatus.delivered,
                            onTap: () => setState(
                                () => _filter = OrderStatus.delivered),
                          ),
                          const SizedBox(width: 8),
                          _FilterTab(
                            label: 'Cancelled',
                            isActive: _filter == OrderStatus.cancelled,
                            onTap: () => setState(
                                () => _filter = OrderStatus.cancelled),
                          ),
                        ],
                      ),
                    ),

                    // List
                    Expanded(
                      child: _filtered.isEmpty
                          ? _EmptyState(isDark: isDark)
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                              itemCount: _filtered.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, i) {
                                final order = _filtered[i];
                                return OrderCard(
                                  orderId: order.id,
                                  date: order.date,
                                  status: order.status,
                                  itemCount: order.itemCount,
                                  total: order.total,
                                  thumbnailGradients: order.thumbnails,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    orderDetailScreenRoute,
                                    arguments: order.toDetail(),
                                  ),
                                );
                              },
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

// ── Filter tab ────────────────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.auroraGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: AppTextStyles.dsCTA.copyWith(
              fontSize: 11,
              letterSpacing: 0.3,
            ),
          ),
        ),
      );
    }

    // Inactive: primary button style at reduced opacity
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: 0.35,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.auroraGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: AppTextStyles.dsCTA.copyWith(
              fontSize: 11,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final subColor = isDark
        ? AppColors.white.withValues(alpha: 0.38)
        : AppColors.auroraDeepBase.withValues(alpha: 0.38);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: AppColors.auroraGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
            blendMode: BlendMode.srcIn,
            child: const FaIcon(FontAwesomeIcons.box,
                size: 40, color: AppColors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'No orders here',
            style: AppTextStyles.dsH2.copyWith(
              color: isDark ? AppColors.white : AppColors.auroraDeepBase,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Orders in this category will appear here.',
            style: AppTextStyles.dsMuted
                .copyWith(color: subColor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
