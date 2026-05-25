import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/apis/auth_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../routes/route_constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/wishlist_service.dart';
import '../../../services/cart_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/app_logo/app_logo.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/aurora/aurora_secondary_button.dart';
import '../../screens/splash/widgets/aurora_glow_blob.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String password;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  static const _cooldownSeconds = 60;
  int _secondsLeft = _cooldownSeconds;
  Timer? _timer;
  bool _isResending = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  Future<void> _handleDoneVerification() async {
    if (_isVerifying) return;
    setState(() => _isVerifying = true);

    final result = await serviceLocator<AuthApi>().login(
      email: widget.email,
      password: widget.password,
    );

    if (!mounted) return;

    await result.fold(
      (err) async {
        setState(() => _isVerifying = false);
        ToastService.instance.showError(
          err.message.isNotEmpty ? err.message : 'Login failed. Please verify your email first.',
        );
      },
      (data) async {
        final tokenData = data['data'] as Map<String, dynamic>?;
        if (tokenData != null) {
          await serviceLocator<AuthService>().signIn(tokenData);
          await serviceLocator<WishlistService>().loadFromServer();
          await serviceLocator<CartService>().loadFromServer();
        }
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, mainScreenRoute);
      },
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _resend() async {
    if (_secondsLeft > 0 || _isResending) return;
    setState(() => _isResending = true);

    final result = await serviceLocator<AuthApi>().resendVerification(
      email: widget.email,
    );

    if (!mounted) return;
    setState(() => _isResending = false);

    result.fold(
      (_) {},
      (data) {
        final message = data['message'] as String?;
        if (message != null) ToastService.instance.showSuccess(message);
        setState(() => _secondsLeft = _cooldownSeconds);
        _startTimer();
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerLabel {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
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
        final bodyColor =
            isDark ? AppColors.white : AppColors.auroraDeepBase;

        return Scaffold(
          backgroundColor: bgColor,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -100, right: -100, size: 280,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -100, left: -100, size: 300,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppLogo(
                          size: LogoSize.medium,
                          isWhiteText: isDark,
                        ),
                      ),

                      const Spacer(),

                      // Envelope icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(
                            colors: AppColors.auroraGradient,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.auroraPink
                                  .withValues(alpha: 0.30),
                              blurRadius: 28,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.envelope,
                            size: 32,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Verify your email',
                        style: AppTextStyles.dsH1.copyWith(
                          color: headingColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'We sent a verification link to',
                        style: AppTextStyles.dsBody.copyWith(
                          color: bodyColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.email,
                        style: AppTextStyles.dsBody.copyWith(
                          color: AppColors.auroraPink,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Can't find it? Check your spam or junk folder.",
                        style: AppTextStyles.dsBody.copyWith(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.white.withValues(alpha: 0.45)
                              : AppColors.auroraDeepBase.withValues(alpha: 0.45),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 36),

                      if (widget.password.isNotEmpty) ...[
                        AuroraPrimaryButton(
                          text: "I've verified my email",
                          isLoading: _isVerifying,
                          onPressed: _handleDoneVerification,
                        ),
                        const SizedBox(height: 12),
                      ],
                      AuroraSecondaryButton(
                        text: 'Continue as guest',
                        height: 52,
                        onPressed: () async {
                          await serviceLocator<AuthService>().signOut();
                          if (!context.mounted) return;
                          Navigator.pushReplacementNamed(
                              context, mainScreenRoute);
                        },
                      ),
                      const SizedBox(height: 24),

                      // Resend row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive it? ",
                            style: AppTextStyles.dsBody.copyWith(
                              fontSize: 13,
                              color: bodyColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: _resend,
                            child: Opacity(
                              opacity: (_secondsLeft > 0 || _isResending) ? 0.45 : 1.0,
                              child: Text(
                                'Resend',
                                style: AppTextStyles.dsBody.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.auroraPink,
                                ),
                              ),
                            ),
                          ),
                          if (_secondsLeft > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.white.withValues(alpha: 0.06)
                                    : AppColors.auroraPurple
                                        .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _timerLabel,
                                style: AppTextStyles.dsBody.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.white.withValues(alpha: 0.38)
                                      : AppColors.auroraPurple
                                          .withValues(alpha: 0.55),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
