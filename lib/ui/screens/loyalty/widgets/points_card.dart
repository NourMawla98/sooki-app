import 'package:flutter/material.dart';

import '../../../../themes/themes.dart';

class PointsCard extends StatelessWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.loyaltyPurple, AppColors.loyaltyPurpleLight],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Points',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '2,450',
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.white,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 8),
          // Gold badge pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.tierGold,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Gold',
              style: AppTextStyles.badgeText.copyWith(
                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gold Tier',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.white,
                ),
              ),
              Text(
                '550 pts to Platinum',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.82,
              minHeight: 8,
              backgroundColor: AppColors.white.withValues(alpha: 0.3),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.tierGold),
            ),
          ),
        ],
      ),
    );
  }
}
