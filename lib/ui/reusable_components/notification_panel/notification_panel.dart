import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Notification panel dropdown that appears below the notification icon
/// Shows list of mock notifications
class NotificationPanel extends StatefulWidget {
  final VoidCallback onClose;

  const NotificationPanel({
    super.key,
    required this.onClose,
  });

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  final List<_MockNotification> _notifications = [
    _MockNotification(
      icon: FontAwesomeIcons.truck,
      iconColor: AppColors.profileIconGreen,
      title: 'Your order #1234 has been shipped!',
      time: '2m ago',
      isRead: false,
    ),
    _MockNotification(
      icon: FontAwesomeIcons.bolt,
      iconColor: AppColors.profileIconYellow,
      title: 'Flash sale starts in 1 hour',
      time: '15m ago',
      isRead: false,
    ),
    _MockNotification(
      icon: FontAwesomeIcons.shirt,
      iconColor: AppColors.primaryPurple,
      title: 'New arrivals in Dresses category',
      time: '1h ago',
      isRead: false,
    ),
    _MockNotification(
      icon: FontAwesomeIcons.solidHeart,
      iconColor: AppColors.auroraRed,
      title: 'Your wishlist item is on sale!',
      time: '3h ago',
      isRead: true,
    ),
    _MockNotification(
      icon: FontAwesomeIcons.solidHandSpock,
      iconColor: AppColors.profileIconTeal,
      title: 'Welcome to SooKI!',
      time: '1d ago',
      isRead: true,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Container(
      width: 300,
      constraints: const BoxConstraints(maxHeight: 420),
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
                Row(
                  children: [
                    Text(
                      'Notifications',
                      style: AppTextStyles.heading4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$unreadCount',
                          style: AppTextStyles.captionSmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                TextButton(
                  onPressed: unreadCount > 0 ? _markAllAsRead : null,
                  child: Text(
                    'Mark all',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: unreadCount > 0
                          ? AppColors.primaryPurple
                          : AppColors.gray400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.gray200),

          // Notification list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: AppColors.gray100,
              ),
              itemBuilder: (context, index) {
                final n = _notifications[index];
                return InkWell(
                  onTap: () {
                    setState(() => n.isRead = true);
                    widget.onClose();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: n.isRead
                        ? AppColors.white
                        : AppColors.primaryPurple.withValues(alpha: 0.04),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: n.iconColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: FaIcon(
                              n.icon,
                              size: 14,
                              color: n.iconColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n.title,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: n.isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                n.time,
                                style: AppTextStyles.captionSmall.copyWith(
                                  color: AppColors.gray400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!n.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // View all
          Divider(height: 1, thickness: 1, color: AppColors.gray200),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: widget.onClose,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.gray50,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'View all notifications',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w600,
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

class _MockNotification {
  _MockNotification({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.isRead,
  });

  final FaIconData icon;
  final Color iconColor;
  final String title;
  final String time;
  bool isRead;
}
