import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/dtos/notification/notification_dto.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// In-app heads-up card shown when a push arrives while the app is open.
///
/// Aurora glass card that slides down from the top with a type icon, title +
/// body, an X to dismiss, and an aurora progress bar that fills left→right over
/// the display window before auto-dismissing. Tapping it runs [onTap]
/// (deep-link) and dismisses.
class NotificationHeadsUp {
  NotificationHeadsUp._();

  static OverlayEntry? _current;

  static void show({
    required NotificationDto notification,
    required VoidCallback onTap,
  }) {
    final overlay = ToastService.navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _current?.remove();
    _current = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _HeadsUpCard(
        notification: notification,
        onTap: onTap,
        onDismiss: () {
          if (_current == entry) {
            entry.remove();
            _current = null;
          }
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }
}

class _HeadsUpCard extends StatefulWidget {
  final NotificationDto notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  static const Duration _displayDuration = Duration(milliseconds: 5000);
  static const Duration _slideDuration = Duration(milliseconds: 300);

  const _HeadsUpCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  State<_HeadsUpCard> createState() => _HeadsUpCardState();
}

class _HeadsUpCardState extends State<_HeadsUpCard>
    with TickerProviderStateMixin {
  late final AnimationController _slideCtrl;
  late final AnimationController _progressCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: _HeadsUpCard._slideDuration,
    );
    _progressCtrl = AnimationController(
      vsync: this,
      duration: _HeadsUpCard._displayDuration,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);

    _slideCtrl.forward();
    _progressCtrl.forward().then((_) {
      if (mounted) _dismiss();
    });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (_dismissing || !mounted) return;
    _dismissing = true;
    _progressCtrl.stop();
    _slideCtrl.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  void _handleTap() {
    widget.onTap();
    _dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final topPad = MediaQuery.paddingOf(context).top;

        final cardFill = isDark ? const Color(0xFF13132A) : AppColors.white;
        final cardBorder = isDark
            ? AppColors.white.withValues(alpha: 0.09)
            : AppColors.auroraPurple.withValues(alpha: 0.12);
        final shadowColor = isDark
            ? AppColors.black.withValues(alpha: 0.5)
            : AppColors.auroraPurple.withValues(alpha: 0.16);
        final iconBg = AppColors.auroraPurple.withValues(alpha: isDark ? 0.16 : 0.10);
        final iconTint = isDark ? const Color(0xFF9B6CF2) : AppColors.auroraPurple;
        final titleColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final bodyColor = isDark
            ? AppColors.white.withValues(alpha: 0.66)
            : AppColors.auroraDeepBase.withValues(alpha: 0.6);
        final xColor = isDark
            ? AppColors.white.withValues(alpha: 0.45)
            : AppColors.auroraPurple.withValues(alpha: 0.5);
        final trackColor = isDark
            ? AppColors.white.withValues(alpha: 0.07)
            : AppColors.auroraPurple.withValues(alpha: 0.08);

        final n = widget.notification;

        return Positioned(
          top: topPad + 8,
          left: 14,
          right: 14,
          child: SlideTransition(
            position: _slideAnim,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: _handleTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardFill,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(13, 13, 13, 13),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: iconBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FaIcon(
                                    n.notificationType.icon,
                                    size: 15,
                                    color: iconTint,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (n.title.isNotEmpty)
                                        Text(
                                          n.title,
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: titleColor,
                                            height: 1.25,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      if (n.body.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          n.body,
                                          style: AppTextStyles.bodySmall.copyWith(
                                            fontSize: 11.5,
                                            color: bodyColor,
                                            height: 1.35,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _dismiss,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: FaIcon(
                                      FontAwesomeIcons.xmark,
                                      size: 12,
                                      color: xColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Aurora progress bar — grey track, gradient fills L→R.
                          SizedBox(
                            height: 3,
                            child: Stack(
                              children: [
                                Positioned.fill(child: ColoredBox(color: trackColor)),
                                Positioned.fill(
                                  child: AnimatedBuilder(
                                    animation: _progressCtrl,
                                    builder: (context, child) => Align(
                                      alignment: Alignment.centerLeft,
                                      child: FractionallySizedBox(
                                        widthFactor: _progressCtrl.value,
                                        child: const DecoratedBox(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: AppColors.auroraGradient,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
