import '../backend_integration/dtos/cart/cart_dto.dart';
import '../backend_integration/dtos/deal/customer_deal_dto.dart';
import '../backend_integration/dtos/item/item_list_item_dto.dart';
import '../enums/deal_type.dart';

/// Where a multi-buy stands once [quantity] units count toward it: the units
/// already in the cart plus the ones about to be added.
class MultiBuyProgress {
  final int quantity;
  final int minQuantity;
  final double discountPercent;

  const MultiBuyProgress._(this.quantity, this.minQuantity, this.discountPercent);

  /// A missing or zero minimum is read as one, so the deal is never shown as
  /// impossible to unlock.
  factory MultiBuyProgress.of({
    required int quantity,
    required int? minQuantity,
    required double? discountPercent,
  }) {
    final min = (minQuantity ?? 1) < 1 ? 1 : (minQuantity ?? 1);
    return MultiBuyProgress._(
      quantity < 0 ? 0 : quantity,
      min,
      discountPercent ?? 0,
    );
  }

  bool get unlocked => quantity >= minQuantity;

  /// Units still needed, zero once unlocked.
  int get remaining => unlocked ? 0 : minQuantity - quantity;

  /// Share of the way to the minimum, from 0 to 1.
  double get fraction => (quantity / minQuantity).clamp(0.0, 1.0);
}

/// Which buy lines of a bundle or free gift deal the cart already covers,
/// the first line still short, and whether a free item is in the cart too.
class DealLinesProgress {
  /// Item id to whether the cart holds the line's full quantity.
  final Map<int, bool> ownedLines;
  final int missingUnits;

  /// Units one full set of buy lines needs.
  final int totalUnits;

  /// The first buy line the cart is short on, and by how many units.
  final ({DealLineDto line, int missing})? firstShort;
  final bool giftInCart;

  const DealLinesProgress._(
    this.ownedLines,
    this.missingUnits,
    this.totalUnits,
    this.firstShort,
    this.giftInCart,
  );

  /// [quantityOf] gives the units of an item id currently in the cart.
  factory DealLinesProgress.of(
    CustomerDealDto deal,
    int Function(int itemId) quantityOf,
  ) {
    final owned = <int, bool>{};
    var missing = 0;
    var total = 0;
    ({DealLineDto line, int missing})? firstShort;
    for (final line in deal.buyLines) {
      final have = quantityOf(line.itemId);
      total += line.quantity;
      owned[line.itemId] = have >= line.quantity;
      if (have < line.quantity) {
        missing += line.quantity - have;
        firstShort ??= (line: line, missing: line.quantity - have);
      }
    }
    final free = deal.freeLine;
    final giftInCart = free != null && quantityOf(free.itemId) >= free.quantity;
    return DealLinesProgress._(owned, missing, total, firstShort, giftInCart);
  }

  /// Every buy line is covered. A deal with no buy lines is never complete,
  /// since there is nothing to buy.
  bool get complete => ownedLines.isNotEmpty && missingUnits == 0;

  bool isOwned(int itemId) => ownedLines[itemId] ?? false;

  /// At least one buy item is in the cart. Until then the card pitches the
  /// deal rather than counting down what is missing.
  bool get started => ownedLines.isNotEmpty && missingUnits < totalUnits;
}

/// How far the cart is from a spend deal's threshold, as the backend priced it.
class SpendProgress {
  final SpendDealDto deal;

  const SpendProgress(this.deal);

  /// As the backend decided it, never worked out on the device.
  bool get unlocked => deal.unlocked;

  double get remaining {
    if (unlocked) return 0;
    final r = deal.remaining > 0
        ? deal.remaining
        : deal.spendThreshold - deal.eligibleSubtotal;
    return r < 0 ? 0 : r;
  }

  double get fraction => deal.spendThreshold <= 0
      ? 1.0
      : (deal.eligibleSubtotal / deal.spendThreshold).clamp(0.0, 1.0);

  /// What the discount takes off the cart as it stands.
  double get saving => deal.eligibleSubtotal * deal.discountPercent / 100;
}

/// What a bundle saves against buying its lines one by one, never negative.
double bundleSaving(CustomerDealDto deal) {
  final price = deal.bundlePrice;
  final original = deal.originalTotal;
  if (price == null || original == null) return 0;
  final saving = original - price;
  return saving > 0 ? saving : 0;
}

/// The filter chips on the Deals tab. [all] shows every deal.
enum DealFilter { all, singleItem, bundle, multiBuy, freeGift, spendThreshold }

extension DealFilterType on DealFilter {
  DealType? get dealType => switch (this) {
    DealFilter.all => null,
    DealFilter.singleItem => DealType.singleItem,
    DealFilter.bundle => DealType.bundle,
    DealFilter.multiBuy => DealType.multiBuy,
    DealFilter.freeGift => DealType.freeGift,
    DealFilter.spendThreshold => DealType.spendThreshold,
  };
}

/// Deals counted per filter chip.
///
/// The spend card is drawn from the cart's spend deal, not from the deal list,
/// so the spend chip counts that one card when the cart has a spend deal and
/// spend deals in the list are left out of every count.
Map<DealFilter, int> dealFilterCounts(
  List<CustomerDealDto> deals, {
  required bool hasSpendDeal,
}) {
  final counts = {for (final f in DealFilter.values) f: 0};
  for (final deal in deals) {
    final type = deal.dealType;
    if (type == DealType.spendThreshold) continue;
    final filter = DealFilter.values.firstWhere((f) => f.dealType == type);
    counts[filter] = counts[filter]! + 1;
    counts[DealFilter.all] = counts[DealFilter.all]! + 1;
  }
  if (hasSpendDeal) {
    counts[DealFilter.spendThreshold] = 1;
    counts[DealFilter.all] = counts[DealFilter.all]! + 1;
  }
  return counts;
}

/// The deals a filter keeps, spend deals excluded since their card comes from
/// the cart.
List<CustomerDealDto> dealsForFilter(
  List<CustomerDealDto> deals,
  DealFilter filter,
) {
  final type = filter.dealType;
  return deals
      .where((d) => d.dealType != DealType.spendThreshold)
      .where((d) => type == null || d.dealType == type)
      .toList();
}

/// One tile in the ending soon row.
typedef EndingSoonEntry = ({ItemListItemDto item, DateTime endsAt});

/// Live fixed price deal items that have an end time, soonest first.
List<EndingSoonEntry> endingSoonEntries(
  List<CustomerDealDto> deals, {
  int limit = 10,
}) {
  final entries = <EndingSoonEntry>[];
  final seen = <int>{};
  for (final deal in deals) {
    if (!deal.isLive || deal.dealType != DealType.singleItem) continue;
    for (final item in deal.items) {
      final ends = item.deal?.expiresAt ?? deal.expiresAt;
      if (ends == null || !seen.add(item.id)) continue;
      entries.add((item: item, endsAt: ends));
    }
  }
  entries.sort((a, b) => a.endsAt.compareTo(b.endsAt));
  return entries.take(limit).toList();
}

/// The soonest end among live deals, or null when none of them ends.
DateTime? soonestLiveEnd(List<CustomerDealDto> deals) {
  DateTime? soonest;
  for (final deal in deals) {
    final ends = deal.expiresAt;
    if (!deal.isLive || ends == null) continue;
    if (soonest == null || ends.isBefore(soonest)) soonest = ends;
  }
  return soonest;
}

/// Where a bundle, multi-buy or free gift card stands against the cart.
enum DealCartStatus {
  /// The cart applies this deal.
  unlocked,

  /// The deal's items are in the cart, but another deal saves more on them.
  betterDealApplies,

  /// The cart does not meet the deal yet.
  inProgress,
}

/// Only a deal the cart actually applies is unlocked, so the card never
/// promises a saving the cart will not give. A deal whose condition the cart
/// meets, or whose items another deal took, has lost to a better deal.
DealCartStatus dealCartStatus({
  required bool applied,
  required bool conditionMet,
  required bool takenByOtherDeal,
}) {
  if (applied) return DealCartStatus.unlocked;
  if (conditionMet || takenByOtherDeal) return DealCartStatus.betterDealApplies;
  return DealCartStatus.inProgress;
}
