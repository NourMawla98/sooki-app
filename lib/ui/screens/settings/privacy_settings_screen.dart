import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../services/toast_service.dart';
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(
            isRtl ? FontAwesomeIcons.arrowRight : FontAwesomeIcons.arrowLeft,
            size: 20,
            color: AppColors.primaryPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'privacy_settings_screen.title'.tr(),
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
            _buildSectionTitle('privacy_settings_screen.data_collection'.tr()),
            const SizedBox(height: 8),
            _buildToggleTile(
              icon: FontAwesomeIcons.chartLine,
              iconColor: AppColors.profileIconTeal,
              title: 'privacy_settings_screen.analytics'.tr(),
              subtitle: 'privacy_settings_screen.analytics_subtitle'.tr(),
              value: _analytics,
              onChanged: (v) => setState(() => _analytics = v),
            ),
            _buildToggleTile(
              icon: FontAwesomeIcons.bullhorn,
              iconColor: AppColors.profileIconYellow,
              title: 'privacy_settings_screen.personalized_ads'.tr(),
              subtitle: 'privacy_settings_screen.personalized_ads_subtitle'.tr(),
              value: _personalizedAds,
              onChanged: (v) => setState(() => _personalizedAds = v),
            ),
            _buildToggleTile(
              icon: FontAwesomeIcons.handshake,
              iconColor: AppColors.profileIconOrange,
              title: 'privacy_settings_screen.data_sharing_partners'.tr(),
              subtitle: 'privacy_settings_screen.data_sharing_partners_subtitle'.tr(),
              value: _dataSharingPartners,
              onChanged: (v) => setState(() => _dataSharingPartners = v),
            ),
            _buildToggleTile(
              icon: FontAwesomeIcons.locationCrosshairs,
              iconColor: AppColors.profileIconGreen,
              title: 'privacy_settings_screen.location_tracking'.tr(),
              subtitle: 'privacy_settings_screen.location_tracking_subtitle'.tr(),
              value: _locationTracking,
              onChanged: (v) => setState(() => _locationTracking = v),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('privacy_settings_screen.your_data'.tr()),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: FontAwesomeIcons.download,
              iconColor: AppColors.primaryPurple,
              title: 'privacy_settings_screen.download_my_data'.tr(),
              subtitle: 'privacy_settings_screen.download_my_data_subtitle'.tr(),
            ),
            _buildActionTile(
              icon: FontAwesomeIcons.clockRotateLeft,
              iconColor: AppColors.profileIconGray,
              title: 'privacy_settings_screen.clear_search_history'.tr(),
              subtitle: 'privacy_settings_screen.clear_search_history_subtitle'.tr(),
            ),
            _buildActionTile(
              icon: FontAwesomeIcons.broom,
              iconColor: AppColors.profileIconPink,
              title: 'privacy_settings_screen.clear_browsing_data'.tr(),
              subtitle: 'privacy_settings_screen.clear_browsing_data_subtitle'.tr(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4),
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ToastService.instance.showSuccess(
            'privacy_settings_screen.coming_soon'.tr(namedArgs: {'title': title}),
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
                isRtl
                    ? FontAwesomeIcons.chevronLeft
                    : FontAwesomeIcons.chevronRight,
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
