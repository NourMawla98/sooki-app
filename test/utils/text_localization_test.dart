import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooki_app/enums/app_language.dart';
import 'package:sooki_app/services/language_service.dart';
import 'package:sooki_app/utils/text_localization.dart';

/// U+060C, the Arabic comma. An escape, so this file stays plain ASCII.
const String _arabicComma = '\u060C';

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

  group('listSeparator', () {
    test('is the Arabic comma under Arabic', () async {
      await _useLanguage(AppLanguage.arabic);
      expect(listSeparator, '$_arabicComma ');
    });

    test('is the Latin comma under English and French', () async {
      await _useLanguage(AppLanguage.english);
      expect(listSeparator, ', ');
      await GetIt.instance.reset();
      await _useLanguage(AppLanguage.french);
      expect(listSeparator, ', ');
    });

    test('falls back to the Latin comma with no language service', () {
      expect(listSeparator, ', ');
    });
  });

  group('joinLocalized', () {
    test('joins an address line with the Arabic comma', () async {
      await _useLanguage(AppLanguage.arabic);
      expect(
        joinLocalized([
          '\u0628\u064A\u0631\u0648\u062A',
          '\u0627\u0644\u0628\u0627\u0634\u0648\u0631\u0629',
        ]),
        '\u0628\u064A\u0631\u0648\u062A$_arabicComma \u0627\u0644\u0628\u0627\u0634\u0648\u0631\u0629',
      );
    });

    test('joins an address line with the Latin comma', () async {
      await _useLanguage(AppLanguage.english);
      expect(joinLocalized(['Beirut', 'Bachoura']), 'Beirut, Bachoura');
    });

    test(
      'drops a missing part instead of leaving a dangling separator',
      () async {
        await _useLanguage(AppLanguage.english);
        expect(joinLocalized(['Beirut', null]), 'Beirut');
        expect(joinLocalized([null, 'Bachoura']), 'Bachoura');
      },
    );

    test('drops a blank or whitespace-only part', () async {
      await _useLanguage(AppLanguage.english);
      expect(joinLocalized(['Beirut', '', '   ']), 'Beirut');
    });

    test('trims the parts it keeps', () async {
      await _useLanguage(AppLanguage.english);
      expect(joinLocalized(['  Beirut ', ' Bachoura  ']), 'Beirut, Bachoura');
    });

    test('is empty when every part is missing', () async {
      await _useLanguage(AppLanguage.english);
      expect(joinLocalized([null, '', '  ']), '');
    });
  });
}
