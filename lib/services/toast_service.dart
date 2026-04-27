import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

enum ToastType { success, error }

class ToastService {
  ToastService._();
  static final instance = ToastService._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  // Set to nav-bar height on screens that have one; reset to 0 otherwise.
  static double _bottomInset = 0;
  static void setBottomInset(double inset) => _bottomInset = inset;

  OverlayEntry? _current;

  void showSuccess(String message) => _show(message, ToastType.success);
  void showError(String message) => _show(message, ToastType.error);

  void _show(String message, ToastType type) {
    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _current?.remove();
    _current = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AuroraToastWidget(
        message: message,
        type: type,
        onDismiss: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }
}

// ─── Widget ──────────────────────────────────────────────────────────────────

class _AuroraToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  static const Duration _displayDuration = Duration(milliseconds: 3000);
  static const Duration _slideDuration = Duration(milliseconds: 300);

  const _AuroraToastWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_AuroraToastWidget> createState() => _AuroraToastWidgetState();
}

class _AuroraToastWidgetState extends State<_AuroraToastWidget>
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
      duration: _AuroraToastWidget._slideDuration,
    );
    _progressCtrl = AnimationController(
      vsync: this,
      duration: _AuroraToastWidget._displayDuration,
    );

    // Slide up from below
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1.6),
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

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final isSuccess = widget.type == ToastType.success;

    final bg = isSuccess ? AppColors.verifiedGreen : AppColors.auroraRed;
    final icon = isSuccess
        ? FontAwesomeIcons.solidCircleCheck
        : FontAwesomeIcons.circleExclamation;

    return Positioned(
      bottom: bottomPad + ToastService._bottomInset + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 9, 14, 9),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.22),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: FaIcon(icon, size: 10, color: AppColors.white),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              widget.message,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                                size: 10,
                                color: AppColors.white.withValues(alpha: 0.55),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Dark overlay depletes right→left as timer runs
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _progressCtrl,
                        builder: (context2, child2) => Align(
                          alignment: Alignment.centerRight,
                          child: FractionallySizedBox(
                            widthFactor: 1 - _progressCtrl.value,
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
