import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/apis/auth_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../services/auth_service.dart';
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
import '../../reusable_components/input_fields/aurora_phone_field.dart';
import '../../screens/splash/widgets/aurora_glow_blob.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey               = GlobalKey<FormState>();
  final _emailController       = TextEditingController();
  final _firstNameController   = TextEditingController();
  final _lastNameController    = TextEditingController();
  final _phoneController       = TextEditingController();
  final _passwordController    = TextEditingController();
  final _confirmController     = TextEditingController();
  final _emailFocusNode      = FocusNode();
  final _firstNameFocusNode  = FocusNode();
  final _lastNameFocusNode   = FocusNode();
  final _phoneFocusNode      = FocusNode();
  final _passwordFocusNode   = FocusNode();
  final _confirmFocusNode    = FocusNode();

  bool _isLoading  = false;
  bool _canSignUp  = false;
  String _dialCode = '+961';
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmError;

  @override
  void initState() {
    super.initState();
    for (final c in [_emailController, _firstNameController, _lastNameController,
        _phoneController, _passwordController, _confirmController]) {
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
        _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
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
      setState(() => _emailError =
          !isValidEmail(_emailController.text) ? 'Enter a valid email address' : null);
    }
  }

  void _onEmailChange() {
    if (_emailError != null && isValidEmail(_emailController.text)) {
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _emailFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await serviceLocator<AuthApi>().register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneCountryCode: _dialCode,
      phoneNumber: _phoneController.text.trim(),
    );

    if (!mounted) return;

    result.fold(
      (_) => setState(() => _isLoading = false),
      (data) async {
        final tokenData = data['data'] as Map<String, dynamic>?;
        if (tokenData != null) {
          await serviceLocator<AuthService>().signIn(tokenData);
        }
        final message = data['message'] as String?;
        if (message != null) ToastService.instance.showSuccess(message);
        if (!mounted) return;
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(
          context,
          emailVerificationScreenRoute,
          arguments: {
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
          },
        );
      },
    );
  }

  void _handleContinueAsGuest() =>
      Navigator.pushReplacementNamed(context, mainScreenRoute);
  void _navigateToSignIn() =>
      Navigator.pushNamed(context, signInScreenRoute);

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
                                      validator: validateEmail,
                                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_firstNameFocusNode),
                                    ),
                                    const SizedBox(height: 14),

                                    // ── First / Last name ──
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: AuroraInputField(
                                            label: 'First name', required: true,
                                            hint: 'Jane',
                                            controller: _firstNameController,
                                            focusNode: _firstNameFocusNode,
                                            keyboardType: TextInputType.name,
                                            prefixIcon: FontAwesomeIcons.solidUser,
                                            textInputAction: TextInputAction.next,
                                            validator: (v) =>
                                                (v == null || v.trim().isEmpty)
                                                    ? 'Required'
                                                    : null,
                                            onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_lastNameFocusNode),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: AuroraInputField(
                                            label: 'Last name', required: true,
                                            hint: 'Doe',
                                            controller: _lastNameController,
                                            focusNode: _lastNameFocusNode,
                                            keyboardType: TextInputType.name,
                                            prefixIcon: FontAwesomeIcons.solidUser,
                                            textInputAction: TextInputAction.next,
                                            validator: (v) =>
                                                (v == null || v.trim().isEmpty)
                                                    ? 'Required'
                                                    : null,
                                            onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_phoneFocusNode),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),

                                    // ── Mobile Number ──
                                    AuroraPhoneField(
                                      label: 'Mobile Number',
                                      required: true,
                                      controller: _phoneController,
                                      focusNode: _phoneFocusNode,
                                      errorText: _phoneError,
                                      onBlur: _onPhoneBlur,
                                      onChanged: _onPhoneChanged,
                                      onCountryChanged: (dialCode) =>
                                          _dialCode = dialCode,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
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
                                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmFocusNode),
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

                            const AuthLegalFooter(),
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
