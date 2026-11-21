import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/dtos/item/item_list_item_dto.dart';
import '../../../../models/deal_progress.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../utils/number_localization.dart';
import '../../../reusable_components/product_card/product_grid_card.dart';
import 'deal_card_parts.dart';

/// Translation key and icon for each filter chip.
(String, FaIconData) dealFilterLabel(DealFilter filter) => switch (filter) {
  DealFilter.all => ('deals.filters.all', FontAwesomeIcons.wandMagicSparkles),
  DealFilter.singleItem => ('deals.filters.single', FontAwesomeIcons.tag),
  DealFilter.bundle => ('deals.filters.bundle', FontAwesomeIcons.boxOpen),
  DealFilter.multiBuy => ('deals.filters.multi', FontAwesomeIcons.layerGroup),
  DealFilter.freeGift => ('deals.filters.gift', FontAwesomeIcons.gift),
  DealFilter.spendThreshold => ('deals.filters.spend', FontAwesomeIcons.cartShopping),
};

/// A horizontal row of filter chips, each with its deal count.
class DealFilterChips extends StatelessWidget {
  final DealFilter selected;
  final Map<DealFilter, int> counts;
  final ValueChanged<DealFilter> onSelected;
  final bool isDark;

  const DealFilterChips({
    super.key,
    required this.selected,
    required this.counts,
    required this.onSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Vertical room inside the scroller so the chips' borders and the
    // selected chip's shadow are not clipped.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final filter in DealFilter.values) ...[
            if (filter != DealFilter.values.first) const SizedBox(width: 8),
            _FilterChip(
              filter: filter,
              count: counts[filter] ?? 0,
              on: filter == selected,
              isDark: isDark,
              onTap: () => onSelected(filter),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final DealFilter filter;
  final int count;
  final bool on;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChip({
    required this.filter,
    required this.count,
    required this.on,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final (key, icon) = dealFilterLabel(filter);
    final foreground = on ? AppColors.white : palette.text;

    return Semantics(
      selected: on,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: reduceMotionOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: on
                ? const LinearGradient(colors: AppColors.auroraGradient)
                : null,
            color: on ? null : palette.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: on ? Colors.transparent : palette.border,
            ),
            boxShadow: on
                ? [
                    BoxShadow(
                      color: AppColors.auroraPurple.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(icon, size: 11, color: foreground),
              const SizedBox(width: 6),
              Text(
                key.tr(),
                style: AppTextStyles.captionSmall.copyWith(
                  color: foreground,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: on
                      ? AppColors.white.withValues(alpha: 0.22)
                      : palette.surfaceSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  localizedNumber(count),
                  style: AppTextStyles.captionSmall.copyWith(
                    color: on ? AppColors.white : palette.muted,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A section title with an icon, and an optional link on the end side.
class DealSectionHead extends StatelessWidget {
  final String title;
  final FaIconData icon;
  final bool isDark;
  final bool flicker;
  final String? actionLabel;
  final VoidCallback? onAction;

  const DealSectionHead({
    super.key,
    required this.title,
    required this.icon,
    required this.isDark,
    this.flicker = false,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final iconWidget = FaIcon(icon, size: 16, color: AppColors.auroraPink);
    final action = actionLabel;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 12),
      child: Row(
        children: [
          flicker && !reduceMotionOf(context)
              ? LoopingPulse(scale: 1.15, period: const Duration(milliseconds: 700), child: iconWidget)
              : iconWidget,
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                color: palette.text,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action,
                style: AppTextStyles.captionSmall.copyWith(
                  color: palette.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Fixed price deal items ending soonest, as the same product cards Browse
/// shows, in a sideways scrolling row.
class EndingSoonRow extends StatelessWidget {
  final List<EndingSoonEntry> entries;

  /// Units of an item id in the cart.
  final int Function(int itemId) quantityOf;

  /// Whether the cart prices this item with a deal other than its own.
  final bool Function(ItemListItemDto item) isTakenByOtherDeal;

  const EndingSoonRow({
    super.key,
    required this.entries,
    required this.quantityOf,
    required this.isTakenByOtherDeal,
  });

  static const double _cardWidth = 140;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            SizedBox(
              width: _cardWidth,
              child: ProductGridCard(
                item: entries[i].item,
                inCartQuantity: quantityOf(entries[i].item.id),
                dealOverridden: isTakenByOtherDeal(entries[i].item),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
