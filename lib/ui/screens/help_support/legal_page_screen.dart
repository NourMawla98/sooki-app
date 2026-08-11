import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class LegalPageScreen extends StatelessWidget {
  const LegalPageScreen({
    super.key,
    required this.titleKey,
    required this.sections,
  });

  /// Translation key, resolved on build so the title follows the app language.
  final String titleKey;
  final List<LegalSection> sections;

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
                    _TopBar(title: titleKey.tr(), isDark: isDark),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sections
                            for (final section in sections) ...[
                              _GroupLabel(label: section.title, isDark: isDark),
                              _GroupCard(
                                isDark: isDark,
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Text(
                                    section.content,
                                    style: AppTextStyles.captionSmall.copyWith(
                                      color: isDark
                                          ? AppColors.white.withValues(alpha: 0.52)
                                          : AppColors.auroraDeepBase.withValues(alpha: 0.55),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      height: 1.7,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
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

  // ── Terms & Conditions content ───────────────────────────────────────────────

  static List<LegalSection> get termsAndConditions => [
    LegalSection(
      title: 'legal_page_screen.terms_acceptance_title'.tr(),
      content: 'legal_page_screen.terms_acceptance_content'.tr(),
    ),
    LegalSection(
      title: 'legal_page_screen.terms_orders_title'.tr(),
      content: 'legal_page_screen.terms_orders_content'.tr(),
    ),
    LegalSection(
      title: 'legal_page_screen.terms_account_title'.tr(),
      content: 'legal_page_screen.terms_account_content'.tr(),
    ),
    LegalSection(
      title: 'legal_page_screen.terms_cancellation_title'.tr(),
      content: 'legal_page_screen.terms_cancellation_content'.tr(),
    ),
    LegalSection(
      title: 'legal_page_screen.terms_ip_title'.tr(),
      content: 'legal_page_screen.terms_ip_content'.tr(),
    ),
    LegalSection(
      title: 'legal_page_screen.terms_changes_title'.tr(),
      content: 'legal_page_screen.terms_changes_content'.tr(),
    ),
  ];

  // ── Privacy Policy content ───────────────────────────────────────────────────

  static List<LegalSection> get privacyPolicy => [
    LegalSection(
      title: 'legal_page_screen.privacy_collect_title'.tr(),
      content: 'legal_page_screen.privacy_collect_content'.tr(),
    ),
    LegalSection(
      title: 'legal_page_screen.privacy_use_title'.tr(),
      content: 'legal_page_screen.privacy_use_content'.tr(),
    ),
    LegalSection(
      title: 'legal_page_screen.privacy_security_title'.tr(),
      content: 'legal_page_screen.privacy_security_content'.tr(),
    ),
    LegalSection(
      title: 'legal_page_screen.privacy_rights_title'.tr(),
      content: 'legal_page_screen.privacy_rights_content'.tr(),
    ),
    LegalSection(
      title: 'legal_page_screen.privacy_changes_title'.tr(),
      content: 'legal_page_screen.privacy_changes_content'.tr(),
    ),
  ];
}

class LegalSection {
  const LegalSection({required this.title, required this.content});
  final String title;
  final String content;
}

// ─── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String title;
  final bool isDark;
  const _TopBar({required this.title, required this.isDark});

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
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
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
  final Widget child;
  const _GroupCard({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }
}
