import 'package:flutter/foundation.dart';

import 'token_service.dart';

/// Tracks in-memory auth state that drives UI (logged in vs. guest).
/// Token persistence is delegated to [TokenService].
class AuthService extends ChangeNotifier {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  Future<void> signIn() async {
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isSignedIn = false;
    await TokenService.instance.clearTokens();
    notifyListeners();
  }
}
