import 'package:flutter/material.dart';

/// Sooki Aurora palette — the **only** canonical colors in the app.
///
/// Every other name in this file is a deprecated alias that resolves to one
/// of the approved colors below. Migrate each callsite to the canonical name
/// when you touch its screen.
class AppColors {
  AppColors._();

  // ─── APPROVED PALETTE ────────────────────────────────────────────────
  static const Color auroraPurple = Color(0xFF7C3AED);
  static const Color auroraPink = Color(0xFFFF00C8);
  static const Color auroraElectricBlue = Color(0xFF0096FF);
  static const Color auroraDeepBase = Color(0xFF0A0A18);
  // Lifted dark surface for panels and dialogs that sit above the deep base.
  static const Color auroraDeepElevated = Color(0xFF12122A);
  static const Color auroraLightBase = Color(0xFFEFEDF8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000); // shadows / overlays only
  static const Color verifiedGreen = Color(0xFF6BCB77); // verified-seller badge ONLY
  static const Color auroraRed = Color(0xFFFF2D55); // error states ONLY
  static const Color auroraGold = Color(0xFFF59E0B); // Editor's Pick tag
  static const Color auroraTeal = Color(0xFF06B6D4); // Quality Checked tag
  static const Color skeletonBase = Color(0xFFE5E7EB); // skeleton loading placeholders only

  /// Signature aurora gradient — pink → purple → blue. Every primary CTA,
  /// every shimmer, every gradient-masked text uses this.
  static const List<Color> auroraGradient = <Color>[
    auroraPink,
    auroraPurple,
    auroraElectricBlue,
  ];

  // ─── Muted text — NEVER grey. Aurora-tinted alpha only. ─────────────
  static Color get mutedOnLight => auroraPurple.withValues(alpha: 0.65);
  static Color get mutedOnDark => white.withValues(alpha: 0.65);

  // ─── Aurora glow variants (alpha on aurora colors). ─────────────────
  static Color get auroraPinkGlow => auroraPink.withValues(alpha: 0.30);
  static Color get auroraPurpleGlow => auroraPurple.withValues(alpha: 0.30);
  static Color get auroraBlueGlow => auroraElectricBlue.withValues(alpha: 0.30);

  // ─── Shadow & overlay (black-alpha only — never a new color). ───────
  static Color get shadowLight => black.withValues(alpha: 0.05);
  static Color get shadowMedium => black.withValues(alpha: 0.10);
  static Color get shadowDark => black.withValues(alpha: 0.20);
  static Color get overlayLight => black.withValues(alpha: 0.30);
  static Color get overlayMedium => black.withValues(alpha: 0.50);
  static Color get overlayDark => black.withValues(alpha: 0.70);

  // ─── Glass surfaces (used by cart/address sheets + splash/auth). ────
  static Color get auroraGlass => black.withValues(alpha: 0.55);
  static Color get auroraLightGlass => white.withValues(alpha: 0.65);

  // ─── Cart background gradient ────────────────────────────────────────
  // Four-stop aurora gradient for depth. Built from alpha-shifted aurora
  // tokens so no new literal colors are introduced.
  static List<Color> get cartBackgroundGradientDark => <Color>[
        auroraDeepBase,
        Color.alphaBlend(auroraPurple.withValues(alpha: 0.08), auroraDeepBase),
        Color.alphaBlend(auroraPink.withValues(alpha: 0.06), auroraDeepBase),
        auroraDeepBase,
      ];
  static List<Color> get cartBackgroundGradientLight => <Color>[
        auroraLightBase,
        Color.alphaBlend(auroraPurple.withValues(alpha: 0.06), auroraLightBase),
        Color.alphaBlend(auroraPink.withValues(alpha: 0.04), auroraLightBase),
        auroraLightBase,
      ];

  // ════════════════════════════════════════════════════════════════════
  // DEPRECATED — every legacy name below now points at an approved color.
  // Migrate callsites to the canonical name, then delete the alias.
  // ════════════════════════════════════════════════════════════════════

  // ── Legacy brand / purples ────────────────────────────────────────
  @Deprecated('Use auroraPurple.')
  static const Color primaryPurple = auroraPurple;
  @Deprecated('Use auroraPurple.')
  static const Color lightPurple = auroraPurple;
  @Deprecated('Use auroraPurple.')
  static const Color textPrimary = auroraPurple;
  @Deprecated('Use AppColors.mutedOnLight or auroraPurple.')
  static const Color textSecondary = auroraPurple;
  @Deprecated('Use AppColors.mutedOnLight or auroraPurple.')
  static const Color textTertiary = auroraPurple;
  @Deprecated('Use white.')
  static const Color textWhite = white;
  @Deprecated('Use auroraDeepBase.')
  static const Color textBlack = auroraDeepBase;

  // ── Legacy accents ────────────────────────────────────────────────
  @Deprecated('Use auroraPink.')
  static const Color accentRed = auroraPink;
  @Deprecated('Use auroraPink.')
  static const Color lightRed = auroraPink;
  @Deprecated('Use verifiedGreen for the verified-seller badge only.')
  static const Color accentGreen = verifiedGreen;
  @Deprecated('Use verifiedGreen.')
  static const Color lightGreen = verifiedGreen;
  @Deprecated('Use auroraPink.')
  static const Color accentYellow = auroraPink;

  // ── Legacy grays — NEVER grey on screen anymore. ──────────────────
  @Deprecated('Use auroraLightBase.')
  static const Color gray50 = auroraLightBase;
  @Deprecated('Use auroraLightBase.')
  static const Color gray100 = auroraLightBase;
  @Deprecated('Use auroraPurple (or AppColors.mutedOnLight for alpha).')
  static const Color gray200 = auroraPurple;
  @Deprecated('Use auroraPurple (or AppColors.mutedOnLight for alpha).')
  static const Color gray300 = auroraPurple;
  @Deprecated('Use auroraPurple (or AppColors.mutedOnLight for alpha).')
  static const Color gray400 = auroraPurple;
  @Deprecated('Use auroraPurple.')
  static const Color gray500 = auroraPurple;
  @Deprecated('Use auroraPurple.')
  static const Color gray600 = auroraPurple;
  @Deprecated('Use auroraPurple.')
  static const Color gray700 = auroraPurple;
  @Deprecated('Use auroraDeepBase.')
  static const Color gray800 = auroraDeepBase;
  @Deprecated('Use auroraDeepBase.')
  static const Color gray900 = auroraDeepBase;

  // ── Semantic ──────────────────────────────────────────────────────
  @Deprecated('Use verifiedGreen.')
  static const Color success = verifiedGreen;
  @Deprecated('Use auroraRed.')
  static const Color error = auroraRed;
  @Deprecated('Use auroraPink.')
  static const Color warning = auroraPink;
  @Deprecated('Use auroraElectricBlue.')
  static const Color info = auroraElectricBlue;

  // ── Backgrounds ───────────────────────────────────────────────────
  @Deprecated('Use auroraLightBase.')
  static const Color backgroundLight = auroraLightBase;
  @Deprecated('Use white.')
  static const Color backgroundWhite = white;
  @Deprecated('Use auroraLightBase.')
  static const Color backgroundGray = auroraLightBase;

  // ── Borders ───────────────────────────────────────────────────────
  @Deprecated('Use auroraPurple (with alpha for softness).')
  static const Color borderLight = auroraPurple;
  @Deprecated('Use auroraPurple.')
  static const Color borderMedium = auroraPurple;
  @Deprecated('Use auroraPurple.')
  static const Color borderDark = auroraPurple;

  // ── Logo ──────────────────────────────────────────────────────────
  @Deprecated('Use auroraPink.')
  static const Color logoCoral = auroraPink;
  @Deprecated('Use auroraElectricBlue.')
  static const Color logoTeal = auroraElectricBlue;
  static const Color logoShoppingBag = Color(0xFFFF6B6B);
  static const Color logoDeliveryTruck = verifiedGreen;
  @Deprecated('Use auroraPurple.')
  static const Color logoText = auroraPurple;

  // ── Gradients ─────────────────────────────────────────────────────
  @Deprecated('Use auroraGradient.')
  static const List<Color> primaryGradient = auroraGradient;
  @Deprecated('Use auroraGradient.')
  static const List<Color> splashGradient = auroraGradient;
  @Deprecated('Use auroraGradient.')
  static const List<Color> redGradient = auroraGradient;
  @Deprecated('Use auroraGradient.')
  static const List<Color> rainbowGradient = auroraGradient;
  @Deprecated('Use auroraGradient.')
  static const List<Color> auroraCartButtonGradient = auroraGradient;

  // ── Interactive hovers ────────────────────────────────────────────
  @Deprecated('Use auroraPurple.withValues(alpha: 0.05).')
  static Color get hoverPurple => auroraPurple.withValues(alpha: 0.05);
  @Deprecated('Use auroraPink.withValues(alpha: 0.05).')
  static Color get hoverRed => auroraPink.withValues(alpha: 0.05);

  // ── Badges ────────────────────────────────────────────────────────
  @Deprecated('Use auroraPink.')
  static const Color badgeNew = auroraPink;
  @Deprecated('Use auroraPink.')
  static const Color badgeDiscount = auroraPink;
  @Deprecated('Use verifiedGreen.')
  static const Color badgeVerified = verifiedGreen;

  // ── Notifications ─────────────────────────────────────────────────
  @Deprecated('Use auroraPink.')
  static const Color notificationUnread = auroraPink;
  @Deprecated('Use AppColors.mutedOnLight or mutedOnDark.')
  static const Color notificationRead = auroraPurple;

  // ── Banner (will be rebuilt) ──────────────────────────────────────
  @Deprecated('Use auroraLightBase.')
  static const Color bannerBackground = auroraLightBase;
  @Deprecated('Use auroraPink.')
  static const Color bannerBadgeYellow = auroraPink;
  @Deprecated('Use auroraPink.')
  static const Color bannerTitleAccent = auroraPink;
  @Deprecated('Use auroraPurple.')
  static const Color bannerProductFrame = auroraPurple;

  // ── Verified extras ───────────────────────────────────────────────
  @Deprecated('Use verifiedGreen.')
  static const Color verifiedGreenLight = verifiedGreen;
  @Deprecated('Use verifiedGreen.')
  static const Color verifiedGreenBorder = verifiedGreen;

  // ── Discount ──────────────────────────────────────────────────────
  @Deprecated('Use auroraPink.')
  static const Color discountBadge = auroraPink;

  // ── Deals ─────────────────────────────────────────────────────────
  @Deprecated('Use auroraDeepBase.')
  static const Color dealsBannerDark = auroraDeepBase;
  @Deprecated('Use auroraPink.')
  static const Color dealsBannerAccent = auroraPink;
  @Deprecated('Use verifiedGreen.')
  static const Color freeShippingGreen = verifiedGreen;
  @Deprecated('Use verifiedGreen.')
  static const Color freeShippingGreenLight = verifiedGreen;

  // ── Loyalty / tiers ───────────────────────────────────────────────
  @Deprecated('Use auroraPurple.')
  static const Color loyaltyPurple = auroraPurple;
  @Deprecated('Use auroraPurple.')
  static const Color loyaltyPurpleLight = auroraPurple;
  @Deprecated('Use auroraPink.')
  static const Color tierGold = auroraPink;
  @Deprecated('Use auroraPurple.')
  static const Color tierPlatinum = auroraPurple;

  // ── Reward card gradients ─────────────────────────────────────────
  @Deprecated('Use verifiedGreen.')
  static const Color rewardGreen1 = verifiedGreen;
  @Deprecated('Use verifiedGreen.')
  static const Color rewardGreen2 = verifiedGreen;
  @Deprecated('Use auroraPink.')
  static const Color rewardYellow1 = auroraPink;
  @Deprecated('Use auroraPink.')
  static const Color rewardYellow2 = auroraPink;
  @Deprecated('Use auroraPink.')
  static const Color rewardCoral1 = auroraPink;
  @Deprecated('Use auroraPink.')
  static const Color rewardCoral2 = auroraPink;
  @Deprecated('Use auroraPurple.')
  static const Color rewardPurple1 = auroraPurple;
  @Deprecated('Use auroraPurple.')
  static const Color rewardPurple2 = auroraPurple;

  // ── Referral ──────────────────────────────────────────────────────
  @Deprecated('Use verifiedGreen.')
  static const Color referralGreen = verifiedGreen;
  @Deprecated('Use verifiedGreen.')
  static const Color referralGreenDark = verifiedGreen;

  // ── Profile ───────────────────────────────────────────────────────
  @Deprecated('Use auroraPurple.')
  static const Color profileCardPurple = auroraPurple;
  @Deprecated('Use auroraPurple.')
  static const Color profileCardPurpleLight = auroraPurple;
  @Deprecated('Use auroraPink.')
  static const Color profileIconOrange = auroraPink;
  @Deprecated('Use verifiedGreen.')
  static const Color profileIconGreen = verifiedGreen;
  @Deprecated('Use auroraPink.')
  static const Color profileIconPink = auroraPink;
  @Deprecated('Use auroraPink.')
  static const Color profileIconYellow = auroraPink;
  @Deprecated('Use auroraElectricBlue.')
  static const Color profileIconTeal = auroraElectricBlue;
  @Deprecated('Use AppColors.mutedOnLight or auroraPurple.')
  static const Color profileIconGray = auroraPurple;
  @Deprecated('Use auroraPink.')
  static const Color profileIconHelpPink = auroraPink;

  // ── Aurora extras (kept for now, will fold into canonical aurora) ─
  @Deprecated('Use auroraElectricBlue.')
  static const Color auroraElectricBlueLight = auroraElectricBlue;
  @Deprecated('Use auroraPinkGlow.')
  static Color get auroraPinkGlowStrong => auroraPink.withValues(alpha: 0.45);
  @Deprecated('Use auroraDeepBase.')
  static const Color splashDimBase = auroraDeepBase;
  @Deprecated('Use auroraPurple.')
  static const Color splashDimViolet = auroraPurple;

  // ── Dark neutrals (from the old ThemedColors system) ──────────────
  @Deprecated('Use auroraDeepBase.')
  static const Color darkBackground = auroraDeepBase;
  @Deprecated('Use auroraDeepBase.')
  static const Color darkSurface = auroraDeepBase;
  @Deprecated('Use auroraDeepBase.')
  static const Color darkElevatedSurface = auroraDeepBase;
  @Deprecated('Use auroraPurple.')
  static const Color darkBorder = auroraPurple;
}
