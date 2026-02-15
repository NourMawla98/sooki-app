import 'package:flutter/material.dart';

import 'widgets/browse_banner_section.dart';
import 'widgets/flash_deals_section.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner carousel (edge-to-edge, no top padding)
            BrowseBannerSection(),

            SizedBox(height: 20),

            // Flash deals section
            FlashDealsSection(),

            SizedBox(height: 24),

            // TODO: Add more sections (categories, products, etc.)
          ],
        ),
      ),
    );
  }
}
