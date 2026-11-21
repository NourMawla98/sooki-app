import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooki_app/i18n/i18n_bootstrap.dart';
import 'package:sooki_app/ui/reusable_components/deals/deal_countdown.dart';

/// Countdowns once showed 1439 hours for a deal two months out. Days now come
/// first, and hours wrap at 24.

const _underHour = Duration(minutes: 18, seconds: 59);
const _underDay = Duration(hours: 23, minutes: 18, seconds: 59);
const _sixtyDays = Duration(days: 60, hours: 23, minutes: 18, seconds: 59);

Future<void> _loadEnglish(WidgetTester tester) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(
      EasyLocalization(
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
            home: const SizedBox.shrink(),
          ),
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
  });
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  group('formatDealClock', () {
    test('under an hour shows zero hours', () {
      expect(formatDealClock(_underHour), '00:18:59');
    });

    test('under a day shows the hours as they are', () {
      expect(formatDealClock(_underDay), '23:18:59');
    });

    test('past a day wraps the hours to 0-23', () {
      expect(formatDealClock(_sixtyDays), '23:18:59');
      expect(formatDealClock(const Duration(hours: 1439)), '23:00:00');
    });

    test('a passed time reads as zero', () {
      expect(formatDealClock(const Duration(seconds: -5)), '00:00:00');
    });
  });

  testWidgets('formatDealRemaining puts the days first from a day on',
      (tester) async {
    await _loadEnglish(tester);

    expect(formatDealRemaining(_underHour), '00:18:59');
    expect(formatDealRemaining(_underDay), '23:18:59');
    expect(formatDealRemaining(_sixtyDays), '60d 23:18:59');
    expect(formatDealRemaining(const Duration(hours: 24)), '1d 00:00:00');
  });
}
