import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../data/mock_products.dart';
import '../../../../models/product.dart';
import '../../../../routes/route_constants.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_gradient_text.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

/// Heat-badge spec: emoji, label, and per-badge glow color.
class _HeatBadgeSpec {
  final String emoji;
  final String label;
  final Color glowColor;
  const _HeatBadgeSpec(this.emoji, this.label, this.glowColor);
}

const List<_HeatBadgeSpec> _heatBadges = [
  _HeatBadgeSpec('🔥', 'ON FIRE',  AppColors.auroraRed),
  _HeatBadgeSpec('⚡', 'VIRAL',    AppColors.auroraPink),
  _HeatBadgeSpec('💥', 'HYPED',    AppColors.auroraPurple),
  _HeatBadgeSpec('🚀', 'SURGING',  AppColors.auroraElectricBlue),
  _HeatBadgeSpec('📈', 'PEAK',     AppColors.verifiedGreen),
  _HeatBadgeSpec('✨', 'BUZZING',  AppColors.auroraPink),
];

/// Section 3 — Trending Now.
///
/// Horizontal scroll of heat-glow product cards. Each card shows a thumbnail,
/// name, price, and a rotating heat badge (ON FIRE · VIRAL · HYPED · SURGING
/// · RARE · PEAK · BUZZING) cycling by card position. Uses the first 6
/// products from [mockBrowseProducts].
class TrendingNowSection extends StatelessWidget {
  final List<Product> products;

  const TrendingNowSection({super.key, List<Product>? products})
    : products = products ?? const <Product>[];

  @override
  Widget build(BuildContext context) {
    final list = products.isEmpty
        ? mockBrowseProducts.take(6).toList()
        : products;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuroraGradientText(
            'Trending Now',
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) => _TrendingCard(
                product: list[i],
                heatIndex: i,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _TrendingCard extends StatelessWidget {
  final Product product;
  final int heatIndex;

  const _TrendingCard({required this.product, required this.heatIndex});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final cardBg = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.primaryPurple.withValues(alpha: 0.04);
        final cardBorder = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.primaryPurple.withValues(alpha: 0.15);
        final nameColor = isDark ? AppColors.white : AppColors.primaryPurple;

        return SizedBox(
          width: 130,
          height: 170,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.pushNamed(
                    context,
                    itemDetailsScreenRoute,
                    arguments: product,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _ProductImage(url: product.thumbnailUrl),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.captionSmall.copyWith(
                            color: nameColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.auroraMonoPrice.copyWith(
                            color: AppColors.auroraElectricBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: _HeatBadge(
                  spec: _heatBadges[heatIndex % _heatBadges.length],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String url;
  const _ProductImage({required this.url});

  static const double _height = 110;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: double.infinity,
      height: _height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraPink.withValues(alpha: 0.3),
            AppColors.auroraPurple.withValues(alpha: 0.3),
          ],
        ),
      ),
    );

    if (url.isEmpty) return fallback;

    return SizedBox(
      width: double.infinity,
      height: _height,
      child: Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}

/// Placeholder card shown while trending products are loading. Mirrors the
/// real card's 130×170 frame with shimmering blocks for image, name, price.
class TrendingCardSkeleton extends StatelessWidget {
  const TrendingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final accent = isDark ? AppColors.auroraPink : AppColors.auroraPurple;
        final cardBg = isDark
            ? AppColors.white.withValues(alpha: 0.05)
            : AppColors.white;

        return SizedBox(
          width: 130,
          height: 170,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 110,
                  child: SkeletonShimmer(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 80,
                  height: 11,
                  child: SkeletonShimmer(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 50,
                  height: 12,
                  child: SkeletonShimmer(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeatBadge extends StatelessWidget {
  final _HeatBadgeSpec spec;
  const _HeatBadge({required this.spec});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: spec.glowColor.withValues(alpha: 0.70),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: spec.glowColor.withValues(alpha: 0.40),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                spec.emoji,
                style: const TextStyle(fontSize: 10, height: 1.0),
              ),
              const SizedBox(width: 3),
              Text(
                spec.label,
                style: AppTextStyles.captionSmall.copyWith(
                  color: AppColors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
