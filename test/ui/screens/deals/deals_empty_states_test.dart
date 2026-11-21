import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooki_app/i18n/i18n_bootstrap.dart';
import 'package:sooki_app/models/deal_progress.dart';
import 'package:sooki_app/ui/screens/deals/widgets/deals_empty_state.dart';

/// Hosts [child] with the app's translations, reduced motion on so the looping
/// illustrations hold still and the tree can settle.
Widget _host(Widget child, {Locale locale = I18nBootstrap.en}) =>
    EasyLocalization(
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
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: Scaffold(body: SingleChildScrollView(child: child)),
            ),
          ),
        ),
      ),
    );

Future<void> _pump(WidgetTester tester, Widget widget) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(widget);
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

  group('DealsEmptyState', () {
    testWidgets('shows the message and both actions', (tester) async {
      var notified = 0;
      var browsed = 0;
      await _pump(
        tester,
        _host(
          DealsEmptyState(
            isDark: false,
            trending: const [],
            alertsOn: false,
            onNotify: () => notified++,
            onBrowse: () => browsed++,
          ),
        ),
      );

      expect(find.text('No deals right now'), findsOneWidget);
      expect(find.text('Notify me'), findsOneWidget);
      expect(find.text('Browse the shop'), findsOneWidget);
      // Nothing trending, so no empty trending row.
      expect(find.text('Trending while you wait'), findsNothing);

      await tester.tap(find.text('Notify me'));
      await tester.tap(find.text('Browse the shop'));
      expect(notified, 1);
      expect(browsed, 1);
    });

    testWidgets('shows alerts as on once they are', (tester) async {
      await _pump(
        tester,
        _host(
          DealsEmptyState(
            isDark: true,
            trending: const [],
            alertsOn: true,
            onNotify: () {},
            onBrowse: () {},
          ),
        ),
      );

      expect(find.text('Alerts on'), findsOneWidget);
      expect(find.text('Notify me'), findsNothing);
    });

    testWidgets('renders in Arabic, right to left', (tester) async {
      await _pump(
        tester,
        _host(
          DealsEmptyState(
            isDark: false,
            trending: const [],
            alertsOn: null,
            onNotify: () {},
            onBrowse: () {},
          ),
          locale: I18nBootstrap.ar,
        ),
      );

      expect(find.text('deals.empty_title'), findsNothing);
      final direction = Directionality.of(
        tester.element(find.byType(DealsEmptyState)),
      );
      expect(direction, TextDirection.rtl);
    });
  });

  group('DealsFilterEmpty', () {
    testWidgets('names the filter and leads back to every deal', (tester) async {
      var seeAll = 0;
      await _pump(
        tester,
        _host(
          DealsFilterEmpty(
            filter: DealFilter.bundle,
            isDark: false,
            onSeeAll: () => seeAll++,
          ),
        ),
      );

      expect(find.text('No bundle deals right now'), findsOneWidget);
      await tester.tap(find.text('See all deals'));
      expect(seeAll, 1);
    });

    test('every deals key exists in every language', () {
      Set<String> keysOf(String lang) {
        final file = File('${I18nBootstrap.translationsPath}/$lang.json');
        final deals = (jsonDecode(file.readAsStringSync())
            as Map<String, dynamic>)['deals'] as Map<String, dynamic>;
        Iterable<String> walk(String prefix, Map<String, dynamic> map) =>
            map.entries.expand(
              (e) => e.value is Map<String, dynamic>
                  ? walk('$prefix${e.key}.', e.value as Map<String, dynamic>)
                  : ['$prefix${e.key}'],
            );
        return walk('', deals).toSet();
      }

      final english = keysOf('en');
      for (final filter in DealFilter.values) {
        expect(
          english,
          contains(DealsFilterEmpty.titleKey(filter).substring(6)),
        );
      }
      expect(keysOf('ar'), english);
      expect(keysOf('fr'), english);
    });
  });
}
