import 'package:flutter/material.dart';
import '../../../themes/app_colors.dart';

/// Small circular dot badge indicator for notifications
/// Positioned on top-right corner of parent widget
class NotificationDotBadge extends StatelessWidget {
  final bool show;
  final double size;

  const NotificationDotBadge({
    super.key,
    this.show = true,
    this.size = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.accentRed,
        shape: BoxShape.circle,
      ),
    );
  }
}
