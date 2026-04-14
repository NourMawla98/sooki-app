/// Typed constants for every translation key used in the app.
///
/// Keys mirror the JSON structure in `assets/translations/{en,ar,fr}.json`
/// using dot notation. Always reference a key through this class rather than
/// passing a raw string literal to `tr(...)` — this prevents typos and gives
/// the editor one place to jump to for rename/find-usages.
///
/// When adding a new key: (1) add a constant here, (2) add the same key to
/// all three JSON files in `assets/translations/`, (3) run the app once to
/// let easy_localization's missing-key logger flag any gaps.
class I18nKeys {
  I18nKeys._();

  // ─── common ─────────────────────────────────────────────────────────────
  static const appName = 'common.app_name';
}
