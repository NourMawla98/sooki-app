import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../backend_integration/apis/items_api.dart';
import '../../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../../backend_integration/dtos/item/trending_item_dto.dart';
import '../../../../routes/route_constants.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../utils/number_localization.dart';
import '../../../reusable_components/aurora/aurora_gradient_text.dart';
import '../../../reusable_components/refresh/refresh_scope.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

class _HeatBadgeSpec {
  final String emoji;
  final String label;
  final Color glowColor;
  const _HeatBadgeSpec(this.emoji, this.label, this.glowColor);
}

const List<_HeatBadgeSpec> _heatBadges = [
  _HeatBadgeSpec('🔥', 'trending_now_section.badge_on_fire',  AppColors.auroraRed),
  _HeatBadgeSpec('⚡', 'trending_now_section.badge_viral',    AppColors.auroraPink),
  _HeatBadgeSpec('💥', 'trending_now_section.badge_hyped',    AppColors.auroraPurple),
  _HeatBadgeSpec('🚀', 'trending_now_section.badge_surging',  AppColors.auroraElectricBlue),
  _HeatBadgeSpec('📈', 'trending_now_section.badge_peak',     AppColors.verifiedGreen),
  _HeatBadgeSpec('✨', 'trending_now_section.badge_buzzing',  AppColors.auroraPink),
];

class TrendingNowSection extends StatefulWidget {
  const TrendingNowSection({super.key});

  @override
  State<TrendingNowSection> createState() => _TrendingNowSectionState();
}

class _TrendingNowSectionState extends State<TrendingNowSection>
    with AutoRefreshMixin {
  List<TrendingItemDto>? _items; // null = loading
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _items = null; _isError = false; });
    final result = await serviceLocator<ItemsApi>().getTrendingItems();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isError = true),
      (items) => setState(() => _items = items),
    );
  }

  @override
  Future<void> onRefresh() => _fetch();

  @override
  Widget build(BuildContext context) {
    final items = _items;

    // Hide section entirely if loaded but empty
    if (items != null && items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuroraGradientText(
            'trending_now_section.trending_now'.tr(),
            style: AppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: _isError
                ? _buildError()
                : items == null
                    ? _buildSkeleton()
                    : _buildList(items),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(width: 10),
      itemBuilder: (_, _) => const TrendingCardSkeleton(),
    );
  }

  Widget _buildError() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(width: 10),
      itemBuilder: (_, _) => const TrendingCardSkeleton(),
    );
  }

  Widget _buildList(List<TrendingItemDto> items) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(width: 10),
      itemBuilder: (context, i) => _TrendingCard(
        item: items[i],
        heatIndex: i,
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final TrendingItemDto item;
  final int heatIndex;

  const _TrendingCard({required this.item, required this.heatIndex});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final cardBg = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.white;
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
                    arguments: item.id,
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
                          child: _ItemImage(url: item.imageUrl),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
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
                          '\$${localizedDigits(item.price.toStringAsFixed(item.price.truncateToDouble() == item.price ? 0 : 2))}',
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
              PositionedDirectional(
                top: 6,
                end: 6,
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

class _ItemImage extends StatelessWidget {
  final String url;
  const _ItemImage({required this.url});

  static const double _height = 110;

  Widget get _fallback => Container(
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

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback;
    return SizedBox(
      width: double.infinity,
      height: _height,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SkeletonShimmer(borderRadius: BorderRadius.circular(10));
        },
        errorBuilder: (_, _, _) => _fallback,
      ),
    );
  }
}

// SKELETON LOCKED — appearance approved 2026-05-12. Do not modify.
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
                spec.label.tr(),
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
