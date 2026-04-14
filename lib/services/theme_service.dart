import 'dart:ui';

import 'package:flutter/material.dart';

/// Global theme notifier — toggles between light and dark mode.
/// On first launch it adopts the OS brightness; user toggles override it for
/// the rest of the session.
class ThemeService extends ChangeNotifier {
  ThemeService._();

  static final ThemeService instance = ThemeService._();

  ThemeMode _themeMode = ThemeMode.light;
  bool _userOverride = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Initialize the mode from the current platform brightness unless the
  /// user has already toggled manually this session. Safe to call from
  /// `main()` after `WidgetsFlutterBinding.ensureInitialized()`.
  void initFromPlatform() {
    if (_userOverride) return;
    final brightness = PlatformDispatcher.instance.platformBrightness;
    _themeMode =
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggle() {
    _userOverride = true;
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
