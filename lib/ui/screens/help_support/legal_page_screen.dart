import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class LegalPageScreen extends StatelessWidget {
  const LegalPageScreen({
    super.key,
    required this.title,
    required this.sections,
  });

  final String title;
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
                    _TopBar(title: title, isDark: isDark),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Last updated notice
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.auroraElectricBlue.withValues(alpha: 0.08)
                                    : AppColors.auroraElectricBlue.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.auroraElectricBlue.withValues(alpha: isDark ? 0.18 : 0.14),
                                ),
                              ),
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.circleInfo,
                                    size: 13,
                                    color: AppColors.auroraElectricBlue.withValues(alpha: 0.70),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Last updated: January 2025',
                                    style: AppTextStyles.captionSmall.copyWith(
                                      color: isDark
                                          ? AppColors.auroraElectricBlue.withValues(alpha: 0.80)
                                          : AppColors.auroraElectricBlue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

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

  static const termsAndConditions = [
    LegalSection(
      title: 'Acceptance of Terms',
      content: 'By using Sooki, you agree to these terms. Please read them carefully before placing any orders. If you do not agree with any part of these terms, you must not use the app.',
    ),
    LegalSection(
      title: 'Orders & Payments',
      content: 'All orders are subject to product availability. We reserve the right to cancel any order that cannot be fulfilled. We currently support cash on delivery as the only payment method.',
    ),
    LegalSection(
      title: 'Account',
      content: 'You are responsible for maintaining the confidentiality of your account credentials. You agree to notify us immediately of any unauthorized use of your account.',
    ),
    LegalSection(
      title: 'Order Cancellation',
      content: 'Orders can only be cancelled while in the Processing stage. Once an order has been shipped, it can no longer be cancelled. Contact our support team via WhatsApp for assistance.',
    ),
    LegalSection(
      title: 'Intellectual Property',
      content: 'All content on the Sooki platform — including logos, images, and text — is the property of Sooki and may not be reproduced without written permission.',
    ),
    LegalSection(
      title: 'Changes to Terms',
      content: 'We may update these terms from time to time. Continued use of the app after changes constitutes acceptance of the new terms.',
    ),
  ];

  // ── Privacy Policy content ───────────────────────────────────────────────────

  static const privacyPolicy = [
    LegalSection(
      title: 'Information We Collect',
      content: 'We collect information you provide directly: your name, phone number, email address, and saved delivery addresses. We also collect order history to improve your shopping experience.',
    ),
    LegalSection(
      title: 'How We Use It',
      content: 'Your information is used solely to process orders, send delivery updates, and improve our services. We do not sell your personal data to third parties.',
    ),
    LegalSection(
      title: 'Data Security',
      content: 'We apply industry-standard security measures to protect your information. Access to personal data is strictly limited to authorized personnel.',
    ),
    LegalSection(
      title: 'Your Rights',
      content: 'You may request access to, correction of, or deletion of your personal data at any time. You can also delete your account directly from Settings → Delete Account.',
    ),
    LegalSection(
      title: 'Changes to Policy',
      content: 'We may update this policy from time to time. We will notify you of significant changes via the app. Continued use constitutes acceptance of the updated policy.',
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 20, color: color),
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
