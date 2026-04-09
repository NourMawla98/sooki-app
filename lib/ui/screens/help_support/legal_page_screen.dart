import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

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
          title,
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleInfo,
                    size: 16,
                    color: AppColors.primaryPurple,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Last updated: April 1, 2026',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...sections.map(
              (section) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(section.content, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Pre-built terms & conditions content
  static const termsAndConditions = [
    LegalSection(
      title: '1. Acceptance of Terms',
      content:
          'By accessing and using the SooKI application, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you must not use the app.',
    ),
    LegalSection(
      title: '2. User Accounts',
      content:
          'You are responsible for maintaining the confidentiality of your account credentials. You agree to accept responsibility for all activities that occur under your account. You must notify us immediately of any unauthorized use.',
    ),
    LegalSection(
      title: '3. Product Listings',
      content:
          'We strive to display product information as accurately as possible. However, we do not guarantee that product descriptions, images, pricing, or other content is accurate, complete, or error-free. We reserve the right to correct any errors.',
    ),
    LegalSection(
      title: '4. Pricing & Payment',
      content:
          'All prices are displayed in USD and are subject to change without notice. Payment is processed securely through our payment partners. We accept major credit cards and digital wallets.',
    ),
    LegalSection(
      title: '5. Shipping & Delivery',
      content:
          'Delivery times are estimates and may vary depending on location and shipping method. SooKI is not responsible for delays caused by carriers, customs, or weather conditions.',
    ),
    LegalSection(
      title: '6. Intellectual Property',
      content:
          'All content, trademarks, and intellectual property on SooKI are owned by or licensed to SooKI Inc. You may not reproduce, distribute, or create derivative works without our prior written consent.',
    ),
  ];

  // Pre-built privacy policy content
  static const privacyPolicy = [
    LegalSection(
      title: '1. Information We Collect',
      content:
          'We collect information you provide directly (name, email, address, payment info), as well as usage data (browsing history, search queries, device information) to improve your shopping experience.',
    ),
    LegalSection(
      title: '2. How We Use Your Information',
      content:
          'Your information is used to process orders, personalize your experience, send order updates, improve our services, and with your consent, send promotional communications.',
    ),
    LegalSection(
      title: '3. Data Sharing',
      content:
          'We do not sell your personal data. We share data only with service providers (payment processing, shipping) who are bound by confidentiality agreements, and when required by law.',
    ),
    LegalSection(
      title: '4. Data Security',
      content:
          'We implement industry-standard encryption (SSL/TLS) and security measures to protect your data. Payment information is tokenized and never stored on our servers in plain text.',
    ),
    LegalSection(
      title: '5. Your Rights',
      content:
          'You have the right to access, correct, or delete your personal data. You can opt out of marketing communications at any time. Contact privacy@sooki.com for data requests.',
    ),
    LegalSection(
      title: '6. Cookies & Tracking',
      content:
          'We use cookies and similar technologies to enhance your experience, analyze usage patterns, and deliver personalized content. You can manage cookie preferences in your device settings.',
    ),
  ];
}

class LegalSection {
  const LegalSection({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;
}
