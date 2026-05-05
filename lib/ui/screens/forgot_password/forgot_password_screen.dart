import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/form_validators.dart';
import '../../reusable_components/app_logo/app_logo.dart';
import '../../reusable_components/auth/auth_legal_footer.dart';
import '../../reusable_components/aurora/aurora_glass_card.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/buttons/theme_toggle_button.dart';
import '../../reusable_components/dropdowns/language_selector.dart';
import '../../reusable_components/floating_emoji/floating_emoji.dart';
import '../../reusable_components/input_fields/aurora_input_field.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      // TODO: POST /auth/forgot-password
      // await ApiService.instance.forgotPassword(email: _emailController.text.trim());
      if (!mounted) return;
      ToastService.instance.showSuccess('Reset link sent to ${_emailController.text.trim()}');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ToastService.instance.showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        final subtitleColor =
            isDark ? AppColors.mutedOnDark : AppColors.auroraDeepBase;

        return Scaffold(
          backgroundColor: bgColor,
          body: Stack(
            children: [
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
                emoji: '🔑',
                size: 36,
                opacity: 0.2,
                top: 80,
                left: 32,
                floatDistance: 15.5,
                rotationAngle: 7.7,
                durationMs: 2200,
              ),
              const FloatingEmoji(
                emoji: '📧',
                size: 30,
                opacity: 0.2,
                top: 160,
                right: 48,
                floatDistance: 14.6,
                rotationAngle: -9.7,
                durationMs: 2400,
              ),
              const FloatingEmoji(
                emoji: '🔒',
                size: 30,
                opacity: 0.2,
                bottom: 128,
                right: 32,
                floatDistance: 14.5,
                rotationAngle: 14.5,
                durationMs: 2100,
              ),
              const FloatingEmoji(
                emoji: '✉️',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                'Forgot Password?',
                                style: AppTextStyles.dsH1
                                    .copyWith(color: headingColor),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Enter your email to receive a reset link',
                                style: AppTextStyles.dsBody
                                    .copyWith(color: subtitleColor),
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
                                        required: true,
                                        hint: 'your@email.com',
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        prefixIcon:
                                            FontAwesomeIcons.solidEnvelope,
                                        textInputAction: TextInputAction.done,
                                        validator: validateEmail,
                                      ),
                                      const SizedBox(height: 20),
                                      AuroraPrimaryButton(
                                        text: 'Send reset link',
                                        onPressed: _handleSendResetLink,
                                        isLoading: _isLoading,
                                      ),
                                      const SizedBox(height: 14),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Remember your password? ',
                                              style: AppTextStyles.dsBody
                                                  .copyWith(
                                                color: subtitleColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                'Log In',
                                                style: AppTextStyles.dsBody
                                                    .copyWith(
                                                  fontSize: 14,
                                                  color: AppColors.auroraPink,
                                                  fontWeight: FontWeight.w700,
                                                  decoration:
                                                      TextDecoration.none,
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
                              const AuthLegalFooter(),
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
