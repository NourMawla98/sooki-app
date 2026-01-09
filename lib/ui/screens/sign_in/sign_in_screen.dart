import 'package:flutter/material.dart';

import '../../../themes/themes.dart';
import '../../reusable_components/app_logo/app_logo.dart';
import '../../reusable_components/buttons/primary_button.dart';
import '../../reusable_components/floating_emoji/floating_emoji.dart';
import '../../reusable_components/input_fields/custom_text_field.dart';

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

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implement actual sign-in logic
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          // Navigate to main app after successful login
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
        }
      });
    }
  }

  void _navigateToSignUp() {
    // TODO: Navigate to sign-up screen
    // Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
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

          // Floating emojis layer
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

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // Logo
                    const AppLogo(
                      size: LogoSize.medium,
                      isWhiteText: true,
                    ),

                    const SizedBox(height: 60),

                    // Welcome text
                    Text(
                      'Welcome Back!',
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Sign in to continue shopping',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email field
                    CustomTextField(
                      label: 'Email',
                      hintText: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.gray400),
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

                    const SizedBox(height: 20),

                    // Password field
                    CustomTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.gray400),
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

                    const SizedBox(height: 16),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Navigate to forgot password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Sign in button
                    PrimaryButton(
                      text: 'Sign In',
                      onPressed: _handleSignIn,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 24),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                        TextButton(
                          onPressed: _navigateToSignUp,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign Up',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
