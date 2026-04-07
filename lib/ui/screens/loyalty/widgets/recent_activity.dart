import 'package:flutter/material.dart';

import '../../../../themes/themes.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  static const _activities = [
    ('🛍️', AppColors.loyaltyPurpleLight, 'Purchase', '2 days ago', '+250'),
    ('⭐', AppColors.tierGold, 'Review', '5 days ago', '+50'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 12),
        ...List.generate(_activities.length, (i) {
          final a = _activities[i];
          return Padding(
            padding: EdgeInsets.only(bottom: i < _activities.length - 1 ? 12 : 0),
            child: _ActivityItem(
              emoji: a.$1,
              circleColor: a.$2,
              title: a.$3,
              timeAgo: a.$4,
              points: a.$5,
            ),
          );
        }),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String emoji;
  final Color circleColor;
  final String title;
  final String timeAgo;
  final String points;

  const _ActivityItem({
    required this.emoji,
    required this.circleColor,
    required this.title,
    required this.timeAgo,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Leading circle with emoji
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: circleColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(width: 12),
        // Title + time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                timeAgo,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Points
        Text(
          points,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.accentGreen,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
