import 'dart:ui' show TextDirection;

import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/enums/app_language.dart';

void main() {
  group('fromCode', () {
    test('resolves every supported code', () {
      expect(AppLanguage.fromCode('en'), AppLanguage.english);
      expect(AppLanguage.fromCode('ar'), AppLanguage.arabic);
      expect(AppLanguage.fromCode('fr'), AppLanguage.french);
    });

    test('ignores case', () {
      expect(AppLanguage.fromCode('AR'), AppLanguage.arabic);
      expect(AppLanguage.fromCode('Fr'), AppLanguage.french);
    });

    test('falls back to English for anything else', () {
      expect(AppLanguage.fromCode('de'), AppLanguage.english);
      expect(AppLanguage.fromCode(''), AppLanguage.english);
    });
  });

  group('fromBackendValue', () {
    test('matches the backend LanguageEnum', () {
      expect(AppLanguage.fromBackendValue(1), AppLanguage.english);
      expect(AppLanguage.fromBackendValue(2), AppLanguage.arabic);
      expect(AppLanguage.fromBackendValue(3), AppLanguage.french);
    });

    test('falls back to English for an unknown value', () {
      expect(AppLanguage.fromBackendValue(0), AppLanguage.english);
      expect(AppLanguage.fromBackendValue(99), AppLanguage.english);
    });
  });

  group('language traits', () {
    test('only Arabic is right to left', () {
      expect(AppLanguage.arabic.isRtl, isTrue);
      expect(AppLanguage.english.isRtl, isFalse);
      expect(AppLanguage.french.isRtl, isFalse);
    });

    test('text direction follows isRtl', () {
      expect(AppLanguage.arabic.textDirection, TextDirection.rtl);
      expect(AppLanguage.english.textDirection, TextDirection.ltr);
      expect(AppLanguage.french.textDirection, TextDirection.ltr);
    });

    test('only Arabic uses Arabic-Indic digits', () {
      expect(AppLanguage.arabic.usesArabicIndicDigits, isTrue);
      expect(AppLanguage.english.usesArabicIndicDigits, isFalse);
      expect(AppLanguage.french.usesArabicIndicDigits, isFalse);
    });
  });

  test('codes and backend values are unique across the enum', () {
    final codes = AppLanguage.values.map((l) => l.code).toSet();
    final values = AppLanguage.values.map((l) => l.backendValue).toSet();
    expect(codes.length, AppLanguage.values.length);
    expect(values.length, AppLanguage.values.length);
  });

  test('display names are endonyms and stay untranslated', () {
    expect(AppLanguage.english.displayName, 'English');
    // "al-Arabiyya" and "Francais", written as escapes so this file is ASCII.
    expect(
      AppLanguage.arabic.displayName,
      '\u0627\u0644\u0639\u0631\u0628\u064a\u0629',
    );
    expect(AppLanguage.french.displayName, 'Fran\u00e7ais');
  });
}
