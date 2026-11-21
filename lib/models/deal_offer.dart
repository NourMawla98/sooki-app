import 'package:easy_localization/easy_localization.dart';

import '../backend_integration/dtos/deal/item_offer_dto.dart';
import '../backend_integration/dtos/order/order_item_dto.dart';
import '../enums/deal_type.dart';
import '../utils/number_localization.dart';
import 'deal_progress.dart';

/// The short badge text for an offer on a product card or the item screen.
String offerBadgeText(ItemOfferDto offer) {
  switch (offer.dealType) {
    case DealType.multiBuy:
      final count = offer.minQuantity;
      final percent = offer.discountPercent;
      if (count == null || percent == null) return 'deals.offer.multi_plain'.tr();
      return 'deals.offer.multi'.tr(
        namedArgs: {
          'count': localizedNumber(count),
          'percent': localizedNumber(percent.round()),
        },
      );
    case DealType.bundle:
      return 'deals.offer.bundle'.tr();
    case DealType.freeGift:
      return offer.lineRole == DealLineRole.free
          ? 'deals.offer.gift_free'.tr()
          : 'deals.offer.gift'.tr();
    case DealType.singleItem:
    case DealType.spendThreshold:
      return offer.title;
  }
}

/// The Deals tab filter that shows an offer's deal.
DealFilter offerFilter(ItemOfferDto offer) => switch (offer.dealType) {
  DealType.bundle => DealFilter.bundle,
  DealType.multiBuy => DealFilter.multiBuy,
  DealType.freeGift => DealFilter.freeGift,
  DealType.singleItem => DealFilter.singleItem,
  DealType.spendThreshold => DealFilter.spendThreshold,
};

/// The live offers worth a badge: the types a card can describe, soonest
/// ending first.
List<ItemOfferDto> badgeOffers(List<ItemOfferDto> offers) {
  final live = offers
      .where((o) => o.isLive)
      .where((o) =>
          o.dealType == DealType.bundle ||
          o.dealType == DealType.multiBuy ||
          o.dealType == DealType.freeGift)
      .toList();
  live.sort((a, b) {
    final ae = a.expiresAt;
    final be = b.expiresAt;
    if (ae == null && be == null) return 0;
    if (ae == null) return 1;
    if (be == null) return -1;
    return ae.compareTo(be);
  });
  return live;
}

/// Translation key naming the deal behind an order line, by deal type number.
String orderDealLabelKey(int? dealType) => switch (dealType) {
  2 => 'order_detail_screen.deal.bundle',
  3 => 'order_detail_screen.deal.multi',
  4 => 'order_detail_screen.deal.gift',
  5 => 'order_detail_screen.deal.spend',
  _ => 'order_detail_screen.deal.price',
};

/// The deal notes under an order line, one per saving: a fixed price deal,
/// the line's bundle, multi-buy or free gift deal, then its share of a spend
/// deal. A fixed price deal with nothing to show as
/// a saving still gets its name.
List<({String labelKey, double amount})> orderLineDealNotes(OrderItemDto line) {
  final notes = <({String labelKey, double amount})>[];
  final isFixedPrice = line.dealType == null || line.dealType == 1;
  if (line.fixedPriceSaving > 0 || (line.dealId != null && isFixedPrice)) {
    notes.add((labelKey: orderDealLabelKey(1), amount: line.fixedPriceSaving));
  }
  if (line.dealDiscount > 0 || (line.dealId != null && !isFixedPrice)) {
    notes.add((labelKey: orderDealLabelKey(line.dealType), amount: line.dealDiscount));
  }
  if (line.cartDealId != null || line.cartDealDiscount > 0) {
    notes.add((labelKey: orderDealLabelKey(5), amount: line.cartDealDiscount));
  }
  return notes;
}
