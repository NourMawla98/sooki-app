import 'package:flutter/material.dart';

import '../../../../themes/themes.dart';
import '../../../reusable_components/product_card/flash_deal_card.dart';
import '../../../reusable_components/timer/flash_deals_timer.dart';

/// Flash deals section for the Browse screen.
///
/// Displays a red gradient container with "FLASH DEALS" title,
/// a countdown timer, and a horizontally scrollable row of deal cards.
///
/// Animations:
/// - Section fades + slides up on first appearance
/// - Title shimmers with a subtle gradient sweep
/// - Product cards stagger in from right with a spring effect
class FlashDealsSection extends StatefulWidget {
  const FlashDealsSection({super.key});

  @override
  State<FlashDealsSection> createState() => _FlashDealsSectionState();
}

class _FlashDealsSectionState extends State<FlashDealsSection>
    with TickerProviderStateMixin {
  late final AnimationController _sectionController;
  late final Animation<double> _sectionFade;
  late final Animation<Offset> _sectionSlide;

  late final AnimationController _titleShimmerController;

  late final AnimationController _cardsController;

  // Mock data - will be replaced with API data later
  static final List<_MockDeal> _mockDeals = [
    _MockDeal(
      imageUrl:
          'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=400&q=80',
      salePrice: 14,
      originalPrice: 45,
      stockLeft: 12,
    ),
    _MockDeal(
      imageUrl:
          'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=400&q=80',
      salePrice: 14,
      originalPrice: 45,
      stockLeft: 12,
    ),
    _MockDeal(
      imageUrl:
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400&q=80',
      salePrice: 14,
      originalPrice: 45,
      stockLeft: 12,
    ),
    _MockDeal(
      imageUrl:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&q=80',
      salePrice: 14,
      originalPrice: 45,
      stockLeft: 12,
    ),
    _MockDeal(
      imageUrl:
          'https://images.unsplash.com/photo-1560343090-f0409e92791a?w=400&q=80',
      salePrice: 14,
      originalPrice: 45,
      stockLeft: 12,
    ),
  ];

  // Hardcoded end time: 3 hours from now
  late final DateTime _dealEndTime;

  @override
  void initState() {
    super.initState();
    _dealEndTime = DateTime.now().add(const Duration(hours: 3));

    // Section entrance: fade + slide up
    _sectionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _sectionFade = CurvedAnimation(
      parent: _sectionController,
      curve: Curves.easeOut,
    );
    _sectionSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _sectionController,
      curve: Curves.easeOutCubic,
    ));

    // Title shimmer sweep
    _titleShimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    // Cards stagger entrance
    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Start the section entrance after a brief delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _sectionController.forward();
        // Start cards after section settles
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) _cardsController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _sectionController.dispose();
    _titleShimmerController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _sectionSlide,
      child: FadeTransition(
        opacity: _sectionFade,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.accentRed, AppColors.lightRed],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentRed.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // "FLASH DEALS" title with shimmer
              _ShimmerTitle(controller: _titleShimmerController),
              const SizedBox(height: 10),

              // Countdown timer
              FlashDealsTimer(endTime: _dealEndTime),
              const SizedBox(height: 12),

              // Horizontally scrollable product cards
              SizedBox(
                height: 178,
                child: AnimatedBuilder(
                  animation: _cardsController,
                  builder: (context, child) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _mockDeals.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        // Stagger each card's entrance
                        final cardDelay = (index * 0.15).clamp(0.0, 1.0);
                        final cardEnd = (cardDelay + 0.5).clamp(0.0, 1.0);
                        final progress = Interval(
                          cardDelay,
                          cardEnd,
                          curve: Curves.easeOutBack,
                        ).transform(_cardsController.value);

                        final deal = _mockDeals[index];
                        return Transform.translate(
                          offset: Offset(30 * (1 - progress), 0),
                          child: Opacity(
                            opacity: progress.clamp(0.0, 1.0),
                            child: FlashDealCard(
                              imageUrl: deal.imageUrl,
                              salePrice: deal.salePrice,
                              originalPrice: deal.originalPrice,
                              stockLeft: deal.stockLeft,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Title with a repeating shimmer highlight sweep.
class _ShimmerTitle extends StatelessWidget {
  final AnimationController controller;

  const _ShimmerTitle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                AppColors.white,
                AppColors.white.withValues(alpha: 0.5),
                AppColors.white,
              ],
              stops: [
                (controller.value - 0.3).clamp(0.0, 1.0),
                controller.value,
                (controller.value + 0.3).clamp(0.0, 1.0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: child!,
        );
      },
      child: Text(
        'FLASH DEALS',
        style: AppTextStyles.heading3.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          fontSize: 20,
        ),
      ),
    );
  }
}

/// Mock deal data structure (temporary until API integration).
class _MockDeal {
  final String imageUrl;
  final double salePrice;
  final double originalPrice;
  final int stockLeft;

  const _MockDeal({
    required this.imageUrl,
    required this.salePrice,
    required this.originalPrice,
    required this.stockLeft,
  });
}
