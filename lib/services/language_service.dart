import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend_integration/apis/auth_api.dart';
import '../enums/app_language.dart';
import '../i18n/i18n_bootstrap.dart';
import 'toast_service.dart';

/// Service for managing app language.
///
/// - Detects the device default language on first run.
/// - Caches the selected language in [SharedPreferences].
/// - Provides the current language for API calls (via `languageBackendValue`).
/// - Keeps `easy_localization`'s live locale in sync when the caller supplies
///   a [BuildContext] to [setLanguage].
class LanguageService {
  static const String _languageKey = 'app_language';

  final SharedPreferences _prefs;
  AppLanguage _currentLanguage;

  LanguageService._({
    required SharedPreferences prefs,
    required AppLanguage initialLanguage,
  })  : _prefs = prefs,
        _currentLanguage = initialLanguage;

  static Future<LanguageService> initialize(SharedPreferences prefs) async {
    final cachedValue = prefs.getInt(_languageKey);

    AppLanguage language;
    if (cachedValue != null) {
      language = AppLanguage.fromBackendValue(cachedValue);
    } else {
      language = _getDeviceLanguage();
      await prefs.setInt(_languageKey, language.backendValue);
    }

    return LanguageService._(prefs: prefs, initialLanguage: language);
  }

  static AppLanguage _getDeviceLanguage() {
    final locale = PlatformDispatcher.instance.locale;
    return AppLanguage.fromCode(locale.languageCode);
  }

  AppLanguage get currentLanguage => _currentLanguage;
  int get languageBackendValue => _currentLanguage.backendValue;

  /// Matching [Locale] for the current language (source of truth for any
  /// caller that needs to reconstruct `easy_localization` state).
  Locale get locale => I18nBootstrap.localeFor(_currentLanguage);

  /// Persist the new language and, if a [context] is supplied, update the
  /// live `easy_localization` locale so the UI rebuilds into the new language
  /// immediately (including flipping `Directionality` to RTL for Arabic).
  Future<void> setLanguage(
    AppLanguage language, {
    BuildContext? context,
  }) async {
    if (_currentLanguage == language) return;

    _currentLanguage = language;
    await _prefs.setInt(_languageKey, language.backendValue);

    if (context != null && context.mounted) {
      await context.setLocale(I18nBootstrap.localeFor(language));
    }

    // Persist the choice to the customer's account (fire-and-forget) and
    // surface the backend's confirmation message.
    unawaited(syncToBackend(showMessage: true));
  }

  /// Push the current language to the backend so the account record matches the
  /// device. Called from [setLanguage] on every change, and once at startup
  /// after auth so the first-run device-detected language is also saved.
  /// Silently no-ops if the API isn't registered yet (e.g. pre-DI).
  ///
  /// When [showMessage] is true (explicit user change), the backend's success
  /// message is shown as a toast. The startup sync passes false to stay silent.
  Future<void> syncToBackend({bool showMessage = false}) async {
    if (!GetIt.instance.isRegistered<AuthApi>()) return;
    final result = await GetIt.instance<AuthApi>()
        .updateLanguage(language: _currentLanguage.backendValue);
    result.fold(
      (_) {}, // errors are silenced for this background sync
      (message) {
        if (showMessage && message.isNotEmpty) {
          ToastService.instance.showSuccess(message);
        }
      },
    );
  }
}
