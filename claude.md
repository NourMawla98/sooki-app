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
- **Colors**: only via `AppColors.*` from `lib/themes/app_colors.dart`. Never `Color(0xFF…)`, `Colors.red`, or hex literals in component files.
- **Text**: only via `AppTextStyles.*` from `lib/themes/app_text_styles.dart`. Use `.copyWith()` to modify.
- **Opacity**: use `.withValues(alpha: x)`. Never `.withOpacity()` (deprecated).
- **Both themes must render**: every widget must work in light AND dark. Don't hardcode `AppColors.white` on a light-mode surface or `AppColors.black` on dark. Watch theme via `ListenableBuilder(listenable: ThemeService.instance, …)` and branch on `ThemeService.instance.isDarkMode`. Pair theme-dependent fg/bg/border together. Aurora tokens (`auroraPink`, `auroraElectricBlue`, `auroraPurple`, `primaryPurple`) read on both backgrounds.

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
When asked to plan a feature:
1. Create `{feature}_plan.md` in the root folder immediately.
2. For clarifications, use **AskUserQuestion ONE question at a time** with 2–4 options. Record answers in the plan as they arrive.
3. Document steps, file changes, decisions, components to reuse, theme considerations.
4. **Wait for explicit approval** ("Execute the plan", "Proceed", "Implement it") before coding.
5. Split into phases. Execute one phase → run `flutter analyze` → wait for approval → next phase. Track in `{FEATURE}_EXECUTION.md`.

**Thinking effort:**
- Planning & design decisions → use extended thinking. Getting the plan right is the hard part.
- Executing an approved phase → default to no/low thinking; mechanical code changes don't need it. Escalate only on real unknowns (subtle bug, architectural ambiguity).

### 8. Skill usage (token discipline)
Don't invoke skills for simple questions, small edits, or status checks. Only invoke superpowers skills for: feature planning, real debugging sessions, completion verification before merging, or when I explicitly ask. This overrides the "1% match → must invoke" rule from `using-superpowers`.

### 9. Screen layout structure (CRITICAL)
Every new screen must follow the address form pattern — not a standard `AppBar` + plain `Scaffold`:
- **No `AppBar`**. Use a custom `_TopBar` widget inside the body: `IconButton(arrowLeft)` + `Text` in a `Row` with `Padding(fromLTRB(4, 4, 16, 8))`. Icon/title color: `white` dark / `auroraPurple` light.
- **Background**: `Scaffold(backgroundColor: isDark ? auroraDeepBase : auroraLightBase)`.
- **Glow blobs**: wrap body in a `Stack` and place two `AuroraGlowBlob` decorations — one top-right (`auroraPurple`), one bottom-left (`auroraElectricBlue`). Intensity: dark `0.18–0.20`, light `0.08–0.10`.
- **SafeArea**: wrap the `Column(_TopBar + Expanded(SingleChildScrollView))` in `SafeArea` inside the `Stack`.
- **No glass card for hero/header areas**: content sits directly on the background. Glass cards (`border + fill`) are only for grouped list sections (menu groups, form fields), never the top hero/avatar area.

Reference implementation: `lib/ui/screens/address_form/address_form_screen.dart`.

### 10. General
- Semantic naming. Follow existing patterns. Keep widgets focused and composable. Extract repeated patterns into reusables.
