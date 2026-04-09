import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/route_constants.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _darkMode = false;
  String _selectedLanguage = 'English';

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
          'Settings',
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
            _buildSectionTitle('Notifications'),
            const SizedBox(height: 8),
            _buildToggleTile(
              icon: FontAwesomeIcons.bell,
              iconColor: AppColors.profileIconYellow,
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              value: _pushNotifications,
              onChanged: (v) => setState(() => _pushNotifications = v),
            ),
            _buildToggleTile(
              icon: FontAwesomeIcons.envelope,
              iconColor: AppColors.profileIconTeal,
              title: 'Email Notifications',
              subtitle: 'Receive order updates via email',
              value: _emailNotifications,
              onChanged: (v) => setState(() => _emailNotifications = v),
            ),
            _buildToggleTile(
              icon: FontAwesomeIcons.commentSms,
              iconColor: AppColors.profileIconGreen,
              title: 'SMS Notifications',
              subtitle: 'Receive delivery alerts via SMS',
              value: _smsNotifications,
              onChanged: (v) => setState(() => _smsNotifications = v),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Appearance'),
            const SizedBox(height: 8),
            _buildToggleTile(
              icon: FontAwesomeIcons.moon,
              iconColor: AppColors.profileIconGray,
              title: 'Dark Mode',
              subtitle: 'Switch to dark theme',
              value: _darkMode,
              onChanged: (v) => setState(() => _darkMode = v),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Language'),
            const SizedBox(height: 8),
            _buildLanguageTile(),
            const SizedBox(height: 24),
            _buildSectionTitle('Account'),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: FontAwesomeIcons.lock,
              iconColor: AppColors.profileIconOrange,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () => Navigator.pushNamed(
                  context, changePasswordScreenRoute),
            ),
            _buildActionTile(
              icon: FontAwesomeIcons.shield,
              iconColor: AppColors.profileIconGreen,
              title: 'Privacy',
              subtitle: 'Manage your data and privacy',
              onTap: () => Navigator.pushNamed(
                  context, privacySettingsScreenRoute),
            ),
            _buildActionTile(
              icon: FontAwesomeIcons.trashCan,
              iconColor: AppColors.accentRed,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              onTap: () => _showDeleteAccountDialog(),
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

  Widget _buildLanguageTile() {
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
                color: AppColors.primaryPurple.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.globe,
                  size: 16,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Language',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Choose your preferred language',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox.shrink(),
              icon: FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 12,
                color: AppColors.gray400,
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
              items: ['English', 'العربية', 'Français']
                  .map(
                    (lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedLanguage = v);
              },
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 20,
              color: AppColors.accentRed,
            ),
            const SizedBox(width: 10),
            Text('Delete Account', style: AppTextStyles.heading4),
          ],
        ),
        content: Text(
          'This action is permanent and cannot be undone. All your data, orders, and loyalty points will be lost.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion requested (mock)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Text(
              'Delete',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.accentRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
