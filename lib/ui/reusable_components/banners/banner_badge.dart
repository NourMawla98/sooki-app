import 'package:flutter/material.dart';

import '../../../themes/themes.dart';

/// A pill-shaped badge for promotional text on banners.
///
/// Typically used to display sale announcements or promotional labels.
class BannerBadge extends StatelessWidget {
  /// The text to display in the badge
  final String text;

  /// Background color of the badge
  final Color backgroundColor;

  /// Text color
  final Color textColor;

  /// Horizontal padding inside the badge
  final double horizontalPadding;

  /// Vertical padding inside the badge
  final double verticalPadding;

  /// Font size for the badge text
  final double fontSize;

  const BannerBadge({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.primaryPurple,
    this.textColor = AppColors.white,
    this.horizontalPadding = 12,
    this.verticalPadding = 6,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyles.badgeText.copyWith(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
