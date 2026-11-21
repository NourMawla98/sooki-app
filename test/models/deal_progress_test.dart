import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/backend_integration/dtos/cart/cart_dto.dart';
import 'package:sooki_app/backend_integration/dtos/deal/customer_deal_dto.dart';
import 'package:sooki_app/backend_integration/dtos/deal/item_deal_dto.dart';
import 'package:sooki_app/backend_integration/dtos/item/item_list_item_dto.dart';
import 'package:sooki_app/models/deal_progress.dart';

ItemListItemDto _item(int id, {double price = 20, DateTime? dealEnds}) =>
    ItemListItemDto(
      id: id,
      title: 'Item $id',
      originalPrice: price,
      categoryName: 'Beauty',
      deal: dealEnds == null
          ? null
          : ItemDealDto(dealId: 1, dealPrice: price / 2, expiresAt: dealEnds),
    );

CustomerDealDto _deal({
  int id = 1,
  int type = 1,
  bool isLive = true,
  DateTime? expiresAt,
  List<ItemListItemDto> items = const [],
  List<DealLineDto> lines = const [],
  double? bundlePrice,
  double? originalTotal,
}) => CustomerDealDto(
  id: id,
  title: 'Deal $id',
  startsAt: DateTime.utc(2026, 11, 1),
  expiresAt: expiresAt,
  isLive: isLive,
  items: items,
  type: type,
  lines: lines,
  bundlePrice: bundlePrice,
  originalTotal: originalTotal,
);

SpendDealDto _spend({
  double threshold = 100,
  double eligible = 0,
  double remaining = 0,
  bool unlocked = false,
}) => SpendDealDto(
  dealId: 1,
  spendThreshold: threshold,
  discountPercent: 20,
  eligibleSubtotal: eligible,
  remaining: remaining,
  unlocked: unlocked,
);

void main() {
  group('MultiBuyProgress', () {
    test('counts down to the minimum, then unlocks', () {
      final short = MultiBuyProgress.of(
        quantity: 1,
        minQuantity: 3,
        discountPercent: 20,
      );
      expect(short.unlocked, isFalse);
      expect(short.remaining, 2);
      expect(short.fraction, closeTo(1 / 3, 1e-9));

      final met = MultiBuyProgress.of(
        quantity: 3,
        minQuantity: 3,
        discountPercent: 20,
      );
      expect(met.unlocked, isTrue);
      expect(met.remaining, 0);
      expect(met.fraction, 1.0);
    });

    test('caps the fraction past the minimum', () {
      final over = MultiBuyProgress.of(
        quantity: 9,
        minQuantity: 3,
        discountPercent: 10,
      );
      expect(over.fraction, 1.0);
    });

    test('a missing minimum or discount never blocks or breaks', () {
      final loose = MultiBuyProgress.of(
        quantity: 1,
        minQuantity: null,
        discountPercent: null,
      );
      expect(loose.unlocked, isTrue);
    });
  });

  group('DealLinesProgress', () {
    final deal = _deal(
      type: 4,
      items: [_item(1), _item(2), _item(3)],
      lines: const [
        DealLineDto(itemId: 1, quantity: 2),
        DealLineDto(itemId: 2, quantity: 1),
        DealLineDto(itemId: 3, quantity: 1, role: 2),
      ],
    );

    test('marks covered lines and counts the missing units', () {
      final progress = DealLinesProgress.of(
        deal,
        (id) => const {1: 1, 2: 1}[id] ?? 0,
      );
      expect(progress.isOwned(1), isFalse);
      expect(progress.isOwned(2), isTrue);
      expect(progress.missingUnits, 1);
      // The progress text names the first short line and how many it needs.
      expect(progress.firstShort?.line.itemId, 1);
      expect(progress.firstShort?.missing, 1);
      expect(progress.complete, isFalse);
      expect(progress.giftInCart, isFalse);
    });

    test('completes once every buy line is in, and sees the gift', () {
      final ready = DealLinesProgress.of(
        deal,
        (id) => const {1: 2, 2: 1}[id] ?? 0,
      );
      expect(ready.complete, isTrue);
      expect(ready.giftInCart, isFalse);

      final done = DealLinesProgress.of(
        deal,
        (id) => const {1: 2, 2: 1, 3: 1}[id] ?? 0,
      );
      expect(done.giftInCart, isTrue);
    });

    test('is not started until a buy item is in the cart', () {
      expect(_started(deal, (_) => 0), isFalse);
      expect(_started(deal, (id) => id == 2 ? 1 : 0), isTrue);
      // The free item alone does not start the deal.
      expect(_started(deal, (id) => id == 3 ? 1 : 0), isFalse);
    });

    test('a deal with no buy lines is never complete', () {
      final progress = DealLinesProgress.of(_deal(type: 4), (_) => 5);
      expect(progress.complete, isFalse);
    });
  });

  group('SpendProgress', () {
    test('reports the gap and the share of the way', () {
      final p = SpendProgress(_spend(eligible: 65, remaining: 35));
      expect(p.unlocked, isFalse);
      expect(p.remaining, 35);
      expect(p.fraction, closeTo(0.65, 1e-9));
    });

    test('works out the gap when the backend leaves it at zero', () {
      final p = SpendProgress(_spend(eligible: 40));
      expect(p.remaining, 60);
    });

    test('unlocks at the threshold and reports the saving', () {
      final p = SpendProgress(_spend(eligible: 120, unlocked: true));
      expect(p.unlocked, isTrue);
      expect(p.remaining, 0);
      expect(p.fraction, 1.0);
      expect(p.saving, closeTo(24, 1e-9));
    });
  });

  test('bundleSaving is the gap to the normal total, never negative', () {
    expect(
      bundleSaving(_deal(type: 2, bundlePrice: 40, originalTotal: 50)),
      10,
    );
    expect(
      bundleSaving(_deal(type: 2, bundlePrice: 60, originalTotal: 50)),
      0,
    );
    expect(bundleSaving(_deal(type: 2)), 0);
  });

  group('filters', () {
    final deals = [
      _deal(id: 1, type: 1, items: [_item(1)]),
      _deal(id: 2, type: 2),
      _deal(id: 3, type: 2),
      _deal(id: 4, type: 3),
      _deal(id: 5, type: 5),
    ];

    test('count each type, leaving list spend deals to the cart', () {
      final counts = dealFilterCounts(deals, hasSpendDeal: false);
      expect(counts[DealFilter.all], 4);
      expect(counts[DealFilter.singleItem], 1);
      expect(counts[DealFilter.bundle], 2);
      expect(counts[DealFilter.multiBuy], 1);
      expect(counts[DealFilter.freeGift], 0);
      expect(counts[DealFilter.spendThreshold], 0);

      final withSpend = dealFilterCounts(deals, hasSpendDeal: true);
      expect(withSpend[DealFilter.spendThreshold], 1);
      expect(withSpend[DealFilter.all], 5);
    });

    test('keep only the chosen type, and never list spend deals', () {
      expect(dealsForFilter(deals, DealFilter.bundle).map((d) => d.id), [2, 3]);
      expect(dealsForFilter(deals, DealFilter.freeGift), isEmpty);
      expect(dealsForFilter(deals, DealFilter.all).map((d) => d.id), [1, 2, 3, 4]);
      expect(dealsForFilter(deals, DealFilter.spendThreshold), isEmpty);
    });
  });

  test('endingSoonEntries keeps live fixed price items, soonest first', () {
    final soon = DateTime.utc(2026, 11, 16, 12);
    final later = DateTime.utc(2026, 11, 17, 12);
    final entries = endingSoonEntries([
      _deal(id: 1, items: [_item(1, dealEnds: later), _item(2, dealEnds: soon)]),
      _deal(id: 2, isLive: false, items: [_item(3, dealEnds: soon)]),
      _deal(id: 3, type: 2, expiresAt: soon, items: [_item(4)]),
      _deal(id: 4, items: [_item(5)]),
    ]);
    expect(entries.map((e) => e.item.id), [2, 1]);
  });

  test('soonestLiveEnd ignores upcoming and endless deals', () {
    final soon = DateTime.utc(2026, 11, 16, 12);
    expect(
      soonestLiveEnd([
        _deal(id: 1, expiresAt: DateTime.utc(2026, 12, 1)),
        _deal(id: 2, expiresAt: soon),
        _deal(id: 3, isLive: false, expiresAt: DateTime.utc(2026, 11, 2)),
        _deal(id: 4),
      ]),
      soon,
    );
    expect(soonestLiveEnd([_deal(id: 4)]), isNull);
  });

  group('dealCartStatus', () {
    test('is unlocked only when the cart applies the deal', () {
      expect(
        dealCartStatus(applied: true, conditionMet: false, takenByOtherDeal: true),
        DealCartStatus.unlocked,
      );
    });

    test('a met condition the cart did not apply lost to a better deal', () {
      expect(
        dealCartStatus(applied: false, conditionMet: true, takenByOtherDeal: false),
        DealCartStatus.betterDealApplies,
      );
      expect(
        dealCartStatus(applied: false, conditionMet: false, takenByOtherDeal: true),
        DealCartStatus.betterDealApplies,
      );
    });

    test('otherwise the deal is still in progress', () {
      expect(
        dealCartStatus(applied: false, conditionMet: false, takenByOtherDeal: false),
        DealCartStatus.inProgress,
      );
    });
  });

  test('a spend deal is unlocked only when the backend says so', () {
    final p = SpendProgress(_spend(eligible: 120));
    expect(p.unlocked, isFalse);
  });
}

bool _started(CustomerDealDto deal, int Function(int) quantityOf) =>
    DealLinesProgress.of(deal, quantityOf).started;
