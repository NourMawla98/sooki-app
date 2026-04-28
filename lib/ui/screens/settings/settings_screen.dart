import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/dialogs/aurora_confirm_sheet.dart';
import '../../reusable_components/toggles/aurora_switch.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -80,
                right: -80,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -80,
                left: -80,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(isDark: isDark),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _GroupLabel(label: 'Appearance', isDark: isDark),
                            _GroupCard(
                              isDark: isDark,
                              children: [
                                _ToggleRow(
                                  isDark: isDark,
                                  iconBg: AppColors.auroraPurple.withValues(
                                      alpha: isDark ? 0.15 : 0.10),
                                  iconColor: AppColors.auroraPurple,
                                  icon: FontAwesomeIcons.moon,
                                  title: 'Dark Mode',
                                  subtitle: 'Switch to dark theme',
                                  value: isDark,
                                  onChanged: (_) =>
                                      ThemeService.instance.toggle(),
                                ),
                                _Divider(isDark: isDark),
                                _ChevronRow(
                                  isDark: isDark,
                                  iconBg: AppColors.auroraPurple.withValues(
                                      alpha: isDark ? 0.15 : 0.10),
                                  iconColor: AppColors.auroraPurple,
                                  icon: FontAwesomeIcons.globe,
                                  title: 'Language',
                                  subtitle: _language,
                                  onTap: () => _showLanguagePicker(isDark),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _GroupLabel(label: 'Notifications', isDark: isDark),
                            _GroupCard(
                              isDark: isDark,
                              children: [
                                _ToggleRow(
                                  isDark: isDark,
                                  iconBg: AppColors.auroraGold.withValues(
                                      alpha: isDark ? 0.15 : 0.12),
                                  iconColor: AppColors.auroraGold,
                                  icon: FontAwesomeIcons.bell,
                                  title: 'Push Notifications',
                                  subtitle: 'Order updates & offers',
                                  value: _pushNotifications,
                                  onChanged: (v) =>
                                      setState(() => _pushNotifications = v),
                                ),
                                _Divider(isDark: isDark),
                                _ToggleRow(
                                  isDark: isDark,
                                  iconBg: AppColors.auroraElectricBlue
                                      .withValues(
                                          alpha: isDark ? 0.15 : 0.10),
                                  iconColor: AppColors.auroraElectricBlue,
                                  icon: FontAwesomeIcons.envelope,
                                  title: 'Email Notifications',
                                  subtitle: 'Receipts & newsletters',
                                  value: _emailNotifications,
                                  onChanged: (v) =>
                                      setState(() => _emailNotifications = v),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _GroupLabel(label: 'Account', isDark: isDark),
                            _GroupCard(
                              isDark: isDark,
                              children: [
                                _ChevronRow(
                                  isDark: isDark,
                                  iconBg: const Color(0xFFFB923C).withValues(
                                      alpha: isDark ? 0.15 : 0.12),
                                  iconColor: const Color(0xFFFB923C),
                                  icon: FontAwesomeIcons.lock,
                                  title: 'Change Password',
                                  subtitle: 'Update your password',
                                  onTap: () => Navigator.pushNamed(
                                      context, changePasswordScreenRoute),
                                ),
                                _Divider(isDark: isDark),
                                _ChevronRow(
                                  isDark: isDark,
                                  iconBg: AppColors.auroraRed.withValues(
                                      alpha: isDark ? 0.12 : 0.10),
                                  iconColor: AppColors.auroraRed,
                                  icon: FontAwesomeIcons.trashCan,
                                  title: 'Delete Account',
                                  subtitle: 'Permanently delete your data',
                                  isDestructive: true,
                                  onTap: () => showAuroraConfirmSheet(
                                    context,
                                    title: 'Delete Account',
                                    subtitle:
                                        'This action is permanent and cannot be undone.',
                                    icon: FontAwesomeIcons.trashCan,
                                    iconColor: AppColors.auroraRed,
                                    confirmLabel: 'Delete',
                                    confirmColor: AppColors.auroraRed,
                                    onConfirm: () {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Center(
                              child: Text(
                                'Sooki v1.0.0',
                                style: AppTextStyles.caption.copyWith(
                                  color: isDark
                                      ? AppColors.white.withValues(alpha: 0.18)
                                      : AppColors.auroraPurple
                                          .withValues(alpha: 0.28),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
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

  void _showLanguagePicker(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _LanguageSheet(
        isDark: isDark,
        selected: _language,
        onSelect: (lang) {
          setState(() => _language = lang);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ─── Top bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final bool isDark;
  const _TopBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final iconColor =
        isDark ? AppColors.white : AppColors.auroraPurple;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 20, color: iconColor),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Text(
            'Settings',
            style: AppTextStyles.heading3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _GroupLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.dsSectionLabel.copyWith(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.28)
              : AppColors.auroraPurple.withValues(alpha: 0.45),
          letterSpacing: 1.8,
        ),
      ),
    );
  }
}

// ─── Glass group card ─────────────────────────────────────────────────────────

class _GroupCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;
  const _GroupCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.03)
            : AppColors.auroraPurple.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.07)
              : AppColors.auroraPurple.withValues(alpha: 0.10),
        ),
      ),
      child: Column(children: children),
    );
  }
}

// ─── Divider ──────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: isDark
          ? AppColors.white.withValues(alpha: 0.05)
          : AppColors.auroraPurple.withValues(alpha: 0.07),
    );
  }
}

// ─── Toggle row ───────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final bool isDark;
  final Color iconBg;
  final Color iconColor;
  final FaIconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.isDark,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: FaIcon(icon, size: 15, color: iconColor)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.40)
                        : AppColors.auroraDeepBase.withValues(alpha: 0.45),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          AuroraSwitch(
            value: value,
            onChanged: onChanged,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

// ─── Chevron row ─────────────────────────────────────────────────────────────

class _ChevronRow extends StatelessWidget {
  final bool isDark;
  final Color iconBg;
  final Color iconColor;
  final FaIconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ChevronRow({
    required this.isDark,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive
        ? AppColors.auroraRed
        : isDark
            ? AppColors.white
            : AppColors.auroraDeepBase;
    final subtitleColor = isDestructive
        ? AppColors.auroraRed.withValues(alpha: 0.55)
        : isDark
            ? AppColors.white.withValues(alpha: 0.40)
            : AppColors.auroraDeepBase.withValues(alpha: 0.45);
    final chevronColor = isDestructive
        ? AppColors.auroraRed.withValues(alpha: 0.40)
        : isDark
            ? AppColors.white.withValues(alpha: 0.25)
            : AppColors.auroraPurple.withValues(alpha: 0.35);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: FaIcon(icon, size: 15, color: iconColor)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: subtitleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            FaIcon(FontAwesomeIcons.chevronRight, size: 12, color: chevronColor),
          ],
        ),
      ),
    );
  }
}

// ─── Language picker sheet ────────────────────────────────────────────────────

class _LanguageSheet extends StatelessWidget {
  final bool isDark;
  final String selected;
  final ValueChanged<String> onSelect;

  static const _options = ['English', 'العربية', 'Français'];

  const _LanguageSheet({
    required this.isDark,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? const Color(0xFF12122A)
        : AppColors.white;
    final borderColor = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.auroraPurple.withValues(alpha: 0.16);
    final titleColor =
        isDark ? AppColors.white : AppColors.auroraDeepBase;
    final mutedColor = isDark
        ? AppColors.white.withValues(alpha: 0.40)
        : AppColors.auroraDeepBase.withValues(alpha: 0.45);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.15)
                    : AppColors.auroraPurple.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Language',
            style: AppTextStyles.heading3.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: titleColor,
            ),
          ),
          Text(
            'Choose your preferred language',
            style: AppTextStyles.caption.copyWith(
              color: mutedColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          ..._options.map(
            (lang) => _LanguageOption(
              isDark: isDark,
              label: lang,
              isSelected: lang == selected,
              onTap: () => onSelect(lang),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final bool isDark;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.isDark,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isSelected
        ? AppColors.auroraPurple
        : isDark
            ? AppColors.white
            : AppColors.auroraDeepBase;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: labelColor,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            if (isSelected)
              FaIcon(
                FontAwesomeIcons.solidCircleCheck,
                size: 16,
                color: AppColors.auroraPurple,
              ),
          ],
        ),
      ),
    );
  }
}
