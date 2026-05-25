import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/apis/auth_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../routes/route_constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/form_validators.dart';
import '../../reusable_components/app_logo/app_logo.dart';
import '../../reusable_components/auth/auth_legal_footer.dart';
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
  final _emailFocusNode = FocusNode();
  bool _isLoading = false;
  bool _canLogin = false;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFieldsChanged);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onFieldsChanged);
    _emailFocusNode.addListener(_onEmailBlur);
  }

  void _onFieldsChanged() {
    final canLogin = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    if (canLogin != _canLogin) setState(() => _canLogin = canLogin);
  }

  void _onEmailBlur() {
    if (!_emailFocusNode.hasFocus && _emailController.text.isNotEmpty) {
      setState(() => _emailError =
          !isValidEmail(_emailController.text) ? 'Enter a valid email address' : null);
    }
  }

  void _onEmailChange() {
    if (_emailError != null && isValidEmail(_emailController.text)) {
      setState(() => _emailError = null);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final result = await serviceLocator<AuthApi>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    result.fold(
      (_) => setState(() => _isLoading = false),
      (data) async {
        final tokenData = data['data'] as Map<String, dynamic>?;
        if (tokenData != null) {
          await serviceLocator<AuthService>().signIn(tokenData);
        }
        if (!mounted) return;
        setState(() => _isLoading = false);
        final message = data['message'] as String?;
        Navigator.pushReplacementNamed(context, mainScreenRoute);
        if (message != null) {
          Future.delayed(const Duration(milliseconds: 400), () {
            ToastService.instance.showSuccess(message);
          });
        }
      },
    );
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
                                        required: true,
                                        hint: 'your@email.com',
                                        controller: _emailController,
                                        focusNode: _emailFocusNode,
                                        errorText: _emailError,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        prefixIcon:
                                            FontAwesomeIcons.solidEnvelope,
                                        textInputAction:
                                            TextInputAction.next,
                                        validator: validateEmail,
                                      ),
                                      const SizedBox(height: 16),
                                      AuroraInputField(
                                        label: 'Password',
                                        required: true,
                                        hint: '••••••••',
                                        controller: _passwordController,
                                        isPassword: true,
                                        prefixIcon: FontAwesomeIcons.lock,
                                        textInputAction:
                                            TextInputAction.done,
                                        validator: (value) {
                                          if ((value?.length ?? 0) < 6) {
                                            return 'Minimum 6 characters';
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
                                        text: 'Login',
                                        onPressed: _canLogin ? _handleLogin : null,
                                        isLoading: _isLoading,
                                      ),
                                      const SizedBox(height: 12),
                                      AuroraSecondaryButton(
                                        text: 'Continue as guest',
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
