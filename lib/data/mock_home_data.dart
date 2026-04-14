import '../routes/route_constants.dart';

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
