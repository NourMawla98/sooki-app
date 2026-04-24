import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

/// Centralized text styles. Every style runs through [AppFonts] so the whole
/// app shares a single source-of-truth font (DM Sans today — change
/// [AppFonts.primary] to restyle everything).
///
/// Exceptions:
/// - `editorialTitle` / `editorialKicker` — serif aurora accent via
///   [AppFonts.editorial].
/// - `auroraMonoPrice` / `timerDigits` — monospace for price/counter digits.
class AppTextStyles {
  AppTextStyles._();

  // ─── Design System Canonical ────────────────────────────────────────────
  // These styles encode the agreed aurora design system.
  // Color variants (dark/light) are applied by callers via .copyWith().

  /// H1 — 34px / w900 / auroraPurple. Use white override in dark mode.
  static TextStyle get dsH1 => AppFonts.primary(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        color: AppColors.auroraPurple,
        height: 1.2,
      );

  /// H2 base — 26px / w900 / white. Always render inside [AuroraGradientText].
  static TextStyle get dsH2 => AppFonts.primary(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: AppColors.white,
        height: 1.2,
      );

  /// Section / Pattern-B kicker label — 11px / w800 / auroraPink / ls 2.0.
  /// Rendered UPPERCASE above an H2 in Pattern B titles.
  static TextStyle get dsSectionLabel => AppFonts.primary(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.auroraPink,
        letterSpacing: 2.0,
        height: 1.2,
      );

  /// Form field label — 11px / w800 / ls 1.8 / UPPERCASE / auroraPurple light.
  /// Callers: apply .copyWith(color: white) in dark mode.
  /// Apply .toUpperCase() to the label string at render time.
  static TextStyle get dsFieldLabel => AppFonts.primary(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.auroraPurple,
        letterSpacing: 1.8,
        height: 1.3,
      );

  /// Body — 16px / regular / auroraDeepBase. Use white override in dark mode.
  static TextStyle get dsBody => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.auroraDeepBase,
        height: 1.5,
      );

  /// Bold body — 16px / w700 / auroraDeepBase. Use white override in dark mode.
  static TextStyle get dsBodyBold => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.auroraDeepBase,
        height: 1.5,
      );

  /// Muted — 14px / regular / auroraPurple@0.65. Use mutedOnDark override.
  static TextStyle get dsMuted => AppFonts.primary(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.mutedOnLight,
        height: 1.4,
      );

  /// CTA button text — 13px / w900 / white / ls 1.8.
  static TextStyle get dsCTA => AppFonts.primary(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        color: AppColors.white,
        letterSpacing: 1.8,
        height: 1.2,
      );

  // ─── Logo ───────────────────────────────────────────────────────────────
  static TextStyle get logoLarge => AppFonts.primary(
        fontSize: 72,
        fontWeight: FontWeight.w900,
        color: AppColors.logoText,
        height: 1.0,
        letterSpacing: 1,
      );

  static TextStyle get logoMedium => AppFonts.primary(
        fontSize: 46,
        fontWeight: FontWeight.w900,
        color: AppColors.logoText,
        height: 1.0,
        letterSpacing: 0.5,
      );

  static TextStyle get logoSmall => AppFonts.primary(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: AppColors.logoText,
        height: 1.0,
        letterSpacing: 0,
      );

  static TextStyle get logoWhiteLarge => AppFonts.primary(
        fontSize: 72,
        fontWeight: FontWeight.w900,
        color: AppColors.white,
        height: 1.0,
        letterSpacing: -1.5,
      );

  static TextStyle get logoWhiteMedium => AppFonts.primary(
        fontSize: 46,
        fontWeight: FontWeight.w900,
        color: AppColors.white,
        height: 1.0,
        letterSpacing: -0.5,
      );

  // ─── Headings ───────────────────────────────────────────────────────────
  static TextStyle get heading1 => AppFonts.primary(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get heading2 => AppFonts.primary(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get heading3 => AppFonts.primary(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get heading4 => AppFonts.primary(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  // ─── Body ───────────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => AppFonts.primary(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodySmall => AppFonts.primary(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // ─── Labels & Captions ──────────────────────────────────────────────────
  static TextStyle get label => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get caption => AppFonts.primary(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.3,
      );

  static TextStyle get captionSmall => AppFonts.primary(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.3,
      );

  // ─── Buttons ────────────────────────────────────────────────────────────
  static TextStyle get buttonLarge => AppFonts.primary(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
        height: 1.2,
      );

  static TextStyle get buttonMedium => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
        height: 1.2,
      );

  static TextStyle get buttonSmall => AppFonts.primary(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
        height: 1.2,
      );

  // ─── Product Card ───────────────────────────────────────────────────────
  static TextStyle get productName => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get productPrice => AppFonts.primary(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AppColors.accentRed,
        height: 1.0,
      );

  static TextStyle get productOriginalPrice => AppFonts.primary(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textTertiary,
        decoration: TextDecoration.lineThrough,
        height: 1.0,
      );

  static TextStyle get productStock => AppFonts.primary(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.0,
      );

  // ─── Badges ─────────────────────────────────────────────────────────────
  static TextStyle get badgeText => AppFonts.primary(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: AppColors.white,
        height: 1.0,
        letterSpacing: 0.5,
      );

  static TextStyle get badgeTextSmall => AppFonts.primary(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: AppColors.white,
        height: 1.0,
        letterSpacing: 0.5,
      );

  // ─── Timer / Flash Sale ─────────────────────────────────────────────────
  static TextStyle get timerLabel => AppFonts.primary(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.accentYellow,
        height: 1.0,
        letterSpacing: 1.5,
      );

  // Monospace intentionally preserved — digit alignment.
  static const TextStyle timerDigits = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    fontFamily: 'monospace',
    height: 1.0,
  );

  // ─── Notifications ──────────────────────────────────────────────────────
  static TextStyle get notificationText => AppFonts.primary(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get notificationTime => AppFonts.primary(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textTertiary,
        height: 1.2,
      );

  // ─── Input Fields ───────────────────────────────────────────────────────
  static TextStyle get inputText => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get inputLabel => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get inputHint => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  // ─── Navigation ─────────────────────────────────────────────────────────
  static TextStyle get navLabel => AppFonts.primary(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.2,
      );

  static TextStyle get navLabelActive => AppFonts.primary(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.accentRed,
        height: 1.2,
      );

  // ─── Rating ─────────────────────────────────────────────────────────────
  static TextStyle get ratingValue => AppFonts.primary(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        height: 1.0,
      );

  // ─── Search ─────────────────────────────────────────────────────────────
  static TextStyle get searchPlaceholder => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  // ─── Section Titles ─────────────────────────────────────────────────────
  static TextStyle get sectionTitle => AppFonts.primary(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  // ─── Deals ──────────────────────────────────────────────────────────────
  static TextStyle get dealPrice => AppFonts.primary(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.accentRed,
      );

  static TextStyle get dealOriginalPrice => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.gray400,
        decoration: TextDecoration.lineThrough,
      );

  // ─── Loyalty ────────────────────────────────────────────────────────────
  static TextStyle get loyaltyPoints => AppFonts.primary(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
      );

  static TextStyle get loyaltyLabel => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.white,
      );

  static TextStyle get rewardTitle => AppFonts.primary(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      );

  static TextStyle get rewardDescription => AppFonts.primary(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.white,
      );

  // ─── Verified Badge ─────────────────────────────────────────────────────
  static TextStyle get verifiedBadge => AppFonts.primary(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      );

  // ─── Electric Aurora ────────────────────────────────────────────────────
  /// Editorial serif — used in home Section 4 ("The Cover") and auth headings.
  static TextStyle get editorialTitle => AppFonts.editorial(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        color: AppColors.white,
        height: 1.15,
      );

  static TextStyle get editorialKicker => AppFonts.primary(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.auroraPink,
        letterSpacing: 2.5,
        height: 1.2,
      );

  // Monospace price/counter — used by floating price tags and aurora counters.
  static const TextStyle auroraMonoPrice = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    fontFamily: 'monospace',
    height: 1.0,
  );

  // Small pill/chip label for aurora sections ("TONIGHT'S EDIT", "AI PICKED",
  // splash tagline).
  static TextStyle get auroraChipLabel => AppFonts.primary(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
        letterSpacing: 1.2,
        height: 1.0,
      );

  // Aurora tagline — used on splash under the logo.
  static TextStyle get auroraTagline => AppFonts.primary(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 3.0,
        height: 1.4,
      );
}
