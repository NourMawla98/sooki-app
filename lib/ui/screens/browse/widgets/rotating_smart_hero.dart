import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/apis/banner_api.dart';
import '../../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../../backend_integration/dtos/banner/banner_dto.dart';
import '../../../../enums/banner_type.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/refresh/refresh_scope.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

/// Rotating banner carousel. Fetches live banners from [BannerApi].
/// Shows a skeleton while loading. Hides itself if the list is empty.
/// Auto-advances every 2.8s and supports manual swipe.
class RotatingSmartHero extends StatefulWidget {
  final double height;
  final Duration autoAdvance;

  const RotatingSmartHero({
    super.key,
    this.height = 260,
    this.autoAdvance = const Duration(milliseconds: 2800),
  });

  @override
  State<RotatingSmartHero> createState() => _RotatingSmartHeroState();
}

class _RotatingSmartHeroState extends State<RotatingSmartHero>
    with AutoRefreshMixin {
  @override
  Future<void> onRefresh() => _fetch();
  List<BannerDto>? _banners; // null = loading
  bool _isError = false;
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _banners = null; _isError = false; });
    final result = await serviceLocator<BannerApi>()
        .getBanners(type: BannerType.browsePage);
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isError = true),
      (banners) {
        setState(() {
          _banners = banners;
          _index = 0;
        });
        if (banners.length > 1) _startTimer();
      },
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoAdvance, (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_index + 1) % _banners!.length;
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

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return _HeroRetry(height: widget.height, onRetry: _fetch);
    }

    final banners = _banners;

    if (banners == null) return HeroSkeleton(height: widget.height);

    if (banners.isEmpty) return const SizedBox.shrink();

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
                  if (n is ScrollStartNotification && n.dragDetails != null) {
                    _timer?.cancel();
                  }
                  if (n is ScrollEndNotification) _startTimer();
                  return false;
                },
                child: PageView.builder(
                  controller: _controller,
                  itemCount: banners.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final banner = banners[i];
                    return _BannerCard(
                      banner: banner,
                      onTap: () {
                        final route = banner.redirectionRoute;
                        if (route != null && route.isNotEmpty) {
                          Navigator.pushNamed(context, route);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _PageDots(count: banners.length, activeIndex: _index),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Skeleton
// ---------------------------------------------------------------------------

// SKELETON LOCKED — appearance approved 2026-05-12. Do not modify.
class HeroSkeleton extends StatelessWidget {
  final double height;
  const HeroSkeleton({super.key, this.height = 260});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: height,
        child: SkeletonShimmer(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Retry state — same shape/size as skeleton, with centered tap-to-retry overlay
// ---------------------------------------------------------------------------

class _HeroRetry extends StatelessWidget {
  final double height;
  final VoidCallback onRetry;

  const _HeroRetry({required this.height, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bgColor = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.skeletonBase;
        final iconColor = isDark
            ? AppColors.white.withValues(alpha: 0.5)
            : AppColors.auroraDeepBase.withValues(alpha: 0.35);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: onRetry,
            child: Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: bgColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.rotateRight, size: 24, color: iconColor),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to retry',
                    style: AppTextStyles.bodySmall.copyWith(color: iconColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Banner card
// ---------------------------------------------------------------------------

class _BannerCard extends StatelessWidget {
  final BannerDto banner;
  final VoidCallback onTap;

  const _BannerCard({required this.banner, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = banner.url;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SkeletonShimmer();
              },
              errorBuilder: (context, _, _) => _FallbackGradient(),
            )
          else
            _FallbackGradient(),
          // Dark overlay for legibility
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
                // Top slot — always present so spaceBetween anchors bottom content correctly
                if (banner.title != null && banner.title!.isNotEmpty)
                  Text(
                    banner.title!.toUpperCase(),
                    style: AppTextStyles.editorialKicker.copyWith(
                      color: AppColors.white,
                      letterSpacing: 2.5,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                // Bottom slot
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (banner.subtitle != null &&
                        banner.subtitle!.isNotEmpty) ...[
                      Text(
                        banner.subtitle!,
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.white,
                          fontSize: 24,
                          height: 1.1,
                          shadows: [
                            Shadow(
                              color: AppColors.black.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    if (banner.description != null &&
                        banner.description!.isNotEmpty) ...[
                      Text(
                        banner.description!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (banner.redirectionRoute != null &&
                        banner.redirectionRoute!.isNotEmpty)
                      _CtaChip(onTap: onTap),
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

class _FallbackGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.auroraCartButtonGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

class _CtaChip extends StatelessWidget {
  final VoidCallback onTap;
  const _CtaChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              'Shop now',
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page dots
// ---------------------------------------------------------------------------

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
                          color:
                              AppColors.auroraElectricBlue.withValues(alpha: 0.5),
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
