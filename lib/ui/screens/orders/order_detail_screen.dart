import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});

  final MockOrderDetail order;

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
          order.id,
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: order.statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: order.statusColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  FaIcon(order.statusIcon, size: 36, color: order.statusColor),
                  const SizedBox(height: 12),
                  Text(
                    order.status,
                    style: AppTextStyles.heading4.copyWith(
                      color: order.statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Placed on ${order.date}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Order timeline
            _buildSectionTitle('Order Timeline'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildTimelineItem(
                    'Order Placed',
                    order.date,
                    true,
                    isFirst: true,
                  ),
                  _buildTimelineItem(
                    'Payment Confirmed',
                    order.date,
                    order.timelineStep >= 1,
                  ),
                  _buildTimelineItem(
                    'Processing',
                    order.timelineStep >= 2 ? 'In progress' : 'Pending',
                    order.timelineStep >= 2,
                  ),
                  _buildTimelineItem(
                    'Shipped',
                    order.timelineStep >= 3 ? 'On the way' : 'Pending',
                    order.timelineStep >= 3,
                  ),
                  _buildTimelineItem(
                    'Delivered',
                    order.timelineStep >= 4 ? 'Completed' : 'Pending',
                    order.timelineStep >= 4,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Items
            _buildSectionTitle('Items (${order.items.length})'),
            const SizedBox(height: 8),
            ...order.items.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.shirt,
                            size: 20,
                            color: AppColors.gray400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Qty: ${item.quantity} · Size: ${item.size}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),

            // Order summary
            _buildSectionTitle('Order Summary'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Shipping', order.shipping == 0 ? 'FREE' : '\$${order.shipping.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: AppColors.gray200),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: AppTextStyles.heading4.copyWith(
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Shipping address
            _buildSectionTitle('Shipping Address'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 16,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '123 Main Street, Apt 4B\nNew York, NY 10001',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(
          color: AppColors.gray500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    bool isCompleted, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.accentGreen
                    : AppColors.gray200,
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? Center(
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        size: 12,
                        color: AppColors.white,
                      ),
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: isCompleted ? AppColors.accentGreen : AppColors.gray200,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCompleted
                        ? AppColors.textPrimary
                        : AppColors.gray400,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isCompleted
                        ? AppColors.textSecondary
                        : AppColors.gray300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Mock data model for order detail
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
  final int timelineStep; // 0-4
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
