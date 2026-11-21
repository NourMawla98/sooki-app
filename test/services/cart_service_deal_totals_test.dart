import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:sooki_app/backend_integration/apis/address_api.dart';
import 'package:sooki_app/backend_integration/apis/cart_api.dart';
import 'package:sooki_app/backend_integration/apis/orders_api.dart';
import 'package:sooki_app/backend_integration/dio/client/request_executor.dart';
import 'package:sooki_app/backend_integration/dtos/cart/cart_dto.dart';
import 'package:sooki_app/services/address_service.dart';
import 'package:sooki_app/services/cart_service.dart';

/// Bundle, multi-buy, free gift and spend deals come off the cart as one
/// backend figure, dealDiscount. These pin that the cart's total takes it off
/// and that the subtotal is the backend's own figure.

CartItemDto _item({
  int id = 1,
  double unitPrice = 50.0,
  int quantity = 1,
  double dealSaving = 0,
}) => CartItemDto(
  id: id,
  itemId: id,
  itemTitle: 'Item $id',
  itemColorId: 1,
  colorName: 'Navy',
  itemSizeId: id,
  sizeName: 'M',
  unitPrice: unitPrice,
  quantity: quantity,
  lineTotal: unitPrice * quantity,
  stock: 10,
  isAvailable: true,
  dealSaving: dealSaving,
);

class _FakeCartApi extends CartApi {
  _FakeCartApi() : super(Dio());

  CartResponseDto response = const CartResponseDto(itemCount: 0, subtotal: 0);

  @override
  Future<Either<ApiFailure, CartResponseDto>> getCart() async =>
      Right(response);

  @override
  Future<Either<ApiFailure, String>> clearCart() async => const Right('');
}

class _FakeOrdersApi extends OrdersApi {
  _FakeOrdersApi() : super(Dio());

  double? lastCartTotal;

  /// What the coupon preview returns; tests swap in a fully priced one.
  CouponPreview coupon = (
    isApplicable: true,
    discountAmount: 10.0,
    reason: null,
    subtotal: null,
    deliveryFee: null,
    total: null,
  );

  @override
  Future<Either<ApiFailure, double>> getDeliveryFee({
    required int addressId,
    required double cartTotal,
  }) async {
    lastCartTotal = cartTotal;
    return const Right(5.0);
  }

  @override
  Future<Either<ApiFailure, CouponPreview>> getCouponPreview({
    required String couponCode,
    required int addressId,
  }) async => Right(coupon);
}

class _FakeAddressService extends AddressService {
  _FakeAddressService() : super(AddressApi(Dio()));

  @override
  int? get selectedId => 7;

  @override
  Future<void> loadFromServer() async {}
}

void main() {
  late _FakeCartApi cartApi;
  late _FakeOrdersApi ordersApi;
  late CartService cart;

  setUp(() {
    cartApi = _FakeCartApi();
    ordersApi = _FakeOrdersApi();
    GetIt.instance.registerSingleton<OrdersApi>(ordersApi);
    GetIt.instance.registerSingleton<AddressService>(_FakeAddressService());
    cart = CartService(cartApi);
  });

  tearDown(() => GetIt.instance.reset());

  test('an old cart without deal fields totals as before', () async {
    cartApi.response = CartResponseDto(
      itemCount: 2,
      subtotal: 100,
      items: [_item(quantity: 2)],
    );
    await cart.loadFromServer();

    expect(cart.dealDiscount, 0);
    expect(cart.appliedDeals, isEmpty);
    expect(cart.subtotal, 100);
    expect(cart.total, 100);
  });

  test('the total takes the deal discount off the subtotal', () async {
    cartApi.response = CartResponseDto(
      itemCount: 3,
      subtotal: 150,
      items: [
        _item(id: 1, quantity: 2, dealSaving: 10),
        _item(id: 2, dealSaving: 50),
      ],
      dealDiscount: 60,
      appliedDeals: const [
        AppliedDealDto(dealId: 1, type: 3, title: 'Buy 2', saving: 10),
        AppliedDealDto(dealId: 2, type: 4, title: 'Free gift', saving: 50),
      ],
    );
    await cart.loadFromServer();

    expect(cart.subtotal, 150);
    expect(cart.total, 90);
    expect(cart.appliedDeals.map((d) => d.saving), [10, 50]);
    expect(cart.displayItems.last.isFreeGift, isTrue);
    expect(cart.displayItems.first.lineTotalAfterDeals, 90);
  });

  test('deals, delivery and a coupon all count toward the total', () async {
    cartApi.response = CartResponseDto(
      itemCount: 2,
      subtotal: 100,
      items: [_item(quantity: 2)],
      dealDiscount: 20,
    );
    await cart.loadFromServer();
    await cart.refreshDeliveryFee();
    await cart.applyPromo('save10');

    // 100 - 20 deals + 5 delivery - 10 coupon.
    expect(cart.total, 75);
  });

  test('the subtotal is the backend figure, not a recount of the lines',
      () async {
    cartApi.response = CartResponseDto(
      itemCount: 1,
      subtotal: 42,
      items: [_item()],
    );
    await cart.loadFromServer();

    expect(cart.subtotal, 42);
  });

  test('the total never goes below zero', () async {
    cartApi.response = CartResponseDto(
      itemCount: 1,
      subtotal: 30,
      items: [_item(unitPrice: 30)],
      dealDiscount: 40,
    );
    await cart.loadFromServer();

    expect(cart.total, 0);
  });

  test('clearing the cart drops the deal discount', () async {
    cartApi.response = CartResponseDto(
      itemCount: 1,
      subtotal: 50,
      items: [_item()],
      dealDiscount: 10,
    );
    await cart.loadFromServer();
    await cart.clearCart();

    expect(cart.dealDiscount, 0);
    expect(cart.subtotal, 0);
    expect(cart.total, 0);
  });

  test('the backend total after deals wins over a recount', () async {
    cartApi.response = CartResponseDto(
      itemCount: 2,
      subtotal: 100,
      total: 78,
      items: [_item(quantity: 2)],
      dealDiscount: 20,
    );
    await cart.loadFromServer();

    expect(cart.totalAfterDeals, 78);
    expect(cart.total, 78);
  });

  test('delivery is priced on the cart after deals, not the subtotal',
      () async {
    cartApi.response = CartResponseDto(
      itemCount: 2,
      subtotal: 100,
      total: 80,
      items: [_item(quantity: 2)],
      dealDiscount: 20,
    );
    await cart.loadFromServer();
    await cart.refreshDeliveryFee();

    expect(ordersApi.lastCartTotal, 80);
    expect(cart.total, 85);
  });

  test('a coupon preview that prices the order sets fee and total', () async {
    cartApi.response = CartResponseDto(
      itemCount: 2,
      subtotal: 100,
      total: 80,
      items: [_item(quantity: 2)],
      dealDiscount: 20,
    );
    ordersApi.coupon = (
      isApplicable: true,
      discountAmount: 8.0,
      reason: null,
      subtotal: 80.0,
      deliveryFee: 0.0,
      total: 72.0,
    );
    await cart.loadFromServer();
    await cart.refreshDeliveryFee();
    await cart.applyPromo('save8');

    expect(cart.deliveryFee, 0);
    expect(cart.shippingCost, 0);
    expect(cart.total, 72);

    cart.removePromo();
    expect(cart.deliveryFee, 5);
    expect(cart.total, 85);
  });

  test('knows which deals the cart applies and which items they took',
      () async {
    cartApi.response = CartResponseDto(
      itemCount: 2,
      subtotal: 100,
      items: [
        _item(id: 1).copyWith(appliedDealId: 8),
        _item(id: 2),
      ],
      appliedDeals: const [AppliedDealDto(dealId: 8, type: 2, saving: 10)],
    );
    await cart.loadFromServer();

    expect(cart.isDealApplied(8), isTrue);
    expect(cart.isDealApplied(9), isFalse);
    expect(cart.isItemTakenByOtherDeal(1, 9), isTrue);
    expect(cart.isItemTakenByOtherDeal(1, 8), isFalse);
    expect(cart.isItemTakenByOtherDeal(2, 9), isFalse);
  });

  test('no spend hint without a live spend deal, or once unlocked', () async {
    cartApi.response = CartResponseDto(
      itemCount: 1,
      subtotal: 50,
      items: [_item()],
    );
    await cart.loadFromServer();
    expect(cart.spendDealHint, isNull);

    cartApi.response = CartResponseDto(
      itemCount: 1,
      subtotal: 120,
      items: [_item(unitPrice: 120)],
      spendDeal: const SpendDealDto(
        dealId: 3,
        spendThreshold: 100,
        discountPercent: 20,
        eligibleSubtotal: 120,
        unlocked: true,
      ),
    );
    await cart.loadFromServer();
    expect(cart.spendDealHint, isNull);
  });

  test('subtotal is before every deal and the rows add up to the discount',
      () async {
    // Item 1: two units, one at a fixed deal price (8 off the line).
    // Item 2: in a bundle that saves 10. Spend deal saves 5.
    cartApi.response = CartResponseDto(
      itemCount: 3,
      subtotal: 150,
      total: 127,
      items: [
        _item(id: 1, quantity: 2).copyWith(
          lineTotal: 92,
          singleDealDiscount: 8,
        ),
        _item(id: 2, dealSaving: 10).copyWith(appliedDealId: 7),
      ],
      dealDiscount: 23,
      singleItemDiscount: 8,
      appliedDeals: const [
        AppliedDealDto(dealId: 3, type: 1, title: 'Weekend', saving: 8),
        AppliedDealDto(dealId: 7, type: 2, title: 'Bundle', saving: 10),
        AppliedDealDto(dealId: 9, type: 5, title: 'Spend', saving: 5),
      ],
    );
    await cart.loadFromServer();

    expect(cart.subtotal, 150);
    expect(cart.totalAfterDeals, 127);
    expect(cart.total, 127);
    final rows = cart.dealSavingRows;
    // The fixed price entry is not counted twice.
    expect(rows.map((r) => r.saving), [8, 10, 5]);
    expect(rows.fold<double>(0, (s, r) => s + r.saving), cart.dealDiscount);
    expect(cart.subtotal - cart.dealDiscount, cart.totalAfterDeals);

    final partial = cart.displayItems.first;
    expect(partial.lineTotal, 92);
    expect(partial.lineTotalAfterDeals, 92);
    expect(partial.struckLineTotal, 100);
    final bundled = cart.displayItems.last;
    expect(bundled.lineTotalAfterDeals, 40);
    expect(bundled.struckLineTotal, 50);
  });

  test('delivery is priced on the total after every deal', () async {
    cartApi.response = CartResponseDto(
      itemCount: 2,
      subtotal: 100,
      total: 70,
      items: [_item(quantity: 2)],
      dealDiscount: 30,
      singleItemDiscount: 10,
    );
    await cart.loadFromServer();
    await cart.refreshDeliveryFee();

    expect(ordersApi.lastCartTotal, 70);
    expect(cart.total, 75);
  });
}
