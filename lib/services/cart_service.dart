import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../backend_integration/apis/cart_api.dart';
import '../backend_integration/apis/orders_api.dart';
import '../backend_integration/dtos/cart/cart_dto.dart';
import 'address_service.dart';

class CartService extends ChangeNotifier {
  static const Map<String, double> _promoCatalog = {'AURORA20': 0.20};

  final CartApi _cartApi;

  List<CartItemDto> _items = [];
  String? _promoCode;
  double? _deliveryFee;
  double? _feeSubtotal;
  bool _loadingDeliveryFee = false;

  CartService(this._cartApi);

  // ─── Public data ──────────────────────────────────────────────────────────

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

  double get promoDiscount {
    final pct = _promoCatalog[_promoCode];
    if (pct == null) return 0.0;
    return subtotal * pct;
  }

  double get total {
    final raw = subtotal + shippingCost - promoDiscount;
    return raw < 0 ? 0 : raw;
  }

  /// Ask the backend what delivery costs for the selected address and the
  /// current subtotal. The fee moves with the subtotal because delivery is
  /// free above a threshold, so this reruns whenever the cart changes and
  /// no-ops when the subtotal it last priced is still current.
  Future<void> refreshDeliveryFee() async {
    if (isEmpty) {
      if (_feeSubtotal == 0.0 && _deliveryFee == 0.0) return;
      _deliveryFee = 0.0;
      _feeSubtotal = 0.0;
      _loadingDeliveryFee = false;
      notifyListeners();
      return;
    }

    if (_feeSubtotal == subtotal) return;

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
  }

  bool isInCart(int itemSizeId) =>
      _items.any((i) => i.itemSizeId == itemSizeId);

  // ─── Server sync ──────────────────────────────────────────────────────────

  Future<void> loadFromServer() async {
    final result = await _cartApi.getCart();
    result.fold((_) {}, (dto) {
      _items = dto.items;
      notifyListeners();
    });
  }

  // ─── Mutations ────────────────────────────────────────────────────────────

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
    notifyListeners();
  }

  bool applyPromo(String code) {
    final normalized = code.trim().toUpperCase();
    if (!_promoCatalog.containsKey(normalized)) return false;
    _promoCode = normalized;
    notifyListeners();
    return true;
  }

  void removePromo() {
    _promoCode = null;
    notifyListeners();
  }
}
