import 'package:flutter/foundation.dart';

import '../backend_integration/apis/address_api.dart';
import '../backend_integration/dtos/address/address_dto.dart';
import '../backend_integration/dtos/address/address_request_dto.dart';

class AddressService extends ChangeNotifier {
  final AddressApi _api;

  AddressService(this._api);

  final List<AddressDto> _addresses = [];
  int? _selectedId;

  List<AddressDto> get addresses => List.unmodifiable(_addresses);
  int? get selectedId => _selectedId;

  AddressDto? get selectedAddress {
    if (_addresses.isEmpty) return null;
    if (_selectedId != null) {
      for (final a in _addresses) {
        if (a.id == _selectedId) return a;
      }
    }
    final def = _addresses.where((a) => a.isDefault);
    return def.isNotEmpty ? def.first : _addresses.first;
  }

  Future<void> loadFromServer() async {
    final result = await _api.getAddresses();
    result.fold(
      (_) {},
      (list) {
        _addresses
          ..clear()
          ..addAll(list);
        if (_selectedId == null || !_addresses.any((a) => a.id == _selectedId)) {
          final def = _addresses.where((a) => a.isDefault);
          _selectedId = def.isNotEmpty ? def.first.id : (_addresses.isNotEmpty ? _addresses.first.id : null);
        }
        notifyListeners();
      },
    );
  }

  void select(int id) {
    if (!_addresses.any((a) => a.id == id)) return;
    _selectedId = id;
    notifyListeners();
  }

  Future<String> createAddress(AddressRequestDto dto) async {
    final result = await _api.createAddress(dto);
    return result.fold(
      (_) => '',
      (message) async {
        await loadFromServer();
        return message;
      },
    );
  }

  Future<String> editAddress(int id, AddressRequestDto dto) async {
    final result = await _api.editAddress(id, dto);
    return result.fold(
      (_) => '',
      (message) async {
        await loadFromServer();
        return message;
      },
    );
  }

  Future<String> deleteAddress(int id) async {
    final result = await _api.deleteAddress(id);
    return result.fold(
      (_) => '',
      (message) async {
        if (_selectedId == id) _selectedId = null;
        await loadFromServer();
        return message;
      },
    );
  }

  Future<String> setDefault(int id) async {
    final result = await _api.setDefault(id);
    return result.fold(
      (_) => '',
      (message) async {
        await loadFromServer();
        return message;
      },
    );
  }
}
