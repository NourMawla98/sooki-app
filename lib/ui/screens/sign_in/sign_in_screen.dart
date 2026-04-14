import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../themes/themes.dart';
import '../../reusable_components/app_logo/app_logo.dart';
import '../../reusable_components/aurora/aurora_glass_card.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/aurora/aurora_text_field.dart';
import '../../reusable_components/buttons/theme_toggle_button.dart';
import '../../reusable_components/dropdowns/language_selector.dart';
import '../../reusable_components/floating_emoji/floating_emoji.dart';
import '../../screens/splash/widgets/aurora_glow_blob.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.pushReplacementNamed(context, mainScreenRoute);
        }
      });
    }
  }

  void _handleContinueAsGuest() {
    Navigator.pushReplacementNamed(context, mainScreenRoute);
  }

  void _handleForgotPassword() {
    Navigator.pushNamed(context, forgotPasswordScreenRoute);
  }

  void _navigateToSignUp() {
    Navigator.pop(context);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bgTop =
            isDark ? AppColors.splashDimBase : AppColors.auroraLightBase;
        final bgMid = isDark
            ? AppColors.splashDimViolet
            : AppColors.auroraLightBase;
        final headingColor =
            isDark ? AppColors.white : AppColors.primaryPurple;
        final subtitleColor = isDark
            ? AppColors.white.withValues(alpha: 0.75)
            : AppColors.gray600;
        final forgotColor =
            isDark ? AppColors.auroraPink : AppColors.auroraPurple;
        final dividerTextColor = isDark
            ? AppColors.white.withValues(alpha: 0.6)
            : AppColors.gray500;
        final guestBorderColor = isDark
            ? AppColors.white.withValues(alpha: 0.20)
            : AppColors.primaryPurple;
        final guestTextColor =
            isDark ? AppColors.white : AppColors.primaryPurple;
        final guestFillColor = isDark
            ? Colors.transparent
            : AppColors.primaryPurple.withValues(alpha: 0.06);
        final termsColor = isDark
            ? AppColors.white.withValues(alpha: 0.7)
            : AppColors.gray600;
        final termsStrongColor =
            isDark ? AppColors.white : AppColors.primaryPurple;

        return Scaffold(
          body: Stack(
            children: [
              // Soft dim-aurora gradient background (matches splash).
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

              // Two quiet corner glows — violet top-right, blue bottom-left.
              AuroraGlowBlob(
                top: -100,
                right: -100,
                size: 280,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -100,
                left: -100,
                size: 300,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),

              // Floating emojis (same positions as splash + sign-up).
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  LanguageSelector(),
                                  SizedBox(width: 12),
                                  ThemeToggleButton(),
                                ],
                              ),

                              const SizedBox(height: 24),

                              AppLogo(
                                size: LogoSize.medium,
                                isWhiteText: isDark,
                              ),

                              const SizedBox(height: 20),

                              Text(
                                'Welcome Back!',
                                style: AppTextStyles.heading1.copyWith(
                                  color: headingColor,
                                  fontSize: 30,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Log in to your account',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: subtitleColor,
                                ),
                              ),

                              const Spacer(),

                      AuroraGlassCard(
                        padding: const EdgeInsets.all(22),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AuroraTextField(
                                label: 'Email',
                                hintText: 'your@email.com',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: isDark
                                      ? AppColors.white.withValues(alpha: 0.5)
                                      : AppColors.gray400,
                                  size: 18,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AuroraTextField(
                                label: 'Password',
                                hintText: '••••••••',
                                controller: _passwordController,
                                isPassword: true,
                                prefixIcon: FaIcon(
                                  FontAwesomeIcons.lock,
                                  color: isDark
                                      ? AppColors.white.withValues(alpha: 0.5)
                                      : AppColors.gray400,
                                  size: 18,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _handleForgotPassword,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Forgot Password?',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: forgotColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              AuroraPrimaryButton(
                                text: 'Log In',
                                onPressed: _handleLogin,
                                isLoading: _isLoading,
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: _handleContinueAsGuest,
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: guestFillColor,
                                    side: BorderSide(
                                        color: guestBorderColor, width: 1.5),
                                    foregroundColor: guestTextColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Continue as Guest',
                                    style: AppTextStyles.buttonMedium.copyWith(
                                      color: guestTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style:
                                          AppTextStyles.bodyMedium.copyWith(
                                        color: dividerTextColor,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _navigateToSignUp,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Sign Up',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                          color: forgotColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                              const Spacer(),

                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: termsColor,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text:
                                            'By continuing, you agree to our '),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: termsStrongColor,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        decorationColor: termsStrongColor,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            _launchUrl('https://google.com'),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: termsStrongColor,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        decorationColor: termsStrongColor,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            _launchUrl('https://google.com'),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
