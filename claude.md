# Sooki App - Development Guidelines

## Session Progress
**IMPORTANT**: Check `.serena/memories/session_progress.md` at the start of each session to understand what was accomplished and pick up where we left off.

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

### 5. Planning Workflow
**When asked to plan a feature or implementation:**
1. Create a markdown file in the **root folder** with an appropriate descriptive title (e.g., `feature_name_plan.md`)
2. Document the complete plan with steps, file changes, and architectural decisions
3. **WAIT for explicit approval** before executing the plan
4. Only implement after the user asks you to proceed

**Example:**
- User: "Plan the user profile feature"
- You: Create `user_profile_plan.md` in root with detailed plan
- Wait for: User says "Execute the plan" or "Proceed"

### 6. Best Practices
- Use semantic naming (e.g., `AppColors.primaryPurple` not `Color(0xFF4D4C7D)`)
- Follow existing patterns in the codebase
- Keep widgets focused and composable
- Extract repeated UI patterns into reusable components

## Current Reusable Components
- `AppLogo` - Animated logo with shopping bag and truck icons (3 sizes: large, medium, small)
- `PulsingDots` - Loading indicator with 3 pulsing dots
- `FloatingEmoji` - Animated floating emoji with customizable position, rotation, and float distance
- `PrimaryButton` - Primary action button (filled purple) with loading state
- `SecondaryButton` - Secondary action button (white with border)
- `CustomTextField` - Text input field with label, validation, and password toggle
- `LanguageSelector` (dropdowns/) - Functional language dropdown with menu (English, العربية, Français)
- `ThemeToggleButton` - Light/dark mode toggle button
