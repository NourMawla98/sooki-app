import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../backend_integration/apis/auth_api.dart';
import '../../../backend_integration/apis/profile_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../routes/route_constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/orders_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../services/token_service.dart';
import '../../../services/user_profile_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/aurora/aurora_primary_button.dart';
import '../../reusable_components/aurora/aurora_secondary_button.dart';
import '../../reusable_components/dialogs/aurora_confirm_sheet.dart';
import '../splash/widgets/aurora_glow_blob.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_menu_list.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static final _auth = GetIt.instance<AuthService>();
  static final _ordersService = GetIt.instance<OrdersService>();

  @override
  void initState() {
    super.initState();
    if (_auth.isCustomer) {
      _loadProfile();
      _ordersService.refreshActiveCount();
    }
  }

  Future<void> _loadProfile() async {
    final result = await serviceLocator<ProfileApi>().getProfile();
    if (!mounted) return;
    result.fold(
      (_) => null,
      (dto) => serviceLocator<UserProfileService>().updateFromDto(dto),
    );
  }

  Future<void> _refresh() async {
    if (_auth.isCustomer) {
      await Future.wait([
        _loadProfile(),
        _ordersService.refreshActiveCount(),
      ]);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService.instance, _auth, _ordersService]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final isLoggedIn = _auth.isCustomer;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -80,
                right: -80,
                size: 260,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: 80,
                left: -80,
                size: 280,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(isDark: isDark),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        color: AppColors.auroraPink,
                        child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isLoggedIn)
                              const ProfileHeaderCard()
                            else
                              _GuestHero(isDark: isDark),
                            ProfileMenuList(
                              isDark: isDark,
                              isLoggedIn: isLoggedIn,
                              activeOrderCount: isLoggedIn ? _ordersService.activeOrderCount : 0,
                            ),
                            if (isLoggedIn) _SignOutRow(isDark: isDark),
                            const SizedBox(height: 12),
                            Center(
                              child: Text(
                                'Sooki v1.0.0',
                                style: AppTextStyles.captionSmall.copyWith(
                                  color: isDark
                                      ? AppColors.white.withValues(alpha: 0.15)
                                      : AppColors.auroraPurple
                                          .withValues(alpha: 0.25),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ),
                      ),
                    ),
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        isDark ? AppColors.white : AppColors.auroraPurple;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              size: 20,
              color: iconColor,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Profile',
              style: AppTextStyles.heading3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: iconColor,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestHero extends StatelessWidget {
  const _GuestHero({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.06)
                  : AppColors.auroraPurple.withValues(alpha: 0.06),
              border: Border.all(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.18)
                    : AppColors.auroraPurple.withValues(alpha: 0.25),
              ),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.user,
                size: 24,
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.3)
                    : AppColors.auroraPurple.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "You're not signed in",
            style: AppTextStyles.heading4.copyWith(
              color: isDark ? AppColors.white : AppColors.auroraDeepBase,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to access your orders, wishlist, addresses and loyalty points.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.4)
                  : AppColors.auroraPurple.withValues(alpha: 0.55),
              height: 1.5,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AuroraPrimaryButton(
                  text: 'Login',
                  height: 42,
                  borderRadius: 100,
                  onPressed: () =>
                      Navigator.pushNamed(context, signInScreenRoute),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AuroraSecondaryButton(
                  text: 'Sign Up',
                  height: 42,
                  borderRadius: 100,
                  onPressed: () =>
                      Navigator.pushNamed(context, signUpScreenRoute),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SignOutRow extends StatefulWidget {
  const _SignOutRow({required this.isDark});

  final bool isDark;

  @override
  State<_SignOutRow> createState() => _SignOutRowState();
}

class _SignOutRowState extends State<_SignOutRow> {
  bool _isLoading = false;

  Future<void> _handleSignOut() async {
    final confirmed = await showAuroraConfirmSheet(
      context,
      title: 'Logout',
      subtitle: 'Are you sure you want to logout?',
      icon: FontAwesomeIcons.rightFromBracket,
      confirmLabel: 'Logout',
    );
    if (!confirmed || !mounted) return;

    setState(() => _isLoading = true);
    final refreshToken = await TokenService.instance.getRefreshToken();
    String? toastMessage;
    Map<String, dynamic>? guestTokenData;
    if (refreshToken != null) {
      final result = await serviceLocator<AuthApi>().logout(refreshToken: refreshToken);
      result.fold(
        (_) => null,
        (data) {
          toastMessage = data['message'] as String?;
          guestTokenData = data['data'] as Map<String, dynamic>?;
        },
      );
    }
    if (!mounted) return;
    await GetIt.instance<AuthService>().signOut(guestTokenData: guestTokenData);
    await serviceLocator<UserProfileService>().clear();
    if (toastMessage != null) {
      ToastService.instance.showSuccess(toastMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return GestureDetector(
      onTap: _isLoading ? null : _handleSignOut,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.auroraRed.withValues(alpha: isDark ? 0.05 : 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.auroraRed
                .withValues(alpha: isDark ? 0.18 : 0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.auroraRed
                    .withValues(alpha: isDark ? 0.12 : 0.09),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: _isLoading
                    ? SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.auroraRed,
                        ),
                      )
                    : const FaIcon(
                        FontAwesomeIcons.rightFromBracket,
                        size: 15,
                        color: AppColors.auroraRed,
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              'Logout',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.auroraRed,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
