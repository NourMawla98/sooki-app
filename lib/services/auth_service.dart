import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Minimal auth flag. Tracks whether a user is currently signed in.
///
/// This is a stand-in for a real auth backend — sufficient to drive
/// login/logout UI until proper authentication ships.
class AuthService extends ChangeNotifier {
  static const String _signedInKey = 'sooki_is_signed_in';

  final SharedPreferences _prefs;
  bool _isSignedIn = false;

  AuthService(this._prefs);

  bool get isSignedIn => _isSignedIn;

  Future<void> load() async {
    try {
      _isSignedIn = _prefs.getBool(_signedInKey) ?? true;
    } catch (_) {
      await _prefs.remove(_signedInKey);
      _isSignedIn = false;
    }
  }

  Future<void> signIn() async {
    _isSignedIn = true;
    await _prefs.setBool(_signedInKey, true);
    notifyListeners();
  }

  Future<void> signOut() async {
    _isSignedIn = false;
    await _prefs.setBool(_signedInKey, false);
    notifyListeners();
  }
}
