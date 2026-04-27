import 'package:flutter/material.dart';

import '../../../../themes/themes.dart';
import '../../../../services/toast_service.dart';

class RedeemRewards extends StatelessWidget {
  const RedeemRewards({super.key});

  static const _rewards = [
    ('💵', '\$5 Off', 'Any purchase', '500 pts', AppColors.rewardGreen1, AppColors.rewardGreen2),
    ('💰', '\$10 Off', 'Orders over \$50', '900 pts', AppColors.rewardYellow1, AppColors.rewardYellow2),
    ('🚚', 'Free Shipping', 'Next order', '300 pts', AppColors.rewardGreen1, AppColors.rewardGreen2),
    ('🎁', '\$25 Off', 'Orders over \$100', '2000 pts', AppColors.rewardCoral1, AppColors.rewardCoral2),
    ('⭐', 'VIP Access', 'Early sale access', '1500 pts', AppColors.rewardPurple1, AppColors.rewardPurple2),
    ('🎂', 'Birthday Gift', 'Special surprise', '1000 pts', AppColors.rewardCoral1, AppColors.rewardCoral2),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Redeem Rewards', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: _rewards.map((r) => _RewardCard(
            emoji: r.$1,
            title: r.$2,
            description: r.$3,
            points: r.$4,
            color1: r.$5,
            color2: r.$6,
          )).toList(),
        ),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final String points;
  final Color color1;
  final Color color2;

  const _RewardCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.points,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ToastService.instance.showError('Requires $points points to redeem');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color1, color2],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.9),
              ),
            ),
            const Spacer(),
            Text(
              points,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
