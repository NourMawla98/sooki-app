import 'package:flutter/material.dart';

import 'backend_integration/dependency_injection/dependency_injection.dart';
import 'themes/themes.dart';
import 'ui/reusable_components/app_logo/app_logo.dart';
import 'ui/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sooki',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

/// Test screen to display the animated logo
class LogoTestScreen extends StatelessWidget {
  const LogoTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large logo (splash screen size)
            const AppLogo(size: LogoSize.large),
            const SizedBox(height: 60),

            // Medium logo (signup size)
            const AppLogo(size: LogoSize.medium),
            const SizedBox(height: 40),

            // Small logo (header size)
            const AppLogo(size: LogoSize.small),
            const SizedBox(height: 80),

            // White text variant on dark background
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.splashGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const AppLogo(
                size: LogoSize.medium,
                isWhiteText: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
