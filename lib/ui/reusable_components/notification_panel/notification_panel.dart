import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/route_constants.dart';
import '../../../services/notification_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_fonts.dart';
import '../../../themes/app_text_styles.dart';

class NotificationPanel extends StatelessWidget {
  final VoidCallback onClose;

  const NotificationPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService.instance, NotificationService.instance]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final svc = NotificationService.instance;
        final items = svc.items;
        final unread = svc.unreadCount;

        final fill = isDark
            ? const Color(0xFF12122A)
            : AppColors.white;
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.auroraPurple.withValues(alpha: 0.12);
        final divider = isDark
            ? AppColors.white.withValues(alpha: 0.06)
            : AppColors.auroraPurple.withValues(alpha: 0.08);

        return Container(
          width: 308,
          constraints: const BoxConstraints(maxHeight: 440),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppColors.black.withValues(alpha: 0.50)
                    : AppColors.auroraPurple.withValues(alpha: 0.12),
                blurRadius: isDark ? 48 : 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
                  child: Row(
                    children: [
                      Text(
                        'Notifications',
                        style: AppTextStyles.heading4.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.white : AppColors.auroraDeepBase,
                        ),
                      ),
                      if (unread > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.auroraPink,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '$unread',
                            style: AppTextStyles.captionSmall.copyWith(
                              color: AppColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (unread > 0)
                        GestureDetector(
                          onTap: svc.markAllRead,
                          child: Text(
                            'Mark all read',
                            style: AppTextStyles.captionSmall.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.white.withValues(alpha: 0.4)
                                  : AppColors.auroraPurple,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(height: 1, color: divider),

                // List
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Text(
                      'No notifications',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.white.withValues(alpha: 0.3)
                            : AppColors.auroraPurple.withValues(alpha: 0.4),
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      separatorBuilder: (_, __) =>
                          Container(height: 1, color: divider),
                      itemBuilder: (context, i) =>
                          _PanelRow(item: items[i], isDark: isDark, onClose: onClose),
                    ),
                  ),

                Container(height: 1, color: divider),

                // Footer — same style as "SEE ALL RESULTS" in search bar
                GestureDetector(
                  onTap: () {
                    onClose();
                    Navigator.of(context).pushNamed(notificationsScreenRoute);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: AppColors.auroraGradient,
                        ).createShader(bounds),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'VIEW ALL NOTIFICATIONS',
                              style: AppFonts.primary(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                                letterSpacing: 1.3,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const FaIcon(
                              FontAwesomeIcons.arrowRight,
                              size: 12,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PanelRow extends StatelessWidget {
  const _PanelRow({required this.item, required this.isDark, required this.onClose});

  final AppNotification item;
  final bool isDark;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final unreadBg = isDark
        ? AppColors.auroraPurple.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.045);
    final removeColor = isDark
        ? AppColors.white.withValues(alpha: 0.35)
        : AppColors.auroraDeepBase.withValues(alpha: 0.45);

    return GestureDetector(
      onTap: () {
        NotificationService.instance.markRead(item.id);
        onClose();
      },
      child: Container(
        color: item.isRead ? null : unreadBg,
        padding: const EdgeInsets.fromLTRB(16, 11, 12, 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 13,
                      fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w700,
                      color: item.isRead
                          ? (isDark
                              ? AppColors.white.withValues(alpha: 0.45)
                              : AppColors.auroraDeepBase.withValues(alpha: 0.45))
                          : (isDark ? AppColors.white : AppColors.auroraDeepBase),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.time,
                    style: AppTextStyles.captionSmall.copyWith(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.3)
                          : AppColors.auroraPurple.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => NotificationService.instance.delete(item.id),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                color: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.xmark,
                  size: 10,
                  color: removeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
