import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend_integration/dtos/profile/profile_dto.dart';

class UserProfileService extends ChangeNotifier {
  static const _keyId               = 'sooki_user_id';
  static const _keyFirstName        = 'sooki_user_first_name';
  static const _keyLastName         = 'sooki_user_last_name';
  static const _keyEmail            = 'sooki_user_email';
  static const _keyPhone            = 'sooki_user_phone';
  static const _keyPhoneCountryCode = 'sooki_user_phone_cc';
  static const _keyIsVerified       = 'sooki_user_is_verified';

  final SharedPreferences _prefs;

  int?    _id;
  String  _firstName        = '';
  String  _lastName         = '';
  String  _email            = '';
  String  _phone            = '';
  String? _phoneCountryCode;
  bool    _isVerified       = false;

  UserProfileService(this._prefs);

  int?    get id               => _id;
  String  get firstName        => _firstName;
  String  get lastName         => _lastName;
  String  get name             => '$_firstName $_lastName'.trim();
  String  get email            => _email;
  String  get phone            => _phone;
  String? get phoneCountryCode => _phoneCountryCode;
  bool    get isVerified       => _isVerified;

  String get initials {
    final f = _firstName.trim();
    final l = _lastName.trim();
    if (f.isEmpty && l.isEmpty) return '?';
    if (l.isEmpty) return f[0].toUpperCase();
    if (f.isEmpty) return l[0].toUpperCase();
    return '${f[0]}${l[0]}'.toUpperCase();
  }

  /// Load cached profile from SharedPreferences (called at app startup).
  Future<void> load() async {
    final savedId = _prefs.getInt(_keyId);
    _id               = savedId;
    _firstName        = _prefs.getString(_keyFirstName) ?? '';
    _lastName         = _prefs.getString(_keyLastName)  ?? '';
    _email            = _prefs.getString(_keyEmail)     ?? '';
    _phone            = _prefs.getString(_keyPhone)     ?? '';
    _phoneCountryCode = _prefs.getString(_keyPhoneCountryCode);
    _isVerified       = _prefs.getBool(_keyIsVerified)  ?? false;
  }

  /// Update profile from API response and persist to cache.
  Future<void> updateFromDto(ProfileDto dto) async {
    _id               = dto.id;
    _firstName        = dto.firstName;
    _lastName         = dto.lastName;
    _email            = dto.email;
    _phone            = dto.phoneNumber ?? '';
    _phoneCountryCode = dto.phoneCountryCode;
    _isVerified       = dto.isVerified;

    await _prefs.setInt(_keyId,                       dto.id);
    await _prefs.setString(_keyFirstName,             dto.firstName);
    await _prefs.setString(_keyLastName,              dto.lastName);
    await _prefs.setString(_keyEmail,                 dto.email);
    await _prefs.setString(_keyPhone,                 dto.phoneNumber ?? '');
    await _prefs.setString(_keyPhoneCountryCode,      dto.phoneCountryCode ?? '');
    await _prefs.setBool(_keyIsVerified,              dto.isVerified);

    notifyListeners();
  }

  /// Save locally-edited profile fields (used by EditProfileScreen).
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

  /// Clear all cached profile data (called on logout).
  Future<void> clear() async {
    _id               = null;
    _firstName        = '';
    _lastName         = '';
    _email            = '';
    _phone            = '';
    _phoneCountryCode = null;
    _isVerified       = false;
    await _prefs.remove(_keyId);
    await _prefs.remove(_keyFirstName);
    await _prefs.remove(_keyLastName);
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyPhone);
    await _prefs.remove(_keyPhoneCountryCode);
    await _prefs.remove(_keyIsVerified);
    notifyListeners();
  }
}
