import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService extends ChangeNotifier {
  static const _keyFirstName = 'sooki_user_first_name';
  static const _keyLastName  = 'sooki_user_last_name';
  static const _keyEmail     = 'sooki_user_email';
  static const _keyPhone     = 'sooki_user_phone';

  final SharedPreferences _prefs;

  String _firstName = '';
  String _lastName  = '';
  String _email     = '';
  String _phone     = '';

  UserProfileService(this._prefs);

  String get firstName => _firstName;
  String get lastName  => _lastName;
  String get name      => '$_firstName $_lastName'.trim();
  String get email     => _email;
  String get phone     => _phone;

  String get initials {
    final f = _firstName.trim();
    final l = _lastName.trim();
    if (f.isEmpty && l.isEmpty) return '?';
    if (l.isEmpty) return f[0].toUpperCase();
    if (f.isEmpty) return l[0].toUpperCase();
    return '${f[0]}${l[0]}'.toUpperCase();
  }

  Future<void> load() async {
    _firstName = _prefs.getString(_keyFirstName) ?? 'Nour';
    _lastName  = _prefs.getString(_keyLastName)  ?? 'Mawla';
    _email     = _prefs.getString(_keyEmail)     ?? 'nour@example.com';
    _phone     = _prefs.getString(_keyPhone)     ?? '';
  }

  Future<void> save({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    _firstName = firstName;
    _lastName  = lastName;
    _email     = email;
    _phone     = phone;
    await _prefs.setString(_keyFirstName, firstName);
    await _prefs.setString(_keyLastName,  lastName);
    await _prefs.setString(_keyEmail,     email);
    await _prefs.setString(_keyPhone,     phone);
    notifyListeners();
  }
}
