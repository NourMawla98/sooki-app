import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../routes/route_constants.dart';
import '../../themes/app_colors.dart';
import '../reusable_components/app_logo/app_logo.dart';
import '../reusable_components/badges/notification_dot_badge.dart';
import '../reusable_components/menu/user_menu_dropdown.dart';
import '../reusable_components/notification_panel/notification_panel.dart';
import '../reusable_components/search_bar/custom_search_bar.dart';

/// Main app header component with logo, notifications, menu, and search bar
/// Displays as a fixed header at the top of the main screen
class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  final bool _hasUnreadNotifications =
      true; // TODO: Connect to real notification state
  OverlayEntry? _overlayEntry;
  final GlobalKey _notificationButtonKey = GlobalKey();
  final GlobalKey _menuButtonKey = GlobalKey();

  void _showMenu() {
    _removeOverlay();
    _overlayEntry = _createMenuOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _showNotificationPanel() {
    _removeOverlay();
    _overlayEntry = _createNotificationOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Offset _getButtonPosition(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size _getButtonSize(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return Size.zero;
    return renderBox.size;
  }

  OverlayEntry _createMenuOverlay() {
    final buttonPosition = _getButtonPosition(_menuButtonKey);
    final buttonSize = _getButtonSize(_menuButtonKey);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop to close overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Menu dropdown
          Positioned(
            top: buttonPosition.dy + buttonSize.height,
            right: 24,
            child: Material(
              color: Colors.transparent,
              child: UserMenuDropdown(onClose: _removeOverlay),
            ),
          ),
        ],
      ),
    );
  }

  OverlayEntry _createNotificationOverlay() {
    final buttonPosition = _getButtonPosition(_notificationButtonKey);
    final buttonSize = _getButtonSize(_notificationButtonKey);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop to close overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Notification panel
          Positioned(
            top: buttonPosition.dy + buttonSize.height + 8,
            right: 16,
            child: Material(
              elevation: 8,
              color: Colors.transparent,
              child: NotificationPanel(onClose: _removeOverlay),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Logo, spacer, notification, menu
            Row(
              children: [
                const AppLogo(size: LogoSize.small),
                const Spacer(),
                // Notification icon with dot badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      key: _notificationButtonKey,
                      icon: const FaIcon(
                        FontAwesomeIcons.bell,
                        size: 22,
                        color: AppColors.primaryPurple,
                      ),
                      onPressed: _showNotificationPanel,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                    if (_hasUnreadNotifications)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: NotificationDotBadge(
                          show: _hasUnreadNotifications,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 0),
                // Menu icon
                IconButton(
                  key: _menuButtonKey,
                  icon: const FaIcon(
                    FontAwesomeIcons.bars,
                    size: 22,
                    color: AppColors.primaryPurple,
                  ),
                  onPressed: _showMenu,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row 2: Search bar
            CustomSearchBar(
              onTap: () =>
                  Navigator.pushNamed(context, searchScreenRoute),
            ),
          ],
        ),
      ),
    );
  }
}
