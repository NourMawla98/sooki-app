import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_text_styles.dart';

class ReturnsExchangesScreen extends StatelessWidget {
  const ReturnsExchangesScreen({super.key});

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
          'Returns & Exchanges',
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
            // Policy highlights
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.profileIconOrange,
                    AppColors.profileIconOrange.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  FaIcon(
                    FontAwesomeIcons.arrowRotateLeft,
                    size: 36,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '30-Day Free Returns',
                    style: AppTextStyles.heading4.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No questions asked on most items',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('How It Works'),
            const SizedBox(height: 8),
            _buildStep(1, 'Initiate Return',
                'Go to Orders, select the item, and tap "Return".'),
            _buildStep(2, 'Print Label',
                'We\'ll email you a prepaid return shipping label.'),
            _buildStep(3, 'Ship It Back',
                'Drop off the package at any carrier location.'),
            _buildStep(4, 'Get Refunded',
                'Refund is processed within 5-7 days of receiving the item.'),
            const SizedBox(height: 20),

            _buildSectionTitle('Return Policy'),
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
                  _buildPolicyRow(
                    FontAwesomeIcons.check,
                    AppColors.accentGreen,
                    'Items must be in original condition with tags',
                  ),
                  _buildPolicyRow(
                    FontAwesomeIcons.check,
                    AppColors.accentGreen,
                    'Free return shipping on all domestic orders',
                  ),
                  _buildPolicyRow(
                    FontAwesomeIcons.check,
                    AppColors.accentGreen,
                    'Exchanges available for different size or color',
                  ),
                  _buildPolicyRow(
                    FontAwesomeIcons.xmark,
                    AppColors.accentRed,
                    'Sale items are final sale (no returns)',
                  ),
                  _buildPolicyRow(
                    FontAwesomeIcons.xmark,
                    AppColors.accentRed,
                    'Swimwear and undergarments cannot be returned',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Initiate return button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ToastService.instance.showSuccess('Return initiation coming soon');
                },
                icon: FaIcon(
                  FontAwesomeIcons.arrowRotateLeft,
                  size: 16,
                  color: AppColors.white,
                ),
                label: Text(
                  'Start a Return',
                  style: AppTextStyles.buttonLarge,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildStep(int number, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: AppTextStyles.buttonMedium,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(description, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyRow(FaIconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, size: 14, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}
