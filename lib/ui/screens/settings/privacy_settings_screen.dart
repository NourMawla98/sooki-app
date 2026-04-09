import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _analytics = true;
  bool _personalizedAds = false;
  bool _dataSharingPartners = false;
  bool _locationTracking = true;

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
          'Privacy',
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
            _buildSectionTitle('Data Collection'),
            const SizedBox(height: 8),
            _buildToggleTile(
              icon: FontAwesomeIcons.chartLine,
              iconColor: AppColors.profileIconTeal,
              title: 'Analytics',
              subtitle: 'Help us improve by sharing usage data',
              value: _analytics,
              onChanged: (v) => setState(() => _analytics = v),
            ),
            _buildToggleTile(
              icon: FontAwesomeIcons.bullhorn,
              iconColor: AppColors.profileIconYellow,
              title: 'Personalized Ads',
              subtitle: 'Show ads based on your interests',
              value: _personalizedAds,
              onChanged: (v) => setState(() => _personalizedAds = v),
            ),
            _buildToggleTile(
              icon: FontAwesomeIcons.handshake,
              iconColor: AppColors.profileIconOrange,
              title: 'Data Sharing with Partners',
              subtitle: 'Share data with trusted partners',
              value: _dataSharingPartners,
              onChanged: (v) => setState(() => _dataSharingPartners = v),
            ),
            _buildToggleTile(
              icon: FontAwesomeIcons.locationCrosshairs,
              iconColor: AppColors.profileIconGreen,
              title: 'Location Tracking',
              subtitle: 'Allow location-based recommendations',
              value: _locationTracking,
              onChanged: (v) => setState(() => _locationTracking = v),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Your Data'),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: FontAwesomeIcons.download,
              iconColor: AppColors.primaryPurple,
              title: 'Download My Data',
              subtitle: 'Get a copy of your personal data',
            ),
            _buildActionTile(
              icon: FontAwesomeIcons.clockRotateLeft,
              iconColor: AppColors.profileIconGray,
              title: 'Clear Search History',
              subtitle: 'Remove all search history',
            ),
            _buildActionTile(
              icon: FontAwesomeIcons.broom,
              iconColor: AppColors.profileIconPink,
              title: 'Clear Browsing Data',
              subtitle: 'Remove cached product views',
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(
          color: AppColors.gray500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required FaIconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(icon, size: 16, color: iconColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.primaryPurple,
              activeThumbColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required FaIconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title — coming soon!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(icon, size: 16, color: iconColor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
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
}
