import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  final ColorVariant? selectedColor;
  final SizeVariant? selectedSize;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedColor,
    this.selectedSize,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
    'selectedColor': selectedColor?.toJson(),
    'selectedSize': selectedSize?.toJson(),
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    product: Product.fromJson(json['product'] as Map<String, dynamic>),
    quantity: json['quantity'] as int,
    selectedColor: json['selectedColor'] != null
        ? ColorVariant.fromJson(json['selectedColor'] as Map<String, dynamic>)
        : null,
    selectedSize: json['selectedSize'] != null
        ? SizeVariant.fromJson(json['selectedSize'] as Map<String, dynamic>)
        : null,
  );
}

class CartService extends ChangeNotifier {
  static const String _storageKey = 'sooki_cart';

  final SharedPreferences _prefs;
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  CartService(this._prefs) {
    _loadFromStorage();
  }

  void addItem(Product product, {ColorVariant? color, SizeVariant? size, int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id
          && item.selectedColor?.name == color?.name
          && item.selectedSize?.label == size?.label,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        quantity: quantity,
        selectedColor: color,
        selectedSize: size,
      ));
    }
    _persistToStorage();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _persistToStorage();
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    if (newQuantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = newQuantity;
    }
    _persistToStorage();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _persistToStorage();
    notifyListeners();
  }

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shippingCost => subtotal > 50.0 ? 0.0 : 5.99;

  double get total => subtotal + shippingCost;

  bool isInCart(String productId) => _items.any((item) => item.product.id == productId);

  void _persistToStorage() {
    final jsonList = _items.map((item) => item.toJson()).toList();
    _prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  void _loadFromStorage() {
    final stored = _prefs.getString(_storageKey);
    if (stored == null) return;

    try {
      final jsonList = jsonDecode(stored) as List<dynamic>;
      _items.addAll(jsonList.map(
        (json) => CartItem.fromJson(json as Map<String, dynamic>),
      ));
    } catch (e) {
      _prefs.remove(_storageKey);
    }
  }

  /// Stub for future API integration.
  Future<void> syncToServer() async {
    // TODO: Send _items to backend merge endpoint
  }
}
