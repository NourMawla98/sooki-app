import 'package:flutter/material.dart';

import '../../../services/refresh_notifier.dart';
import '../../../themes/app_colors.dart';
import '../../reusable_components/refresh/refresh_scope.dart';
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
  final _refreshNotifier = RefreshNotifier();

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshScope(
      notifier: _refreshNotifier,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshNotifier.refresh,
          color: AppColors.auroraPink,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
        ),
      ),
    );
  }
}
