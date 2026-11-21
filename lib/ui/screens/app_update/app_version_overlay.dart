import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/app_version_gate.dart';
import '../../../services/toast_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import 'update_required_screen.dart';

/// Sits above the navigator and shows what the version gate asks for: the
/// blocking update screen over everything, or a dismissible banner on top.
class AppVersionOverlay extends StatefulWidget {
  final Widget child;
  final AppVersionGate gate;

  AppVersionOverlay({super.key, required this.child, AppVersionGate? gate})
      : gate = gate ?? AppVersionGate.instance;

  @override
  State<AppVersionOverlay> createState() => _AppVersionOverlayState();
}

class _AppVersionOverlayState extends State<AppVersionOverlay>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.gate.addListener(_syncBarrier);
    _syncBarrier();
  }

  @override
  void dispose() {
    widget.gate.removeListener(_syncBarrier);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _syncBarrier() => UpdateBarrier.sync(widget.gate);

  /// The blocking screen sits above the navigator, so its own PopScope never
  /// sees back. Swallowing back here keeps it from closing the app or opening
  /// screens behind the block.
  @override
  Future<bool> didPopRoute() async => widget.gate.isBlocked;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.gate,
      builder: (context, _) {
        final config = widget.gate.config;
        return Stack(
          children: [
            widget.child,
            if (widget.gate.showBanner && config != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _UpdateBanner(
                  onUpdate: () => openStoreUrl(config.storeUrl),
                  onDismiss: widget.gate.dismissBanner,
                ),
              ),
            if (widget.gate.isBlocked && config != null)
              Positioned.fill(child: UpdateRequiredScreen(config: config)),
          ],
        );
      },
    );
  }
}

/// While the app is blocked, an invisible route that cannot be popped sits on
/// top of the navigator. Its PopScope tells the platform the app handles back,
/// so back does nothing instead of sending the app to the background.
class UpdateBarrier {
  UpdateBarrier._();

  static Route<void>? _route;

  /// Puts the barrier back on top whenever navigation moves it, such as the
  /// splash screen replacing the top route.
  static final NavigatorObserver observer = _BarrierObserver();

  /// Adds or removes the barrier to match [gate], after the current frame.
  static void sync(AppVersionGate gate) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _apply(gate));
  }

  static void _apply(AppVersionGate gate) {
    final navigator = ToastService.navigatorKey.currentState;
    if (navigator == null) return;
    final route = _route;
    if (gate.isBlocked) {
      if (route != null && route.isActive && route.isCurrent) return;
      if (route != null && route.isActive) navigator.removeRoute(route);
      final barrier = PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (_, _, _) =>
            const PopScope(canPop: false, child: SizedBox.shrink()),
      );
      _route = barrier;
      navigator.push(barrier);
    } else if (route != null) {
      if (route.isActive) navigator.removeRoute(route);
      _route = null;
    }
  }
}

class _BarrierObserver extends NavigatorObserver {
  void _check(Route<dynamic>? route) {
    if (route == UpdateBarrier._route) return;
    if (AppVersionGate.instance.isBlocked) {
      UpdateBarrier.sync(AppVersionGate.instance);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _check(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _check(newRoute);

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _check(previousRoute);
}

class _UpdateBanner extends StatelessWidget {
  final VoidCallback onUpdate;
  final VoidCallback onDismiss;

  const _UpdateBanner({required this.onUpdate, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 6, 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.auroraGradient),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.circleArrowUp,
                size: 16,
                color: AppColors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'app_update.banner_text'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: onUpdate,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Text(
                  'app_update.banner_action'.tr(),
                  style: AppTextStyles.buttonSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                ),
              ),
              // No tooltip: the banner sits above the navigator, where there
              // is no overlay for a tooltip to show in.
              Semantics(
                button: true,
                label: 'app_update.dismiss'.tr(),
                child: InkResponse(
                  onTap: onDismiss,
                  radius: 20,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: FaIcon(
                      FontAwesomeIcons.xmark,
                      size: 14,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
