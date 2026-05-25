import 'dart:async';

import 'package:flutter/foundation.dart';

import '../backend_integration/apis/wishlist_api.dart';
import '../backend_integration/dtos/wishlist/wishlist_item_dto.dart';

class WishlistService extends ChangeNotifier {
  final WishlistApi _api;

  List<WishlistItemDto> _items = [];
  final Set<int> _ids = {};

  WishlistService(this._api);

  List<WishlistItemDto> get items => List.unmodifiable(_items);

  bool isWishlisted(String productId) {
    final id = int.tryParse(productId);
    return id != null && _ids.contains(id);
  }

  Future<String?> toggle(String productId) async {
    final id = int.tryParse(productId);
    if (id == null) return null;
    return _toggleServer(id);
  }

  Future<void> loadFromServer() async {
    await _fetchAndSet();
  }

  // ─── Server toggle (optimistic) ─────────────────────────────────────────────

  Future<String?> _toggleServer(int itemId) async {
    final wasWishlisted = _ids.contains(itemId);
    final prevItems = List<WishlistItemDto>.from(_items);

    if (wasWishlisted) {
      _ids.remove(itemId);
      _items = _items.where((e) => e.itemId != itemId).toList();
    } else {
      _ids.add(itemId);
    }
    notifyListeners();

    final result = wasWishlisted
        ? await _api.removeFromWishlist(itemId)
        : await _api.addToWishlist(itemId);

    return result.fold(
      (_) {
        if (wasWishlisted) {
          _ids.add(itemId);
          _items = prevItems;
        } else {
          _ids.remove(itemId);
        }
        notifyListeners();
        return null;
      },
      (message) {
        if (!wasWishlisted) unawaited(_fetchAndSet());
        return message.isNotEmpty ? message : null;
      },
    );
  }

  Future<void> _fetchAndSet() async {
    final result = await _api.getWishlist();
    result.fold(
      (_) {},
      (page) {
        _items = page.items;
        _ids
          ..clear()
          ..addAll(page.items.map((e) => e.itemId));
        notifyListeners();
      },
    );
  }
}
