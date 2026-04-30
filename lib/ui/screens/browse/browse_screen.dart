import 'package:flutter/material.dart';

import 'widgets/categories_arrivals_section.dart';
// import 'widgets/editorial_cover.dart';
import 'widgets/for_you_deck.dart';
import 'widgets/live_ticker.dart';
import 'widgets/quick_actions.dart';
import 'widgets/rotating_smart_hero.dart';
import 'widgets/trending_now_section.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LiveTicker(),
            const RotatingSmartHero(),
            const TrendingNowSection(),
            // const EditorialCover(),
            const ForYouDeck(),
            const QuickActions(),
            CategoriesArrivalsSection(scrollController: _scrollController),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
