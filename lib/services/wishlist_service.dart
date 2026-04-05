import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistService extends ChangeNotifier {
  static const String _storageKey = 'sooki_wishlist';

  final SharedPreferences _prefs;
  final Set<String> _productIds = {};

  Set<String> get productIds => Set.unmodifiable(_productIds);

  WishlistService(this._prefs) {
    _loadFromStorage();
  }

  void toggle(String productId) {
    if (_productIds.contains(productId)) {
      _productIds.remove(productId);
    } else {
      _productIds.add(productId);
    }
    _persistToStorage();
    notifyListeners();
  }

  bool isWishlisted(String productId) => _productIds.contains(productId);

  void _persistToStorage() {
    _prefs.setString(_storageKey, jsonEncode(_productIds.toList()));
  }

  void _loadFromStorage() {
    final stored = _prefs.getString(_storageKey);
    if (stored == null) return;

    try {
      final list = jsonDecode(stored) as List<dynamic>;
      _productIds.addAll(list.cast<String>());
    } catch (e) {
      _prefs.remove(_storageKey);
    }
  }

  Future<void> syncToServer() async {
    // TODO: Send _productIds to backend
  }
}
