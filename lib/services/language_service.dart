import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../enums/app_language.dart';

/// Service for managing app language
///
/// - Detects device default language on first run
/// - Caches selected language in SharedPreferences
/// - Provides current language for API calls
class LanguageService {
  static const String _languageKey = 'app_language';

  final SharedPreferences _prefs;
  AppLanguage _currentLanguage;

  LanguageService._({
    required SharedPreferences prefs,
    required AppLanguage initialLanguage,
  })  : _prefs = prefs,
        _currentLanguage = initialLanguage;

  /// Initialize the language service
  ///
  /// - Loads cached language if available
  /// - Falls back to device language if no cache
  /// - Defaults to English if device language not supported
  static Future<LanguageService> initialize(SharedPreferences prefs) async {
    final cachedValue = prefs.getInt(_languageKey);

    AppLanguage language;
    if (cachedValue != null) {
      // Use cached language
      language = AppLanguage.fromBackendValue(cachedValue);
    } else {
      // Detect device language
      language = _getDeviceLanguage();
      // Cache it for future use
      await prefs.setInt(_languageKey, language.backendValue);
    }

    return LanguageService._(prefs: prefs, initialLanguage: language);
  }

  /// Get the device's default language
  static AppLanguage _getDeviceLanguage() {
    final locale = PlatformDispatcher.instance.locale;
    final languageCode = locale.languageCode;
    return AppLanguage.fromCode(languageCode);
  }

  /// Current app language
  AppLanguage get currentLanguage => _currentLanguage;

  /// Change the app language and cache it
  Future<void> setLanguage(AppLanguage language) async {
    _currentLanguage = language;
    await _prefs.setInt(_languageKey, language.backendValue);
  }

  /// Get language backend value for API calls
  int get languageBackendValue => _currentLanguage.backendValue;
}
