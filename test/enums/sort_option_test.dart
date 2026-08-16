import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooki_app/enums/sort_option.dart';
import 'package:sooki_app/i18n/i18n_bootstrap.dart';

/// Renders every option's label and button label under one locale, so a missing
/// translation key shows up as the raw key rather than as translated copy.
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
              for (final option in SortOption.values) ...[
                Text(option.label, key: Key('label.${option.name}')),
                Text(option.buttonLabel, key: Key('button.${option.name}')),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

String _read(WidgetTester tester, String key) =>
    tester.widget<Text>(find.byKey(Key(key))).data!;

Future<void> _pump(WidgetTester tester, Locale locale) async {
  await tester.pumpWidget(_probeFor(locale));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  test('toSortBy maps every option to a distinct backend value', () {
    final values = SortOption.values.map((o) => o.toSortBy()).toList();
    expect(values, [1, 2, 3, 4, 5, 6]);
    expect(values.toSet().length, SortOption.values.length);
  });

  test('every option has its own icon', () {
    final icons = SortOption.values.map((o) => o.icon).toSet();
    expect(icons.length, SortOption.values.length);
  });

  for (final locale in [I18nBootstrap.en, I18nBootstrap.fr, I18nBootstrap.ar]) {
    testWidgets('${locale.languageCode}: every label is translated', (
      tester,
    ) async {
      await _pump(tester, locale);
      for (final option in SortOption.values) {
        expect(
          _read(tester, 'label.${option.name}'),
          isNot(startsWith('enums.')),
          reason: '${option.name} has no translation in ${locale.languageCode}',
        );
        expect(
          _read(tester, 'button.${option.name}'),
          isNot(contains('enums.')),
          reason: '${option.name} short label is missing',
        );
      }

      // The price shortcuts carry a direction arrow in every language.
      expect(_read(tester, 'button.priceLowToHigh'), endsWith('\u2191'));
      expect(_read(tester, 'button.priceHighToLow'), endsWith('\u2193'));

      if (locale == I18nBootstrap.en) {
        expect(_read(tester, 'label.newest'), 'Newest');
        expect(_read(tester, 'label.priceLowToHigh'), 'Price: Low to High');
      }
      if (locale == I18nBootstrap.ar) {
        expect(
          _read(tester, 'label.newest'),
          '\u0627\u0644\u0623\u062d\u062f\u062b',
        );
      }
    });
  }
}
