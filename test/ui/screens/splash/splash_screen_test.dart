import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sooki_app/routes/route_constants.dart';
import 'package:sooki_app/ui/reusable_components/app_logo/app_logo.dart';
import 'package:sooki_app/ui/screens/splash/splash_screen.dart';
import 'package:sooki_app/ui/screens/splash/widgets/aurora_glow_blob.dart';
import 'package:sooki_app/ui/screens/splash/widgets/pulsing_dots.dart';

Widget _host() => MaterialApp(
      home: const SplashScreen(),
      routes: {
        signUpScreenRoute: (_) =>
            const Scaffold(body: SizedBox.shrink(key: Key('stub-signup'))),
      },
    );

/// Dispose the splash tree cleanly. PulsingDots schedules `Future.delayed`
/// callbacks that kick off repeating animation controllers; pump long enough
/// for those to resolve, then swap in an empty widget so `dispose` cancels
/// the controllers before the test finishes.
Future<void> _tearDownSplash(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 700));
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

void main() {
  testWidgets('Splash renders logo, tagline, and PulsingDots', (tester) async {
    await tester.pumpWidget(_host());
    expect(find.byType(AppLogo), findsOneWidget);
    expect(find.text('YOUR SHOPPING DESTINATION'), findsOneWidget);
    expect(find.byType(PulsingDots), findsOneWidget);
    await _tearDownSplash(tester);
  });

  testWidgets('Splash renders two soft AuroraGlowBlob corner accents',
      (tester) async {
    await tester.pumpWidget(_host());
    expect(find.byType(AuroraGlowBlob), findsNWidgets(2));
    await _tearDownSplash(tester);
  });
}
