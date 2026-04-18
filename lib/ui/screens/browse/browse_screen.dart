import 'package:flutter/material.dart';

import 'widgets/categories_arrivals_section.dart';
import 'widgets/editorial_cover.dart';
import 'widgets/for_you_deck.dart';
import 'widgets/live_ticker.dart';
import 'widgets/quick_actions.dart';
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
          children: const [
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

            // Section 6 — Quick Actions (icon bubbles row)
            QuickActions(),

            // Section 7 — Categories + New Arrivals (pills + 2-col grid)
            CategoriesArrivalsSection(),

            SizedBox(height: 100), // bottom padding for nav bar
          ],
        ),
      ),
    );
  }
}
