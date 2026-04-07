import 'package:flutter/material.dart';

import 'widgets/points_card.dart';
import 'widgets/stats_row.dart';
import 'widgets/redeem_rewards.dart';
import 'widgets/refer_and_earn.dart';
import 'widgets/recent_activity.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PointsCard(),
          SizedBox(height: 24),
          StatsRow(),
          SizedBox(height: 24),
          RedeemRewards(),
          SizedBox(height: 24),
          ReferAndEarn(),
          SizedBox(height: 24),
          RecentActivity(),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
