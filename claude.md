# Sooki App - Development Guidelines

**🔒 CRITICAL: This file (CLAUDE.md) can ONLY be edited with explicit permission from the user. Never edit this file unless the user specifically asks you to do so.**

## Session Progress & Memory
**IMPORTANT**: When the user asks to "save progress" or "remember where we are", use the **memory plugin** (`C:\Users\PC\.claude\projects\C--Users-PC-Documents-GitHub-sooki-app\memory\`) to save detailed, thorough, and precise memory files. Include:
- Exactly which phase/step was completed and which is next
- Any files created or modified in the current session
- Decisions made, blockers encountered, and context needed to resume
- The current state of `flutter analyze` (pass/fail)

When starting a new session, **always check MEMORY.md first** to understand what was accomplished and pick up exactly where we left off. Be thorough enough that no context is lost between sessions.

## Design Reference
**Magic Patterns Design**: https://www.magicpatterns.com/c/4lgkv1vah8hx3nb4ke46t7

**IMPORTANT**: Use the Magic Pattern MCP tools to read the design before implementing features.

## Core Principles

### 1. Reusable Components First
- **ALWAYS** check `lib/ui/reusable_components/` for existing components before creating new ones
- Create new reusable components in `lib/ui/reusable_components/` when appropriate
- Example: `AppLogo` component is reusable across splash, sign-up, and header

### 2. Theme Consistency (CRITICAL)
**NEVER hardcode colors or text styles. ALWAYS use centralized theme values.**

**CRITICAL: Color Usage Rule**
**NEVER use colors directly in component files.** ALL colors must be:
1. Defined in `lib/themes/app_colors.dart`
2. Referenced as `AppColors.colorName`

This ensures theme consistency and allows global color changes with minimal fixes.

**Examples:**
- ✅ **CORRECT**: `AppColors.accentRed`, `AppColors.primaryPurple`
- ❌ **WRONG**: `Color(0xFFFF6B6B)`, `Colors.red`, any hex color directly
- ✅ **DO**: `AppColors.primaryPurple`, `AppTextStyles.bodyLarge`
- ❌ **DON'T**: `Color(0xFF4D4C7D)`, `fontSize: 16`
- All colors from `lib/themes/app_colors.dart`
- All text styles from `lib/themes/app_text_styles.dart`
- Use `.copyWith()` for style modifications (e.g., `AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)`)

**CRITICAL - Color Opacity:**
- ❌ **NEVER use**: `.withOpacity()` - This is DEPRECATED
- ✅ **ALWAYS use**: `.withValues(alpha: 0.5)` for transparency
- Example: `AppColors.white.withValues(alpha: 0.9)` NOT `AppColors.white.withOpacity(0.9)`

**Why**: Centralized themes allow global changes with minimal fixes. `withValues()` provides better precision and is the modern Flutter API.

**CRITICAL: Icon Usage Rule**
**ALWAYS use Font Awesome icons. NEVER use Material Icons.**
- ✅ **DO**: Import `package:font_awesome_flutter/font_awesome_flutter.dart` and use `FaIcon(FontAwesomeIcons.iconName)`
- ❌ **DON'T**: Use `Icon(Icons.iconName)` from Material Icons
- Always specify size for consistency: `FaIcon(FontAwesomeIcons.house, size: 20)`
- Font Awesome icons are solid by default (no need for separate solid variants)
- For TextField prefix icons: Pass directly to `CustomTextField`, it handles centering automatically

**Examples:**
- ✅ **CORRECT**: `FaIcon(FontAwesomeIcons.house, size: 20, color: AppColors.primaryPurple)`
- ✅ **CORRECT**: `FaIcon(FontAwesomeIcons.envelope, size: 20)`
- ✅ **CORRECT**: TextField prefixIcon: `FaIcon(FontAwesomeIcons.envelope, size: 20, color: AppColors.gray400)`
- ❌ **WRONG**: `Icon(Icons.home, size: 20)`
- ❌ **WRONG**: `Icon(Icons.email_outlined)`
- ❌ **WRONG**: Wrapping FaIcon in Padding for TextField (CustomTextField handles this)

**Why**: Font Awesome provides a more consistent, professional icon set with better design quality and more variants.

### 3. File Organization
```
lib/
├── enums/                    # ALL app enums (e.g., app_language.dart, banner_type.dart)
├── ui/
│   ├── screens/              # Feature screens
│   └── reusable_components/  # Shared widgets
│       ├── buttons/          # Button components
│       ├── dropdowns/        # Dropdown components
│       ├── input_fields/     # Form input components
│       └── ...               # Other component categories
├── themes/                   # Colors, text styles, theme
└── backend_integration/
```

**CRITICAL: Enum Location Rule**
**ALL enums must be placed in `lib/enums/` directory.**
- ✅ **DO**: `lib/enums/app_language.dart`, `lib/enums/banner_type.dart`
- ❌ **DON'T**: `lib/backend_integration/enums/`, `lib/models/enums/`, or any other location

**Why**: Centralized enum location makes it easy to find and reuse enums across the app.

### 4. Routing (Named Routes Pattern)
**ALWAYS use named routes with the centralized route generator.**

**Route Structure:**
```
lib/routes/
├── route_constants.dart  # All route name constants
├── route.dart            # Route generator (map-based lookup)
└── route_exports.dart    # Barrel export file
```

**Navigation Rules:**
- ✅ **DO**: `Navigator.pushNamed(context, signInScreenRoute)`
- ✅ **DO**: `Navigator.pushReplacementNamed(context, mainScreenRoute)`
- ❌ **DON'T**: `Navigator.push(context, MaterialPageRoute(builder: (_) => Screen()))`

**Adding New Routes:**
1. Add route constant in `route_constants.dart`: `const String newScreenRoute = 'new_screen';`
2. Add route mapping in `route.dart`: `newScreenRoute: (_) => const NewScreen(),`
3. Import in screen: `import '../../../routes/route_constants.dart';`
4. Navigate: `Navigator.pushNamed(context, newScreenRoute);`

**Why**: Centralized routing supports dynamic routes from backend, maintains clean architecture, and follows the virtual-mall-app pattern.

### 5. Design & Visual Workflow
**NEVER use space / cosmic / galaxy / orbit / planets / stars / nebula imagery as a design reference, metaphor, or inspiration.** Not as a home-screen paradigm, not as a background, not as a brand aesthetic, not even as a throwaway mockup option. Do not propose it. Do not include it among A/B/C choices.

**ALWAYS use the Visual Companion for any design, UI, or brainstorming work.**
- Start the visual companion server (if not already running) and generate mockups/comparisons as HTML
- After writing a mockup file, **give me the server URL** so I can open it in my own browser — do NOT render it in Playwright
- Applies to: design brainstorming, layout comparisons, color/theme choices, component mockups, screen redesigns, side-by-side A/B/C options
- Prefer visuals over text descriptions for anything that would be easier to understand by looking than reading

**ALWAYS include previously-agreed-on sections when designing a new section.** When brainstorming section N, every mockup must render sections 0 through N-1 above it (using the variants/options already locked), so the full picture is visible. Never show a new section in isolation. Context stacks.

### 6. Planning Workflow
**When asked to plan a feature or implementation:**
1. **IMMEDIATELY** create a markdown file in the **root folder** with an appropriate descriptive title (e.g., `feature_name_plan.md`)
2. If you need clarifications:
   - **ASK QUESTIONS ONE BY ONE** using the AskUserQuestion tool with multiple choice options
   - Wait for user response before asking the next question
   - Document answers in the plan file as they are received
3. Document the complete plan with:
   - Implementation steps
   - File changes (new files, modifications)
   - Architectural decisions
   - Components to reuse
   - Theme/color considerations
4. **WAIT for explicit approval** before executing the plan
5. Only implement after the user says "Execute the plan", "Proceed", or "Implement it"

**IMPORTANT - Planning Mode Question Behavior:**
- ✅ **DO**: Ask clarification questions ONE AT A TIME using AskUserQuestion tool
- ✅ **DO**: Provide clear options (2-4 choices) for each question
- ❌ **DON'T**: Ask all questions at once in the plan file
- ❌ **DON'T**: Execute any implementation during planning
- ✅ **DO**: Wait for explicit user approval before coding

**CRITICAL - Phased Execution:**
- **Divide plans into phases**, execute **ONE phase at a time**
- After completing a phase, **wait for user approval** before starting the next phase
- Track progress in `{FEATURE}_EXECUTION.md` alongside the plan file
- Run `flutter analyze` after each phase to verify no issues

**Example:**
- User: "Plan the user profile feature"
- You: Create `user_profile_plan.md` in root, then ask first clarifying question with options
- Continue: Ask next question after receiving answer
- Wait for: User says "Execute the plan" or "Proceed"
- Execute: Phase 1 only → wait for approval → Phase 2 → wait → etc.

### 6. Best Practices
- Use semantic naming (e.g., `AppColors.primaryPurple` not `Color(0xFF4D4C7D)`)
- Follow existing patterns in the codebase
- Keep widgets focused and composable
- Extract repeated UI patterns into reusable components

## Current Reusable Components
- `AppLogo` - Animated logo with shopping bag and truck icons (3 sizes: large, medium, small)
- `SooKiTextLogo` - Text-based "SooKI" logo with colored letters (used in header)
- `PulsingDots` - Loading indicator with 3 pulsing dots
- `FloatingEmoji` - Animated floating emoji with customizable position, rotation, and float distance
- `PrimaryButton` - Primary action button (filled purple) with loading state
- `SecondaryButton` - Secondary action button (white with border)
- `CustomTextField` - Text input field with label, validation, and password toggle
- `CustomSearchBar` (search_bar/) - Read-only search bar for header (functionality TBD)
- `LanguageSelector` (dropdowns/) - Functional language dropdown with menu (English, العربية, Français)
- `ThemeToggleButton` - Light/dark mode toggle button
- `NotificationDotBadge` (badges/) - Small blue/purple dot indicator for notifications
- `UserMenuDropdown` (menu/) - Dropdown menu with Profile and Logout options
- `NotificationPanel` (notification_panel/) - Notification dropdown with empty state

## Current App Sections
- `AppHeader` (header/) - Fixed header with logo, notifications, menu, and search bar (shared across all nav tabs)
