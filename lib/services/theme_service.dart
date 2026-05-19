import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global theme notifier — toggles between light and dark mode.
/// User preference is persisted to SharedPreferences and restored on startup.
class ThemeService extends ChangeNotifier {
  ThemeService._();

  static final ThemeService instance = ThemeService._();

  static const _key = 'sooki_theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Restore saved preference, falling back to OS brightness on first launch.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      _themeMode = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
    } else {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      _themeMode =
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggle() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _themeMode == ThemeMode.dark ? 'dark' : 'light');
  }
}
