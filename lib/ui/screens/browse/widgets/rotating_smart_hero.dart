import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../data/mock_home_data.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

/// Rotating banner carousel. Auto-advances every 4s and supports manual swipe.
/// Manual interaction resets the auto-advance timer so the user isn't fighting
/// the animation.
class RotatingSmartHero extends StatefulWidget {
  final List<HeroSlide> slides;
  final double height;
  final Duration autoAdvance;

  const RotatingSmartHero({
    super.key,
    this.slides = mockHeroSlides,
    this.height = 260,
    this.autoAdvance = const Duration(milliseconds: 2800),
  });

  @override
  State<RotatingSmartHero> createState() => _RotatingSmartHeroState();
}

class _RotatingSmartHeroState extends State<RotatingSmartHero> {
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.slides.length <= 1) return;
    _timer = Timer.periodic(widget.autoAdvance, (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_index + 1) % widget.slides.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTap(HeroSlide slide) {
    Navigator.pushNamed(context, slide.ctaRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: widget.height,
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollStartNotification &&
                      n.dragDetails != null) {
                    _timer?.cancel();
                  }
                  if (n is ScrollEndNotification) {
                    _startTimer();
                  }
                  return false;
                },
                child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final slide = widget.slides[i];
                    return _HeroSlideCard(
                      slide: slide,
                      onTap: () => _onTap(slide),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _PageDots(count: widget.slides.length, activeIndex: _index),
        ],
      ),
    );
  }
}

class _HeroSlideCard extends StatelessWidget {
  final HeroSlide slide;
  final VoidCallback onTap;

  const _HeroSlideCard({required this.slide, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            slide.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const SkeletonShimmer();
            },
            errorBuilder: (context, error, stack) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.auroraCartButtonGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Dark gradient overlay for text legibility.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.black.withValues(alpha: 0.15),
                  AppColors.black.withValues(alpha: 0.65),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  slide.kicker,
                  style: AppTextStyles.editorialKicker.copyWith(
                    color: AppColors.white,
                    letterSpacing: 2.5,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      slide.headline,
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.white,
                        fontSize: 24,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            color:
                                AppColors.black.withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      slide.subtext,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CtaChip(label: slide.ctaLabel),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaChip extends StatelessWidget {
  final String label;
  const _CtaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.buttonSmall.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          const FaIcon(
            FontAwesomeIcons.arrowRight,
            size: 11,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _PageDots({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final inactive = isDark
            ? AppColors.white.withValues(alpha: 0.3)
            : AppColors.primaryPurple.withValues(alpha: 0.3);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (i) {
            final isActive = i == activeIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 20 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isActive ? AppColors.auroraElectricBlue : inactive,
                borderRadius: BorderRadius.circular(3),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.auroraElectricBlue
                              .withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        );
      },
    );
  }
}
