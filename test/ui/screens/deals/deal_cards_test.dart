import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sooki_app/backend_integration/dtos/deal/customer_deal_dto.dart';
import 'package:sooki_app/backend_integration/dtos/deal/item_deal_dto.dart';
import 'package:sooki_app/backend_integration/dtos/item/item_list_item_dto.dart';
import 'package:sooki_app/i18n/i18n_bootstrap.dart';
import 'package:sooki_app/models/deal_progress.dart';
import 'package:sooki_app/ui/screens/deals/widgets/bundle_deal_card.dart';
import 'package:sooki_app/ui/screens/deals/widgets/multi_buy_deal_card.dart';

/// Deal cards only read the cart: items in it are marked, a met condition
/// lights the card up, and nothing on the card adds to the cart.

ItemListItemDto _item(int id, String title) => ItemListItemDto(
  id: id,
  title: title,
  originalPrice: 20,
  categoryName: 'Beauty',
);

CustomerDealDto _bundle() => CustomerDealDto(
  id: 1,
  title: 'Hair trio',
  startsAt: DateTime.utc(2026, 11, 1),
  isLive: true,
  type: 2,
  bundlePrice: 30,
  originalTotal: 40,
  items: [_item(1, 'Shampoo'), _item(2, 'Mask')],
  lines: const [
    DealLineDto(itemId: 1, quantity: 1),
    DealLineDto(itemId: 2, quantity: 1),
  ],
);

CustomerDealDto _multi() => CustomerDealDto(
  id: 2,
  title: 'Gummies multi-buy',
  startsAt: DateTime.utc(2026, 11, 1),
  isLive: true,
  type: 3,
  minQuantity: 3,
  discountPercent: 20,
  items: [_item(5, 'Gummies')],
  lines: const [DealLineDto(itemId: 5, quantity: 1)],
);

Widget _host(Widget child) => EasyLocalization(
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

  testWidgets('a part-filled bundle names what is missing', (tester) async {
    await _pump(
      tester,
      BundleDealCard(
        deal: _bundle(),
        isDark: false,
        quantityOf: (id) => id == 1 ? 1 : 0,
        status: DealCartStatus.inProgress,
      ),
    );

    expect(find.text('In cart x1'), findsOneWidget);
    expect(find.text('Unlocked'), findsNothing);
    expect(find.text('Add 1 more Mask to complete the bundle'), findsOneWidget);
    expect(find.textContaining('Add all'), findsNothing);
  });

  testWidgets('a complete bundle is unlocked', (tester) async {
    await _pump(
      tester,
      BundleDealCard(
        deal: _bundle(),
        isDark: false,
        quantityOf: (_) => 1,
        status: DealCartStatus.unlocked,
      ),
    );

    expect(find.text('Unlocked'), findsOneWidget);
    expect(find.text('In cart x1'), findsNWidgets(2));
  });

  testWidgets('a complete bundle the cart did not apply is not unlocked',
      (tester) async {
    await _pump(
      tester,
      BundleDealCard(
        deal: _bundle(),
        isDark: false,
        quantityOf: (_) => 1,
        status: DealCartStatus.betterDealApplies,
      ),
    );

    expect(find.text('Unlocked'), findsNothing);
    expect(find.text('A better deal applies to this item'), findsOneWidget);
  });

  testWidgets('a bundle with nothing in the cart pitches the saving',
      (tester) async {
    await _pump(
      tester,
      BundleDealCard(
        deal: _bundle(),
        isDark: false,
        quantityOf: (_) => 0,
        status: DealCartStatus.inProgress,
      ),
    );

    expect(find.text(r'Buy all 2 together and save $10'), findsOneWidget);
    expect(find.textContaining('more'), findsNothing);
  });

  testWidgets('a multi-buy counts the cart toward the minimum',
      (tester) async {
    await _pump(
      tester,
      MultiBuyDealCard(
        deal: _multi(),
        isDark: false,
        inCartQuantity: 2,
        status: DealCartStatus.inProgress,
      ),
    );
    expect(
      find.text('Add 1 more Gummies to unlock 20% off'),
      findsOneWidget,
    );
    expect(find.text('Unlocked'), findsNothing);

    await _pump(
      tester,
      MultiBuyDealCard(
        deal: _multi(),
        isDark: false,
        inCartQuantity: 3,
        status: DealCartStatus.unlocked,
      ),
    );
    expect(find.text('Unlocked'), findsOneWidget);
    expect(find.text('In cart x3'), findsOneWidget);

    await _pump(
      tester,
      MultiBuyDealCard(
        deal: _multi(),
        isDark: false,
        inCartQuantity: 0,
        status: DealCartStatus.inProgress,
      ),
    );
    expect(find.text('Buy 3 Gummies and save 20%'), findsOneWidget);
  });

  testWidgets('a multi-buy tile shows the normal price, not a deal price',
      (tester) async {
    final deal = _multi().copyWith(
      items: [
        _item(5, 'Gummies').copyWith(
          deal: const ItemDealDto(dealId: 99, dealPrice: 12),
        ),
      ],
    );
    await _pump(
      tester,
      MultiBuyDealCard(
        deal: deal,
        isDark: false,
        inCartQuantity: 0,
        status: DealCartStatus.inProgress,
      ),
    );

    expect(find.text(r'$20'), findsOneWidget);
    expect(find.text(r'$12'), findsNothing);
  });
}
