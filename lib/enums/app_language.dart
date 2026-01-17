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
