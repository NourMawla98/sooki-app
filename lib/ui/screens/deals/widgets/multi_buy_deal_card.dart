import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/dtos/deal/customer_deal_dto.dart';
import '../../../../backend_integration/dtos/item/item_list_item_dto.dart';
import '../../../../models/deal_progress.dart';
import '../../../../models/display_price.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../utils/number_localization.dart';
import '../../../reusable_components/product_card/product_grid_card.dart';
import 'deal_card_parts.dart';

/// Buy more, save more: a segmented bar fills with the units already in the
/// cart toward the minimum, and the card lights up once it is reached.
class MultiBuyDealCard extends StatelessWidget {
  final CustomerDealDto deal;
  final bool isDark;
  final int inCartQuantity;

  /// Where the deal stands against the cart.
  final DealCartStatus status;
  final VoidCallback? onElapsed;

  const MultiBuyDealCard({
    super.key,
    required this.deal,
    required this.isDark,
    required this.inCartQuantity,
    required this.status,
    this.onElapsed,
  });

  /// The item the deal is on: its buy line, or its first item.
  static ItemListItemDto? itemOf(CustomerDealDto deal) {
    final lines = deal.buyLines;
    if (lines.isNotEmpty) return deal.itemFor(lines.first);
    return deal.items.isNotEmpty ? deal.items.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final item = itemOf(deal);
    final progress = MultiBuyProgress.of(
      quantity: inCartQuantity,
      minQuantity: deal.minQuantity,
      discountPercent: deal.discountPercent,
    );
    final unlocked = status == DealCartStatus.unlocked;
    final percent = localizedNumber(progress.discountPercent.round());
    // The normal price, never a fixed price deal: the multi-buy saving is
    // measured from it, and the cart picks only one deal per line.
    final price = item == null
        ? null
        : DisplayPrice.of(
            original: item.originalPrice,
            discounted: item.discountedPrice,
          );

    return DealCardShell(
      isDark: isDark,
      unlocked: unlocked,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DealCardHead(
            unlocked: unlocked,
            label: DealTypeLabel(
              icon: FontAwesomeIcons.layerGroup,
              label: 'deals.types.multi_label'.tr(),
              tint: AppColors.auroraGold,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DealItemTile(
                item: item,
                inCart: inCartQuantity,
                covered: unlocked,
                isDark: isDark,
                size: 84,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: palette.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _TierChip(
                      label: 'deals.multi.tier'.tr(
                        namedArgs: {
                          'count': localizedNumber(progress.minQuantity),
                          'percent': percent,
                        },
                      ),
                      on: unlocked,
                      isDark: isDark,
                    ),
                    if (price != null) ...[
                      const SizedBox(height: 8),
                      ProductCardPrice(
                        now: price.now,
                        was: price.was,
                        isDeal: price.isDeal,
                        isDark: isDark,
                        fontSize: 16,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SegmentBar(
            segments: progress.minQuantity.clamp(1, 10),
            fraction: progress.fraction,
            win: unlocked,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          DealProgressText(
            unlocked: unlocked,
            isDark: isDark,
            text: unlocked
                ? 'deals.multi.unlocked'.tr(namedArgs: {'percent': percent})
                : status == DealCartStatus.betterDealApplies
                ? 'deals.progress.better_deal'.tr()
                : inCartQuantity == 0
                ? 'deals.progress.multi_pitch'.tr(
                    namedArgs: {
                      'count': localizedNumber(progress.minQuantity),
                      'item': item?.title ?? '',
                      'percent': percent,
                    },
                  )
                : 'deals.progress.multi_add'.tr(
                    namedArgs: {
                      'count': localizedNumber(progress.remaining),
                      'item': item?.title ?? '',
                      'percent': percent,
                    },
                  ),
          ),
          if (!deal.isLive || deal.expiresAt != null) ...[
            const SizedBox(height: 10),
            DealTimerPill(
              target: deal.isLive ? deal.expiresAt : deal.startsAt,
              isDark: isDark,
              label: deal.isLive ? 'deals.ends_in'.tr() : 'deals.starts_in'.tr(),
              onElapsed: onElapsed,
            ),
          ],
        ],
      ),
    );
  }
}

class _TierChip extends StatelessWidget {
  final String label;
  final bool on;
  final bool isDark;

  const _TierChip({required this.label, required this.on, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    return AnimatedContainer(
      duration: reduceMotionOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: on ? palette.winSoft : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: on ? palette.win : palette.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.captionSmall.copyWith(
          color: on ? palette.text : palette.muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// A bar split into [segments] that fills to [fraction], purple on the way
/// and green once [win].
class SegmentBar extends StatelessWidget {
  final int segments;
  final double fraction;
  final bool win;
  final bool isDark;

  const SegmentBar({
    super.key,
    required this.segments,
    required this.fraction,
    required this.win,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final filled = (fraction * segments).round();
    final duration = reduceMotionOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 300);
    return Row(
      children: [
        for (var i = 0; i < segments; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: AnimatedContainer(
              duration: duration,
              height: 10,
              decoration: BoxDecoration(
                color: i < filled ? null : palette.surfaceSoft,
                gradient: i < filled
                    ? LinearGradient(
                        colors: win
                            ? [AppColors.verifiedGreen, AppColors.verifiedGreen]
                            : const [
                                AppColors.auroraElectricBlue,
                                AppColors.auroraPurple,
                              ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(6),
                border: i < filled ? null : Border.all(color: palette.border),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
