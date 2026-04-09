import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/route_constants.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const _mockOrders = [
    _MockOrder(
      id: '#ORD-1234',
      date: 'Apr 5, 2026',
      status: 'Delivered',
      statusColor: AppColors.accentGreen,
      itemCount: 3,
      total: 89.97,
      icon: FontAwesomeIcons.circleCheck,
      timelineStep: 4,
    ),
    _MockOrder(
      id: '#ORD-1198',
      date: 'Mar 28, 2026',
      status: 'Shipped',
      statusColor: AppColors.profileIconTeal,
      itemCount: 1,
      total: 129.99,
      icon: FontAwesomeIcons.truck,
      timelineStep: 3,
    ),
    _MockOrder(
      id: '#ORD-1156',
      date: 'Mar 15, 2026',
      status: 'Processing',
      statusColor: AppColors.profileIconYellow,
      itemCount: 2,
      total: 54.98,
      icon: FontAwesomeIcons.gear,
      timelineStep: 2,
    ),
    _MockOrder(
      id: '#ORD-1089',
      date: 'Feb 20, 2026',
      status: 'Delivered',
      statusColor: AppColors.accentGreen,
      itemCount: 5,
      total: 214.95,
      icon: FontAwesomeIcons.circleCheck,
      timelineStep: 4,
    ),
    _MockOrder(
      id: '#ORD-1042',
      date: 'Feb 3, 2026',
      status: 'Cancelled',
      statusColor: AppColors.accentRed,
      itemCount: 1,
      total: 39.99,
      icon: FontAwesomeIcons.circleXmark,
      timelineStep: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: 20,
            color: AppColors.primaryPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Orders',
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockOrders.length,
        itemBuilder: (context, index) {
          final order = _mockOrders[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              orderDetailScreenRoute,
              arguments: order.toDetail(),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.id,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: order.statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                order.icon,
                                size: 12,
                                color: order.statusColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                order.status,
                                style: AppTextStyles.captionSmall.copyWith(
                                  color: order.statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.calendar,
                          size: 14,
                          color: AppColors.gray400,
                        ),
                        const SizedBox(width: 8),
                        Text(order.date, style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${order.itemCount} item${order.itemCount > 1 ? 's' : ''}',
                          style: AppTextStyles.bodySmall,
                        ),
                        Row(
                          children: [
                            Text(
                              '\$${order.total.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            FaIcon(
                              FontAwesomeIcons.chevronRight,
                              size: 12,
                              color: AppColors.gray400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MockOrder {
  const _MockOrder({
    required this.id,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.itemCount,
    required this.total,
    required this.icon,
    required this.timelineStep,
  });

  final String id;
  final String date;
  final String status;
  final Color statusColor;
  final int itemCount;
  final double total;
  final FaIconData icon;
  final int timelineStep;

  MockOrderDetail toDetail() {
    final items = List.generate(
      itemCount,
      (i) => MockOrderItem(
        name: ['Summer Dress', 'Casual Top', 'Sneakers', 'Handbag', 'Smart Watch'][i % 5],
        quantity: 1,
        size: ['S', 'M', 'L', 'XL'][i % 4],
        price: total / itemCount,
      ),
    );
    final subtotal = total * 0.85;
    final tax = total * 0.08;
    final shipping = total > 50 ? 0.0 : 4.99;
    return MockOrderDetail(
      id: id,
      date: date,
      status: status,
      statusColor: statusColor,
      statusIcon: icon,
      timelineStep: timelineStep,
      items: items,
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: total,
    );
  }
}
