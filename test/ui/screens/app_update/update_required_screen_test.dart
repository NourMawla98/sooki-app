import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooki_app/i18n/i18n_bootstrap.dart';
import 'package:sooki_app/models/app_version.dart';
import 'package:sooki_app/services/app_version_gate.dart';
import 'package:sooki_app/services/toast_service.dart';
import 'package:sooki_app/ui/screens/app_update/app_version_overlay.dart';
import 'package:sooki_app/ui/screens/app_update/update_required_screen.dart';

const _url = 'https://play.google.com/store/apps/details?id=com.sooki.app';

Widget _host(Widget home) => EasyLocalization(
  supportedLocales: I18nBootstrap.supportedLocales,
  path: I18nBootstrap.translationsPath,
  fallbackLocale: I18nBootstrap.fallbackLocale,
  startLocale: I18nBootstrap.en,
  useOnlyLangCode: true,
  assetLoader: const RootBundleAssetLoader(),
  child: Builder(
    builder: (context) => MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: home,
    ),
  ),
);

/// The app as main builds it: the overlay in MaterialApp.builder, above the
/// navigator, with the barrier observer on the navigator.
Widget _app() => EasyLocalization(
  supportedLocales: I18nBootstrap.supportedLocales,
  path: I18nBootstrap.translationsPath,
  fallbackLocale: I18nBootstrap.fallbackLocale,
  startLocale: I18nBootstrap.en,
  useOnlyLangCode: true,
  assetLoader: const RootBundleAssetLoader(),
  child: Builder(
    builder: (context) => MaterialApp(
      navigatorKey: ToastService.navigatorKey,
      navigatorObservers: [UpdateBarrier.observer],
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const Scaffold(body: Text('Behind')),
      builder: (context, child) =>
          AppVersionOverlay(child: child ?? const SizedBox.shrink()),
    ),
  ),
);

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(_app());
    await Future<void>.delayed(const Duration(milliseconds: 50));
  });
  await tester.pumpAndSettle();
}

Future<void> _pump(WidgetTester tester, Widget widget) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(_host(widget));
    await Future<void>.delayed(const Duration(milliseconds: 50));
  });
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });
  setUp(AppVersionGate.instance.reset);

  testWidgets('shows the default text and opens the store', (tester) async {
    String? opened;
    await _pump(
      tester,
      UpdateRequiredScreen(
        config: const AppVersionConfig(
          minSupportedVersion: '2.0.0',
          latestVersion: '2.0.0',
          storeUrl: _url,
        ),
        onOpenStore: (url) async => opened = url,
      ),
    );

    expect(find.text('Update required'), findsOneWidget);
    expect(
      find.text(
        'This version of Sooki is no longer supported. Update the app to keep shopping.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Update now'));
    expect(opened, _url);
  });

  testWidgets("shows the backend's message as is", (tester) async {
    await _pump(
      tester,
      const UpdateRequiredScreen(
        config: AppVersionConfig(
          minSupportedVersion: '2.0.0',
          latestVersion: '2.0.0',
          storeUrl: _url,
          message: 'Big new release, please update.',
        ),
      ),
    );
    expect(find.text('Big new release, please update.'), findsOneWidget);
  });

  testWidgets('cannot be left with back', (tester) async {
    await _pumpApp(tester);
    AppVersionGate.instance.requireUpdate(
      const AppVersionConfig(
        minSupportedVersion: '2.0.0',
        latestVersion: '2.0.0',
        storeUrl: _url,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Update required'), findsOneWidget);
    // A route that refuses to pop sits on the navigator, so the platform
    // hands back to the app and the app ignores it.
    final navigator = ToastService.navigatorKey.currentState!;
    expect(navigator.canPop(), isTrue);
    final handled = await tester.binding.handlePopRoute();
    expect(handled, isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Update required'), findsOneWidget);
    expect(navigator.canPop(), isTrue);

    // Once supported again, the barrier goes away.
    AppVersionGate.instance.apply(
      '2.0.0',
      const AppVersionConfig(
        minSupportedVersion: '2.0.0',
        latestVersion: '2.0.0',
        storeUrl: _url,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Update required'), findsNothing);
    expect(navigator.canPop(), isFalse);
  });

  testWidgets('the banner shows and dismisses above the navigator',
      (tester) async {
    await _pumpApp(tester);
    AppVersionGate.instance.apply(
      '1.0.0',
      const AppVersionConfig(
        minSupportedVersion: '1.0.0',
        latestVersion: '1.1.0',
        storeUrl: _url,
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('A new version of Sooki is available.'), findsOneWidget);
    expect(find.text('Behind'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Dismiss'));
    await tester.pumpAndSettle();
    expect(find.text('A new version of Sooki is available.'), findsNothing);
  });
}
