import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../backend_integration/dtos/deal/item_offer_dto.dart';
import '../../../../models/deal_offer.dart';
import '../../../../routes/item_navigation.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/deals/offer_pill.dart';
import '../../../reusable_components/icons/mirrored_fa_icon.dart';

/// The bundle, multi-buy and free gift deals this item is part of. Tapping one
/// opens the Deals screen over this one with that deal type's filter on.
class ItemOfferBox extends StatelessWidget {
  final List<ItemOfferDto> offers;
  final bool isDark;

  const ItemOfferBox({super.key, required this.offers, required this.isDark});

  void _open(BuildContext context, ItemOfferDto offer) {
    openDealsFiltered(context, offerFilter(offer));
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final muted = isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.auroraPurple.withValues(alpha: 0.14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final offer in offers) ...[
          Material(
            color: offerStyle(offer).$2.withValues(alpha: isDark ? 0.14 : 0.08),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _open(context, offer),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OfferPill(offer: offer, fontSize: 10, maxWidth: 220),
                          if (offer.title.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              offer.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                          const SizedBox(height: 2),
                          Text(
                            'deals.offer.see_deal'.tr(),
                            style: AppTextStyles.captionSmall.copyWith(
                              color: muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    MirroredFaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: 12,
                      color: muted,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (offer != offers.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}
