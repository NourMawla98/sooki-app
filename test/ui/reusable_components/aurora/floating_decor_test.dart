import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/ui/reusable_components/aurora/floating_decor.dart';

void main() {
  testWidgets('FloatingDecor positions and renders its child', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              FloatingDecor(
                top: 40,
                left: 20,
                child: Text('TAG'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('TAG'), findsOneWidget);
    expect(find.byType(Positioned), findsOneWidget);
  });

  testWidgets('FloatingDecor animates over time without throwing',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              FloatingDecor(
                top: 0,
                left: 0,
                floatDistance: 10,
                rotationAngle: 8,
                durationMs: 1200,
                child: Text('ANIM'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('ANIM'), findsOneWidget);
  });
}
