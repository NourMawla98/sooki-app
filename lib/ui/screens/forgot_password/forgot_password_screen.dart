import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/route_constants.dart';
import '../../../themes/themes.dart';
import '../../reusable_components/app_logo/app_logo.dart';
import '../../reusable_components/buttons/primary_button.dart';
import '../../reusable_components/buttons/theme_toggle_button.dart';
import '../../reusable_components/dropdowns/language_selector.dart';
import '../../reusable_components/floating_emoji/floating_emoji.dart';
import '../../reusable_components/input_fields/custom_text_field.dart';

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

  void _handleSendResetLink() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implement actual forgot password logic
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Password reset link sent to ${_emailController.text}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
              backgroundColor: AppColors.primaryPurple,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          // Navigate back to sign in screen after success
          Navigator.pop(context);
        }
      });
    }
  }

  void _navigateBackToSignIn() {
    Navigator.pop(context);
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Handle error silently for now
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.splashGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Ombre gradient overlays
          // Orange glow - top right
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentRed.withValues(alpha: 0.3),
                    AppColors.accentRed.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Blue glow - bottom left
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4FC3F7).withValues(alpha: 0.4),
                    const Color(0xFF4FC3F7).withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Floating emojis layer
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

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Language selector and theme toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      LanguageSelector(),
                      SizedBox(width: 12),
                      ThemeToggleButton(),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Logo
                  const AppLogo(
                    size: LogoSize.medium,
                    isWhiteText: true,
                  ),

                  const SizedBox(height: 32),

                  // Welcome text
                  Text(
                    'Forgot Password?',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.white,
                      fontSize: 32,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Enter your email to receive a password reset link',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // White card container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email field
                          CustomTextField(
                            label: 'Email',
                            hintText: 'your@email.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.gray400,
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

                          const SizedBox(height: 24),

                          // Send reset link button
                          PrimaryButton(
                            text: 'Send Reset Link',
                            onPressed: _handleSendResetLink,
                            isLoading: _isLoading,
                          ),

                          const SizedBox(height: 16),

                          // Back to log in link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Remember your password? ',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: _navigateBackToSignIn,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Log In',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primaryPurple,
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

                  const SizedBox(height: 24),

                  // Terms and privacy policy
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                      children: [
                        const TextSpan(text: 'By continuing, you agree to our '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.white,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchUrl('https://google.com'),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.white,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchUrl('https://google.com'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
