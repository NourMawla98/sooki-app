import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooki_app/enums/app_language.dart';
import 'package:sooki_app/services/language_service.dart';
import 'package:sooki_app/utils/number_localization.dart';

/// Registers a language service holding [language], the way the app does.
Future<void> _useLanguage(AppLanguage language) async {
  SharedPreferences.setMockInitialValues({
    'app_language': language.backendValue,
  });
  final prefs = await SharedPreferences.getInstance();
  final service = await LanguageService.initialize(prefs);
  GetIt.instance.registerSingleton<LanguageService>(service);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() => GetIt.instance.reset());

  group('toArabicIndicDigits', () {
    test('converts every ASCII digit', () {
      expect(
        toArabicIndicDigits('0123456789'),
        '\u0660\u0661\u0662\u0663\u0664\u0665\u0666\u0667\u0668\u0669',
      );
    });

    test('leaves separators, letters and symbols alone', () {
      expect(toArabicIndicDigits('20.99 USD'), '\u0662\u0660.\u0669\u0669 USD');
      expect(
        toArabicIndicDigits('SK-SEED-0001'),
        'SK-SEED-\u0660\u0660\u0660\u0661',
      );
    });

    test('is a no-op for a string with no digits', () {
      expect(toArabicIndicDigits('Sooki'), 'Sooki');
      expect(toArabicIndicDigits(''), '');
    });
  });

  test('keepWesternDigits never converts', () {
    expect(keepWesternDigits('+961 3 123456'), '+961 3 123456');
  });

  group('without a registered language service', () {
    test('digits stay western', () {
      expect(useArabicIndicDigits, isFalse);
      expect(localizedDigits('2026'), '2026');
      expect(localizedNumber(7), '7');
      expect(localizedPrice(20.9), '20.90');
    });
  });

  group('in Arabic', () {
    setUp(() => _useLanguage(AppLanguage.arabic));

    test('the flag is on', () {
      expect(useArabicIndicDigits, isTrue);
    });

    test('localizedDigits converts an already-formatted string', () {
      expect(localizedDigits('3 / 10'), '\u0663 / \u0661\u0660');
    });

    test('localizedNumber honours the decimals argument', () {
      expect(localizedNumber(7), '\u0667');
      expect(localizedNumber(7, decimals: 2), '\u0667.\u0660\u0660');
      expect(
        localizedNumber(1234.5, decimals: 1),
        '\u0661\u0662\u0663\u0664.\u0665',
      );
    });

    test('localizedPrice always shows two decimals', () {
      expect(localizedPrice(20.9), '\u0662\u0660.\u0669\u0660');
      expect(localizedPrice(0), '\u0660.\u0660\u0660');
    });

    test('keepWesternDigits still opts out', () {
      expect(keepWesternDigits('SK-SEED-0001'), 'SK-SEED-0001');
    });
  });

  group('in English and French', () {
    for (final language in [AppLanguage.english, AppLanguage.french]) {
      test('${language.code}: everything passes through', () async {
        await _useLanguage(language);
        expect(useArabicIndicDigits, isFalse);
        expect(localizedDigits('3 / 10'), '3 / 10');
        expect(localizedNumber(7, decimals: 2), '7.00');
        expect(localizedPrice(20.9), '20.90');
      });
    }
  });
}
