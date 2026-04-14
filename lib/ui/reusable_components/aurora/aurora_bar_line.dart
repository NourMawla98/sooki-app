import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';

/// Thin animated aurora gradient line (blue → purple → pink → blue) that
/// slowly pans horizontally. Used on top of the bottom nav bar to replace
/// the old rainbow accent.
class AuroraBarLine extends StatefulWidget {
  final double height;
  final Duration duration;

  const AuroraBarLine({
    super.key,
    this.height = 4,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AuroraBarLine> createState() => _AuroraBarLineState();
}

class _AuroraBarLineState extends State<AuroraBarLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  AppColors.auroraElectricBlue,
                  AppColors.auroraPurple,
                  AppColors.auroraPink,
                  AppColors.auroraElectricBlue,
                  AppColors.auroraPurple,
                  AppColors.auroraPink,
                  AppColors.auroraElectricBlue,
                ],
                stops: const [0.0, 0.16, 0.33, 0.5, 0.66, 0.83, 1.0],
                begin: Alignment(-1 + t * 2, 0),
                end: Alignment(1 + t * 2, 0),
                tileMode: TileMode.repeated,
              ),
            ),
          );
        },
      ),
    );
  }
}
