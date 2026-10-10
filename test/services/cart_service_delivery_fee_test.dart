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

/// The delivery fee decides what the customer is charged, and it once shipped
/// with the cart and the checkout screen each fetching it separately and
/// disagreeing. These cover the pricing surface itself: what is asked of the
/// backend, when it is asked, and what the total does with the answer.

const ApiFailure _failure = (message: 'nope', error: 'nope');

CartItemDto _item({
  int id = 1,
  double unitPrice = 100.0,
  int quantity = 1,
}) => CartItemDto(
  id: id,
  itemId: id,
  itemTitle: 'Trendy Polo Shirts',
  itemColorId: 1,
  colorName: 'Navy',
  itemSizeId: id,
  sizeName: 'M',
  unitPrice: unitPrice,
  quantity: quantity,
  lineTotal: unitPrice * quantity,
  stock: 10,
  isAvailable: true,
);

class _FakeCartApi extends CartApi {
  _FakeCartApi() : super(Dio());

  List<CartItemDto> items = [];

  @override
  Future<Either<ApiFailure, CartResponseDto>> getCart() async => Right(
    CartResponseDto(
      itemCount: items.length,
      subtotal: items.fold(0.0, (s, i) => s + i.lineTotal),
      items: items,
    ),
  );

  @override
  Future<Either<ApiFailure, String>> clearCart() async {
    items = [];
    return const Right('');
  }
}

class _FakeOrdersApi extends OrdersApi {
  _FakeOrdersApi() : super(Dio());

  double fee = 3.0;
  bool shouldFail = false;
  int calls = 0;
  double? lastCartTotal;
  int? lastAddressId;

  @override
  Future<Either<ApiFailure, double>> getDeliveryFee({
    required int addressId,
    required double cartTotal,
  }) async {
    calls++;
    lastCartTotal = cartTotal;
    lastAddressId = addressId;
    return shouldFail ? const Left(_failure) : Right(fee);
  }

  /// What the backend says a coupon is worth; tests change it to model the
  /// backend accepting, refusing, or failing.
  Either<ApiFailure, CouponPreview> coupon =
      const Right((isApplicable: true, discountAmount: 20.0, reason: null));
  String? lastCouponCode;
  int? lastCouponAddressId;

  @override
  Future<Either<ApiFailure, CouponPreview>> getCouponPreview({
    required String couponCode,
    required int addressId,
  }) async {
    lastCouponCode = couponCode;
    lastCouponAddressId = addressId;
    return coupon;
  }
}

class _FakeAddressService extends AddressService {
  _FakeAddressService() : super(AddressApi(Dio()));

  int? selected = 7;
  int loadCalls = 0;

  @override
  int? get selectedId => selected;

  @override
  Future<void> loadFromServer() async => loadCalls++;
}

void main() {
  late _FakeCartApi cartApi;
  late _FakeOrdersApi ordersApi;
  late _FakeAddressService addresses;
  late CartService cart;

  setUp(() {
    cartApi = _FakeCartApi();
    ordersApi = _FakeOrdersApi();
    addresses = _FakeAddressService();
    GetIt.instance.registerSingleton<OrdersApi>(ordersApi);
    GetIt.instance.registerSingleton<AddressService>(addresses);
    cart = CartService(cartApi);
  });

  tearDown(() => GetIt.instance.reset());

  Future<void> fill(List<CartItemDto> items) async {
    cartApi.items = items;
    await cart.loadFromServer();
  }

  group('what is asked of the backend', () {
    test('prices the current subtotal against the selected address', () async {
      await fill([_item(unitPrice: 40.0, quantity: 3)]);
      await cart.refreshDeliveryFee();

      expect(ordersApi.lastCartTotal, 120.0);
      expect(ordersApi.lastAddressId, 7);
    });

    test('loads the addresses first when none are held yet', () async {
      await fill([_item()]);
      await cart.refreshDeliveryFee();

      expect(addresses.loadCalls, 1);
    });

    test('does not call the backend with no address to deliver to', () async {
      addresses.selected = null;
      await fill([_item()]);
      await cart.refreshDeliveryFee();

      expect(ordersApi.calls, 0);
    });
  });

  group('when it prices again', () {
    test('no-ops while the subtotal it last priced is still current', () async {
      await fill([_item()]);
      await cart.refreshDeliveryFee();
      await cart.refreshDeliveryFee();

      expect(ordersApi.calls, 1);
    });

    test('prices again when the subtotal moves', () async {
      await fill([_item(quantity: 1)]);
      await cart.refreshDeliveryFee();
      await fill([_item(quantity: 2)]);
      await cart.refreshDeliveryFee();

      expect(ordersApi.calls, 2);
      expect(ordersApi.lastCartTotal, 200.0);
    });

    test('force prices again on an unchanged subtotal', () async {
      await fill([_item()]);
      await cart.refreshDeliveryFee();
      await cart.refreshDeliveryFee(force: true);

      expect(ordersApi.calls, 2);
    });

    test('a failed lookup does not stick, so the cart prices again', () async {
      await fill([_item()]);
      ordersApi.shouldFail = true;
      await cart.refreshDeliveryFee();
      ordersApi.shouldFail = false;
      await cart.refreshDeliveryFee();

      expect(ordersApi.calls, 2);
      expect(cart.deliveryFee, 3.0);
    });
  });

  group('an empty cart', () {
    test('costs nothing to deliver and asks nobody', () async {
      await fill([]);
      await cart.refreshDeliveryFee();

      expect(ordersApi.calls, 0);
      expect(cart.shippingCost, 0.0);
      expect(cart.total, 0.0);
    });

    test('drops a fee it was carrying when the last line goes', () async {
      await fill([_item()]);
      await cart.refreshDeliveryFee();
      expect(cart.shippingCost, 3.0);

      await fill([]);
      await cart.refreshDeliveryFee();

      expect(cart.shippingCost, 0.0);
    });
  });

  group('what the customer is charged', () {
    test('total is subtotal plus the fee the backend quoted', () async {
      ordersApi.fee = 3.0;
      await fill([_item(unitPrice: 242.97)]);
      await cart.refreshDeliveryFee();

      expect(cart.subtotal, 242.97);
      expect(cart.total, closeTo(245.97, 0.001));
    });

    test('a free delivery quote leaves the total at the subtotal', () async {
      ordersApi.fee = 0.0;
      await fill([_item(unitPrice: 323.96)]);
      await cart.refreshDeliveryFee();

      expect(cart.total, closeTo(323.96, 0.001));
    });

    test('shipping reads zero until the first quote lands', () async {
      await fill([_item(unitPrice: 50.0)]);

      expect(cart.deliveryFee, isNull);
      expect(cart.shippingCost, 0.0);
      expect(cart.total, 50.0);
    });

    test('the backend-quoted coupon discount comes off the total', () async {
      ordersApi.fee = 3.0;
      await fill([_item(unitPrice: 100.0)]);
      await cart.refreshDeliveryFee();
      await cart.applyPromo('save20');

      // 100 less the 20.00 the backend quoted, plus the 3.00 fee.
      expect(cart.total, closeTo(83.0, 0.001));
    });

    test('never goes negative when the discount covers the cart', () async {
      ordersApi.fee = 0.0;
      ordersApi.coupon =
          const Right((isApplicable: true, discountAmount: 50.0, reason: null));
      await fill([_item(unitPrice: 10.0)]);
      await cart.refreshDeliveryFee();
      await cart.applyPromo('SAVE50');

      expect(cart.total, 0.0);
    });
  });

  group('promo codes', () {
    test('are priced by the backend for the selected address, upper-cased', () async {
      await fill([_item()]);
      final rejection = await cart.applyPromo(' save20 ');

      expect(rejection, isNull);
      expect(ordersApi.lastCouponCode, 'SAVE20');
      expect(ordersApi.lastCouponAddressId, 7);
      expect(cart.promoCode, 'SAVE20');
      expect(cart.promoDiscount, 20.0);
    });

    test('a refused code is not applied and carries the backend reason', () async {
      ordersApi.coupon =
          const Right((isApplicable: false, discountAmount: 0.0, reason: 'Coupon expired'));
      await fill([_item()]);
      final rejection = await cart.applyPromo('OLD');

      expect(rejection, isA<PromoRejectedByBackend>());
      expect((rejection! as PromoRejectedByBackend).message, 'Coupon expired');
      expect(cart.hasPromo, isFalse);
      expect(cart.promoDiscount, 0.0);
    });

    test('a failed request is not applied and carries its message', () async {
      ordersApi.coupon = const Left((message: 'Coupon not found', error: 'x'));
      await fill([_item()]);
      final rejection = await cart.applyPromo('NOPE');

      expect((rejection! as PromoRejectedByBackend).message, 'Coupon not found');
      expect(cart.hasPromo, isFalse);
    });

    test('needs an address before it can be priced', () async {
      addresses.selected = null;
      await fill([_item()]);
      final rejection = await cart.applyPromo('SAVE20');

      expect(rejection, isA<PromoNeedsAddress>());
      expect(ordersApi.lastCouponCode, isNull);
    });

    test('is dropped when the cart changes and the backend no longer accepts it', () async {
      await fill([_item(unitPrice: 100.0)]);
      await cart.refreshDeliveryFee();
      await cart.applyPromo('SAVE20');
      expect(cart.hasPromo, isTrue);

      ordersApi.coupon =
          const Right((isApplicable: false, discountAmount: 0.0, reason: 'Minimum not met'));
      await fill([_item(unitPrice: 30.0)]);
      await cart.refreshDeliveryFee();

      expect(cart.hasPromo, isFalse);
      expect(cart.total, closeTo(33.0, 0.001));
    });

    test('is cleared with the cart', () async {
      await fill([_item()]);
      await cart.applyPromo('SAVE20');
      cartApi.items = [];
      await cart.clearCart();

      expect(cart.hasPromo, isFalse);
      expect(cart.promoDiscount, 0.0);
    });
  });

  group('loading state', () {
    test('is false once the quote has landed', () async {
      await fill([_item()]);
      await cart.refreshDeliveryFee();

      expect(cart.isLoadingDeliveryFee, isFalse);
    });

    test('is false again after a failed quote', () async {
      ordersApi.shouldFail = true;
      await fill([_item()]);
      await cart.refreshDeliveryFee();

      expect(cart.isLoadingDeliveryFee, isFalse);
    });
  });
}
