import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/dtos/deal/customer_deal_dto.dart';
import '../../../../models/deal_progress.dart';
import '../../../../models/display_price.dart';
import '../../../../routes/item_navigation.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../utils/number_localization.dart';
import '../../../reusable_components/product_card/product_grid_card.dart';
import 'deal_card_parts.dart';

/// A free gift: the buy items light up as they land in the cart, and the gift
/// box opens and the card lights up once they are all there.
class FreeGiftDealCard extends StatelessWidget {
  final CustomerDealDto deal;
  final bool isDark;

  /// Units of an item id in the cart.
  final int Function(int itemId) quantityOf;

  /// Where the deal stands against the cart.
  final DealCartStatus status;
  final VoidCallback? onElapsed;

  const FreeGiftDealCard({
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
    final progress = DealLinesProgress.of(deal, quantityOf);
    final short = progress.firstShort;
    final freeLine = deal.freeLine;
    final gift = freeLine == null ? null : deal.itemFor(freeLine);
    final giftImage = gift != null && gift.colorImages.isNotEmpty
        ? gift.colorImages.first
        : null;
    final giftValue = gift == null
        ? null
        : DisplayPrice.of(
            original: gift.originalPrice,
            discounted: gift.discountedPrice,
          ).now;

    final unlocked = status == DealCartStatus.unlocked;
    final String message;
    if (status == DealCartStatus.betterDealApplies) {
      message = 'deals.progress.better_deal'.tr();
    } else if (!unlocked && !progress.started) {
      message = 'deals.progress.gift_pitch'.tr(
        namedArgs: {'item': gift?.title ?? ''},
      );
    } else if (!unlocked && short != null) {
      message = 'deals.progress.gift_add'.tr(
        namedArgs: {
          'count': localizedNumber(short.missing),
          'item': deal.itemFor(short.line)?.title ?? '',
        },
      );
    } else if (progress.giftInCart) {
      message = 'deals.gift.in_cart'.tr();
    } else {
      message = 'deals.gift.unlocked'.tr(namedArgs: {'item': gift?.title ?? ''});
    }

    return DealCardShell(
      isDark: isDark,
      unlocked: status == DealCartStatus.unlocked,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 56),
                  child: DealCardHead(
                    unlocked: status == DealCartStatus.unlocked,
                    label: DealTypeLabel(
                      icon: FontAwesomeIcons.gift,
                      label: 'deals.types.gift_label'.tr(),
                      tint: AppColors.verifiedGreen,
                      isDark: isDark,
                    ),
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
                      const Padding(
                        padding: EdgeInsets.only(top: 21),
                        child: DealJoinCircle(symbol: '='),
                      ),
                      GestureDetector(
                        onTap: gift == null
                            ? null
                            : () => openItemDetail(context, gift.id),
                        child: _GiftBox(
                          open: unlocked,
                          imageUrl: giftImage,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                DealProgressText(
                  unlocked: status == DealCartStatus.unlocked,
                  isDark: isDark,
                  text: message,
                ),
                if (giftValue != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'deals.gift.worth'.tr(
                      namedArgs: {
                        'item': gift?.title ?? '',
                        'amount': formatCardPrice(giftValue),
                      },
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.captionSmall.copyWith(
                      color: palette.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (!deal.isLive || deal.expiresAt != null) ...[
                  const SizedBox(height: 10),
                  DealTimerPill(
                    target: deal.isLive ? deal.expiresAt : deal.startsAt,
                    isDark: isDark,
                    label: deal.isLive
                        ? 'deals.ends_in'.tr()
                        : 'deals.starts_in'.tr(),
                    onElapsed: onElapsed,
                  ),
                ],
              ],
            ),
          ),
          const PositionedDirectional(
            top: 18,
            end: -34,
            child: _Ribbon(),
          ),
        ],
      ),
    );
  }
}

/// A striped gift box. Once [open], the lid lifts away and the free item
/// pops in.
class _GiftBox extends StatelessWidget {
  final bool open;
  final String? imageUrl;
  final bool isDark;

  const _GiftBox({
    required this.open,
    required this.imageUrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final palette = DealPalette(isDark);
    final reduce = reduceMotionOf(context);
    final duration = reduce ? Duration.zero : const Duration(milliseconds: 450);
    final accent = open ? palette.win : AppColors.auroraPink;

    return SizedBox(
      width: 78,
      height: 84,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          AnimatedContainer(
            duration: duration,
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: open ? palette.winSoft : null,
              gradient: open
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: const Alignment(-0.6, -0.6),
                      tileMode: TileMode.repeated,
                      colors: [
                        AppColors.auroraPink.withValues(alpha: 0.14),
                        AppColors.auroraPink.withValues(alpha: 0.14),
                        palette.surfaceSoft,
                        palette.surfaceSoft,
                      ],
                      stops: const [0, 0.5, 0.5, 1],
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedScale(
                    duration: duration,
                    curve: Curves.elasticOut,
                    scale: open ? 1 : 0.4,
                    child: AnimatedOpacity(
                      duration: duration,
                      opacity: open ? 1 : 0,
                      child: dealItemImage(imageUrl, 50, radius: 10),
                    ),
                  ),
                  AnimatedSlide(
                    duration: duration,
                    offset: open ? const Offset(0, -0.6) : Offset.zero,
                    child: AnimatedOpacity(
                      duration: duration,
                      opacity: open ? 0 : 1,
                      child: const FaIcon(
                        FontAwesomeIcons.gift,
                        size: 30,
                        color: AppColors.auroraPink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.verifiedGreen,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'deals.gift.free'.tr(),
                style: AppTextStyles.badgeText.copyWith(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The corner ribbon across the card's top end corner.
class _Ribbon extends StatelessWidget {
  const _Ribbon();

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Transform.rotate(
      angle: isRtl ? -0.785 : 0.785,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.auroraPink,
          boxShadow: [
            BoxShadow(
              color: AppColors.auroraPink.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          'deals.gift.ribbon'.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.badgeText.copyWith(
            color: AppColors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
