import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService extends ChangeNotifier {
  static const String _storageKey = 'search_recents';
  static const int _maxEntries = 5;

  final SharedPreferences _prefs;
  final List<String> _recents = [];

  SearchHistoryService(this._prefs);

  List<String> get recents => List.unmodifiable(_recents);

  Future<void> load() async {
    List<String> saved;
    try {
      saved = _prefs.getStringList(_storageKey) ?? const [];
    } catch (_) {
      // Key exists but with an incompatible type (e.g. from a prior version).
      // Reset it so subsequent reads succeed.
      await _prefs.remove(_storageKey);
      saved = const [];
    }
    _recents
      ..clear()
      ..addAll(saved);
  }

  Future<void> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final existing = _recents
        .where((e) => e.toLowerCase() == trimmed.toLowerCase())
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);
    _recents.removeWhere((e) => e.toLowerCase() == trimmed.toLowerCase());
    _recents.insert(0, existing ?? trimmed);
    if (_recents.length > _maxEntries) {
      _recents.removeRange(_maxEntries, _recents.length);
    }
    await _persist();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _recents.clear();
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() =>
      _prefs.setStringList(_storageKey, List<String>.from(_recents));
}
