import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/route_constants.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _faqItems = [
    _FaqItem(
      question: 'How do I track my order?',
      answer:
          'Go to Profile > Orders, tap on the order you want to track. You\'ll see real-time tracking information including carrier details and estimated delivery date.',
    ),
    _FaqItem(
      question: 'What is the return policy?',
      answer:
          'We offer free returns within 30 days of purchase. Items must be in original condition with tags attached. Initiate a return from your Orders page.',
    ),
    _FaqItem(
      question: 'How do I change my shipping address?',
      answer:
          'Go to Profile > Addresses to add, edit, or remove shipping addresses. You can also set a default address for faster checkout.',
    ),
    _FaqItem(
      question: 'How do loyalty points work?',
      answer:
          'Earn points on every purchase (1 point per \$1 spent). Points can be redeemed for discounts, free shipping, and exclusive rewards in the Loyalty tab.',
    ),
    _FaqItem(
      question: 'Is my payment information secure?',
      answer:
          'Yes! We use industry-standard encryption to protect your payment data. We never store your full card number on our servers.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: 20,
            color: AppColors.primaryPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  FaIcon(
                    FontAwesomeIcons.headset,
                    size: 40,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Need Help?',
                    style: AppTextStyles.heading4.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Our support team is here for you 24/7',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ContactButton(
                          icon: FontAwesomeIcons.comments,
                          label: 'Live Chat',
                          onTap: () => Navigator.pushNamed(
                              context, liveChatScreenRoute),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ContactButton(
                          icon: FontAwesomeIcons.envelope,
                          label: 'Email Us',
                          onTap: () => Navigator.pushNamed(
                              context, emailSupportScreenRoute),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick links
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Quick Links',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.gray500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildQuickLink(
              context,
              icon: FontAwesomeIcons.book,
              color: AppColors.profileIconTeal,
              title: 'Shipping Information',
              onTap: () => Navigator.pushNamed(
                  context, shippingInfoScreenRoute),
            ),
            _buildQuickLink(
              context,
              icon: FontAwesomeIcons.arrowRotateLeft,
              color: AppColors.profileIconOrange,
              title: 'Returns & Exchanges',
              onTap: () => Navigator.pushNamed(
                  context, returnsExchangesScreenRoute),
            ),
            _buildQuickLink(
              context,
              icon: FontAwesomeIcons.fileLines,
              color: AppColors.profileIconGray,
              title: 'Terms & Conditions',
              onTap: () => Navigator.pushNamed(
                  context, termsConditionsScreenRoute),
            ),
            _buildQuickLink(
              context,
              icon: FontAwesomeIcons.shieldHalved,
              color: AppColors.profileIconGreen,
              title: 'Privacy Policy',
              onTap: () => Navigator.pushNamed(
                  context, privacyPolicyScreenRoute),
            ),
            const SizedBox(height: 24),

            // FAQ
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Frequently Asked Questions',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.gray500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ..._faqItems.map((faq) => _buildFaqTile(faq)),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLink(
    BuildContext context, {
    required FaIconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(icon, size: 16, color: color),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FaIcon(
                FontAwesomeIcons.chevronRight,
                size: 14,
                color: AppColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqTile(_FaqItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          faq.question,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: FaIcon(
          FontAwesomeIcons.chevronDown,
          size: 14,
          color: AppColors.gray400,
        ),
        children: [
          Text(faq.answer, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final FaIconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 16, color: AppColors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.buttonSmall.copyWith(
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
}
