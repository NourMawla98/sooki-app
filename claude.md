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

- ✅ **DO**: `AppColors.primaryPurple`, `AppTextStyles.bodyLarge`
- ❌ **DON'T**: `Color(0xFF4D4C7D)`, `fontSize: 16`
- All colors from `lib/themes/app_colors.dart`
- All text styles from `lib/themes/app_text_styles.dart`
- Use `.copyWith()` for style modifications (e.g., `AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)`)

**Why**: Centralized themes allow global changes with minimal fixes

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

### 4. Best Practices
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
