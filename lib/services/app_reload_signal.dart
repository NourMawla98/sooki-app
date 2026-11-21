import 'package:flutter/foundation.dart';

/// Tells the main screens to load their data again, for an event that makes
/// what they hold stale or broken everywhere at once: an update block lifting
/// after requests behind it were refused.
class AppReloadSignal extends ChangeNotifier {
  AppReloadSignal._();

  static final AppReloadSignal instance = AppReloadSignal._();

  void reloadAll() => notifyListeners();
}
