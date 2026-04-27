import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_text_styles.dart';

class DeliveryDetailScreen extends StatelessWidget {
  const DeliveryDetailScreen({super.key, required this.delivery});

  final MockDeliveryDetail delivery;

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
          'Tracking Details',
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
            // Delivery status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.profileIconGreen,
                    AppColors.profileIconGreen.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  FaIcon(
                    FontAwesomeIcons.truckFast,
                    size: 40,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    delivery.status,
                    style: AppTextStyles.heading4.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Estimated: ${delivery.estimatedDate}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: delivery.progress,
                      backgroundColor: AppColors.white.withValues(alpha: 0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.white),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Shipment info
            _buildSectionTitle('Shipment Information'),
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
                  _buildInfoRow(
                    FontAwesomeIcons.hashtag,
                    'Order',
                    delivery.orderId,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, color: AppColors.gray100),
                  ),
                  _buildInfoRow(
                    FontAwesomeIcons.truck,
                    'Carrier',
                    delivery.carrier,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, color: AppColors.gray100),
                  ),
                  _buildInfoRow(
                    FontAwesomeIcons.barcode,
                    'Tracking',
                    delivery.trackingNumber,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, color: AppColors.gray100),
                  ),
                  _buildInfoRow(
                    FontAwesomeIcons.weightHanging,
                    'Weight',
                    delivery.weight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tracking timeline
            _buildSectionTitle('Tracking History'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: delivery.trackingEvents
                    .asMap()
                    .entries
                    .map((entry) => _buildTrackingEvent(
                          entry.value,
                          isFirst: entry.key == 0,
                          isLast:
                              entry.key == delivery.trackingEvents.length - 1,
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Delivery address
            _buildSectionTitle('Delivery Address'),
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
            const SizedBox(height: 20),

            // Contact carrier button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ToastService.instance.showSuccess('Carrier contact coming soon');
                },
                icon: FaIcon(
                  FontAwesomeIcons.phone,
                  size: 16,
                  color: AppColors.primaryPurple,
                ),
                label: Text(
                  'Contact ${delivery.carrier}',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.primaryPurple,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryPurple),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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

  Widget _buildInfoRow(FaIconData icon, String label, String value) {
    return Row(
      children: [
        FaIcon(icon, size: 14, color: AppColors.gray400),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.bodySmall),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingEvent(
    TrackingEvent event, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isFirst
                    ? AppColors.profileIconGreen
                    : AppColors.gray200,
                shape: BoxShape.circle,
              ),
              child: isFirst
                  ? Center(
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        size: 10,
                        color: AppColors.white,
                      ),
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isFirst
                    ? AppColors.profileIconGreen
                    : AppColors.gray200,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                    color: isFirst
                        ? AppColors.textPrimary
                        : AppColors.gray400,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      event.date,
                      style: AppTextStyles.captionSmall.copyWith(
                        color: AppColors.gray400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      event.location,
                      style: AppTextStyles.captionSmall.copyWith(
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MockDeliveryDetail {
  const MockDeliveryDetail({
    required this.orderId,
    required this.productName,
    required this.estimatedDate,
    required this.status,
    required this.progress,
    required this.carrier,
    required this.trackingNumber,
    required this.weight,
    required this.trackingEvents,
  });

  final String orderId;
  final String productName;
  final String estimatedDate;
  final String status;
  final double progress;
  final String carrier;
  final String trackingNumber;
  final String weight;
  final List<TrackingEvent> trackingEvents;
}

class TrackingEvent {
  const TrackingEvent({
    required this.title,
    required this.date,
    required this.location,
  });

  final String title;
  final String date;
  final String location;
}
