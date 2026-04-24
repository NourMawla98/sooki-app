import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/route_constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/app_logo/app_logo.dart';
import '../../reusable_components/aurora/aurora_glass_card.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/aurora/aurora_secondary_button.dart';
import '../../reusable_components/buttons/theme_toggle_button.dart';
import '../../reusable_components/dropdowns/language_selector.dart';
import '../../reusable_components/floating_emoji/floating_emoji.dart';
import '../../reusable_components/input_fields/aurora_input_field.dart';
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
      Future.delayed(const Duration(seconds: 2), () async {
        if (!mounted) return;
        await GetIt.instance<AuthService>().signIn();
        if (!mounted) return;
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, mainScreenRoute);
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
    Navigator.pushReplacementNamed(context, signUpScreenRoute);
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
        final bgColor =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final headingColor =
            isDark ? AppColors.white : AppColors.auroraPurple;

        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: bgColor,
              ),

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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  LanguageSelector(),
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
                                style: AppTextStyles.dsH1.copyWith(
                                    color: headingColor),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Log in to your account',
                                style: AppTextStyles.dsBody.copyWith(
                                  color: isDark
                                      ? AppColors.mutedOnDark
                                      : AppColors.auroraDeepBase,
                                ),
                              ),

                              const Spacer(flex: 1),

                              AuroraGlassCard(
                                padding: const EdgeInsets.all(22),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AuroraInputField(
                                        label: 'Email',
                                        hint: 'your@email.com',
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        prefixIcon:
                                            FontAwesomeIcons.solidEnvelope,
                                        textInputAction:
                                            TextInputAction.next,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      AuroraInputField(
                                        label: 'Password',
                                        hint: '••••••••',
                                        controller: _passwordController,
                                        isPassword: true,
                                        prefixIcon: FontAwesomeIcons.lock,
                                        textInputAction:
                                            TextInputAction.done,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
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
                                        child: GestureDetector(
                                          onTap: _handleForgotPassword,
                                          child: Text(
                                            'Forgot Password?',
                                            style: AppTextStyles.dsBody
                                                .copyWith(
                                              fontSize: 14,
                                              color: AppColors.auroraPink,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      AuroraPrimaryButton(
                                        text: 'LOG IN',
                                        onPressed: _handleLogin,
                                        isLoading: _isLoading,
                                      ),
                                      const SizedBox(height: 12),
                                      AuroraSecondaryButton(
                                        text: 'CONTINUE AS GUEST',
                                        onPressed: _handleContinueAsGuest,
                                        height: 48,
                                      ),
                                      const SizedBox(height: 14),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Don't have an account? ",
                                              style: AppTextStyles.dsBody
                                                  .copyWith(
                                                      color: isDark ? AppColors.mutedOnDark : AppColors.auroraDeepBase,
                                                      fontSize: 14),
                                            ),
                                            GestureDetector(
                                              onTap: _navigateToSignUp,
                                              child: Text(
                                                'Sign Up',
                                                style: AppTextStyles.dsBody
                                                    .copyWith(
                                                  fontSize: 14,
                                                  color: AppColors.auroraPink,
                                                  fontWeight: FontWeight.w700,
                                                  decoration: TextDecoration.none,
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

                              const Spacer(flex: 3),

                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: AppTextStyles.dsMuted.copyWith(
                                    color: isDark ? AppColors.mutedOnDark : AppColors.auroraDeepBase,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text:
                                            'By continuing, you agree to our '),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: AppTextStyles.dsMuted.copyWith(
                                        fontSize: 12,
                                        color: AppColors.auroraPink,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            _launchUrl('https://google.com'),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: AppTextStyles.dsMuted.copyWith(
                                        fontSize: 12,
                                        color: AppColors.auroraPink,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none,
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
