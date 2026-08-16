import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooki_app/enums/app_language.dart';
import 'package:sooki_app/i18n/i18n_bootstrap.dart';
import 'package:sooki_app/services/language_service.dart';
import 'package:sooki_app/utils/date_localization.dart';

/// Two dates rendered by every probe: a single digit day and a two digit one.
final DateTime _spring = DateTime(2026, 3, 7);
final DateTime _winter = DateTime(2026, 12, 25);

/// Renders both dates through the app's only date formatter under [locale].
Widget _probeFor(Locale locale) {
  return EasyLocalization(
    supportedLocales: I18nBootstrap.supportedLocales,
    path: I18nBootstrap.translationsPath,
    fallbackLocale: I18nBootstrap.fallbackLocale,
    startLocale: locale,
    useOnlyLangCode: true,
    assetLoader: const RootBundleAssetLoader(),
    child: Builder(
      builder: (context) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: Scaffold(
          body: Column(
            children: [
              Text(localizedLongDate(_spring), key: const Key('spring')),
              Text(localizedLongDate(_winter), key: const Key('winter')),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Renders under [locale] and returns the two formatted dates.
Future<(String, String)> _render(
  WidgetTester tester,
  Locale locale,
  AppLanguage language,
) async {
  SharedPreferences.setMockInitialValues({
    'app_language': language.backendValue,
  });
  final prefs = await SharedPreferences.getInstance();
  GetIt.instance.registerSingleton<LanguageService>(
    await LanguageService.initialize(prefs),
  );
  await tester.pumpWidget(_probeFor(locale));
  await tester.pumpAndSettle();
  return (
    tester.widget<Text>(find.byKey(const Key('spring'))).data!,
    tester.widget<Text>(find.byKey(const Key('winter'))).data!,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  tearDown(() => GetIt.instance.reset());

  testWidgets('English puts the month first', (tester) async {
    final (spring, winter) = await _render(
      tester,
      I18nBootstrap.en,
      AppLanguage.english,
    );
    expect(spring, 'Mar 7, 2026');
    expect(winter, 'Dec 25, 2026');
  });

  testWidgets('French puts the day first and translates the month', (
    tester,
  ) async {
    final (spring, winter) = await _render(
      tester,
      I18nBootstrap.fr,
      AppLanguage.french,
    );
    expect(spring, '7 mars 2026');
    expect(winter, '25 d\u00e9c. 2026');
  });

  testWidgets('Arabic translates the month and localizes the digits', (
    tester,
  ) async {
    final (spring, winter) = await _render(
      tester,
      I18nBootstrap.ar,
      AppLanguage.arabic,
    );
    expect(spring, '\u0667 \u0645\u0627\u0631\u0633 \u0662\u0660\u0662\u0666');
    expect(winter, isNot(contains('25')));
  });
}
