import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../data/mock_products.dart';
import '../../../../models/product.dart';
import '../../../../routes/route_constants.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

/// Heat-badge rotation shown on [_TrendingCard], cycling by card position.
/// Matches `.superpowers/brainstorm/891-1775991693/content/s03-heat-tags-fa.html`.
class _HeatBadgeSpec {
  final FaIconData icon;
  final String label;
  const _HeatBadgeSpec(this.icon, this.label);
}

const List<_HeatBadgeSpec> _heatBadges = [
  _HeatBadgeSpec(FontAwesomeIcons.fire, 'ON FIRE'),
  _HeatBadgeSpec(FontAwesomeIcons.bolt, 'VIRAL'),
  _HeatBadgeSpec(FontAwesomeIcons.burst, 'HYPED'),
  _HeatBadgeSpec(FontAwesomeIcons.rocket, 'SURGING'),
  _HeatBadgeSpec(FontAwesomeIcons.gem, 'RARE'),
  _HeatBadgeSpec(FontAwesomeIcons.arrowTrendUp, 'PEAK'),
  _HeatBadgeSpec(FontAwesomeIcons.wandMagicSparkles, 'BUZZING'),
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
          _SectionHeader(),
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

class _SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: AppColors.auroraCartButtonGradient,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(
        'Trending Now',
        style: AppTextStyles.heading3.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
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
        // Heat-badge accent stays theme-specific — that's the "trending"
        // signal. The card chrome matches the New Arrivals card so the two
        // sections feel like part of the same family.
        final accent = isDark ? AppColors.auroraPink : AppColors.auroraPurple;
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
                  color: accent,
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
  final Color color;
  final _HeatBadgeSpec spec;
  const _HeatBadge({required this.color, required this.spec});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(spec.icon, size: 8, color: AppColors.white),
          const SizedBox(width: 4),
          Text(
            spec.label,
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.white,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
