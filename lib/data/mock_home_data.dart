import 'dart:ui';

import '../routes/route_constants.dart';
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

/// Rotating announcement strings for the home-screen LiveTicker.
/// Replace with backend-driven copy once the promotions API is wired.
const List<String> mockTickerMessages = [
  'FREE SHIPPING on orders over 150 SAR',
  'NEW ARRIVALS just dropped — shop now',
  'FLASH DEAL · 40% off selected styles today',
  'LOYALTY · Earn 2× points all week',
];

/// Fallback shown when the ticker has no data (e.g. API failure).
const String tickerFallbackMessage = 'Welcome to SooKI — tap anywhere to shop';

/// Static banner slide shown in the home screen's RotatingSmartHero.
class HeroSlide {
  final String kicker;
  final String headline;
  final String subtext;
  final String ctaLabel;
  final String ctaRoute;
  final String imageUrl;

  const HeroSlide({
    required this.kicker,
    required this.headline,
    required this.subtext,
    required this.ctaLabel,
    required this.ctaRoute,
    required this.imageUrl,
  });
}

/// Mock hero slides for the home screen. Replace `imageUrl` with real CDN
/// links once the backend is wired.
const List<HeroSlide> mockHeroSlides = [
  HeroSlide(
    kicker: 'FLASH DEAL',
    headline: '40% off\nselected styles',
    subtext: 'Until midnight · tap to shop',
    ctaLabel: 'Shop Now',
    ctaRoute: dealsScreenRoute,
    imageUrl:
        'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=900&h=600&fit=crop',
  ),
  HeroSlide(
    kicker: 'NEW ARRIVALS',
    headline: 'Fresh drops\njust landed',
    subtext: 'From the brands you love',
    ctaLabel: 'Explore',
    ctaRoute: browseScreenRoute,
    imageUrl:
        'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=900&h=600&fit=crop',
  ),
  HeroSlide(
    kicker: 'LOYALTY REWARDS',
    headline: 'Earn 2× points\nthis week',
    subtext: 'Members unlock exclusive perks',
    ctaLabel: 'Join Now',
    ctaRoute: loyaltyScreenRoute,
    imageUrl:
        'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=900&h=600&fit=crop',
  ),
  HeroSlide(
    kicker: 'TONIGHT\'S EDIT',
    headline: 'Your shopping,\nafter dark',
    subtext: 'Curated nightly · for you only',
    ctaLabel: 'Open Edit',
    ctaRoute: browseScreenRoute,
    imageUrl:
        'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=900&h=600&fit=crop',
  ),
];
