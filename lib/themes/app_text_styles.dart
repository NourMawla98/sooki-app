import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle logoLarge = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w900,
    color: AppColors.logoText,
    height: 1.0,
    letterSpacing: 1,
    fontFamily: '',
  );

  static const TextStyle logoMedium = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: AppColors.logoText,
    height: 1.0,
    letterSpacing: 0.5,
    fontFamily: '',
  );

  static const TextStyle logoSmall = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.logoText,
    height: 1.0,
    letterSpacing: 0,
    fontFamily: '',
  );

  static const TextStyle logoWhiteLarge = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    height: 1.0,
    letterSpacing: -1.5,
    fontFamily: '',
  );

  static const TextStyle logoWhiteMedium = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    height: 1.0,
    letterSpacing: -0.5,
    fontFamily: '',
  );

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Labels & Captions
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static const TextStyle captionSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // Buttons
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    height: 1.2,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    height: 1.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    height: 1.2,
  );

  // Product Card Styles
  static const TextStyle productName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle productPrice = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: AppColors.accentRed,
    height: 1.0,
  );

  static const TextStyle productOriginalPrice = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    decoration: TextDecoration.lineThrough,
    height: 1.0,
  );

  static const TextStyle productStock = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.0,
  );

  // Badges
  static const TextStyle badgeText = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    height: 1.0,
    letterSpacing: 0.5,
  );

  static const TextStyle badgeTextSmall = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    height: 1.0,
    letterSpacing: 0.5,
  );

  // Timer / Flash Sale
  static const TextStyle timerLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.accentYellow,
    height: 1.0,
    letterSpacing: 1.5,
  );

  static const TextStyle timerDigits = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    fontFamily: 'monospace',
    height: 1.0,
  );

  // Notifications
  static const TextStyle notificationText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle notificationTime = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.2,
  );

  // Input Fields
  static const TextStyle inputText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle inputHint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  // Navigation
  static const TextStyle navLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.2,
  );

  static const TextStyle navLabelActive = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppColors.accentRed,
    height: 1.2,
  );

  // Rating
  static const TextStyle ratingValue = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.0,
  );

  // Search
  static const TextStyle searchPlaceholder = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  // Section titles
  static TextStyle get sectionTitle => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  // Deal prices
  static TextStyle get dealPrice => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.accentRed,
      );

  static TextStyle get dealOriginalPrice => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.gray400,
        decoration: TextDecoration.lineThrough,
      );

  // Loyalty
  static TextStyle get loyaltyPoints => GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
      );

  static TextStyle get loyaltyLabel => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.white,
      );

  static TextStyle get rewardTitle => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      );

  static TextStyle get rewardDescription => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.white,
      );

  // Verified badge
  static TextStyle get verifiedBadge => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      );
}
