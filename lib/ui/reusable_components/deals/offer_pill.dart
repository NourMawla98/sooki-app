import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/dtos/deal/item_offer_dto.dart';
import '../../../enums/deal_type.dart';
import '../../../models/deal_offer.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Icon and color for each kind of offer, shared by the card pill and the
/// item screen's offer box.
(FaIconData, Color) offerStyle(ItemOfferDto offer) => switch (offer.dealType) {
  DealType.bundle => (FontAwesomeIcons.boxOpen, AppColors.auroraPurple),
  DealType.multiBuy => (FontAwesomeIcons.layerGroup, AppColors.auroraGold),
  DealType.freeGift => (FontAwesomeIcons.gift, AppColors.verifiedGreen),
  DealType.singleItem ||
  DealType.spendThreshold => (FontAwesomeIcons.tag, AppColors.auroraPink),
};

/// A small solid pill naming an item's bundle, multi-buy or free gift offer.
class OfferPill extends StatelessWidget {
  final ItemOfferDto offer;
  final double fontSize;
  final double maxWidth;

  const OfferPill({
    super.key,
    required this.offer,
    this.fontSize = 9,
    this.maxWidth = 110,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color) = offerStyle(offer);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: fontSize * 0.8,
          vertical: fontSize * 0.35,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: fontSize - 1, color: AppColors.white),
            SizedBox(width: fontSize * 0.4),
            Flexible(
              child: Text(
                offerBadgeText(offer),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.badgeText.copyWith(
                  color: AppColors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
