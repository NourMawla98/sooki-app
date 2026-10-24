import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../backend_integration/apis/cart_api.dart';
import '../backend_integration/apis/orders_api.dart';
import '../backend_integration/dtos/cart/cart_dto.dart';
import 'address_service.dart';

/// Why a promo code was not applied: the backend's own reason when it gave
/// one, or that the shopper has no delivery address to price it against.
sealed class PromoRejection {
  const PromoRejection();
}

class PromoRejectedByBackend extends PromoRejection {
  final String? message;
  const PromoRejectedByBackend(this.message);
}

class PromoNeedsAddress extends PromoRejection {
  const PromoNeedsAddress();
}

class CartService extends ChangeNotifier {
  final CartApi _cartApi;

  List<CartItemDto> _items = [];
  String? _promoCode;
  double _promoDiscount = 0.0;
  double? _deliveryFee;
  double? _feeSubtotal;
  bool _loadingDeliveryFee = false;

  CartService(this._cartApi);

  // --- Public data ----------------------------------------------------------

  List<CartLineItem> get displayItems =>
      _items.map(CartLineItem.fromServer).toList();

  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (s, i) => s + i.quantity);
  double get subtotal => _items.fold(0.0, (s, i) => s + i.lineTotal);
  /// What the backend charges to deliver the current cart to the selected
  /// address. Null until the first fetch lands, which is why the summaries
  /// show a placeholder rather than a number while it is loading.
  double? get deliveryFee => _deliveryFee;
  bool get isLoadingDeliveryFee => _loadingDeliveryFee;
  double get shippingCost => isEmpty ? 0.0 : (_deliveryFee ?? 0.0);
  String? get promoCode => _promoCode;
  bool get hasPromo => _promoCode != null;

  /// The discount the backend quoted for [promoCode] on this cart and address.
  double get promoDiscount => _promoCode == null ? 0.0 : _promoDiscount;

  double get total {
    final raw = subtotal + shippingCost - promoDiscount;
    return raw < 0 ? 0 : raw;
  }

  /// Ask the backend what delivery costs for the selected address and the
  /// current subtotal. The fee moves with the subtotal because delivery is
  /// free above a threshold, so this reruns whenever the cart changes and
  /// no-ops when the subtotal it last priced is still current.
  ///
  /// Pass [force] to price again even when the subtotal has not moved. A pull
  /// to refresh has to reach the network, and the fee can change under a
  /// steady subtotal when the selected address or the threshold changes.
  Future<void> refreshDeliveryFee({bool force = false}) async {
    if (isEmpty) {
      if (_feeSubtotal == 0.0 && _deliveryFee == 0.0) return;
      _deliveryFee = 0.0;
      _feeSubtotal = 0.0;
      _loadingDeliveryFee = false;
      notifyListeners();
      return;
    }

    if (!force && _feeSubtotal == subtotal) return;

    final addressService = GetIt.instance<AddressService>();
    if (addressService.addresses.isEmpty) {
      await addressService.loadFromServer();
    }
    final addressId = addressService.selectedId;
    if (addressId == null) return;

    final pricedSubtotal = subtotal;
    _feeSubtotal = pricedSubtotal;
    _loadingDeliveryFee = true;
    notifyListeners();

    final result = await GetIt.instance<OrdersApi>()
        .getDeliveryFee(addressId: addressId, cartTotal: pricedSubtotal);

    _loadingDeliveryFee = false;
    result.fold(
      // A failed lookup must not stick, or the cart never prices again.
      (_) => _feeSubtotal = null,
      (fee) => _deliveryFee = fee,
    );
    notifyListeners();
    // A coupon's value can move with the subtotal and the delivery fee.
    await _repricePromo();
  }

  bool isInCart(int itemSizeId) =>
      _items.any((i) => i.itemSizeId == itemSizeId);

  // --- Server sync ----------------------------------------------------------

  Future<void> loadFromServer() async {
    final result = await _cartApi.getCart();
    result.fold((_) {}, (dto) {
      _items = dto.items;
      notifyListeners();
    });
  }

  /// Forgets the cart held for the previous identity, before the next one's
  /// cart is fetched.
  void reset() {
    _items = [];
    _promoCode = null;
    _promoDiscount = 0.0;
    _deliveryFee = null;
    _feeSubtotal = null;
    _loadingDeliveryFee = false;
    notifyListeners();
  }

  // --- Mutations ------------------------------------------------------------

  Future<String?> addToCart({
    required int? itemSizeId,
    required int itemId,
    required String itemTitle,
    String? mainImageUrl,
    required String colorName,
    required String sizeName,
    required double unitPrice,
    int quantity = 1,
  }) async {
    final result = await _cartApi.addToCart(itemSizeId, quantity);
    return result.fold((_) => null, (message) async {
      await loadFromServer();
      return message.isNotEmpty ? message : null;
    });
  }

  Future<String?> removeItem(String id) async {
    final cartItemId = int.tryParse(id);
    if (cartItemId == null) return null;
    final result = await _cartApi.removeItem(cartItemId);
    await loadFromServer();
    return result.fold((_) => null, (m) => m.isNotEmpty ? m : null);
  }

  Future<void> updateQuantity(String id, int newQty) async {
    final cartItemId = int.tryParse(id);
    if (cartItemId == null) return;
    if (newQty <= 0) {
      await removeItem(id);
    } else {
      await _cartApi.updateQuantity(cartItemId, newQty);
      await loadFromServer();
    }
  }

  Future<void> clearCart() async {
    await _cartApi.clearCart();
    _items = [];
    _promoCode = null;
    _promoDiscount = 0.0;
    notifyListeners();
  }

  /// Asks the backend what [code] is worth on this cart for the selected
  /// address. Returns null once applied, or why it was not.
  Future<PromoRejection?> applyPromo(String code) async {
    final normalized = code.trim().toUpperCase();
    final addressId = GetIt.instance<AddressService>().selectedId;
    if (addressId == null) return const PromoNeedsAddress();

    final result = await GetIt.instance<OrdersApi>()
        .getCouponPreview(couponCode: normalized, addressId: addressId);
    return result.fold(
      (failure) => PromoRejectedByBackend(failure.message),
      (preview) {
        if (!preview.isApplicable) return PromoRejectedByBackend(preview.reason);
        _promoCode = normalized;
        _promoDiscount = preview.discountAmount;
        notifyListeners();
        return null;
      },
    );
  }

  void removePromo() {
    _promoCode = null;
    _promoDiscount = 0.0;
    notifyListeners();
  }

  /// Prices the applied code again after the cart or address changed, and
  /// drops it when it no longer applies, so the totals never show a discount
  /// the backend would refuse at checkout.
  Future<void> _repricePromo() async {
    final code = _promoCode;
    if (code == null) return;
    final rejection = await applyPromo(code);
    if (rejection != null && _promoCode == code) removePromo();
  }
}
