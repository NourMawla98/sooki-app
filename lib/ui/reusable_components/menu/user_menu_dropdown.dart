import 'package:flutter/material.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../routes/route_constants.dart';

/// User menu dropdown with Profile and Logout options
/// Displays as a white card overlay below the menu icon
class UserMenuDropdown extends StatelessWidget {
  final VoidCallback onClose;

  const UserMenuDropdown({
    super.key,
    required this.onClose,
  });

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: AppTextStyles.heading3,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              onClose(); // Close menu
              // TODO: Add actual logout logic here
              // For now, navigate to sign in screen
              Navigator.pushReplacementNamed(context, signInScreenRoute);
            },
            child: Text(
              'Logout',
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile option
          InkWell(
            onTap: () {
              onClose();
              Navigator.pushNamed(context, profileScreenRoute);
            },
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Text(
                'Profile',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.gray200,
          ),
          // Logout option
          InkWell(
            onTap: () => _showLogoutDialog(context),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Text(
                'Logout',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.accentRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
