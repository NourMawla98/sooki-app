import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/apis/auth_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../enums/app_language.dart';
import '../../../routes/route_constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/language_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../services/token_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../dialogs/aurora_confirm_sheet.dart';

/// Aurora glass user menu rendered as a 2×2 grid of tinted tiles. Items:
/// Profile (blue tint) · Language (purple tint) · Theme (neutral) ·
/// Logout (pink tint). Tapping Language swaps the body to a 3-item picker.
class UserMenuDropdown extends StatefulWidget {
  final VoidCallback onClose;

  const UserMenuDropdown({super.key, required this.onClose});

  @override
  State<UserMenuDropdown> createState() => _UserMenuDropdownState();
}

class _UserMenuDropdownState extends State<UserMenuDropdown> {
  bool _showLanguagePicker = false;
  late final LanguageService _languageService =
      serviceLocator<LanguageService>();
  late final AuthService _authService = serviceLocator<AuthService>();

  @override
  void initState() {
    super.initState();
    _authService.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  void _goToSignIn() {
    widget.onClose();
    Navigator.pushNamed(context, signInScreenRoute);
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    await showAuroraConfirmSheet(
      context,
      title: 'common.logout'.tr(),
      subtitle: 'user_menu_dropdown.logout_confirm'.tr(),
      icon: FontAwesomeIcons.rightFromBracket,
      iconColor: AppColors.auroraPink,
      confirmLabel: 'common.logout'.tr(),
      confirmColor: AppColors.auroraPink,
      cancelLabel: 'common.cancel'.tr(),
      onConfirm: () async {
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
        await _authService.signOut(guestTokenData: guestTokenData);
        if (toastMessage != null) ToastService.instance.showSuccess(toastMessage!);
      },
    );
  }

  Future<void> _pickLanguage(AppLanguage language) async {
    await _languageService.setLanguage(language, context: context);
    if (!mounted) return;
    setState(() => _showLanguagePicker = false);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark
            ? AppColors.auroraDeepBase.withValues(alpha: 0.92)
            : AppColors.white.withValues(alpha: 0.98);
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.gray200;

        return SizedBox(
          width: 280,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: _showLanguagePicker
                    ? _buildLanguagePicker(isDark)
                    : _buildTileGrid(context, isDark),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTileGrid(BuildContext ctx, bool isDark) {
    final themeValue =
        isDark ? 'user_menu_dropdown.dark'.tr() : 'user_menu_dropdown.light'.tr();
    final langValue = _languageService.currentLanguage.displayName;
    final mutedOnTile = AppColors.white.withValues(alpha: 0.7);
    final mutedOnTileLight = AppColors.primaryPurple.withValues(alpha: 0.7);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _Tile(
                icon: FontAwesomeIcons.user,
                label: 'user_menu_dropdown.profile'.tr(),
                sub: 'user_menu_dropdown.view_account'.tr(),
                accent: AppColors.auroraElectricBlue,
                isDark: isDark,
                subColor: isDark ? mutedOnTile : mutedOnTileLight,
                onTap: () {
                  widget.onClose();
                  Navigator.pushNamed(ctx, profileScreenRoute);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Tile(
                icon: FontAwesomeIcons.globe,
                label: 'user_menu_dropdown.language'.tr(),
                sub: langValue,
                accent: AppColors.auroraPurple,
                isDark: isDark,
                subColor: isDark ? mutedOnTile : mutedOnTileLight,
                onTap: () =>
                    setState(() => _showLanguagePicker = true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _Tile(
                icon: isDark ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
                label: 'user_menu_dropdown.theme'.tr(),
                sub: themeValue,
                accent: AppColors.verifiedGreen,
                isDark: isDark,
                subColor: AppColors.verifiedGreen.withValues(alpha: 0.75),
                onTap: () => ThemeService.instance.toggle(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _authService.isCustomer
                  ? _Tile(
                      icon: FontAwesomeIcons.rightFromBracket,
                      label: 'common.logout'.tr(),
                      accent: AppColors.auroraPink,
                      isDark: isDark,
                      subColor: AppColors.auroraPink.withValues(alpha: 0.75),
                      labelColor: AppColors.auroraPink,
                      onTap: () {
                        widget.onClose();
                        _showLogoutDialog(ctx);
                      },
                    )
                  : _Tile(
                      icon: FontAwesomeIcons.rightToBracket,
                      label: 'user_menu_dropdown.log_in'.tr(),
                      sub: '',
                      accent: AppColors.auroraPink,
                      isDark: isDark,
                      subColor: AppColors.auroraPink.withValues(alpha: 0.75),
                      labelColor: AppColors.auroraPink,
                      onTap: _goToSignIn,
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguagePicker(bool isDark) {
    final current = _languageService.currentLanguage;
    final textColor = isDark ? AppColors.white : AppColors.primaryPurple;
    final divider = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.gray100;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PickerRow(
          icon: isRtl
              ? FontAwesomeIcons.chevronRight
              : FontAwesomeIcons.chevronLeft,
          label: 'user_menu_dropdown.language'.tr(),
          color: textColor,
          onTap: () => setState(() => _showLanguagePicker = false),
        ),
        Divider(height: 1, thickness: 1, color: divider),
        for (var i = 0; i < AppLanguage.values.length; i++) ...[
          _PickerRow(
            icon: AppLanguage.values[i] == current
                ? FontAwesomeIcons.solidCircleDot
                : FontAwesomeIcons.circle,
            label: AppLanguage.values[i].displayName,
            color: AppLanguage.values[i] == current
                ? AppColors.auroraElectricBlue
                : textColor,
            onTap: () => _pickLanguage(AppLanguage.values[i]),
          ),
          if (i < AppLanguage.values.length - 1)
            Divider(height: 1, thickness: 1, color: divider),
        ],
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String sub;
  final Color accent;
  final Color subColor;
  final Color? labelColor;
  final bool isDark;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.label,
    this.sub = '',
    required this.accent,
    required this.subColor,
    required this.isDark,
    required this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final textOnTile =
        labelColor ?? (isDark ? AppColors.white : AppColors.primaryPurple);
    final baseAlpha = isDark ? 0.28 : 0.22;
    final fadeAlpha = isDark ? 0.08 : 0.06;
    final borderAlpha = isDark ? 0.40 : 0.45;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 92,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent.withValues(alpha: baseAlpha),
                accent.withValues(alpha: fadeAlpha),
              ],
            ),
            border: Border.all(color: accent.withValues(alpha: borderAlpha)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FaIcon(icon, size: 18, color: accent),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textOnTile,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: AppTextStyles.captionSmall.copyWith(
                      color: subColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PickerRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: Row(
          children: [
            FaIcon(icon, size: 14, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
