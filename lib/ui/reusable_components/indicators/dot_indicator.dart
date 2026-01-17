import 'package:flutter/material.dart';

import '../../../themes/themes.dart';

/// A reusable page indicator with animated dots.
///
/// Shows a row of dots where the current page is highlighted.
/// Commonly used with PageView or carousel components.
///
/// Example:
/// ```dart
/// DotIndicator(
///   itemCount: 5,
///   currentIndex: 2,
/// )
/// ```
class DotIndicator extends StatelessWidget {
  /// Total number of dots/pages
  final int itemCount;

  /// Currently active page index (0-based)
  final int currentIndex;

  /// Color of the active dot
  final Color activeColor;

  /// Color of inactive dots
  final Color inactiveColor;

  /// Size of each dot
  final double dotSize;

  /// Size of the active dot (defaults to dotSize if not specified)
  final double? activeDotSize;

  /// Spacing between dots
  final double spacing;

  const DotIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = AppColors.white,
    this.inactiveColor = const Color(0x80FFFFFF), // 50% white
    this.dotSize = 8,
    this.activeDotSize,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;
        final size = isActive ? (activeDotSize ?? dotSize) : dotSize;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
