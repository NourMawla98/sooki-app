import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend_integration/dio/interceptors/global_headers_interceptor.dart';
import 'backend_integration/dependency_injection/dependency_injection.dart';
import 'i18n/i18n_bootstrap.dart';
import 'routes/route_exports.dart' as router;
import 'services/language_service.dart';
import 'services/push_notification_service.dart';
import 'services/theme_service.dart';
import 'services/toast_service.dart';
import 'themes/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // easy_localization requires this before any EasyLocalization widgets build.
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase (push notifications). Reads native config from
  // android/app/google-services.json (and iOS GoogleService-Info.plist later).
  try {
    await Firebase.initializeApp();
    // Background/terminated push handler must be registered at startup.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (_) {
    // App still runs without push if Firebase init fails (e.g. missing config).
  }

  // Capture app version once for the X-App-Version request header.
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    GlobalHeadersInterceptor.appVersion = packageInfo.version;
  } catch (_) {
    // Keep the default fallback version if lookup fails.
  }

  final prefs = await SharedPreferences.getInstance();
  final languageService = await LanguageService.initialize(prefs);

  // Restore saved theme preference, falling back to OS brightness on first launch.
  await ThemeService.instance.init();

  await setupDependencyInjection(
    prefs: prefs,
    languageService: languageService,
  );

  runApp(
    I18nBootstrap.wrap(
      languageService: languageService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Sooki',
          debugShowCheckedModeBanner: false,
          navigatorKey: ToastService.navigatorKey,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeService.instance.themeMode,
          onGenerateRoute: router.generateRoute,
          initialRoute: router.splashScreenRoute,

          // easy_localization delegates + the live locale driven by it.
          // These three lines are what make `tr(...)` + RTL work app-wide.
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}
