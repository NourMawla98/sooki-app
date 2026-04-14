import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooki_app/i18n/i18n_bootstrap.dart';
import 'package:sooki_app/i18n/i18n_keys.dart';

Widget _probeForLocale(Locale locale) {
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
          body: Text(I18nKeys.appName.tr(), key: const Key('probe')),
        ),
      ),
    ),
  );
}

Future<Text> _pumpAndRead(WidgetTester tester, Locale locale) async {
  await tester.pumpWidget(_probeForLocale(locale));
  await tester.pumpAndSettle();
  return tester.widget<Text>(find.byKey(const Key('probe')));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('I18nKeys.appName resolves to "Sooki" in English',
      (tester) async {
    final text = await _pumpAndRead(tester, I18nBootstrap.en);
    expect(text.data, 'Sooki');
  });

  testWidgets('I18nKeys.appName resolves to the Arabic translation',
      (tester) async {
    final text = await _pumpAndRead(tester, I18nBootstrap.ar);
    expect(text.data, 'سوكي');
  });

  testWidgets('I18nKeys.appName resolves to "Sooki" in French',
      (tester) async {
    final text = await _pumpAndRead(tester, I18nBootstrap.fr);
    expect(text.data, 'Sooki');
  });
}
