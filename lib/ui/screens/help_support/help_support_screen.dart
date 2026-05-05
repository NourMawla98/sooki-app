import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../splash/widgets/aurora_glow_blob.dart';

const _kWhatsAppUrl = 'https://wa.me/962XXXXXXXXX'; // TODO: replace with real number

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _expandedFaq;

  static const _faqItems = [
    _FaqItem(
      question: 'How do I track my order?',
      answer: 'Go to Profile → Orders and tap the order you want to track. You\'ll see the latest status and any updates from the carrier.',
    ),
    _FaqItem(
      question: 'Can I cancel my order?',
      answer: 'You can cancel your order only while it\'s still in the Processing stage. Once it moves to Shipped, cancellation is no longer available. Contact us via WhatsApp if you need help.',
    ),
    _FaqItem(
      question: 'What payment methods are available?',
      answer: 'We currently support cash on delivery only. More payment options are coming soon.',
    ),
    _FaqItem(
      question: 'How do I change my shipping address?',
      answer: 'Go to Profile → Addresses to add, edit, or remove shipping addresses. You can also set a default address for faster checkout.',
    ),
  ];

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse(_kWhatsAppUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ToastService.instance.showError('Could not open WhatsApp');
    }
  }

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
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroSection(
                              isDark: isDark,
                              onWhatsApp: _launchWhatsApp,
                              onEmail: () => Navigator.pushNamed(context, emailSupportScreenRoute),
                            ),
                            _GroupLabel(label: 'Quick Links', isDark: isDark),
                            _GroupCard(
                              isDark: isDark,
                              children: [
                                _ChevronRow(
                                  isDark: isDark,
                                  iconBg: AppColors.auroraTeal.withValues(alpha: isDark ? 0.14 : 0.10),
                                  iconColor: AppColors.auroraTeal,
                                  icon: FontAwesomeIcons.book,
                                  title: 'Shipping Information',
                                  subtitle: 'Delivery times & fees',
                                  onTap: () => Navigator.pushNamed(context, shippingInfoScreenRoute),
                                ),
                                _Divider(isDark: isDark),
                                _ChevronRow(
                                  isDark: isDark,
                                  iconBg: AppColors.auroraPurple.withValues(alpha: isDark ? 0.15 : 0.10),
                                  iconColor: AppColors.auroraPurple,
                                  icon: FontAwesomeIcons.fileLines,
                                  title: 'Terms & Conditions',
                                  subtitle: 'Usage & purchase terms',
                                  onTap: () => Navigator.pushNamed(context, termsConditionsScreenRoute),
                                ),
                                _Divider(isDark: isDark),
                                _ChevronRow(
                                  isDark: isDark,
                                  iconBg: AppColors.verifiedGreen.withValues(alpha: isDark ? 0.12 : 0.10),
                                  iconColor: AppColors.verifiedGreen,
                                  icon: FontAwesomeIcons.shieldHalved,
                                  title: 'Privacy Policy',
                                  subtitle: 'How we handle your data',
                                  onTap: () => Navigator.pushNamed(context, privacyPolicyScreenRoute),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _GroupLabel(label: 'Frequently Asked', isDark: isDark),
                            _GroupCard(
                              isDark: isDark,
                              children: [
                                for (int i = 0; i < _faqItems.length; i++) ...[
                                  if (i > 0) _Divider(isDark: isDark),
                                  _FaqTile(
                                    item: _faqItems[i],
                                    isExpanded: _expandedFaq == i,
                                    isDark: isDark,
                                    onTap: () => setState(
                                      () => _expandedFaq = _expandedFaq == i ? null : i,
                                    ),
                                  ),
                                ],
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 20, color: color),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Text(
            'Help & Support',
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

// ─── Hero section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final bool isDark;
  final VoidCallback onWhatsApp;
  final VoidCallback onEmail;

  const _HeroSection({
    required this.isDark,
    required this.onWhatsApp,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 28),
      child: Column(
        children: [
          // Glowing icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.auroraPurple.withValues(alpha: 0.22),
                        AppColors.auroraElectricBlue.withValues(alpha: 0.18),
                      ]
                    : [
                        AppColors.auroraPurple.withValues(alpha: 0.10),
                        AppColors.auroraElectricBlue.withValues(alpha: 0.08),
                      ],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.auroraPurple.withValues(alpha: isDark ? 0.30 : 0.20),
              ),
              boxShadow: isDark
                  ? [
                      BoxShadow(
                        color: AppColors.auroraPurple.withValues(alpha: 0.25),
                        blurRadius: 28,
                      ),
                      BoxShadow(
                        color: AppColors.auroraElectricBlue.withValues(alpha: 0.12),
                        blurRadius: 60,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: AppColors.auroraPurple.withValues(alpha: 0.15),
                        blurRadius: 24,
                      ),
                    ],
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.headset,
                size: 28,
                color: isDark ? const Color(0xFFa78bfa) : AppColors.auroraPurple,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Gradient title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: AppColors.auroraGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Text(
              'Need Help?',
              style: AppTextStyles.heading3.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'Our team is here for you 24/7',
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.40)
                  : AppColors.auroraDeepBase.withValues(alpha: 0.42),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // CTA buttons
          Row(
            children: [
              // WhatsApp
              Expanded(
                child: GestureDetector(
                  onTap: onWhatsApp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF25D366).withValues(alpha: 0.30),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.whatsapp, size: 15, color: AppColors.white),
                        const SizedBox(width: 7),
                        Text(
                          'WhatsApp',
                          style: AppTextStyles.dsCTA.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Email
              Expanded(
                child: GestureDetector(
                  onTap: onEmail,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.05)
                          : AppColors.auroraPurple.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? AppColors.white.withValues(alpha: 0.10)
                            : AppColors.auroraPurple.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.envelope,
                          size: 14,
                          color: isDark
                              ? AppColors.white.withValues(alpha: 0.70)
                              : AppColors.auroraPurple,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Email Us',
                          style: AppTextStyles.dsCTA.copyWith(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.white.withValues(alpha: 0.70)
                                : AppColors.auroraPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
      height: 1, thickness: 1, indent: 14, endIndent: 14,
      color: isDark
          ? AppColors.white.withValues(alpha: 0.05)
          : AppColors.auroraPurple.withValues(alpha: 0.07),
    );
  }
}

// ─── Chevron row ──────────────────────────────────────────────────────────────

class _ChevronRow extends StatelessWidget {
  final bool isDark;
  final Color iconBg;
  final Color iconColor;
  final FaIconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChevronRow({
    required this.isDark,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Center(child: FaIcon(icon, size: 14, color: iconColor)),
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
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 11,
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.20)
                  : AppColors.auroraPurple.withValues(alpha: 0.25),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── FAQ tile ─────────────────────────────────────────────────────────────────

class _FaqTile extends StatelessWidget {
  final _FaqItem item;
  final bool isExpanded;
  final bool isDark;
  final VoidCallback onTap;

  const _FaqTile({
    required this.item,
    required this.isExpanded,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.question,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  child: FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 11,
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.25)
                        : AppColors.auroraPurple.withValues(alpha: 0.30),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Text(
                    item.answer,
                    style: AppTextStyles.captionSmall.copyWith(
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.46)
                          : AppColors.auroraDeepBase.withValues(alpha: 0.52),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.65,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}
