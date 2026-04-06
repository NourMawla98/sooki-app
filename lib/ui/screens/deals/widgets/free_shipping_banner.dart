import 'package:flutter/material.dart';

import '../../../../themes/themes.dart';

/// Promotional banner advertising free shipping on orders over $50.
///
/// Displays a green gradient container with a truck emoji,
/// headline text, subtitle, and a "Shop Now" pill button.
class FreeShippingBanner extends StatelessWidget {
  const FreeShippingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.freeShippingGreen,
            AppColors.freeShippingGreenLight,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Left side: emoji, headline, subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '\u{1F69A}',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  'FREE SHIPPING',
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'On orders over \$50',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          // Right side: "Shop Now" pill button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Shop Now',
              style: AppTextStyles.buttonSmall.copyWith(
                color: AppColors.freeShippingGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
