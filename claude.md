# Sooki App — Development Guidelines

**🔒 This file can ONLY be edited with explicit permission from the user.**

## Memory & Sessions
When the user says "save progress" / "remember where we are", write to the memory plugin at `C:\Users\PC\.claude\projects\C--Users-PC-Documents-GitHub-sooki-app\memory\`. Include: phase completed + next, files touched, decisions, blockers, current `flutter analyze` state.

On new sessions, **read `MEMORY.md` first**.

## Design Reference
Magic Patterns: https://www.magicpatterns.com/c/4lgkv1vah8hx3nb4ke46t7 — use the Magic Pattern MCP tools before implementing.

## Core Rules

### 1. Reuse first
Check `lib/ui/reusable_components/` before building. New reusables go there.

### 2. Theme consistency (CRITICAL)
The rule is the global `frontend-theme-tokens` skill. This repo's specifics:
- **Colors**: `AppColors.*` from `lib/themes/app_colors.dart`.
- **Text**: `AppTextStyles.*` from `lib/themes/app_text_styles.dart`, modified with `.copyWith()`.
- **Theme signal**: `ListenableBuilder(listenable: ThemeService.instance, …)`, branch on `ThemeService.instance.isDarkMode`.
- Aurora tokens (`auroraPink`, `auroraElectricBlue`, `auroraPurple`, `primaryPurple`) read on both backgrounds.

Common theme-aware pairings:
- Neutral accent: dark → `white`, light → `primaryPurple`
- Glass fill: dark → `white @ 0.05`, light → `primaryPurple @ 0.05`
- Glass border: dark → `white @ 0.10`, light → `primaryPurple @ 0.18`
- Badge cutout: dark → `auroraDeepBase`, light → `white`

### 3. Icons
Font Awesome only. `FaIcon(FontAwesomeIcons.name, size: N)`. Never `Icon(Icons.*)`. For `CustomTextField.prefixIcon`, pass `FaIcon` directly — don't wrap in Padding.

### 4. File organization
```
lib/
├── enums/                    # ALL enums live here — nowhere else
├── ui/
│   ├── screens/
│   └── reusable_components/  # buttons/, dropdowns/, input_fields/, …
├── themes/
└── backend_integration/
```

### 5. Routing
Named routes only, via the centralized generator.
- Use: `Navigator.pushNamed(context, fooScreenRoute)` / `pushReplacementNamed`
- Never: `Navigator.push(context, MaterialPageRoute(...))`
- To add: constant in `lib/routes/route_constants.dart` → mapping in `lib/routes/route.dart` → import the constants file → navigate by name.

### 6. Design / visual workflow
- **No space / cosmic / galaxy / orbit / planets / stars / nebula imagery.** Not as background, metaphor, aesthetic, or A/B option. Don't propose it.
- Use the Visual Companion for any design/UI/brainstorm work: write the mockup HTML, then give the user the server URL. Don't render in Playwright.
- When designing section N, every mockup must stack sections 0..N-1 above it using the locked variants. Never show a section in isolation.

### 7. Planning workflow
Follow the global `general-plan-feature` skill. The only thing this repo adds: the verification run
after each phase is `flutter analyze`.

### 8. Screen layout structure (CRITICAL)
Every new screen must follow the address form pattern — not a standard `AppBar` + plain `Scaffold`:
- **No `AppBar`**. Use a custom `_TopBar` widget inside the body: `IconButton(arrowLeft)` + `Text` in a `Row` with `Padding(fromLTRB(4, 4, 16, 8))`. Icon/title color: `white` dark / `auroraPurple` light.
- **Background**: `Scaffold(backgroundColor: isDark ? auroraDeepBase : auroraLightBase)`.
- **Glow blobs**: wrap body in a `Stack` and place two `AuroraGlowBlob` decorations — one top-right (`auroraPurple`), one bottom-left (`auroraElectricBlue`). Intensity: dark `0.18–0.20`, light `0.08–0.10`.
- **SafeArea**: wrap the `Column(_TopBar + Expanded(SingleChildScrollView))` in `SafeArea` inside the `Stack`.
- **No glass card for hero/header areas**: content sits directly on the background. Glass cards (`border + fill`) are only for grouped list sections (menu groups, form fields), never the top hero/avatar area.

Reference implementation: `lib/ui/screens/address_form/address_form_screen.dart`.

### 9. Store name — hard ban
`storeName` (and any equivalent field) must **never** appear anywhere in the customer-facing UI — not on product cards, wishlist cards, search results, product detail, or any other screen. It is an admin-only field.

### 10. General
- Semantic naming. Follow existing patterns. Keep widgets focused and composable. Extract repeated patterns into reusables.

### 11. Live testing on a device
Never launch the emulator yourself. Ask the user to start the app from Android Studio and say when
it is running, then drive it over `adb`.
- An emulator started from the CLI opens a window the user cannot find. Android Studio shows the
  screen in the **Running Devices** tool window, which is where they can type.
- `adb` cannot type into the app's text fields. The field takes focus but no input connection binds,
  so anything needing credentials or typed input is the user's to enter.
- If the AVD hangs on "Starting up", the quickboot snapshot is bad. Delete
  `~/.android/avd/<avd>.avd/snapshots/default_boot` and boot cold.
