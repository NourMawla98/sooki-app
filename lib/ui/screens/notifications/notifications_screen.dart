import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/dtos/notification/notification_dto.dart';
import '../../../services/notification_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../splash/widgets/aurora_glow_blob.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    NotificationService.instance.fetchNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      NotificationService.instance.loadMore();
    }
  }

  Future<void> _refresh() async {
    await NotificationService.instance.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService.instance, NotificationService.instance]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final svc = NotificationService.instance;
        final today = svc.todayItems;
        final earlier = svc.earlierItems;
        final hasAny = today.isNotEmpty || earlier.isNotEmpty;

        return Scaffold(
          backgroundColor: isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -80, right: -80, size: 260,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.20 : 0.10,
              ),
              AuroraGlowBlob(
                bottom: 80, left: -80, size: 280,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.18 : 0.08,
              ),
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(isDark: isDark, hasUnread: svc.unreadCount > 0),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        color: AppColors.auroraPink,
                        child: hasAny
                            ? _NotificationList(
                                isDark: isDark,
                                today: today,
                                earlier: earlier,
                                controller: _scrollController,
                              )
                            : SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: _EmptyState(isDark: isDark),
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isDark, required this.hasUnread});

  final bool isDark;
  final bool hasUnread;

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
          Expanded(
            child: Text(
              'Notifications',
              style: AppTextStyles.heading3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ),
          if (hasUnread)
            GestureDetector(
              onTap: NotificationService.instance.markAllRead,
              behavior: HitTestBehavior.opaque,
              child: Text(
                'Mark all read',
                style: AppTextStyles.captionSmall.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.4)
                      : AppColors.auroraPurple,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({
    required this.isDark,
    required this.today,
    required this.earlier,
    required this.controller,
  });

  final bool isDark;
  final List<NotificationDto> today;
  final List<NotificationDto> earlier;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (today.isNotEmpty) ...[
          _GroupLabel(label: 'Today', isDark: isDark),
          _NotifGroup(items: today, isDark: isDark),
        ],
        if (earlier.isNotEmpty) ...[
          _GroupLabel(label: 'Earlier', isDark: isDark),
          _NotifGroup(items: earlier, isDark: isDark),
        ],
      ],
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.dsSectionLabel.copyWith(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.28)
              : AppColors.auroraPurple.withValues(alpha: 0.4),
          letterSpacing: 1.8,
        ),
      ),
    );
  }
}

class _NotifGroup extends StatelessWidget {
  const _NotifGroup({required this.items, required this.isDark});

  final List<NotificationDto> items;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final divider = Container(
      height: 1,
      color: isDark
          ? AppColors.white.withValues(alpha: 0.05)
          : AppColors.auroraPurple.withValues(alpha: 0.07),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _NotifRow(item: items[i], isDark: isDark),
              if (i < items.length - 1) divider,
            ],
          ],
        ),
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  const _NotifRow({required this.item, required this.isDark});

  final NotificationDto item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final unreadBg = isDark
        ? AppColors.auroraPurple.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.04);
    final iconTint = isDark ? AppColors.auroraPink : AppColors.auroraPurple;
    final iconBg = isDark
        ? AppColors.auroraPurple.withValues(alpha: 0.16)
        : AppColors.auroraPurple.withValues(alpha: 0.10);

    return GestureDetector(
      onTap: () => NotificationService.instance.markRead(item.id),
      child: Container(
        color: item.isRead ? null : unreadBg,
        padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: FaIcon(item.notificationType.icon, size: 14, color: iconTint),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 14,
                      fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w700,
                      color: item.isRead
                          ? (isDark
                              ? AppColors.white.withValues(alpha: 0.45)
                              : AppColors.auroraDeepBase.withValues(alpha: 0.45))
                          : (isDark ? AppColors.white : AppColors.auroraDeepBase),
                      height: 1.35,
                    ),
                  ),
                  if (item.body.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      item.body,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 12.5,
                        color: isDark
                            ? AppColors.white.withValues(alpha: 0.55)
                            : AppColors.auroraDeepBase.withValues(alpha: 0.6),
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    item.relativeLabel,
                    style: AppTextStyles.captionSmall.copyWith(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.3)
                          : AppColors.auroraPurple.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.bell,
            size: 40,
            color: isDark
                ? AppColors.white.withValues(alpha: 0.12)
                : AppColors.auroraPurple.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: AppTextStyles.heading4.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.3)
                  : AppColors.auroraPurple.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
