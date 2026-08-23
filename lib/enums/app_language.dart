import 'dart:ui' show TextDirection;

/// Supported languages in the app
///
/// Maps to backend LanguageEnum:
/// - English = 1
/// - Arabic = 2
/// - French = 3
enum AppLanguage {
  english(code: 'en', backendValue: 1, displayName: 'English'),
  arabic(code: 'ar', backendValue: 2, displayName: 'العربية'),
  french(code: 'fr', backendValue: 3, displayName: 'Français');

  const AppLanguage({
    required this.code,
    required this.backendValue,
    required this.displayName,
  });

  /// ISO 639-1 language code (e.g., 'en', 'ar', 'fr')
  final String code;

  /// Backend enum value for API calls
  final int backendValue;

  /// Display name for UI
  final String displayName;

  /// True when the language is written right-to-left.
  ///
  /// The app-wide `Directionality` is already flipped by
  /// `GlobalWidgetsLocalizations` (supplied through
  /// `context.localizationDelegates`), so widgets should normally rely on
  /// `Directionality.of(context)`. Use this only where the direction is needed
  /// outside a widget tree, or to build a `Directionality` island around
  /// content that must stay left-to-right (order codes, emails, URLs).
  bool get isRtl => this == AppLanguage.arabic;

  /// Text direction for this language.
  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  /// True when numbers should render with Arabic-Indic digits.
  bool get usesArabicIndicDigits => this == AppLanguage.arabic;

  /// True when punctuation should use the Arabic forms, such as the comma
  /// U+060C in place of the Latin one. Separate from
  /// [usesArabicIndicDigits] because a language can want one and not the other.
  bool get usesArabicPunctuation => this == AppLanguage.arabic;

  /// Get language from ISO code, defaults to English if not found
  static AppLanguage fromCode(String code) {
    final lowerCode = code.toLowerCase();
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == lowerCode,
      orElse: () => AppLanguage.english,
    );
  }

  /// Get language from backend value, defaults to English if not found
  static AppLanguage fromBackendValue(int value) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.backendValue == value,
      orElse: () => AppLanguage.english,
    );
  }
}
