import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../data/mock_home_data.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

/// Section 1 — Live Ticker.
///
/// 32 px rounded pill with a horizontal aurora gradient fill (blue→purple→pink
/// at low opacity). A pulsing blue dot anchors the left, followed by one
/// rotating announcement from [mockTickerMessages]. Messages slide upward and
/// fade every [interval].
class LiveTicker extends StatefulWidget {
  final List<String> messages;
  final Duration interval;
  final double height;

  const LiveTicker({
    super.key,
    this.messages = mockTickerMessages,
    this.interval = const Duration(seconds: 3),
    this.height = 32,
  });

  @override
  State<LiveTicker> createState() => _LiveTickerState();
}

class _LiveTickerState extends State<LiveTicker>
    with SingleTickerProviderStateMixin {
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

    if (widget.messages.length > 1) {
      _timer = Timer.periodic(widget.interval, (_) {
        if (!mounted) return;
        setState(() {
          _index = (_index + 1) % widget.messages.length;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  String get _currentMessage {
    if (widget.messages.isEmpty) return tickerFallbackMessage;
    return widget.messages[_index];
  }

  @override
  Widget build(BuildContext context) {
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
            height: widget.height,
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
                      alignment: Alignment.centerLeft,
                      children: <Widget>[...previousChildren, ?currentChild],
                    ),
                    child: Text(
                      _currentMessage,
                      key: ValueKey<int>(_index),
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
            color: AppColors.auroraElectricBlue.withValues(
              alpha: 0.5 + 0.5 * t,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.auroraElectricBlue.withValues(
                  alpha: 0.4 + 0.4 * t,
                ),
                blurRadius: 8,
              ),
            ],
          ),
        );
      },
    );
  }
}
