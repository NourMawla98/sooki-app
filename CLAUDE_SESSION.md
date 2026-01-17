# Sooki App - Development Session Log

**Last Updated:** January 17, 2026

---

## Session: January 17, 2026 (Continued)

### What Was Accomplished

#### 1. Banner Feature Implementation ✅
Completed the promotional banner carousel for the Browse screen:

**Components Created:**
- `BannerDto` - Freezed model for banner API response
- `BannerType` enum - Banner types for API requests (browsePage=1)
- `BannerApi` - Injectable API service for fetching banners
- `PromoBanner` - Main carousel component with auto-scroll
- `BannerBadge` - Yellow pill badge for promotional text
- `DotIndicator` - Page indicator dots with animation
- `BrowseBannerSection` - Self-contained widget handling API and state

**Key Features:**
- Edge-to-edge layout with only bottom corners rounded
- Background images carousel from `imageUrls` array
- Auto-scroll every 4 seconds (when 2+ images)
- Manual swipe support via PageView
- Dot indicators for current image
- Badge displays `title` field, large text displays `subtitle` field
- Gradient overlay for text readability
- "Shop Now" button with full pill shape (360 radius)

#### 2. Language Management System ✅ (From Earlier)
- `AppLanguage` enum - Language definitions (English=1, Arabic=2, French=3)
- `LanguageService` - Singleton for language detection and caching
- `LanguageInterceptor` - Auto-injects `Language` query param to ALL API calls

#### 3. CLAUDE.md Updates
- Added **Enum Location Rule** - All enums must be in `lib/enums/`
- Updated file organization structure

### Code Changes Made

**New Files (Phase 2 - Banner API):**
```
lib/backend_integration/dtos/banner/banner_dto.dart
lib/backend_integration/dtos/banner/banner_dto.freezed.dart (generated)
lib/backend_integration/dtos/banner/banner_dto.g.dart (generated)
lib/enums/banner_type.dart
lib/backend_integration/apis/banner_api.dart
```

**New Files (Phase 3 - UI Components):**
```
lib/ui/reusable_components/banners/promo_banner.dart
lib/ui/reusable_components/banners/banner_badge.dart
lib/ui/reusable_components/indicators/dot_indicator.dart
```

**New Files (Phase 4 - Integration):**
```
lib/ui/screens/browse/widgets/browse_banner_section.dart
```

**Modified Files:**
```
lib/ui/screens/browse/browse_screen.dart - Integrated BrowseBannerSection
lib/themes/app_colors.dart - Added banner colors
CLAUDE.md - Added enum location rule
browse_banner_implementation_plan.md - Added skeleton loader to future enhancements
```

### Build Status
- ✅ `flutter pub get` - Dependencies installed
- ✅ `flutter pub run build_runner build` - Code generation complete
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
│   │   │   ├── browse_screen.dart      # ✅ With banner integration
│   │   │   └── widgets/
│   │   │       └── browse_banner_section.dart  # ✅ Banner widget
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
│       ├── banners/                    # ✅ NEW
│       │   ├── promo_banner.dart       # Main carousel component
│       │   └── banner_badge.dart       # Yellow pill badge
│       ├── buttons/
│       ├── dropdowns/
│       ├── indicators/                 # ✅ NEW
│       │   └── dot_indicator.dart      # Page indicator dots
│       ├── input_fields/
│       ├── menu/
│       ├── notification_panel/
│       └── search_bar/
├── themes/
│   ├── app_colors.dart                 # ✅ Added banner colors
│   ├── app_text_styles.dart
│   ├── app_theme.dart
│   └── themes.dart
├── routes/
│   ├── route_constants.dart
│   ├── route.dart
│   └── route_exports.dart
├── backend_integration/
│   ├── apis/
│   │   └── banner_api.dart             # ✅ NEW
│   ├── dtos/
│   │   └── banner/
│   │       ├── banner_dto.dart         # ✅ NEW
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

### Enum Location
- **Decision:** All enums in `lib/enums/` directory
- **Rationale:** Centralized location makes enums easy to find and reuse

### Language System
- **Decision:** Global language injection via Dio interceptor
- **Rationale:** All API calls need language param, interceptor ensures consistency

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

### Screen Widget Pattern
```dart
// Self-contained widget that handles its own API call
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
  // ... loading, error, success states
}
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
- Auto-scroll through images ✅
- Manual swipe support ✅
- Dot indicators ✅

**Infrastructure:**
- Theme system (light/dark)
- Reusable components library
- Language management system
- Global API language injection

### ❌ What's NOT Implemented Yet

**Browse Screen:**
- [ ] Skeleton loader for banner (planned)
- [ ] Product categories
- [ ] Product grid/list
- [ ] Floating product items (separate API)

**Other Screens:**
- [ ] Deals screen content
- [ ] Shopping screen content
- [ ] Hub screen content
- [ ] Loyalty screen content
- [ ] Cart screen content
- [ ] Profile screen content

**Features:**
- [ ] Search functionality
- [ ] Product details
- [ ] Cart management
- [ ] Checkout flow
- [ ] User profile management

---

## Banner Colors Added

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
1. **Skeleton Loader** - Replace loading spinner with shimmer skeleton
2. **Floating Product Items** - Separate API call for product thumbnails on banner
3. **Categories Section** - Add horizontal scrollable categories below banner

### Future:
- Product grid implementation
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

- `AppLogo` - Animated logo with shopping bag and truck icons
- `SooKiTextLogo` - Text-based "SooKI" logo with colored letters
- `PulsingDots` - Loading indicator with 3 pulsing dots
- `FloatingEmoji` - Animated floating emoji
- `PrimaryButton` - Primary action button (filled purple)
- `SecondaryButton` - Secondary action button (white with border)
- `CustomTextField` - Text input field with label and validation
- `CustomSearchBar` - Read-only search bar for header
- `LanguageSelector` - Language dropdown (English, العربية, Français)
- `ThemeToggleButton` - Light/dark mode toggle
- `NotificationDotBadge` - Small dot indicator for notifications
- `UserMenuDropdown` - Dropdown with Profile and Logout
- `NotificationPanel` - Notification dropdown with empty state
- `PromoBanner` - Promotional banner carousel ✅ NEW
- `BannerBadge` - Yellow pill badge for promotional text ✅ NEW
- `DotIndicator` - Page indicator dots ✅ NEW

---

## Important Notes

### CLAUDE.md Protection
**🔒 CRITICAL:** The `CLAUDE.md` file can ONLY be edited with explicit user permission.

### Enum Location Rule
**ALL enums must be in `lib/enums/` directory** - no exceptions.

### Design Reference
Always check Magic Patterns design before implementing features:
https://www.magicpatterns.com/c/4lgkv1vah8hx3nb4ke46t7
