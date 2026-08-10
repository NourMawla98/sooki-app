import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class ShippingInfoScreen extends StatelessWidget {
  const ShippingInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        return Scaffold(
          backgroundColor: isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -80, right: -80,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: -80, left: -80,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(isDark: isDark),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _GroupLabel(label: 'shipping_info_screen.delivery'.tr(), isDark: isDark),
                            _GroupCard(
                              isDark: isDark,
                              children: [
                                _InfoRow(
                                  isDark: isDark,
                                  iconBg: AppColors.verifiedGreen.withValues(alpha: isDark ? 0.13 : 0.10),
                                  iconColor: AppColors.verifiedGreen,
                                  icon: FontAwesomeIcons.clock,
                                  title: 'shipping_info_screen.estimated_delivery'.tr(),
                                  subtitle: 'shipping_info_screen.from_order_confirmation'.tr(),
                                  value: 'shipping_info_screen.estimated_delivery_value'.tr(),
                                ),
                                _Divider(isDark: isDark),
                                _InfoRow(
                                  isDark: isDark,
                                  iconBg: AppColors.auroraPink.withValues(alpha: isDark ? 0.12 : 0.10),
                                  iconColor: AppColors.auroraPink,
                                  icon: FontAwesomeIcons.tag,
                                  title: 'shipping_info_screen.delivery_fee'.tr(),
                                  subtitle: 'shipping_info_screen.calculated_based_on_location'.tr(),
                                  value: 'shipping_info_screen.delivery_fee_value'.tr(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _GroupLabel(label: 'shipping_info_screen.notes'.tr(), isDark: isDark),
                            _GroupCard(
                              isDark: isDark,
                              children: [
                                _NoticeRow(
                                  isDark: isDark,
                                  text: 'shipping_info_screen.notice_peak_periods'.tr(),
                                ),
                                _Divider(isDark: isDark),
                                _NoticeRow(
                                  isDark: isDark,
                                  text: 'shipping_info_screen.notice_address_accurate'.tr(),
                                ),
                              ],
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
}

// ─── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final bool isDark;
  const _TopBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.white : AppColors.auroraPurple;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(
              isRtl ? FontAwesomeIcons.arrowRight : FontAwesomeIcons.arrowLeft,
              size: 20,
              color: color,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Text(
            'shipping_info_screen.title'.tr(),
            style: AppTextStyles.heading3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
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
      padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 2, 8),
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
      height: 1, thickness: 1, indent: 14, endIndent: 14,
      color: isDark
          ? AppColors.white.withValues(alpha: 0.05)
          : AppColors.auroraPurple.withValues(alpha: 0.07),
    );
  }
}

// ─── Info row (title + value) ─────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final bool isDark;
  final Color iconBg;
  final Color iconColor;
  final FaIconData icon;
  final String title;
  final String subtitle;
  final String value;

  const _InfoRow({
    required this.isDark,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
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
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Center(child: FaIcon(icon, size: 13, color: iconColor)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.captionSmall.copyWith(
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.38)
                        : AppColors.auroraPurple.withValues(alpha: 0.50),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.60)
                  : AppColors.auroraPurple.withValues(alpha: 0.70),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Notice row ───────────────────────────────────────────────────────────────

class _NoticeRow extends StatelessWidget {
  final bool isDark;
  final String text;
  const _NoticeRow({required this.isDark, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: FaIcon(
              FontAwesomeIcons.circleInfo,
              size: 13,
              color: AppColors.auroraElectricBlue.withValues(alpha: isDark ? 0.55 : 0.65),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.captionSmall.copyWith(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.45)
                    : AppColors.auroraDeepBase.withValues(alpha: 0.52),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
