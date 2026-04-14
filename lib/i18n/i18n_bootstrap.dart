import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../enums/app_language.dart';
import '../services/language_service.dart';

/// Wraps the root app widget in an [EasyLocalization] configured from the
/// persisted [LanguageService] choice. Call this from `main()` after
/// `LanguageService.initialize(...)` has run.
///
/// Supported locales: English (en), Arabic (ar), French (fr). The locale
/// passed to `startLocale` is derived from the user's cached preference so
/// the app opens straight into the previously selected language.
class I18nBootstrap {
  I18nBootstrap._();

  static const Locale en = Locale('en');
  static const Locale ar = Locale('ar');
  static const Locale fr = Locale('fr');

  static const List<Locale> supportedLocales = [en, ar, fr];
  static const String translationsPath = 'assets/translations';
  static const Locale fallbackLocale = en;

  /// Convert an [AppLanguage] into the matching [Locale].
  static Locale localeFor(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return en;
      case AppLanguage.arabic:
        return ar;
      case AppLanguage.french:
        return fr;
    }
  }

  /// Build the [EasyLocalization] wrapper around [child] using the supplied
  /// [LanguageService] to pick the start locale.
  static Widget wrap({
    required LanguageService languageService,
    required Widget child,
  }) {
    return EasyLocalization(
      supportedLocales: supportedLocales,
      path: translationsPath,
      fallbackLocale: fallbackLocale,
      startLocale: localeFor(languageService.currentLanguage),
      useOnlyLangCode: true,
      child: child,
    );
  }
}
