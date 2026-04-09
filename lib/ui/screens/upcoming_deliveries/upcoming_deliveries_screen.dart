import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/route_constants.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import 'delivery_detail_screen.dart';

class UpcomingDeliveriesScreen extends StatelessWidget {
  const UpcomingDeliveriesScreen({super.key});

  static final _mockDeliveries = [
    _MockDelivery(
      orderId: '#ORD-1198',
      productName: 'Smart Watch',
      estimatedDate: 'Apr 12, 2026',
      status: 'In Transit',
      progress: 0.65,
      carrier: 'FedEx',
      trackingNumber: 'FX-9284710384',
      weight: '0.4 kg',
      trackingEvents: const [
        TrackingEvent(
          title: 'Out for delivery',
          date: 'Apr 11, 10:30 AM',
          location: 'New York, NY',
        ),
        TrackingEvent(
          title: 'Arrived at local facility',
          date: 'Apr 11, 6:00 AM',
          location: 'New York, NY',
        ),
        TrackingEvent(
          title: 'In transit',
          date: 'Apr 9, 3:15 PM',
          location: 'Memphis, TN',
        ),
        TrackingEvent(
          title: 'Shipped',
          date: 'Apr 8, 11:00 AM',
          location: 'Los Angeles, CA',
        ),
        TrackingEvent(
          title: 'Label created',
          date: 'Apr 7, 9:00 AM',
          location: 'Los Angeles, CA',
        ),
      ],
    ),
    _MockDelivery(
      orderId: '#ORD-1156',
      productName: 'Casual Top & Sneakers',
      estimatedDate: 'Apr 14, 2026',
      status: 'Preparing',
      progress: 0.3,
      carrier: 'DHL',
      trackingNumber: 'DHL-5839201746',
      weight: '1.2 kg',
      trackingEvents: const [
        TrackingEvent(
          title: 'Package picked up',
          date: 'Apr 9, 2:00 PM',
          location: 'Chicago, IL',
        ),
        TrackingEvent(
          title: 'Label created',
          date: 'Apr 8, 4:30 PM',
          location: 'Chicago, IL',
        ),
      ],
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
          'Upcoming Deliveries',
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockDeliveries.length,
        itemBuilder: (context, index) {
          final delivery = _mockDeliveries[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              deliveryDetailScreenRoute,
              arguments: delivery.toDetail(),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                          delivery.orderId,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.gray400,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.profileIconGreen.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            delivery.status,
                            style: AppTextStyles.captionSmall.copyWith(
                              color: AppColors.profileIconGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      delivery.productName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: delivery.progress,
                        backgroundColor: AppColors.gray200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.profileIconGreen,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.truck,
                          size: 14,
                          color: AppColors.gray400,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          delivery.carrier,
                          style: AppTextStyles.bodySmall,
                        ),
                        const Spacer(),
                        FaIcon(
                          FontAwesomeIcons.calendar,
                          size: 14,
                          color: AppColors.gray400,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          delivery.estimatedDate,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
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
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MockDelivery {
  _MockDelivery({
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

  MockDeliveryDetail toDetail() {
    return MockDeliveryDetail(
      orderId: orderId,
      productName: productName,
      estimatedDate: estimatedDate,
      status: status,
      progress: progress,
      carrier: carrier,
      trackingNumber: trackingNumber,
      weight: weight,
      trackingEvents: trackingEvents,
    );
  }
}
