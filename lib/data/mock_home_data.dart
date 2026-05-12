import 'dart:ui';

import '../themes/app_colors.dart';

/// Single "AI picked" recommendation surfaced in the For You Deck.
class ForYouPick {
  final String name;
  final double price;
  final String why;
  final String imageUrl;
  final List<Color> gradient;

  const ForYouPick({
    required this.name,
    required this.price,
    required this.why,
    required this.imageUrl,
    required this.gradient,
  });
}

/// Hand-curated aspirational picks for the For You Deck. Replace `imageUrl`
/// with real CDN links once the recommendations API is wired. `gradient` is
/// the fallback shown while the image loads or if the request fails.
final List<ForYouPick> mockForYouPicks = [
  ForYouPick(
    name: 'Satin Midi Dress',
    price: 119,
    why: 'Because you liked Silk Blouse',
    imageUrl:
        'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=600&h=800&fit=crop',
    gradient: [AppColors.auroraPink, const Color(0xFF7C0F5F)],
  ),
  ForYouPick(
    name: 'Velvet Blazer',
    price: 159,
    why: 'Matches your evening style',
    imageUrl:
        'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&h=800&fit=crop',
    gradient: [AppColors.auroraElectricBlue, const Color(0xFF1A1A3A)],
  ),
  ForYouPick(
    name: 'Linen Sneakers',
    price: 75,
    why: 'Trending in your size',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&h=800&fit=crop',
    gradient: [const Color(0xFFD3FF3A), const Color(0xFF6AB80A)],
  ),
  ForYouPick(
    name: 'Wool Scarf',
    price: 95,
    why: 'Your favorite brand restocked',
    imageUrl:
        'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=600&h=800&fit=crop',
    gradient: [AppColors.auroraPurple, AppColors.auroraPink],
  ),
];
