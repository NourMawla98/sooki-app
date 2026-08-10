import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/notification_service.dart';
import '../../services/theme_service.dart';
import '../../themes/app_colors.dart';
import '../reusable_components/app_logo/app_logo.dart';
import '../reusable_components/badges/notification_dot_badge.dart';
import '../reusable_components/menu/user_menu_dropdown.dart';
import '../reusable_components/notification_panel/notification_panel.dart';
import '../reusable_components/search_bar/custom_search_bar.dart';

/// Aurora-glass app header. Plain notification-bell and menu-bars icons
/// (no button chip) on the right. Tapping the menu opens a bottom sheet
/// where Profile / Language / Theme / Logout live.
class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  int get _unreadCount => NotificationService.instance.unreadCount;
  OverlayEntry? _overlay;
  final GlobalKey _notificationButtonKey = GlobalKey();
  final GlobalKey _menuButtonKey = GlobalKey();

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  OverlayEntry _positionedOverlay({
    required GlobalKey anchor,
    required Widget child,
  }) {
    final rb = anchor.currentContext?.findRenderObject() as RenderBox?;
    final pos = rb?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = rb?.size ?? Size.zero;
    return OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _removeOverlay,
              child: const SizedBox.shrink(),
            ),
          ),
          // The header buttons sit on the right in every language, so the
          // panel they open is anchored to the right rather than to the end.
          Positioned(
            top: pos.dy + size.height + 8,
            right: 16,
            child: Material(color: Colors.transparent, child: child),
          ),
        ],
      ),
    );
  }

  void _showNotificationPanel() {
    _removeOverlay();
    _overlay = _positionedOverlay(
      anchor: _notificationButtonKey,
      child: NotificationPanel(onClose: _removeOverlay),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _showMenu() {
    _removeOverlay();
    _overlay = _positionedOverlay(
      anchor: _menuButtonKey,
      child: UserMenuDropdown(onClose: _removeOverlay),
    );
    Overlay.of(context).insert(_overlay!);
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        ThemeService.instance,
        NotificationService.instance,
      ]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark
            ? AppColors.auroraDeepBase.withValues(alpha: 0.88)
            : AppColors.white.withValues(alpha: 0.9);
        final borderBottom = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.gray100;
        final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;

        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                  bottom: BorderSide(color: borderBottom, width: 1),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // The logo and the two icon buttons keep the same
                      // positions in every language, so this row never mirrors.
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          children: [
                            const AppLogo(size: LogoSize.small),
                            const Spacer(),
                            _PlainIconButton(
                              buttonKey: _notificationButtonKey,
                              icon: FontAwesomeIcons.bell,
                              iconColor: iconColor,
                              badgeCount: _unreadCount,
                              onTap: _showNotificationPanel,
                            ),
                            const SizedBox(width: 18),
                            _PlainIconButton(
                              buttonKey: _menuButtonKey,
                              icon: FontAwesomeIcons.bars,
                              iconColor: iconColor,
                              onTap: _showMenu,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const CustomSearchBar(readOnly: true),
                    ],
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

class _PlainIconButton extends StatelessWidget {
  final GlobalKey? buttonKey;
  final FaIconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final int badgeCount;

  const _PlainIconButton({
    this.buttonKey,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: buttonKey,
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: FaIcon(icon, size: 20, color: iconColor),
          ),
          if (badgeCount > 0)
            PositionedDirectional(
              top: -3,
              end: -4,
              child: NotificationDotBadge(count: badgeCount),
            ),
        ],
      ),
    );
  }
}
