# Sooki App - Development Session Log

**Last Updated:** February 15, 2026

---

## Session: February 15, 2026

### What Was Accomplished

#### 1. Banner Skeleton Loader Fix ✅
- Fixed error state bug: `Radius.circular(200)` → `Radius.circular(20)` (lopsided blob)
- Replaced ugly loading spinner with a proper **shimmer skeleton loader**
- Skeleton matches real banner layout: badge placeholder, title lines, description, button, dot indicators
- Uses `AnimationController` + `ShaderMask` gradient sweep (1.5s loop)
- Fixed error state dimensions to match real banner (height 330, radius 36)

#### 2. Flash Deals Section ✅ (All 3 Phases Complete)
Implemented the flash deals section for the Browse screen with animations.

**Phase 1 - Reusable Components:**
- `FlashDealsTimer` - Purple pill countdown timer with animated lightning bolt (wiggle + scale) and flip-clock digit transitions
- `FlashDealCard` - Compact product card (130px wide) with image, sale/original price, stock count

**Phase 2 - Section Widget:**
- `FlashDealsSection` - Red gradient container with title, timer, and horizontally scrollable product cards
- Animations: section fade+slide entrance, title shimmer sweep, staggered card entrance from right

**Phase 3 - Integration:**
- Added `FlashDealsSection` to `browse_screen.dart` below the banner

#### 3. CLAUDE.md Updates ✅
- Added **Phased Execution Rule** to Planning Workflow section
- Plans must be divided into phases, executed one at a time with user approval between phases
- Track progress in `{FEATURE}_EXECUTION.md`

### Code Changes Made

**New Files:**
```
lib/ui/reusable_components/timer/flash_deals_timer.dart
lib/ui/reusable_components/product_card/flash_deal_card.dart
lib/ui/screens/browse/widgets/flash_deals_section.dart
```

**Modified Files:**
```
lib/ui/screens/browse/browse_screen.dart - Added FlashDealsSection
lib/ui/screens/browse/widgets/browse_banner_section.dart - Shimmer skeleton + error state fix
CLAUDE.md - Added phased execution rule
```

**Plan Files:**
```
flash_deals_implementation_plan.md - Feature plan
flash_deals_execution.md - Execution tracker (all phases complete)
```

### Build Status
- ✅ `flutter analyze` - No issues found

---

## Project Overview

### Tech Stack
- **Framework:** Flutter 3.10.4+
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
│   │   ├── main/                       # Main container with nav
│   │   ├── browse/
│   │   │   ├── browse_screen.dart      # ✅ Banner + Flash Deals
│   │   │   └── widgets/
│   │   │       ├── browse_banner_section.dart  # ✅ With shimmer skeleton
│   │   │       └── flash_deals_section.dart    # ✅ NEW
│   │   ├── deals/                      # TODO: Implement
│   │   ├── shopping/                   # TODO: Implement
│   │   ├── hub/                        # TODO: Implement
│   │   ├── loyalty/                    # TODO: Implement
│   │   ├── cart/                       # TODO: Implement
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
│       ├── category_tabs/
│       ├── dropdowns/
│       ├── floating_emoji/
│       ├── indicators/
│       │   └── dot_indicator.dart      # Page indicator dots
│       ├── input_fields/
│       ├── menu/
│       ├── menu_panel/
│       ├── notification_panel/
│       ├── product_card/
│       │   └── flash_deal_card.dart    # ✅ NEW
│       ├── rating_stars/
│       ├── search_bar/
│       └── timer/
│           └── flash_deals_timer.dart  # ✅ NEW
├── themes/
│   ├── app_colors.dart                 # Centralized colors (banner colors included)
│   ├── app_text_styles.dart            # All text styles (timer, product styles included)
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
- **Rationale:** Each banner has multiple background images that auto-cycle
- **Pattern:** PageView for image carousel, content overlay stays fixed

### Text Field Mapping
- **Decision:** Badge = `title` field, Large text = `subtitle` field
- **Rationale:** Matches the design where badge shows "SUMMER SALE IS LIVE" (title) and large text shows "Vibe Check Your Style" (subtitle)

### Flash Deals Section
- **Decision:** Mock data for now, API integration later
- **Decision:** Timer uses real DateTime endTime (hardcoded 3 hours from now, backend later)
- **Decision:** Horizontally scrollable product cards (per design reference)
- **Decision:** Cards are simple: image + sale price + original price + stock count (no add to cart or favorites)

### Enum Location
- **Decision:** All enums in `lib/enums/` directory
- **Rationale:** Centralized location makes enums easy to find and reuse

### Language System
- **Decision:** Global language injection via Dio interceptor
- **Rationale:** All API calls need language param, interceptor ensures consistency

### Phased Execution
- **Decision:** Divide plans into phases, execute ONE phase at a time
- **Rationale:** Better control, user approval between phases, tracked in execution files

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
class BrowseBannerSection extends StatefulWidget {
  @override
  State<BrowseBannerSection> createState() => _BrowseBannerSectionState();
}

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
// Staggered entrance: Interval-based delays per item index
// Digit flip: AnimatedSwitcher with SlideTransition + FadeTransition
// Bolt wiggle: TweenSequence rotation + scale pulse
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
- Main screen container
- Bottom navigation bar (5 tabs)
- App header with notifications and menu

**Browse Screen:**
- Promotional banner carousel ✅
- Banner shimmer skeleton loader ✅
- Banner error state with retry ✅
- Flash deals section with animations ✅
- Flash deals countdown timer ✅
- Flash deals horizontal product cards ✅

**Infrastructure:**
- Theme system (light/dark)
- Reusable components library
- Language management system
- Global API language injection

### ❌ What's NOT Implemented Yet

**Browse Screen:**
- [ ] Flash deals API integration (currently mock data)
- [ ] Product categories horizontal tabs
- [ ] New arrivals section
- [ ] Product grid/list
- [ ] Floating product items on banner

**Other Screens:**
- [ ] Deals screen content
- [ ] Shopping screen content
- [ ] Hub screen content
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

## Banner Colors

```dart
// In app_colors.dart
static const Color bannerBackground = Color(0xFFF5E1D0); // Warm beige/peach
static const Color bannerBadgeYellow = Color(0xFFFFD93D); // Yellow badge
static const Color bannerTitleAccent = Color(0xFFFFD93D); // Yellow for title accent
static const Color bannerProductFrame = Color(0xFF4D4C7D); // Purple frame border
```

---

## Next Steps

### Immediate:
1. **Categories Section** - Horizontal scrollable category tabs below flash deals (per design)
2. **New Arrivals Section** - Product grid with full ProductCard components
3. **Flash Deals API** - Create backend endpoint and integrate

### Future:
- Product details page
- Floating product items on banner
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
- `LanguageSelector` - Language dropdown (English, العربية, Français)
- `ThemeToggleButton` - Light/dark mode toggle
- `NotificationDotBadge` - Small dot indicator for notifications
- `UserMenuDropdown` - Dropdown with Profile and Logout
- `NotificationPanel` - Notification dropdown with empty state
- `PromoBanner` - Promotional banner carousel with auto-scroll
- `BannerBadge` - Yellow pill badge for promotional text
- `DotIndicator` - Page indicator dots with animation
- `FlashDealsTimer` - Countdown timer pill with animated bolt + flip-clock digits ✅ NEW
- `FlashDealCard` - Compact product card for flash deals ✅ NEW

---

## Important Notes

### CLAUDE.md Protection
**🔒 CRITICAL:** The `CLAUDE.md` file can ONLY be edited with explicit user permission.

### Enum Location Rule
**ALL enums must be in `lib/enums/` directory** - no exceptions.

### Phased Execution Rule
Plans divided into phases, ONE phase at a time, user approval between phases. Track in `{FEATURE}_EXECUTION.md`.

### Design Reference
Always check Magic Patterns design before implementing features:
https://www.magicpatterns.com/c/4lgkv1vah8hx3nb4ke46t7
