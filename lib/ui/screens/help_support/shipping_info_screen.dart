import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class ShippingInfoScreen extends StatelessWidget {
  const ShippingInfoScreen({super.key});

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
          'Shipping Information',
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
            _buildShippingOption(
              icon: FontAwesomeIcons.truck,
              iconColor: AppColors.profileIconGreen,
              title: 'Standard Shipping',
              duration: '5-7 business days',
              price: 'FREE on orders over \$50',
              details: 'Otherwise \$4.99',
            ),
            _buildShippingOption(
              icon: FontAwesomeIcons.truckFast,
              iconColor: AppColors.profileIconTeal,
              title: 'Express Shipping',
              duration: '2-3 business days',
              price: '\$9.99',
              details: 'Available for most items',
            ),
            _buildShippingOption(
              icon: FontAwesomeIcons.bolt,
              iconColor: AppColors.profileIconYellow,
              title: 'Next Day Delivery',
              duration: '1 business day',
              price: '\$14.99',
              details: 'Order before 2 PM',
            ),
            _buildShippingOption(
              icon: FontAwesomeIcons.globe,
              iconColor: AppColors.primaryPurple,
              title: 'International Shipping',
              duration: '10-14 business days',
              price: 'From \$19.99',
              details: 'Customs fees may apply',
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Shipping Policy'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPolicyItem(
                    'Orders are processed within 1-2 business days.',
                  ),
                  _buildPolicyItem(
                    'Tracking information is emailed once your order ships.',
                  ),
                  _buildPolicyItem(
                    'Free shipping is available on all domestic orders over \$50.',
                  ),
                  _buildPolicyItem(
                    'P.O. Box deliveries are only available via Standard Shipping.',
                  ),
                  _buildPolicyItem(
                    'Delivery times do not include weekends or holidays.',
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

  Widget _buildShippingOption({
    required FaIconData icon,
    required Color iconColor,
    required String title,
    required String duration,
    required String price,
    required String details,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(icon, size: 20, color: iconColor),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(duration, style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Text(
                  '$price · $details',
                  style: AppTextStyles.captionSmall.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildPolicyItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: FaIcon(
              FontAwesomeIcons.circleCheck,
              size: 14,
              color: AppColors.accentGreen,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}
