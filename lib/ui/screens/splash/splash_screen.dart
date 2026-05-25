import 'package:flutter/material.dart';

import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../routes/route_constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/app_logo/app_logo.dart';
import '../../reusable_components/floating_emoji/floating_emoji.dart';
import 'widgets/aurora_glow_blob.dart';
import 'widgets/pulsing_dots.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _fadeController.forward();
    _startup();
  }

  Future<void> _startup() async {
    setState(() => _errorMessage = null);
    final authService = serviceLocator<AuthService>();
    // Enforce a minimum display time so the animations play.
    final minDelay = Future<void>.delayed(const Duration(milliseconds: 1800));

    String? error;
    try {
      await authService.restoreSession();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    }

    await minDelay;
    if (!mounted) return;

    if (error != null) {
      ToastService.instance.showError(error);
      setState(() => _errorMessage = error);
    } else {
      final route = authService.isCustomer ? mainScreenRoute : signInScreenRoute;
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bgTop = isDark ? AppColors.splashDimBase : AppColors.auroraLightBase;
        final bgMid = isDark
            ? Color.alphaBlend(
                AppColors.auroraPurple.withValues(alpha: 0.38),
                AppColors.auroraDeepBase,
              )
            : AppColors.auroraLightBase;
        final taglineColor = isDark ? AppColors.white : AppColors.primaryPurple;

        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [bgTop, bgMid, bgTop],
                  ),
                ),
              ),
              AuroraGlowBlob(
                top: -100,
                right: -100,
                size: 280,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.12,
              ),
              AuroraGlowBlob(
                bottom: -100,
                left: -100,
                size: 300,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.10,
              ),
              const FloatingEmoji(
                emoji: '🛍️',
                size: 36,
                opacity: 0.2,
                top: 80,
                left: 32,
                floatDistance: 15.5,
                rotationAngle: 7.7,
                durationMs: 2200,
              ),
              const FloatingEmoji(
                emoji: '❤️',
                size: 30,
                opacity: 0.2,
                top: 160,
                right: 48,
                floatDistance: 14.6,
                rotationAngle: -9.7,
                durationMs: 2400,
              ),
              const FloatingEmoji(
                emoji: '⭐',
                size: 30,
                opacity: 0.2,
                bottom: 128,
                right: 32,
                floatDistance: 14.5,
                rotationAngle: 14.5,
                durationMs: 2100,
              ),
              const FloatingEmoji(
                emoji: '🎁',
                size: 36,
                opacity: 0.2,
                bottom: 80,
                left: 48,
                floatDistance: 18.5,
                rotationAngle: -13.9,
                durationMs: 2300,
              ),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: AppLogo(size: LogoSize.large, isWhiteText: isDark),
                    ),
                    const SizedBox(height: 24),
                    AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: FadeTransition(opacity: _fadeAnimation, child: child),
                      ),
                      child: Text(
                        'YOUR SHOPPING DESTINATION',
                        style: AppTextStyles.auroraTagline.copyWith(color: taglineColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 32,
                      child: _errorMessage != null
                          ? Center(
                              child: GestureDetector(
                                onTap: _startup,
                                child: Text(
                                  'Try again',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isDark
                                        ? AppColors.white.withValues(alpha: 0.55)
                                        : AppColors.auroraPurple.withValues(alpha: 0.65),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: isDark
                                        ? AppColors.white.withValues(alpha: 0.35)
                                        : AppColors.auroraPurple.withValues(alpha: 0.45),
                                  ),
                                ),
                              ),
                            )
                          : const PulsingDots(),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

