import '../backend_integration/dtos/deal/item_deal_dto.dart';

/// The price a shopper pays now and the price shown struck through beside it.
///
/// A live deal beats a store discount: the deal price is shown against the
/// current price (the discounted price when there is one). Without a deal a
/// discount is shown against the original price. The shopper always pays the
/// lower of the deal price and the current price, so a deal that is not below
/// the current price is ignored.
class DisplayPrice {
  final double now;
  final double? was;
  final bool isDeal;

  /// Whole percent saved on the shown prices, or null when nothing is saved.
  final int? percentOff;

  /// The deal behind [now], when [isDeal] is true.
  final ItemDealDto? deal;

  const DisplayPrice._({
    required this.now,
    required this.was,
    required this.isDeal,
    required this.percentOff,
    required this.deal,
  });

  /// [surcharge] is a size's additional price, added on top of both prices.
  factory DisplayPrice.of({
    required double original,
    double? discounted,
    ItemDealDto? deal,
    double surcharge = 0,
  }) {
    final current = discounted ?? original;
    final liveDeal = deal != null && deal.isLive && deal.dealPrice < current
        ? deal
        : null;

    final double nowBase;
    final double? wasBase;
    if (liveDeal != null) {
      nowBase = liveDeal.dealPrice;
      wasBase = current;
    } else if (discounted != null && discounted < original) {
      nowBase = discounted;
      wasBase = original;
    } else {
      nowBase = current;
      wasBase = null;
    }

    final now = nowBase + surcharge;
    final was = wasBase == null ? null : wasBase + surcharge;
    final percent = was != null && was > 0
        ? ((1 - now / was) * 100).round()
        : null;

    return DisplayPrice._(
      now: now,
      was: was,
      isDeal: liveDeal != null,
      percentOff: percent != null && percent > 0 ? percent : null,
      deal: liveDeal,
    );
  }
}
