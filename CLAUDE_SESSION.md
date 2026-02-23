# Sooki App - Development Session Log

**Last Updated:** February 23, 2026

---

## Session: February 23, 2026

### What Was Accomplished

#### 1. Flash Deals Opacity Bug Fix ✅
- **Bug:** Red error screen appeared briefly before flash deal cards loaded on the Browse page
- **Root Cause:** `Curves.easeOutBack` overshoots past 1.0 (~1.05), but `Opacity` widget requires values strictly between 0.0 and 1.0. The overshoot caused an assertion error in debug mode.
- **Fix:** Added `.clamp(0.0, 1.0)` to the opacity value in `flash_deals_section.dart` line 188. The `Transform.translate` offset still uses the raw value to preserve the spring/bounce effect.
- **File:** `lib/ui/screens/browse/widgets/flash_deals_section.dart`

#### 2. Categories + New Arrivals Plan Created ✅
- Reviewed Magic Patterns design reference for browse page layout
- Identified next sections to implement: **Category Pills** + **New Arrivals Section**
- Created `categories_new_arrivals_plan.md` with 3-phase plan
- **Decisions made:**
  - Mock data for both categories and products (API integration later)
  - Buttons (heart/favorite, add to cart) are visual only for now
  - Categories: `[All, Dresses, Tops, Shoes, Accessories, Sale]`

### Code Changes Made

**Modified Files:**
```
lib/ui/screens/browse/widgets/flash_deals_section.dart - Fixed opacity clamp bug
```

**Plan Files:**
```
categories_new_arrivals_plan.md - Feature plan for categories + new arrivals (approved)
```

### Build Status
- ✅ `flutter analyze` - No issues found

---

## Project Overview

### Tech Stack
- **Framework:** Flutter 3.38.5 (Dart 3.10.4)
- **Language:** Dart
- **Architecture:** Clean Architecture
- **DI:** get_it + injectable
- **HTTP Client:** Dio with custom interceptors & smart retry
- **State Management:** StatefulWidget (local state)
- **Data Models:** Freezed (immutable DTOs)
- **Error Handling:** fpdart (Either-based)
- **Icons:** Font Awesome Flutter
- **Fonts:** Google Fonts
- **Theme:** Centralized AppColors + AppTextStyles
- **Local Storage:** SharedPreferences

---

## Project Structure

```
lib/
├── enums/                              # ALL app enums (CRITICAL: all enums here)
│   ├── app_language.dart               # Language enum (EN=1, AR=2, FR=3)
│   └── banner_type.dart                # Banner type enum (browsePage=1)
├── services/
│   └── language_service.dart           # Language detection & caching
├── ui/
│   ├── header/
│   │   └── app_header.dart
│   ├── screens/
│   │   ├── splash/
│   │   ├── sign_in/
│   │   ├── sign_up/
│   │   ├── forgot_password/
│   │   ├── main/                       # Main container with IndexedStack nav
│   │   ├── browse/
│   │   │   ├── browse_screen.dart      # ✅ Banner + Flash Deals
│   │   │   └── widgets/
│   │   │       ├── browse_banner_section.dart  # ✅ With shimmer skeleton
│   │   │       └── flash_deals_section.dart    # ✅ With opacity fix
│   │   ├── deals/                      # Placeholder only
│   │   ├── shopping/                   # Placeholder only
│   │   ├── loyalty/                    # Placeholder only
│   │   ├── cart/                       # Placeholder only
│   │   └── profile/                    # TODO: Implement
│   ├── nav_bar/
│   │   ├── custom_bottom_nav_bar.dart
│   │   └── widget/
│   │       ├── pulsing_shopping_button.dart
│   │       └── rainbow_bar.dart
│   └── reusable_components/
│       ├── app_logo/
│       ├── badges/
│       ├── banners/
│       │   ├── promo_banner.dart       # Main carousel component
│       │   └── banner_badge.dart       # Yellow pill badge
│       ├── buttons/
│       ├── category_tabs/              # Empty - next to implement
│       ├── dropdowns/
│       ├── floating_emoji/
│       ├── indicators/
│       │   └── dot_indicator.dart      # Page indicator dots
│       ├── input_fields/
│       ├── menu/
│       ├── menu_panel/
│       ├── notification_panel/
│       ├── product_card/
│       │   └── flash_deal_card.dart    # Compact flash deal card
│       ├── rating_stars/               # Empty - next to implement
│       ├── search_bar/
│       └── timer/
│           └── flash_deals_timer.dart  # Countdown timer with animations
├── themes/
│   ├── app_colors.dart                 # Centralized colors
│   ├── app_text_styles.dart            # All text styles
│   ├── app_theme.dart
│   └── themes.dart
├── routes/
│   ├── route_constants.dart
│   ├── route.dart
│   └── route_exports.dart
├── backend_integration/
│   ├── apis/
│   │   └── banner_api.dart
│   ├── dtos/
│   │   └── banner/
│   │       ├── banner_dto.dart
│   │       ├── banner_dto.freezed.dart
│   │       └── banner_dto.g.dart
│   ├── dio/
│   │   ├── client/
│   │   │   ├── api_client.dart
│   │   │   ├── api_error_handler.dart
│   │   │   └── request_executor.dart
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       ├── global_headers_interceptor.dart
│   │       ├── language_interceptor.dart
│   │       └── retry_interceptor_config.dart
│   └── dependency_injection/
│       ├── dependency_injection.dart
│       └── dependency_injection.config.dart
└── main.dart
```

---

## Architecture Decisions Log

### Banner Component Design
- **Decision:** Carousel scrolls through `imageUrls` within a single banner (not between banners)
- **Pattern:** PageView for image carousel, content overlay stays fixed

### Text Field Mapping
- **Decision:** Badge = `title` field, Large text = `subtitle` field

### Flash Deals Section
- **Decision:** Mock data for now, API integration later
- **Decision:** Timer uses real DateTime endTime (hardcoded 3 hours from now)
- **Decision:** Horizontally scrollable product cards
- **Decision:** Cards are simple: image + sale price + original price + stock count

### Categories + New Arrivals (Planned)
- **Decision:** Mock data for both categories and products
- **Decision:** Buttons (heart, add to cart) are visual only - no logic
- **Decision:** Categories: `[All, Dresses, Tops, Shoes, Accessories, Sale]`
- **Decision:** 2-column product grid with full ProductCard components

### Animation Safety
- **Decision:** Always clamp opacity values when using curves that overshoot (easeOutBack, easeOutElastic, etc.)
- **Lesson learned:** `Curves.easeOutBack` produces values > 1.0, which breaks `Opacity` widget assertions

### Enum Location
- **Decision:** All enums in `lib/enums/` directory

### Language System
- **Decision:** Global language injection via Dio interceptor

### Phased Execution
- **Decision:** Divide plans into phases, execute ONE phase at a time with user approval

### API Base URL
- **Current:** `http://10.0.2.2:1010/api/`
- **Note:** Android emulator localhost, port 1010

---

## Code Patterns & Conventions

### Banner DTO
```dart
@Freezed(toJson: false, fromJson: true)
abstract class BannerDto with _$BannerDto {
  const factory BannerDto({
    required int id,
    required int type,
    required String title,
    String? subtitle,
    String? description,
    String? redirectionRoute,
    @Default([]) List<String> imageUrls,
  }) = _BannerDto;
}
```

### API Service Pattern
```dart
@injectable
class BannerApi {
  final Dio _dio;
  BannerApi(@Named(apiClientKey) this._dio);

  Future<Either<ApiFailure, List<BannerDto>>> getBanners({
    required BannerType type,
  }) async {
    return executeRequest(
      client: _dio,
      method: HttpMethod.get,
      path: 'client/banners',
      queryParameters: {'Type': type.value},
      operationName: 'getBanners',
      successParser: (response) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BannerDto.fromJson(json)).toList();
      },
    );
  }
}
```

### Screen Widget Pattern (Self-contained with API)
```dart
class BrowseBannerSection extends StatefulWidget { ... }
class _BrowseBannerSectionState extends State<BrowseBannerSection> {
  late final BannerApi _bannerApi;
  List<BannerDto>? _banners;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bannerApi = serviceLocator<BannerApi>();
    _loadBanners();
  }
  // ... loading (shimmer skeleton), error (retry), success states
}
```

### Animation Patterns
```dart
// Shimmer skeleton: AnimationController + ShaderMask gradient sweep
// Staggered entrance: Interval-based delays per item index (CLAMP opacity!)
// Digit flip: AnimatedSwitcher with SlideTransition + FadeTransition
// Bolt wiggle: TweenSequence rotation + scale pulse
// IMPORTANT: Always .clamp(0.0, 1.0) on opacity when using overshoot curves
```

---

## Current Implementation Status

### ✅ Completed Features

**Authentication:**
- Splash screen with animated logo
- Sign-up screen
- Sign-in screen
- Forgot password screen

**Navigation:**
- Main screen container (IndexedStack for tab persistence)
- Bottom navigation bar (5 tabs: Browse, Deals, Shopping, Loyalty, Cart)
- App header with notifications and menu

**Browse Screen:**
- Promotional banner carousel (API-integrated) ✅
- Banner shimmer skeleton loader ✅
- Banner error state with retry ✅
- Flash deals section with animations ✅
- Flash deals countdown timer ✅
- Flash deals horizontal product cards ✅
- Flash deals opacity bug fixed ✅

**Infrastructure:**
- Theme system (light/dark)
- Reusable components library
- Language management system
- Global API language injection
- Dependency injection (get_it + injectable)

### ❌ What's NOT Implemented Yet

**Browse Screen (Next Up):**
- [ ] Category pills horizontal tabs ← **NEXT (Phase 1)**
- [ ] New Arrivals section with ProductCard ← **NEXT (Phase 2-3)**
- [ ] Flash deals API integration (currently mock data)
- [ ] Floating product items on banner

**Other Screens:**
- [ ] Deals screen content
- [ ] Shopping screen content
- [ ] Loyalty screen content
- [ ] Cart screen content
- [ ] Profile screen content

**Features:**
- [ ] Search functionality
- [ ] Product details page
- [ ] Cart management
- [ ] Checkout flow
- [ ] User profile management
- [ ] Favorites/wishlist

---

## Next Steps

### Immediate - Categories + New Arrivals (Plan Ready, Awaiting "Execute")

**Phase 1: Reusable Components**
- `CategoryPillBar` - Horizontal scrollable category pills with selected/unselected states
- `ProductCard` - Full product card (image, badges, heart, rating, name, price, add to cart button)
- `StarRating` - 5-star rating row widget

**Phase 2: New Arrivals Section Widget**
- Title row ("New Arrivals" or category name + item count)
- 2-column grid of ProductCards
- Filters by selected category
- Staggered entrance animation

**Phase 3: Integration**
- Add CategoryPillBar + NewArrivalsSection to browse_screen.dart
- Convert BrowseScreen to StatefulWidget for category state management

### After Categories + New Arrivals:
- Product details page
- Floating product items on banner
- Flash deals API integration
- Search functionality
- Other screen content

---

## Important Commands

```bash
# Install dependencies
flutter pub get

# Code generation (after modifying Freezed/Injectable files)
flutter pub run build_runner build --delete-conflicting-outputs

# Run analysis
flutter analyze

# Run app on Android emulator
flutter run -d emulator-5554

# Format code
flutter format lib/
```

---

## Backend API Reference

### Get Banners
```
GET /api/client/banners?Type=1&Language=1

Response:
{
  "statusCode": 200,
  "data": [
    {
      "id": 1,
      "type": 1,
      "title": "SUMMER SALE IS LIVE",
      "subtitle": "Vibe Check Your Style",
      "description": "Discover the hottest trends dropping daily",
      "redirectionRoute": "/deals/summer",
      "imageUrls": ["url1", "url2", "url3"]
    }
  ]
}
```

---

## User Context

- **Working Directory:** C:\Users\PC\Documents\GitHub\sooki-app
- **Git Branch:** dev
- **Backend URL:** http://10.0.2.2:1010/api/
- **Backend Repo:** C:\Users\PC\Documents\GitHub\sooki-backend
- **Reference App:** C:\Users\PC\Documents\GitHub\virtual-mall-app
- **Design Reference:** https://www.magicpatterns.com/c/4lgkv1vah8hx3nb4ke46t7

---

## Reusable Components

- `AppLogo` - Animated logo with shopping bag and truck icons (3 sizes)
- `SooKiTextLogo` - Text-based "SooKI" logo with colored letters
- `PulsingDots` - Loading indicator with 3 pulsing dots
- `FloatingEmoji` - Animated floating emoji
- `PrimaryButton` - Primary action button (filled purple) with loading state
- `SecondaryButton` - Secondary action button (white with border)
- `CustomTextField` - Text input field with label, validation, password toggle
- `CustomSearchBar` - Read-only search bar for header
- `LanguageSelector` - Language dropdown (English, Arabic, French)
- `ThemeToggleButton` - Light/dark mode toggle
- `NotificationDotBadge` - Small dot indicator for notifications
- `UserMenuDropdown` - Dropdown with Profile and Logout
- `NotificationPanel` - Notification dropdown with empty state
- `PromoBanner` - Promotional banner carousel with auto-scroll
- `BannerBadge` - Yellow pill badge for promotional text
- `DotIndicator` - Page indicator dots with animation
- `FlashDealsTimer` - Countdown timer pill with animated bolt + flip-clock digits
- `FlashDealCard` - Compact product card for flash deals

---

## Important Notes

### CLAUDE.md Protection
**CRITICAL:** The `CLAUDE.md` file can ONLY be edited with explicit user permission.

### Enum Location Rule
**ALL enums must be in `lib/enums/` directory** - no exceptions.

### Phased Execution Rule
Plans divided into phases, ONE phase at a time, user approval between phases. Track in `{FEATURE}_EXECUTION.md`.

### Animation Opacity Safety
**Always** use `.clamp(0.0, 1.0)` on opacity values when using curves that overshoot (easeOutBack, easeOutElastic, etc.).

### Design Reference
Always check Magic Patterns design before implementing features:
https://www.magicpatterns.com/c/4lgkv1vah8hx3nb4ke46t7

### Browse Page Design Order (from Magic Patterns)
1. Banner/Hero section ✅
2. Flash Deals section ✅
3. Category Pills (horizontal scrollable) ← NEXT
4. New Arrivals section (2-col grid with ProductCard) ← NEXT
