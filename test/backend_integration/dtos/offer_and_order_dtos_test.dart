import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/backend_integration/dtos/deal/item_offer_dto.dart';
import 'package:sooki_app/backend_integration/dtos/item/item_list_item_dto.dart';
import 'package:sooki_app/backend_integration/dtos/order/order_detail_dto.dart';
import 'package:sooki_app/backend_integration/dtos/order/order_item_dto.dart';
import 'package:sooki_app/backend_integration/dtos/order/order_list_item_dto.dart';
import 'package:sooki_app/enums/deal_type.dart';
import 'package:sooki_app/models/deal_offer.dart';
import 'package:sooki_app/models/deal_progress.dart';

/// Item offers and order deal fields are new; every one of them has to parse
/// when the backend leaves it out as well as when it sends it.

Map<String, dynamic> _card({List<Map<String, dynamic>>? offers}) => {
  'id': 1,
  'title': 'Gummies',
  'originalPrice': 22.0,
  'categoryName': 'Beauty',
  'offers': ?offers,
};

Map<String, dynamic> _orderLine({Map<String, dynamic> extra = const {}}) => {
  'id': 1,
  'itemId': 5,
  'status': 1,
  'quantity': 2,
  'unitPrice': 10.0,
  'totalPrice': 20.0,
  'itemTitle': 'Cream',
  'colorName': 'White',
  'sizeName': '200ml',
  ...extra,
};

Map<String, dynamic> _order({Map<String, dynamic> extra = const {}}) => {
  'id': 3,
  'trackingNumber': 'SK-1',
  'status': 1,
  'customerName': 'A',
  'city': 'Beirut',
  'subtotal': 100.0,
  'discountAmount': 0.0,
  'deliveryFee': 5.0,
  'totalAmount': 85.0,
  'createdAt': '2026-11-16T10:00:00Z',
  'items': [_orderLine()],
  ...extra,
};

void main() {
  group('item offers', () {
    test('a card parses with no store name, and ignores one if sent', () {
      final bare = ItemListItemDto.fromJson(_card());
      expect(bare.title, 'Gummies');
      final legacy = ItemListItemDto.fromJson({..._card(), 'storeName': ''});
      expect(legacy.id, 1);
    });

    test('a card without offers parses with none', () {
      expect(ItemListItemDto.fromJson(_card()).offers, isEmpty);
    });

    test('a card reads each offer and its fields', () {
      final dto = ItemListItemDto.fromJson(
        _card(offers: [
          {
            'dealId': 4,
            'type': 3,
            'title': 'Gummies multi-buy',
            'discountPercent': 20,
            'minQuantity': 3,
            'bundlePrice': null,
            'originalTotal': null,
            'role': 1,
            'expiresAt': '2026-12-01T00:00:00',
          },
          {'dealId': 5, 'type': 4, 'role': 2},
        ]),
      );

      final multi = dto.offers.first;
      expect(multi.dealType, DealType.multiBuy);
      expect(multi.minQuantity, 3);
      expect(multi.discountPercent, 20.0);
      expect(multi.expiresAt, DateTime.utc(2026, 12, 1));
      final gift = dto.offers.last;
      expect(gift.dealType, DealType.freeGift);
      expect(gift.lineRole, DealLineRole.free);
      expect(gift.title, '');
      expect(gift.expiresAt, isNull);
    });

    test('an offer opens the Deals tab on its own type', () {
      expect(offerFilter(const ItemOfferDto(dealId: 1, type: 2)), DealFilter.bundle);
      expect(offerFilter(const ItemOfferDto(dealId: 1, type: 3)), DealFilter.multiBuy);
      expect(offerFilter(const ItemOfferDto(dealId: 1, type: 4)), DealFilter.freeGift);
    });

    test('badges keep live card types, soonest ending first', () {
      final offers = badgeOffers([
        ItemOfferDto(dealId: 1, type: 2, expiresAt: DateTime.utc(2099, 2)),
        const ItemOfferDto(dealId: 2, type: 3),
        ItemOfferDto(dealId: 3, type: 4, expiresAt: DateTime.utc(2099, 1)),
        ItemOfferDto(dealId: 4, type: 2, expiresAt: DateTime.utc(2000)),
        const ItemOfferDto(dealId: 5, type: 5),
      ]);
      expect(offers.map((o) => o.dealId), [3, 1, 2]);
    });
  });

  group('order deals', () {
    test('an old order line parses with no deal', () {
      final line = OrderItemDto.fromJson(_orderLine());
      expect(line.dealId, isNull);
      expect(line.dealType, isNull);
      expect(line.dealDiscount, 0);
      expect(line.cartDealDiscount, 0);
      expect(line.hasDeal, isFalse);
      expect(line.labelDealType, isNull);
      expect(line.totalBeforeDeals, isNull);
    });

    test('a deal line reads its deal and adds both savings', () {
      final line = OrderItemDto.fromJson(_orderLine(extra: {
        'dealId': 8,
        'dealType': 2,
        'snapshotDealPrice': 9.5,
        'dealDiscount': 4,
        'cartDealId': 10,
        'cartDealDiscount': 1.5,
      }));
      expect(line.dealType, 2);
      expect(line.snapshotDealPrice, 9.5);
      expect(line.totalDealSaving, 5.5);
      // totalPrice is after both discounts, so the struck price adds them back.
      expect(line.totalPrice, 20.0);
      expect(line.totalBeforeDeals, 25.5);
      expect(line.hasDeal, isTrue);
      expect(line.labelDealType, 2);
      expect(orderDealLabelKey(line.labelDealType), 'order_detail_screen.deal.bundle');
    });

    test('a line lists its own deal saving and its spend share apart', () {
      final line = OrderItemDto.fromJson(_orderLine(extra: {
        'dealId': 8,
        'dealType': 3,
        'dealDiscount': 4,
        'cartDealId': 10,
        'cartDealDiscount': 1.5,
      }));
      final notes = orderLineDealNotes(line);
      expect(notes.map((n) => n.labelKey), [
        'order_detail_screen.deal.multi',
        'order_detail_screen.deal.spend',
      ]);
      expect(notes.map((n) => n.amount), [4.0, 1.5]);
      expect(orderLineDealNotes(OrderItemDto.fromJson(_orderLine())), isEmpty);
    });

    test('the backend line discount and fixed price saving win over math',
        () {
      // Fully at the deal price: unitPrice already has the deal in it, so
      // only the backend knows the normal price.
      final line = OrderItemDto.fromJson(_orderLine(extra: {
        'dealId': 3,
        'dealType': 1,
        'unitPrice': 8.395,
        'totalPrice': 16.79,
        'singleItemSaving': 7.2,
        'totalLineDiscount': 7.2,
      }));
      expect(line.totalBeforeDeals, closeTo(23.99, 1e-9));
      expect(orderLineDealNotes(line).single.amount, 7.2);

      final none = OrderItemDto.fromJson(_orderLine(extra: {
        'totalLineDiscount': 0,
      }));
      expect(none.totalBeforeDeals, isNull);
    });

    test('order dates are read as UTC', () {
      final detail = OrderDetailDto.fromJson(_order(extra: {
        'createdAt': '2026-11-16T23:30:00',
      }));
      expect(detail.createdAt.isUtc, isTrue);
      expect(detail.createdAt, DateTime.utc(2026, 11, 16, 23, 30));
    });

    test('a partly fixed price line notes its own saving and strikes it',
        () {
      final line = OrderItemDto.fromJson(_orderLine(extra: {
        'dealId': 3,
        'dealType': 1,
        'singleDealDiscount': 2.5,
        'totalPrice': 17.5,
      }));
      expect(line.totalBeforeDeals, 20);
      final notes = orderLineDealNotes(line);
      expect(notes.map((n) => n.labelKey), ['order_detail_screen.deal.price']);
      expect(notes.single.amount, 2.5);
    });

    test('a line only in a spend deal is labelled as spend and save', () {
      final line = OrderItemDto.fromJson(
        _orderLine(extra: {'cartDealId': 10, 'cartDealDiscount': 2}),
      );
      expect(line.labelDealType, 5);
      expect(orderDealLabelKey(line.labelDealType), 'order_detail_screen.deal.spend');
      expect(orderDealLabelKey(1), 'order_detail_screen.deal.price');
    });

    test('the order subtotal shown above deal savings adds up', () {
      final sent = OrderDetailDto.fromJson(_order(extra: {
        'subtotalBeforeDeals': 120.0,
        'totalDealDiscount': 20.0,
      }));
      expect(sent.displaySubtotal, 120);

      // Without the backend figure the savings are put back on the subtotal.
      final derived = OrderDetailDto.fromJson(
        _order(extra: {'totalDealDiscount': 15.0}),
      );
      expect(derived.subtotalBeforeDeals, isNull);
      expect(derived.displaySubtotal, 115);
      expect(
        derived.displaySubtotal -
            derived.totalDealDiscount +
            derived.deliveryFee -
            derived.discountAmount,
        105,
      );
    });

    test('orders read their total deal discount, zero when absent', () {
      expect(OrderDetailDto.fromJson(_order()).totalDealDiscount, 0);
      expect(
        OrderDetailDto.fromJson(_order(extra: {'totalDealDiscount': 12.5}))
            .totalDealDiscount,
        12.5,
      );
      final listItem = OrderListItemDto.fromJson({
        'id': 3,
        'trackingNumber': 'SK-1',
        'status': 1,
        'totalAmount': 85.0,
        'createdAt': '2026-11-16T10:00:00Z',
        'totalDealDiscount': 7,
      });
      expect(listItem.totalDealDiscount, 7.0);
    });
  });
}
