import 'dart:ui';

import '../themes/app_colors.dart';

/// Single "AI picked" recommendation surfaced in the For You Deck.
class ForYouPick {
  final int itemId;
  final String name;
  final double price;
  final String why;
  final String? imageUrl;
  final List<Color> gradient;

  const ForYouPick({
    required this.itemId,
    required this.name,
    required this.price,
    required this.why,
    this.imageUrl,
    required this.gradient,
  });
}

// Gradient palette cycled when mapping API items to ForYouPick.
const List<List<Color>> forYouGradientPalette = [
  [AppColors.auroraPink, Color(0xFF7C0F5F)],
  [AppColors.auroraElectricBlue, Color(0xFF1A1A3A)],
  [AppColors.auroraPurple, AppColors.auroraPink],
  [AppColors.auroraGold, AppColors.auroraPurple],
];
