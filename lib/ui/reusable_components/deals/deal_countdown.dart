import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_text_styles.dart';
import '../../../utils/number_localization.dart';

/// Time left as hh:mm:ss under a day, and as days plus hours beyond that.
String formatDealRemaining(Duration remaining) {
  final d = remaining.isNegative ? Duration.zero : remaining;
  if (d.inDays >= 1) {
    return 'deals.days_hours'.tr(
      namedArgs: {
        'days': localizedNumber(d.inDays),
        'hours': localizedNumber(d.inHours % 24),
      },
    );
  }
  String two(int n) => n.toString().padLeft(2, '0');
  return localizedDigits(
    '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}',
  );
}

/// A ticking countdown to [target], with an optional [label] in front.
///
/// Renders nothing when [target] is null, which is how a deal that never ends
/// shows no timer. [onElapsed] fires once when the count reaches zero while on
/// screen, so the owner can refetch; it does not fire for a target that had
/// already passed when the widget was built. When the phone clock runs ahead
/// of the server, that refetch can return the same, not yet passed, time, so
/// [onElapsed] fires again a few times, a few seconds apart, while the target
/// stays unchanged.
class DealCountdown extends StatefulWidget {
  final DateTime? target;
  final String? label;
  final Color color;
  final double fontSize;
  final bool showIcon;
  final VoidCallback? onElapsed;

  const DealCountdown({
    super.key,
    required this.target,
    required this.color,
    this.label,
    this.fontSize = 11,
    this.showIcon = true,
    this.onElapsed,
  });

  @override
  State<DealCountdown> createState() => _DealCountdownState();
}

class _DealCountdownState extends State<DealCountdown> {
  static const _retryDelay = Duration(seconds: 5);
  static const _maxRetries = 3;

  Timer? _timer;
  Duration _remaining = Duration.zero;
  int _retries = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(DealCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    _retries = 0;
    final target = widget.target;
    if (target == null) return;
    _remaining = target.difference(DateTime.now());
    if (_remaining <= Duration.zero) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final target = widget.target;
    if (!mounted || target == null) return;
    final remaining = target.difference(DateTime.now());
    setState(() => _remaining = remaining);
    if (remaining <= Duration.zero) {
      _timer?.cancel();
      _elapsed();
    }
  }

  void _elapsed() {
    final onElapsed = widget.onElapsed;
    if (onElapsed == null) return;
    onElapsed();
    if (_retries >= _maxRetries) return;
    _timer = Timer(_retryDelay, () {
      if (!mounted) return;
      _retries++;
      _elapsed();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.target == null) return const SizedBox.shrink();
    final style = AppTextStyles.auroraMonoPrice.copyWith(
      color: widget.color,
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w800,
      height: 1.0,
    );
    final label = widget.label;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showIcon) ...[
          FaIcon(
            FontAwesomeIcons.clock,
            size: widget.fontSize - 1,
            color: widget.color,
          ),
          SizedBox(width: widget.fontSize * 0.4),
        ],
        if (label != null) ...[
          Text(
            label,
            style: AppTextStyles.captionSmall.copyWith(
              color: widget.color,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
          SizedBox(width: widget.fontSize * 0.35),
        ],
        Text(formatDealRemaining(_remaining), style: style),
      ],
    );
  }
}
