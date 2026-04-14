import 'package:flutter/material.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';

/// Theme-aware skeleton placeholder. A light highlight band repeatedly pans
/// across a muted base, signaling that real content is loading. Drop it
/// anywhere a network image, list row, or text block is being fetched.
class SkeletonShimmer extends StatefulWidget {
  final BorderRadius borderRadius;
  final Duration duration;

  const SkeletonShimmer({
    super.key,
    this.borderRadius = BorderRadius.zero,
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final base = isDark
            ? AppColors.white.withValues(alpha: 0.14)
            : AppColors.gray200;
        final highlight = isDark
            ? AppColors.white.withValues(alpha: 0.40)
            : AppColors.white.withValues(alpha: 0.8);

        return ClipRRect(
          borderRadius: widget.borderRadius,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value;
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: base,
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + t * 2, 0),
                    end: Alignment(1.0 + t * 2, 0),
                    colors: [base, highlight, base],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
        );
      },
    );
  }
}
