import 'package:flutter/foundation.dart';

/// Tracks whether a user is currently signed in.
///
/// Token storage and real credential validation will be handled by the
/// API layer. This service only holds the in-memory auth state that
/// drives UI (logged in vs. guest) until a session is established.
class AuthService extends ChangeNotifier {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  Future<void> signIn() async {
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isSignedIn = false;
    notifyListeners();
  }
}
