import 'package:flutter/material.dart';

import '../../../../themes/themes.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  static const _stats = [
    ('🏆', 12, 'Rewards Used'),
    ('🔥', 28, 'Day Streak'),
    ('👥', 5, 'Referrals'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < _stats.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: _StatCard(
            emoji: _stats[i].$1,
            value: _stats[i].$2,
            label: _stats[i].$3,
          )),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final int value;
  final String label;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: AppTextStyles.heading4,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
