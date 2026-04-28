import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService extends ChangeNotifier {
  static const _keyName = 'sooki_user_name';
  static const _keyEmail = 'sooki_user_email';
  static const _keyPhone = 'sooki_user_phone';

  final SharedPreferences _prefs;

  String _name = '';
  String _email = '';
  String _phone = '';

  UserProfileService(this._prefs);

  String get name => _name;
  String get email => _email;
  String get phone => _phone;

  String get initials {
    final parts =
        _name.trim().split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  Future<void> load() async {
    _name = _prefs.getString(_keyName) ?? 'Nour Mawla';
    _email = _prefs.getString(_keyEmail) ?? 'nour@example.com';
    _phone = _prefs.getString(_keyPhone) ?? '';
  }

  Future<void> save({
    required String name,
    required String email,
    required String phone,
  }) async {
    _name = name;
    _email = email;
    _phone = phone;
    await _prefs.setString(_keyName, name);
    await _prefs.setString(_keyEmail, email);
    await _prefs.setString(_keyPhone, phone);
    notifyListeners();
  }
}
