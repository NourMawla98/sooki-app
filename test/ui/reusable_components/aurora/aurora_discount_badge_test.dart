import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/ui/reusable_components/aurora/aurora_discount_badge.dart';

void main() {
  testWidgets('AuroraDiscountBadge renders the percentage label',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AuroraDiscountBadge(percent: 30),
        ),
      ),
    );

    expect(find.text('-30%'), findsOneWidget);
  });

  testWidgets('AuroraDiscountBadge renders as a circle (equal width/height)',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: AuroraDiscountBadge(percent: 50, size: 72),
          ),
        ),
      ),
    );

    final size = tester.getSize(find.byType(AuroraDiscountBadge));
    expect(size.width, 72);
    expect(size.height, 72);
  });
}
