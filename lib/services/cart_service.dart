import 'package:flutter/foundation.dart';

import '../backend_integration/apis/cart_api.dart';
import '../backend_integration/dtos/cart/cart_dto.dart';

class CartService extends ChangeNotifier {
  static const Map<String, double> _promoCatalog = {
    'AURORA20': 0.20,
  };

  final CartApi _cartApi;

  List<CartItemDto> _items = [];
  String? _promoCode;

  CartService(this._cartApi);

  // ─── Public data ──────────────────────────────────────────────────────────

  List<CartLineItem> get displayItems => _items.map(CartLineItem.fromServer).toList();

  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (s, i) => s + i.quantity);
  double get subtotal => _items.fold(0.0, (s, i) => s + i.lineTotal);
  double get shippingCost => isEmpty ? 0.0 : 5.99;
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

  bool isInCart(int sizeValueId) => _items.any((i) => i.itemSizeId == sizeValueId);

  // ─── Server sync ──────────────────────────────────────────────────────────

  Future<void> loadFromServer() async {
    final result = await _cartApi.getCart();
    result.fold(
      (_) {},
      (dto) {
        _items = dto.items;
        notifyListeners();
      },
    );
  }

  // ─── Mutations ────────────────────────────────────────────────────────────

  Future<String?> addToCart({
    required int? sizeValueId,
    required int itemId,
    required String itemTitle,
    String? mainImageUrl,
    required String colorName,
    required String sizeName,
    required double unitPrice,
    int quantity = 1,
  }) async {
    final result = await _cartApi.addToCart(sizeValueId, quantity);
    return result.fold(
      (_) => null,
      (message) async {
        await loadFromServer();
        return message.isNotEmpty ? message : null;
      },
    );
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
