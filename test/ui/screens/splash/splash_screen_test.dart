import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooki_app/backend_integration/dependency_injection/dependency_injection.dart';
import 'package:sooki_app/i18n/i18n_bootstrap.dart';
import 'package:sooki_app/services/auth_service.dart';
import 'package:sooki_app/routes/route_constants.dart';
import 'package:sooki_app/ui/reusable_components/app_logo/app_logo.dart';
import 'package:sooki_app/ui/screens/splash/splash_screen.dart';
import 'package:sooki_app/ui/screens/splash/widgets/aurora_glow_blob.dart';
import 'package:sooki_app/ui/screens/splash/widgets/pulsing_dots.dart';

/// Fails session restore, which keeps the splash on screen: the screen only
/// reaches for the language, push and notification services once a session is
/// restored, and only navigates away after that.
class _FailingAuthService extends AuthService {
  @override
  Future<void> restoreSession() async => throw Exception('no session in tests');
}

/// The splash resolves its copy through easy_localization, so the screen needs
/// the same wrapper the app gives it or every label renders as its key.
Widget _host() => EasyLocalization(
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
      home: const SplashScreen(),
      routes: {
        signUpScreenRoute: (_) =>
            const Scaffold(body: SizedBox.shrink(key: Key('stub-signup'))),
      },
    ),
  ),
);

/// Mount the splash and wait for the translations to load. Loading them reads
/// a real asset, which resolves outside the test's fake clock, so the pump has
/// to happen in a real async zone or the localization wrapper renders nothing.
Future<void> _pumpSplash(WidgetTester tester) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(_host());
    await Future<void>.delayed(const Duration(milliseconds: 50));
  });
  await tester.pump();
}

/// Dispose the splash tree cleanly. PulsingDots schedules `Future.delayed`
/// callbacks that kick off repeating animation controllers, and startup holds a
/// minimum-display delay of its own; pump past both, then swap in an empty
/// widget so `dispose` cancels the controllers before the test finishes.
Future<void> _tearDownSplash(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    serviceLocator.registerSingleton<AuthService>(_FailingAuthService());
  });

  tearDown(() async => serviceLocator.reset());

  testWidgets('Splash renders logo, tagline, and PulsingDots', (tester) async {
    await _pumpSplash(tester);
    expect(find.byType(AppLogo), findsOneWidget);
    expect(find.text('YOUR SHOPPING DESTINATION'), findsOneWidget);
    expect(find.byType(PulsingDots), findsOneWidget);
    await _tearDownSplash(tester);
  });

  testWidgets('Splash renders two soft AuroraGlowBlob corner accents', (
    tester,
  ) async {
    await _pumpSplash(tester);
    expect(find.byType(AuroraGlowBlob), findsNWidgets(2));
    await _tearDownSplash(tester);
  });
}
