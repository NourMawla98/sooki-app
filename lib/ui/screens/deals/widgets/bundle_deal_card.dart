import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/dtos/deal/customer_deal_dto.dart';
import '../../../../models/deal_progress.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../utils/number_localization.dart';
import '../../../reusable_components/product_card/product_grid_card.dart';
import 'deal_card_parts.dart';

/// A bundle: every line's item joined by plus signs, the set price against
/// the normal total and a save sticker. Lines already in the cart light up,
/// and the whole card does once the set is complete.
class BundleDealCard extends StatelessWidget {
  final CustomerDealDto deal;
  final bool isDark;

  /// Units of an item id in the cart.
  final int Function(int itemId) quantityOf;

  /// Where the deal stands against the cart.
  final DealCartStatus status;
  final VoidCallback? onElapsed;

  const BundleDealCard({
    super.key,
    required this.deal,
    required this.isDark,
    required this.quantityOf,
    required this.status,
    this.onElapsed,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final lines = deal.buyLines;
    final saving = bundleSaving(deal);
    final price = deal.bundlePrice;
    final progress = DealLinesProgress.of(deal, quantityOf);
    final short = progress.firstShort;

    return DealCardShell(
      isDark: isDark,
      unlocked: status == DealCartStatus.unlocked,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DealCardHead(
            unlocked: status == DealCartStatus.unlocked,
            label: DealTypeLabel(
              icon: FontAwesomeIcons.boxOpen,
              label: 'deals.types.bundle_label'.tr(),
              tint: AppColors.auroraPurple,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            deal.title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: palette.text,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < lines.length; i++) ...[
                  if (i > 0)
                    const Padding(
                      padding: EdgeInsets.only(top: 21),
                      child: DealJoinCircle(symbol: '+'),
                    ),
                  DealItemTile(
                    item: deal.itemFor(lines[i]),
                    lineQuantity: lines[i].quantity,
                    inCart: quantityOf(lines[i].itemId),
                    covered: progress.isOwned(lines[i].itemId),
                    isDark: isDark,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '=',
                style: AppTextStyles.heading3.copyWith(
                  color: palette.muted,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 10),
              if (price != null)
                Expanded(
                  child: ProductCardPrice(
                    now: price,
                    was: saving > 0 ? deal.originalTotal : null,
                    isDeal: true,
                    isDark: isDark,
                    fontSize: 24,
                  ),
                )
              else
                const Spacer(),
              if (saving > 0) _SaveSticker(amount: saving),
            ],
          ),
          const SizedBox(height: 10),
          DealProgressText(
            unlocked: status == DealCartStatus.unlocked,
            isDark: isDark,
            text: status == DealCartStatus.unlocked
                ? 'deals.progress.bundle_done'.tr()
                : status == DealCartStatus.betterDealApplies
                ? 'deals.progress.better_deal'.tr()
                : !progress.started || short == null
                ? _pitch(lines.fold<int>(0, (s, l) => s + l.quantity), saving)
                : 'deals.progress.bundle_add'.tr(
                    namedArgs: {
                      'count': localizedNumber(short.missing),
                      'item': deal.itemFor(short.line)?.title ?? '',
                    },
                  ),
          ),
          const SizedBox(height: 10),
          DealTimerPill(
            target: deal.isLive ? deal.expiresAt : deal.startsAt,
            isDark: isDark,
            label: deal.isLive ? 'deals.ends_in'.tr() : 'deals.starts_in'.tr(),
            onElapsed: onElapsed,
          ),
        ],
      ),
    );
  }
}

/// What the card says before any of the bundle is in the cart.
String _pitch(int units, double saving) {
  final count = localizedNumber(units);
  return saving > 0
      ? 'deals.progress.bundle_pitch'.tr(
          namedArgs: {'count': count, 'amount': formatCardPrice(saving)},
        )
      : 'deals.progress.bundle_pitch_plain'.tr(namedArgs: {'count': count});
}

/// A tilted round sticker with the saving, rocking gently.
class _SaveSticker extends StatelessWidget {
  final double amount;

  const _SaveSticker({required this.amount});

  @override
  Widget build(BuildContext context) {
    return LoopingWobble(
      child: Container(
        width: 62,
        height: 62,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.auroraGold,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.auroraGold.withValues(alpha: 0.45),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FittedBox(
          child: Text(
            'deals.save_sticker'.tr(
              namedArgs: {'amount': formatCardPrice(amount)},
            ),
            textAlign: TextAlign.center,
            style: AppTextStyles.badgeText.copyWith(
              color: AppColors.auroraDeepBase,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
