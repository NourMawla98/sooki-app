import 'package:flutter/material.dart';

/// Centralized color palette for the Sooki app
///
/// All colors used throughout the app should be defined here.
/// This allows for easy theme changes and consistency.
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Brand Colors
  static const Color primaryPurple = Color(0xFF4D4C7D);
  static const Color lightPurple = Color(0xFF6B6AA3);

  // Accent Colors
  static const Color accentRed = Color(0xFFFF6B6B);
  static const Color lightRed = Color(0xFFFF8E8E);

  static const Color accentGreen = Color(0xFF6BCB77);
  static const Color lightGreen = Color(0xFF5AB368);

  static const Color accentYellow = Color(0xFFFFD93D);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Semantic Colors
  static const Color success = accentGreen;
  static const Color error = accentRed;
  static const Color warning = accentYellow;
  static const Color info = primaryPurple;

  // Background Colors
  static const Color backgroundLight = gray50;
  static const Color backgroundWhite = white;
  static const Color backgroundGray = gray100;

  // Text Colors
  static const Color textPrimary = primaryPurple;
  static const Color textSecondary = gray600;
  static const Color textTertiary = gray400;
  static const Color textWhite = white;
  static const Color textBlack = black;

  // Border Colors
  static const Color borderLight = gray100;
  static const Color borderMedium = gray200;
  static const Color borderDark = gray300;

  // Logo Colors
  static const Color logoCoral = Color(0xFFFF5E8A);
  static const Color logoTeal = Color(0xFF00D4C5);
  static const Color logoShoppingBag = logoCoral;
  static const Color logoDeliveryTruck = logoTeal;
  static const Color logoText = primaryPurple;

  // Gradient Colors
  static List<Color> get primaryGradient => [primaryPurple, lightPurple];
  static List<Color> get splashGradient => [
        primaryPurple,
        lightPurple,
        primaryPurple,
      ];
  static List<Color> get redGradient => [accentRed, lightRed];

  // Rainbow Navigation Gradient (for bottom nav bar)
  static List<Color> get rainbowGradient => [
        accentRed,
        accentYellow,
        accentGreen,
        accentRed,
      ];

  // Shadow Colors
  static Color get shadowLight => black.withValues(alpha: 0.05);
  static Color get shadowMedium => black.withValues(alpha: 0.1);
  static Color get shadowDark => black.withValues(alpha: 0.2);

  // Overlay Colors
  static Color get overlayLight => black.withValues(alpha: 0.3);
  static Color get overlayMedium => black.withValues(alpha: 0.5);
  static Color get overlayDark => black.withValues(alpha: 0.7);

  // Interactive States
  static Color get hoverPurple => primaryPurple.withValues(alpha: 0.05);
  static Color get hoverRed => accentRed.withValues(alpha: 0.05);

  // Badge Colors
  static const Color badgeNew = accentYellow;
  static const Color badgeDiscount = accentRed;
  static const Color badgeVerified = accentGreen;

  // Notification Colors
  static const Color notificationUnread = accentRed;
  static const Color notificationRead = gray400;

  // Banner Colors
  static const Color bannerBackground = Color(0xFFF5E1D0); // Warm beige/peach
  static const Color bannerBadgeYellow = Color(0xFFFFD93D); // Yellow badge
  static const Color bannerTitleAccent = Color(0xFFFFD93D); // Yellow for "Your Style"
  static const Color bannerProductFrame = Color(0xFF4D4C7D); // Purple frame border

  // Verified product
  static const Color verifiedGreen = Color(0xFF6BCB77);
  static const Color verifiedGreenLight = Color(0xFFE8F5E9);
  static const Color verifiedGreenBorder = Color(0xFF6BCB77);

  // Discount
  static const Color discountBadge = Color(0xFFFF6B6B);

  // Deals page
  static const Color dealsBannerDark = Color(0xFF1A1A2E);
  static const Color dealsBannerAccent = Color(0xFFE94560);
  static const Color freeShippingGreen = Color(0xFF00B894);
  static const Color freeShippingGreenLight = Color(0xFF55EFC4);

  // Loyalty
  static const Color loyaltyPurple = Color(0xFF6C5CE7);
  static const Color loyaltyPurpleLight = Color(0xFFA29BFE);
  static const Color tierGold = Color(0xFFFFD700);
  static const Color tierPlatinum = Color(0xFFE5E4E2);

  // Reward card gradients
  static const Color rewardGreen1 = Color(0xFF00B894);
  static const Color rewardGreen2 = Color(0xFF55EFC4);
  static const Color rewardYellow1 = Color(0xFFFDCB6E);
  static const Color rewardYellow2 = Color(0xFFF6E58D);
  static const Color rewardCoral1 = Color(0xFFFF7675);
  static const Color rewardCoral2 = Color(0xFFFAB1A0);
  static const Color rewardPurple1 = Color(0xFF6C5CE7);
  static const Color rewardPurple2 = Color(0xFFA29BFE);

  // Referral
  static const Color referralGreen = Color(0xFF00B894);
  static const Color referralGreenDark = Color(0xFF00A381);

  // Profile
  static const Color profileCardPurple = Color(0xFF4D4C7D);
  static const Color profileCardPurpleLight = Color(0xFF6B6AA3);
  static const Color profileIconOrange = Color(0xFFFF6348);
  static const Color profileIconGreen = Color(0xFF2ED573);
  static const Color profileIconPink = Color(0xFFFF4757);
  static const Color profileIconYellow = Color(0xFFFFA502);
  static const Color profileIconTeal = Color(0xFF1E90FF);
  static const Color profileIconGray = Color(0xFF747D8C);
  static const Color profileIconHelpPink = Color(0xFFFF6B81);

  // ─── Electric Aurora Design Tokens ──────────────────────────────────────────
  // Shared by splash, auth, and home-screen Electric Aurora surfaces.
  static const Color auroraDeepBase = Color(0xFF0A0A18);
  static const Color auroraPink = Color(0xFFFF00C8);
  static const Color auroraPurple = Color(0xFF7C3AED);
  static const Color auroraElectricBlue = Color(0xFF0096FF);
  static const Color auroraElectricBlueLight = Color(0xFF2AB5FF);

  // Soft glow variants (used for RadialGradient background blobs + glass borders)
  static Color get auroraPinkGlow => auroraPink.withValues(alpha: 0.30);
  static Color get auroraPinkGlowStrong => auroraPink.withValues(alpha: 0.45);
  static Color get auroraPurpleGlow => auroraPurple.withValues(alpha: 0.30);
  static Color get auroraBlueGlow => auroraElectricBlue.withValues(alpha: 0.30);
  static Color get auroraGlass => black.withValues(alpha: 0.55);
  // Light-mode glass fill (semi-transparent white for aurora surfaces in light theme).
  static Color get auroraLightGlass => white.withValues(alpha: 0.65);

  // Signature aurora gradient (pink → purple → blue)
  static const List<Color> auroraCartButtonGradient = [
    auroraPink,
    auroraPurple,
    auroraElectricBlue,
  ];

  // Inverted Aurora (light theme base — NOT pure white)
  static const Color auroraLightBase = Color(0xFFF8F8FC);

  // Splash dim-aurora palette (softer than auroraDeepBase — used on splash
  // gradient top/bottom; `splashDimViolet` is the mid stop for the tint).
  static const Color splashDimBase = Color(0xFF12121F);
  static const Color splashDimViolet = Color(0xFF1A1430);

  // ─── Dark Theme Neutrals (for ThemedColors) ─────────────────────────────
  static const Color darkBackground = Color(0xFF121220);
  static const Color darkSurface = Color(0xFF1E1E2E);
  static const Color darkElevatedSurface = Color(0xFF24243A);
  static const Color darkBorder = Color(0xFF2A2A3E);
}
