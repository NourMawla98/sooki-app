import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/themes/app_colors.dart';
import 'package:sooki_app/ui/reusable_components/aurora/aurora_price_tag.dart';

void main() {
  testWidgets('AuroraPriceTag renders the price text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AuroraPriceTag(
            price: '\$24.99',
            accent: AppColors.auroraElectricBlue,
          ),
        ),
      ),
    );

    expect(find.text('\$24.99'), findsOneWidget);
  });

  testWidgets('AuroraPriceTag uses the supplied accent as its border color',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AuroraPriceTag(
            price: '\$9.99',
            accent: AppColors.auroraPink,
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find
          .ancestor(of: find.text('\$9.99'), matching: find.byType(Container))
          .first,
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.border, isA<Border>());
    expect((decoration.border as Border).top.color, AppColors.auroraPink);
  });
}
