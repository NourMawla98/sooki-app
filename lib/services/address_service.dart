import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/delivery_address.dart';

class AddressService extends ChangeNotifier {
  static const String _storageKey = 'sooki_addresses';
  static const String _selectedIdKey = 'sooki_address_selected_id';

  final SharedPreferences _prefs;
  final List<DeliveryAddress> _addresses = [];
  String? _selectedId;

  AddressService(this._prefs);

  List<DeliveryAddress> get addresses => List.unmodifiable(_addresses);
  String? get selectedId => _selectedId;

  DeliveryAddress? get selectedAddress {
    if (_addresses.isEmpty) return null;
    if (_selectedId != null) {
      for (final a in _addresses) {
        if (a.id == _selectedId) return a;
      }
    }
    final def = _addresses.where((a) => a.isDefault);
    return def.isNotEmpty ? def.first : _addresses.first;
  }

  Future<void> load() async {
    String? stored;
    try {
      stored = _prefs.getString(_storageKey);
    } catch (_) {
      await _prefs.remove(_storageKey);
    }

    if (stored != null && stored.isNotEmpty) {
      try {
        final list = jsonDecode(stored) as List<dynamic>;
        _addresses
          ..clear()
          ..addAll(list.map(
            (j) => DeliveryAddress.fromJson(j as Map<String, dynamic>),
          ));
      } catch (_) {
        await _prefs.remove(_storageKey);
      }
    }

    if (_addresses.isEmpty) {
      _addresses.add(const DeliveryAddress(
        id: 'default-home',
        label: 'Home',
        phone: '+961 70 123 456',
        line: 'Rue Gouraud · Bldg Sooki · Apt 3B, Mar Mikhael, Beirut',
        latitude: 33.8892,
        longitude: 35.5014,
        isDefault: true,
      ));
      await _persistAddresses();
    }

    try {
      _selectedId = _prefs.getString(_selectedIdKey);
    } catch (_) {
      await _prefs.remove(_selectedIdKey);
    }

    if (_selectedId == null || !_addresses.any((a) => a.id == _selectedId)) {
      final def = _addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => _addresses.first,
      );
      _selectedId = def.id;
      await _prefs.setString(_selectedIdKey, _selectedId!);
    }
  }

  Future<void> select(String id) async {
    if (!_addresses.any((a) => a.id == id)) return;
    _selectedId = id;
    await _prefs.setString(_selectedIdKey, id);
    notifyListeners();
  }

  Future<void> add(DeliveryAddress address) async {
    final existing = _addresses.indexWhere((a) => a.id == address.id);
    if (existing >= 0) {
      _addresses[existing] = address;
    } else {
      _addresses.add(address);
    }
    if (address.isDefault) {
      for (var i = 0; i < _addresses.length; i++) {
        if (_addresses[i].id != address.id && _addresses[i].isDefault) {
          _addresses[i] = _addresses[i].copyWith(isDefault: false);
        }
      }
    }
    await _persistAddresses();
    await select(address.id);
  }

  Future<void> remove(String id) async {
    _addresses.removeWhere((a) => a.id == id);
    if (_selectedId == id) {
      if (_addresses.isNotEmpty) {
        final def = _addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => _addresses.first,
        );
        _selectedId = def.id;
        await _prefs.setString(_selectedIdKey, _selectedId!);
      } else {
        _selectedId = null;
        await _prefs.remove(_selectedIdKey);
      }
    }
    await _persistAddresses();
    notifyListeners();
  }

  Future<void> setDefault(String id) async {
    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isDefault: _addresses[i].id == id);
    }
    await _persistAddresses();
    notifyListeners();
  }

  Future<void> _persistAddresses() async {
    final jsonList = _addresses.map((a) => a.toJson()).toList();
    await _prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}
