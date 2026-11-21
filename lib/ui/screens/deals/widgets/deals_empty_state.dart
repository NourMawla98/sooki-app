import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/dtos/item/trending_item_dto.dart';
import '../../../../models/deal_progress.dart';
import '../../../../models/display_price.dart';
import '../../../../routes/item_navigation.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/product_card/product_grid_card.dart';
import 'deal_card_parts.dart';
import 'deals_sections.dart';

/// Shown when no deal is live or coming up: a sleepy gift box, a way to hear
/// about the next deal, a way into the shop, and trending items meanwhile.
class DealsEmptyState extends StatelessWidget {
  final bool isDark;
  final List<TrendingItemDto> trending;

  /// Whether push alerts are on, or null when unknown, for a guest or before
  /// the preference has loaded.
  final bool? alertsOn;
  final bool alertsBusy;
  final VoidCallback onNotify;
  final VoidCallback onBrowse;

  const DealsEmptyState({
    super.key,
    required this.isDark,
    required this.trending,
    required this.alertsOn,
    required this.onNotify,
    required this.onBrowse,
    this.alertsBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final on = alertsOn ?? false;

    return Column(
      children: [
        const SizedBox(height: 28),
        _SleepyGift(isDark: isDark),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Text(
                'deals.empty_title'.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.heading3.copyWith(
                  color: palette.text,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'deals.empty_body'.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: palette.muted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  DealActionButton(
                    label: on
                        ? 'deals.alerts_on'.tr()
                        : 'deals.notify_me'.tr(),
                    icon: FontAwesomeIcons.bell,
                    isLoading: alertsBusy,
                    isDone: on,
                    onPressed: onNotify,
                  ),
                  _GhostButton(
                    label: 'deals.browse_shop'.tr(),
                    icon: FontAwesomeIcons.bagShopping,
                    isDark: isDark,
                    onTap: onBrowse,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (trending.isNotEmpty) ...[
          DealSectionHead(
            title: 'deals.trending_while_you_wait'.tr(),
            icon: FontAwesomeIcons.fire,
            isDark: isDark,
            flicker: true,
          ),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: trending.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) =>
                  _TrendingTile(item: trending[i], isDark: isDark),
            ),
          ),
        ],
      ],
    );
  }
}

/// Shown in place of the deal list when a filter matches nothing.
class DealsFilterEmpty extends StatelessWidget {
  final DealFilter filter;
  final bool isDark;
  final VoidCallback onSeeAll;

  const DealsFilterEmpty({
    super.key,
    required this.filter,
    required this.isDark,
    required this.onSeeAll,
  });

  /// One full sentence per filter, since word order differs by language.
  static String titleKey(DealFilter filter) => switch (filter) {
    DealFilter.all => 'deals.empty_title',
    DealFilter.singleItem => 'deals.filter_empty.single',
    DealFilter.bundle => 'deals.filter_empty.bundle',
    DealFilter.multiBuy => 'deals.filter_empty.multi',
    DealFilter.freeGift => 'deals.filter_empty.gift',
    DealFilter.spendThreshold => 'deals.filter_empty.spend',
  };

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: [
          FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 30,
            color: palette.ink,
          ),
          const SizedBox(height: 10),
          Text(
            titleKey(filter).tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: palette.text,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'deals.filter_empty.body'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: palette.muted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          _GhostButton(
            label: 'deals.filter_empty.see_all'.tr(),
            icon: FontAwesomeIcons.wandMagicSparkles,
            isDark: isDark,
            onTap: onSeeAll,
          ),
        ],
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _GhostButton({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    return Material(
      color: palette.surfaceSoft,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(icon, size: 12, color: palette.ink),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.buttonSmall.copyWith(
                  color: palette.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SleepyGift extends StatelessWidget {
  final bool isDark;

  const _SleepyGift({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.auroraPurple.withValues(alpha: isDark ? 0.22 : 0.10),
              shape: BoxShape.circle,
            ),
          ),
          const LoopingFloat(
            child: FaIcon(
              FontAwesomeIcons.gift,
              size: 58,
              color: AppColors.auroraPurple,
            ),
          ),
          PositionedDirectional(
            top: 18,
            end: 22,
            child: LoopingFloat(
              period: const Duration(milliseconds: 1500),
              child: Text(
                'z z',
                style: AppTextStyles.heading3.copyWith(
                  color: palette.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const PositionedDirectional(
            top: 40,
            start: 10,
            child: LoopingFloat(
              period: Duration(milliseconds: 2500),
              child: _Dot(size: 14, color: AppColors.auroraGold),
            ),
          ),
          const PositionedDirectional(
            bottom: 34,
            end: 8,
            child: _Dot(size: 10, color: AppColors.auroraPink),
          ),
          const PositionedDirectional(
            bottom: 14,
            start: 34,
            child: _Dot(size: 8, color: AppColors.verifiedGreen),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;

  const _Dot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _TrendingTile extends StatelessWidget {
  final TrendingItemDto item;
  final bool isDark;

  const _TrendingTile({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final price = DisplayPrice.of(original: item.price, deal: item.deal);
    return GestureDetector(
      onTap: () => openItemDetail(context, item.id),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 72,
                width: double.infinity,
                child: ProductCardImage(url: item.imageUrl),
              ),
            ),
            const SizedBox(height: 6),
            ProductCardTitle(title: item.title, isDark: isDark),
            const SizedBox(height: 4),
            ProductCardPrice(
              now: price.now,
              was: price.was,
              isDeal: price.isDeal,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}
