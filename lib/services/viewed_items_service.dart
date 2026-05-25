import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewedItemsService extends ChangeNotifier {
  static const _key = 'viewed_item_ids';
  static const _max = 15;

  final SharedPreferences _prefs;
  final List<int> _ids = [];

  ViewedItemsService(this._prefs);

  List<int> get ids => List.unmodifiable(_ids);

  Future<void> load() async {
    final raw = _prefs.getStringList(_key) ?? const [];
    _ids
      ..clear()
      ..addAll(raw.map(int.parse));
  }

  Future<void> record(int itemId) async {
    _ids.removeWhere((id) => id == itemId);
    _ids.insert(0, itemId);
    if (_ids.length > _max) _ids.removeRange(_max, _ids.length);
    await _prefs.setStringList(_key, _ids.map((id) => id.toString()).toList());
    notifyListeners();
  }
}
