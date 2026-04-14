import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import 'widgets/editorial_cover.dart';
import 'widgets/for_you_deck.dart';
import 'widgets/live_ticker.dart';
import 'widgets/rotating_smart_hero.dart';
import 'widgets/trending_now_section.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1 — Live announcement ticker
            LiveTicker(),

            // Section 2 — Rotating aurora hero banner
            RotatingSmartHero(),

            // Section 3 — Trending Now (horizontal heat-glow card scroll)
            TrendingNowSection(),

            // Section 4 — Editorial Cover (moody full-bleed editorial card)
            EditorialCover(),

            // Section 5 — For You Deck (auto-rotating AI-picked card)
            ForYouDeck(),

            // ⚠️ TEMP preview of the For You skeleton — remove once approved.
            _ForYouSkeletonPreview(),

            SizedBox(height: 100), // bottom padding for nav bar
          ],
        ),
      ),
    );
  }
}

/// ⚠️ TEMPORARY preview block — shows the For You deck skeleton below the
/// real card. Delete this widget and its call-site once approved.
class _ForYouSkeletonPreview extends StatelessWidget {
  const _ForYouSkeletonPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Text(
            'SKELETON LOADER SAMPLE',
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.auroraPink,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const ForYouDeckSkeleton(),
      ],
    );
  }
}
