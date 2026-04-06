import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../reusable_components/timer/flash_deals_timer.dart';
import '../../../../themes/themes.dart';

/// Hero banner carousel for the Deals page.
///
/// Displays a full-width [PageView] with 3 pages that auto-advance every
/// 4 seconds. Each page shows a dark gradient background, a yellow
/// "LIMITED TIME ONLY" pill badge, a large "MEGA DEALS" heading, and a
/// [FlashDealsTimer] countdown. Dot indicators sit at the bottom.
class DealsBannerSection extends StatefulWidget {
  const DealsBannerSection({super.key});

  @override
  State<DealsBannerSection> createState() => _DealsBannerSectionState();
}

class _DealsBannerSectionState extends State<DealsBannerSection> {
  late final PageController _pageController;
  Timer? _autoAdvanceTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        final nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          children: [
            // Page view carousel
            PageView.builder(
              controller: _pageController,
              itemCount: 3,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _BannerPage();
              },
            ),

            // Dot indicators
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.white
                          : AppColors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single banner page with gradient background and content overlay.
class _BannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dealsBannerDark,
            AppColors.dealsBannerAccent,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Yellow pill badge — top-left aligned
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow,
                  borderRadius: BorderRadius.circular(360),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.bolt,
                      size: 10,
                      color: AppColors.black,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIMITED TIME ONLY',
                      style: AppTextStyles.badgeText.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Large heading — centered
            Text(
              'MEGA DEALS',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.white,
                letterSpacing: 2,
              ),
            ),

            const Spacer(),

            // Flash deals timer — centered
            FlashDealsTimer(
              endTime: DateTime.now().add(
                const Duration(hours: 12, minutes: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
