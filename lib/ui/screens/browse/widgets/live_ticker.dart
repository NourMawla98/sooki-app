import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../backend_integration/apis/announcement_api.dart';
import '../../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/refresh/refresh_scope.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

/// Section 1 — Live Ticker.
///
/// Fetches announcements from [AnnouncementApi]. Messages slide upward and
/// fade every 3 seconds. Shows a localized placeholder when the list is empty.
class LiveTicker extends StatefulWidget {
  const LiveTicker({super.key});

  @override
  State<LiveTicker> createState() => _LiveTickerState();
}

class _LiveTickerState extends State<LiveTicker>
    with SingleTickerProviderStateMixin, AutoRefreshMixin {
  @override
  Future<void> onRefresh() => _fetch();
  /// null = loading, [] = empty/error, [...] = has data
  List<String>? _messages;
  int _index = 0;
  Timer? _timer;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _fetch();
  }

  Future<void> _fetch() async {
    final result = await serviceLocator<AnnouncementApi>().getAnnouncements();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _messages = []),
      (messages) {
        setState(() {
          _messages = messages;
          _index = 0;
        });
        if (messages.length > 1) _startTimer();
      },
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _messages!.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  String _currentMessage() {
    final msgs = _messages;
    if (msgs == null) return ''; // loading — dot only
    if (msgs.isEmpty) return tr('ticker.no_announcements');
    return msgs[_index];
  }

  @override
  Widget build(BuildContext context) {
    if (_messages == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: SizedBox(
          height: 32,
          child: SkeletonShimmer(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final gradientAlpha = isDark ? 0.12 : 0.22;
        final borderColor = isDark
            ? AppColors.white.withValues(alpha: 0.06)
            : AppColors.auroraPurple.withValues(alpha: 0.25);
        final textColor = isDark ? AppColors.white : AppColors.primaryPurple;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.auroraElectricBlue.withValues(alpha: gradientAlpha),
                  AppColors.auroraPurple.withValues(alpha: gradientAlpha),
                  AppColors.auroraPink.withValues(alpha: gradientAlpha),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                _PulsingDot(pulse: _pulse),
                const SizedBox(width: 8),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final slide = Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation);
                      return ClipRect(
                        child: FadeTransition(
                          opacity: animation,
                          child: SlideTransition(position: slide, child: child),
                        ),
                      );
                    },
                    layoutBuilder: (currentChild, previousChildren) => Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: <Widget>[...previousChildren, ?currentChild],
                    ),
                    child: Text(
                      _currentMessage(),
                      key: ValueKey<String>(_currentMessage()),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.captionSmall.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        letterSpacing: 1.1,
                        height: 1.0,
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

class _PulsingDot extends StatelessWidget {
  final Animation<double> pulse;
  const _PulsingDot({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, _) {
        final t = pulse.value;
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.auroraElectricBlue.withValues(alpha: 0.5 + 0.5 * t),
            boxShadow: [
              BoxShadow(
                color: AppColors.auroraElectricBlue.withValues(alpha: 0.4 + 0.4 * t),
                blurRadius: 8,
              ),
            ],
          ),
        );
      },
    );
  }
}
