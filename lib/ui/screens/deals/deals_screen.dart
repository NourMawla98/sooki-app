import 'package:flutter/material.dart';

import 'widgets/deals_banner_section.dart';
import 'widgets/free_shipping_banner.dart';
import 'widgets/hot_deals_section.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          DealsBannerSection(),
          SizedBox(height: 16),
          FreeShippingBanner(),
          SizedBox(height: 24),
          HotDealsSection(),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
