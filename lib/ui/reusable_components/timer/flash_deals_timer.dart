import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/themes.dart';

/// A countdown timer pill for flash deals.
///
/// Displays a purple pill with a lightning bolt icon,
/// "FLASH SALE" label, and a live HH:MM:SS countdown.
///
/// Animations:
/// - Lightning bolt wiggles with a zappy rotation + scale pulse
/// - Digits slide down when they change (like a flip clock)
class FlashDealsTimer extends StatefulWidget {
  final DateTime endTime;

  const FlashDealsTimer({super.key, required this.endTime});

  @override
  State<FlashDealsTimer> createState() => _FlashDealsTimerState();
}

class _FlashDealsTimerState extends State<FlashDealsTimer>
    with TickerProviderStateMixin {
  Timer? _timer;
  late Duration _remaining;

  // Bolt zap animation
  late final AnimationController _boltController;
  late final Animation<double> _boltRotation;
  late final Animation<double> _boltScale;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });

    // Bolt: wiggle rotation + scale pulse, repeating
    _boltController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _boltRotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -0.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.15), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.15, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _boltController,
      curve: Curves.easeInOut,
    ));

    _boltScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _boltController, curve: Curves.easeInOut),
    );
  }

  void _updateRemaining() {
    final now = DateTime.now();
    final diff = widget.endTime.difference(now);
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
    if (_remaining == Duration.zero) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _boltController.dispose();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(360),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated bolt: wiggle + scale
          AnimatedBuilder(
            animation: _boltController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _boltRotation.value,
                child: Transform.scale(
                  scale: _boltScale.value,
                  child: child,
                ),
              );
            },
            child: FaIcon(
              FontAwesomeIcons.bolt,
              size: 14,
              color: AppColors.accentYellow,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'FLASH SALE',
            style: AppTextStyles.timerLabel,
          ),
          const SizedBox(width: 10),
          // Animated digits
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AnimatedDigit(value: _pad(hours)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(':', style: AppTextStyles.timerDigits),
              ),
              _AnimatedDigit(value: _pad(minutes)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(':', style: AppTextStyles.timerDigits),
              ),
              _AnimatedDigit(value: _pad(seconds)),
            ],
          ),
        ],
      ),
    );
  }
}

/// A single time unit that animates with a slide-down + fade when value changes.
class _AnimatedDigit extends StatelessWidget {
  final String value;

  const _AnimatedDigit({required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        // Slide down for incoming, slide up for outgoing
        final isIncoming = child.key == ValueKey(value);
        final offset = Tween<Offset>(
          begin: Offset(0, isIncoming ? -0.5 : 0.5),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: offset,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: SizedBox(
        key: ValueKey(value),
        width: 22,
        child: Text(
          value,
          style: AppTextStyles.timerDigits,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
