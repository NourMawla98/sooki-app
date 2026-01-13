import 'package:flutter/material.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Notification panel dropdown that appears below the notification icon
/// Shows list of notifications with empty state
class NotificationPanel extends StatelessWidget {
  final VoidCallback onClose;

  const NotificationPanel({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                // Mark all as read button (disabled for now)
                TextButton(
                  onPressed: null,
                  child: Text(
                    'Mark all',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.gray200,
          ),
          // Notification list (empty state for now)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 48,
                    color: AppColors.gray300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No notifications yet',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'We\'ll notify you when something arrives',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // View all button (disabled for now)
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: null,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.gray100,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'View all notifications',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
