import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/backend_integration/dtos/cart/cart_dto.dart';
import 'package:sooki_app/backend_integration/dtos/deal/customer_deal_dto.dart';
import 'package:sooki_app/enums/deal_type.dart';

/// The app has to keep working against a backend that predates deal types,
/// so every new field must parse when it is missing and when it is present.

Map<String, dynamic> _item(int id, {Map<String, dynamic>? deal}) => {
  'id': id,
  'title': 'Item $id',
  'originalPrice': 20.0,
  'categoryName': 'Beauty',
  'colorImages': <String>[],
  'tags': <Map<String, dynamic>>[],
  'deal': ?deal,
};

Map<String, dynamic> _cartLine(int id, {Map<String, dynamic> extra = const {}}) => {
  'id': id,
  'itemId': id,
  'itemTitle': 'Item $id',
  'itemColorId': 1,
  'colorName': 'Red',
  'itemSizeId': id * 10,
  'sizeName': 'M',
  'unitPrice': 10.0,
  'quantity': 2,
  'lineTotal': 20.0,
  'stock': 5,
  'isAvailable': true,
  ...extra,
};

void main() {
  group('CustomerDealDto', () {
    test('an old payload without deal types reads as a fixed price deal', () {
      final dto = CustomerDealDto.fromJson({
        'id': 7,
        'title': 'Weekend sale',
        'description': null,
        'startsAt': '2026-11-01T10:00:00',
        'expiresAt': '2026-11-20T10:00:00',
        'isLive': true,
        'items': [
          _item(1, deal: {
            'dealId': 7,
            'dealPrice': 15.0,
            'expiresAt': '2026-11-20T10:00:00',
          }),
        ],
      });

      expect(dto.dealType, DealType.singleItem);
      expect(dto.discountPercent, isNull);
      expect(dto.minQuantity, isNull);
      expect(dto.bundlePrice, isNull);
      expect(dto.originalTotal, isNull);
      expect(dto.spendThreshold, isNull);
      expect(dto.lines, isEmpty);
      expect(dto.items.single.deal?.dealPrice, 15.0);
      expect(dto.startsAt.isUtc, isTrue);
    });

    test('a bundle parses its lines and prices', () {
      final dto = CustomerDealDto.fromJson({
        'id': 8,
        'title': 'Silky Hair Trio',
        'startsAt': '2026-11-01T10:00:00Z',
        'expiresAt': null,
        'isLive': true,
        'items': [_item(1), _item(2)],
        'type': 2,
        'bundlePrice': 40,
        'originalTotal': 50.5,
        'lines': [
          {'itemId': 1, 'quantity': 2, 'role': 1},
          {'itemId': 2, 'quantity': 1, 'role': 1},
        ],
      });

      expect(dto.dealType, DealType.bundle);
      expect(dto.bundlePrice, 40.0);
      expect(dto.originalTotal, 50.5);
      expect(dto.buyLines.map((l) => l.quantity), [2, 1]);
      expect(dto.freeLine, isNull);
      expect(dto.itemFor(dto.lines.first)?.title, 'Item 1');
    });

    test('a free gift splits its buy lines from the free line', () {
      final dto = CustomerDealDto.fromJson({
        'id': 9,
        'title': 'Cream gift',
        'startsAt': '2026-11-01T10:00:00Z',
        'isLive': true,
        'items': [_item(1), _item(2)],
        'type': 4,
        'originalTotal': 36,
        'lines': [
          {'itemId': 1, 'quantity': 2, 'role': 1},
          {'itemId': 2, 'quantity': 1, 'role': 2},
        ],
      });

      expect(dto.dealType, DealType.freeGift);
      expect(dto.buyLines.single.itemId, 1);
      expect(dto.freeLine?.itemId, 2);
      expect(dto.freeLine?.lineRole, DealLineRole.free);
    });

    test('a spend deal with no items and no lines still parses', () {
      final dto = CustomerDealDto.fromJson({
        'id': 10,
        'title': 'Spend 100',
        'startsAt': '2026-11-01T10:00:00Z',
        'isLive': true,
        'items': <Map<String, dynamic>>[],
        'type': 5,
        'discountPercent': 20,
        'spendThreshold': 100,
        'lines': <Map<String, dynamic>>[],
      });

      expect(dto.dealType, DealType.spendThreshold);
      expect(dto.items, isEmpty);
      expect(dto.spendThreshold, 100.0);
      expect(dto.discountPercent, 20.0);
    });

    test('an unknown type number falls back to a fixed price deal', () {
      expect(DealType.fromInt(99), DealType.singleItem);
      expect(DealType.fromInt(3), DealType.multiBuy);
    });
  });

  group('CartResponseDto', () {
    test('an old cart payload without deal fields parses with defaults', () {
      final dto = CartResponseDto.fromJson({
        'itemCount': 1,
        'subtotal': 20.0,
        'items': [_cartLine(1)],
      });

      expect(dto.dealDiscount, 0.0);
      expect(dto.singleItemDiscount, 0.0);
      expect(dto.items.single.singleDealDiscount, 0.0);
      expect(dto.appliedDeals, isEmpty);
      expect(dto.spendDeal, isNull);
      expect(dto.items.single.dealSaving, 0.0);
      expect(dto.items.single.appliedDealId, isNull);

      final line = CartLineItem.fromServer(dto.items.single);
      expect(line.dealSaving, 0.0);
      expect(line.appliedDealId, isNull);
    });

    test('a new cart payload parses deals, spend progress and line savings', () {
      final dto = CartResponseDto.fromJson({
        'itemCount': 1,
        'subtotal': 20.0,
        'items': [
          _cartLine(1, extra: {'dealSaving': 4, 'appliedDealId': 8}),
        ],
        'dealDiscount': 4.5,
        'appliedDeals': [
          {
            'dealId': 8,
            'type': 3,
            'title': 'Buy 2',
            'saving': 4.5,
          },
        ],
        'spendDeal': {
          'dealId': 10,
          'title': 'Spend 100',
          'spendThreshold': 100,
          'discountPercent': 20,
          'eligibleSubtotal': 65.5,
          'remaining': 34.5,
          'unlocked': false,
        },
      });

      expect(dto.dealDiscount, 4.5);
      expect(dto.appliedDeals.single.type, 3);
      expect(dto.appliedDeals.single.saving, 4.5);
      expect(dto.items.single.dealSaving, 4.0);
      expect(dto.items.single.appliedDealId, 8);
      final spend = dto.spendDeal!;
      expect(spend.spendThreshold, 100.0);
      expect(spend.eligibleSubtotal, 65.5);
      expect(spend.remaining, 34.5);
      expect(spend.unlocked, isFalse);
    });

    test('a free gift line costs nothing and shows what it was worth', () {
      final line = CartLineItem.fromServer(
        CartItemDto.fromJson(
          _cartLine(3, extra: {'dealSaving': 20, 'appliedDealId': 9}),
        ),
      );
      expect(line.isFreeGift, isTrue);
      expect(line.lineTotalAfterDeals, 0);
      expect(line.struckLineTotal, 20);

      final partial = CartLineItem.fromServer(
        CartItemDto.fromJson(_cartLine(4, extra: {'dealSaving': 5})),
      );
      expect(partial.isFreeGift, isFalse);
      expect(partial.lineTotalAfterDeals, 15);

      final plain = CartLineItem.fromServer(CartItemDto.fromJson(_cartLine(5)));
      expect(plain.struckLineTotal, isNull);
      expect(plain.lineTotalAfterDeals, 20);
    });
  });
}
