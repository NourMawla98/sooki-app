import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/route_constants.dart';
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
import '../../reusable_components/input_fields/aurora_phone_field.dart';
import '../../screens/splash/widgets/aurora_glow_blob.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey             = GlobalKey<FormState>();
  final _emailController     = TextEditingController();
  final _fullNameController  = TextEditingController();
  final _phoneController     = TextEditingController();
  final _passwordController  = TextEditingController();
  final _confirmController   = TextEditingController();
  final _emailFocusNode      = FocusNode();
  final _passwordFocusNode   = FocusNode();
  final _confirmFocusNode    = FocusNode();

  bool _isLoading  = false;
  bool _canSignUp  = false;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmError;

  static final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();
    for (final c in [_emailController, _fullNameController, _phoneController,
        _passwordController, _confirmController]) {
      c.addListener(_onFieldsChanged);
    }
    _emailController.addListener(_onEmailChange);
    _emailFocusNode.addListener(_onEmailBlur);
    _passwordController.addListener(_onPasswordChange);
    _passwordFocusNode.addListener(_onPasswordBlur);
    _confirmFocusNode.addListener(_onConfirmBlur);
  }

  void _onFieldsChanged() {
    final allFilled = _emailController.text.isNotEmpty &&
        _fullNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmController.text.isNotEmpty;
    final passwordsMatch =
        _confirmController.text == _passwordController.text;
    final can = allFilled && passwordsMatch;
    if (can != _canSignUp) setState(() => _canSignUp = can);
  }

  void _onEmailBlur() {
    if (!_emailFocusNode.hasFocus && _emailController.text.isNotEmpty) {
      final invalid = !_emailRegex.hasMatch(_emailController.text);
      setState(() => _emailError = invalid ? 'Enter a valid email address' : null);
    }
  }

  void _onEmailChange() {
    if (_emailError != null && _emailRegex.hasMatch(_emailController.text)) {
      setState(() => _emailError = null);
    }
  }

  void _onConfirmBlur() {
    if (!_confirmFocusNode.hasFocus) {
      final mismatch = _confirmController.text.isNotEmpty &&
          _confirmController.text != _passwordController.text;
      setState(() => _confirmError = mismatch ? 'Passwords do not match' : null);
    }
  }

  void _onPasswordBlur() {
    if (!_passwordFocusNode.hasFocus && _passwordController.text.isNotEmpty) {
      final tooShort = _passwordController.text.length < 6;
      setState(() => _passwordError = tooShort ? 'Minimum 6 characters' : null);
    }
  }

  void _onPasswordChange() {
    if (_passwordError != null && _passwordController.text.length >= 6) {
      setState(() => _passwordError = null);
    }
    if (_confirmController.text.isNotEmpty) {
      final match = _confirmController.text == _passwordController.text;
      final newErr = match ? null : 'Passwords do not match';
      if (newErr != _confirmError) setState(() => _confirmError = newErr);
    }
  }

  void _onPhoneBlur() {
    final digits = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (_phoneController.text.isNotEmpty && digits.length < 5) {
      setState(() => _phoneError = 'Enter a valid phone number');
    }
  }

  void _onPhoneChanged(String value) {
    if (_phoneError != null) {
      final digits = value.replaceAll(RegExp(r'[^\d]'), '');
      if (digits.length >= 5) setState(() => _phoneError = null);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.pushReplacementNamed(
            context,
            emailVerificationScreenRoute,
            arguments: _emailController.text.trim(),
          );
        }
      });
    }
  }

  void _handleContinueAsGuest() =>
      Navigator.pushReplacementNamed(context, mainScreenRoute);
  void _navigateToSignIn() =>
      Navigator.pushNamed(context, signInScreenRoute);
  Future<void> _launchUrl(String url) async =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark       = ThemeService.instance.isDarkMode;
        final bgColor      = isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final headingColor = isDark ? AppColors.white : AppColors.auroraPurple;

        return Scaffold(
          body: Stack(
            children: [
              Container(width: double.infinity, height: double.infinity, color: bgColor),
              AuroraGlowBlob(top: -100, right: -100, size: 280,
                  color: AppColors.auroraPurple, intensity: isDark ? 0.20 : 0.10),
              AuroraGlowBlob(bottom: -100, left: -100, size: 300,
                  color: AppColors.auroraElectricBlue, intensity: isDark ? 0.18 : 0.08),
              const FloatingEmoji(emoji: '🛍️', size: 36, opacity: 0.2,
                  top: 80, left: 32, floatDistance: 15.5, rotationAngle: 7.7, durationMs: 2200),
              const FloatingEmoji(emoji: '❤️', size: 30, opacity: 0.2,
                  top: 160, right: 48, floatDistance: 14.6, rotationAngle: -9.7, durationMs: 2400),
              const FloatingEmoji(emoji: '⭐', size: 30, opacity: 0.2,
                  bottom: 128, right: 32, floatDistance: 14.5, rotationAngle: 14.5, durationMs: 2100),
              const FloatingEmoji(emoji: '🎁', size: 36, opacity: 0.2,
                  bottom: 80, left: 48, floatDistance: 18.5, rotationAngle: -13.9, durationMs: 2300),

              SafeArea(
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [LanguageSelector(), ThemeToggleButton()],
                            ),
                            const SizedBox(height: 24),
                            AppLogo(size: LogoSize.medium, isWhiteText: isDark),
                            const SizedBox(height: 20),
                            Text('Create Account',
                                style: AppTextStyles.dsH1.copyWith(color: headingColor)),
                            const SizedBox(height: 8),
                            Text('Sign up to start shopping',
                                style: AppTextStyles.dsBody.copyWith(
                                  color: isDark ? AppColors.mutedOnDark : AppColors.auroraDeepBase,
                                )),
                            const Spacer(flex: 1),

                            AuroraGlassCard(
                              padding: const EdgeInsets.all(22),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    // ── Email ──
                                    AuroraInputField(
                                      label: 'Email', required: true,
                                      hint: 'your@email.com',
                                      controller: _emailController,
                                      focusNode: _emailFocusNode,
                                      errorText: _emailError,
                                      keyboardType: TextInputType.emailAddress,
                                      prefixIcon: FontAwesomeIcons.solidEnvelope,
                                      textInputAction: TextInputAction.next,
                                      validator: (v) {
                                        if (v == null || v.isEmpty) return 'Please enter your email';
                                        if (!RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$').hasMatch(v)) return 'Enter a valid email';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 14),

                                    // ── Full Name ──
                                    AuroraInputField(
                                      label: 'Full Name', required: true,
                                      hint: 'Jane Doe',
                                      controller: _fullNameController,
                                      keyboardType: TextInputType.name,
                                      prefixIcon: FontAwesomeIcons.solidUser,
                                      textInputAction: TextInputAction.next,
                                      validator: (v) =>
                                          (v == null || v.trim().isEmpty)
                                              ? 'Required'
                                              : null,
                                    ),
                                    const SizedBox(height: 14),

                                    // ── Mobile Number ──
                                    AuroraPhoneField(
                                      label: 'Mobile Number',
                                      required: true,
                                      controller: _phoneController,
                                      errorText: _phoneError,
                                      onBlur: _onPhoneBlur,
                                      onChanged: _onPhoneChanged,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(height: 14),

                                    // ── Password ──
                                    AuroraInputField(
                                      label: 'Password', required: true,
                                      hint: '••••••••',
                                      controller: _passwordController,
                                      focusNode: _passwordFocusNode,
                                      errorText: _passwordError,
                                      isPassword: true,
                                      prefixIcon: FontAwesomeIcons.lock,
                                      textInputAction: TextInputAction.next,
                                      validator: (v) {
                                        if ((v?.length ?? 0) < 6) return 'Minimum 6 characters';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 14),

                                    // ── Confirm Password ──
                                    AuroraInputField(
                                      label: 'Confirm Password', required: true,
                                      hint: '••••••••',
                                      controller: _confirmController,
                                      focusNode: _confirmFocusNode,
                                      isPassword: true,
                                      prefixIcon: FontAwesomeIcons.lockOpen,
                                      textInputAction: TextInputAction.done,
                                      errorText: _confirmError,
                                      validator: (v) {
                                        if (v != _passwordController.text) return 'Passwords do not match';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    AuroraPrimaryButton(
                                      text: 'Sign up',
                                      onPressed: _canSignUp ? _handleSignUp : null,
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Already have an account? ',
                                            style: AppTextStyles.dsBody.copyWith(
                                              color: isDark
                                                  ? AppColors.mutedOnDark
                                                  : AppColors.auroraDeepBase,
                                              fontSize: 14,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _navigateToSignIn,
                                            child: Text('Log in',
                                              style: AppTextStyles.dsBody.copyWith(
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
                                  const TextSpan(text: 'By continuing, you agree to our '),
                                  TextSpan(
                                    text: 'Terms',
                                    style: AppTextStyles.dsMuted.copyWith(
                                      fontSize: 12, color: AppColors.auroraPink,
                                      fontWeight: FontWeight.w700, decoration: TextDecoration.none,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => _launchUrl('https://google.com'),
                                  ),
                                  const TextSpan(text: ' & '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: AppTextStyles.dsMuted.copyWith(
                                      fontSize: 12, color: AppColors.auroraPink,
                                      fontWeight: FontWeight.w700, decoration: TextDecoration.none,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => _launchUrl('https://google.com'),
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
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
