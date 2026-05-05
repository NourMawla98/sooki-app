import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../data/mock_products.dart';
import '../../../routes/route_constants.dart';
import '../../../services/search_history_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_fonts.dart';
import '../../../themes/app_text_styles.dart';

/// Cohesive search pill.
///
/// [readOnly] — renders a non-editable tappable pill that navigates to the
/// search screen. Use this in the app header.
///
/// [autofocus] — immediately focuses the TextField when the widget mounts.
/// Use this on the SearchScreen so the keyboard appears on entry.
class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    this.readOnly = false,
    this.autofocus = false,
    this.showOverlay = true,
    this.onSubmitted,
    this.onChanged,
  });

  final bool readOnly;
  final bool autofocus;

  /// Whether to show the autocomplete overlay dropdown when focused.
  /// Set to false on the SearchScreen — it manages its own results.
  final bool showOverlay;

  /// Called when the user submits a query (keyboard search action).
  /// If null, the bar handles navigation internally.
  final ValueChanged<String>? onSubmitted;

  /// Called on every keystroke. Use on SearchScreen for live results.
  final ValueChanged<String>? onChanged;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  static const int _matchLimit = 4;
  static const int _debounceMs = 120;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _anchorKey = GlobalKey();

  OverlayEntry? _dimEntry;
  OverlayEntry? _dropdownEntry;
  String _query = '';
  List<String> _matches = const [];
  int _debounceToken = 0;

  SearchHistoryService get _history => GetIt.instance<SearchHistoryService>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      if (widget.showOverlay) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _focusNode.hasFocus) _showOverlay();
        });
      }
    } else {
      _removeOverlay();
    }
    setState(() {});
  }

  void _onTextChange() {
    final q = _controller.text;
    setState(() => _query = q);
    widget.onChanged?.call(q);
    final token = ++_debounceToken;
    Future.delayed(const Duration(milliseconds: _debounceMs), () {
      if (!mounted || token != _debounceToken) return;
      _recomputeMatches();
      _dropdownEntry?.markNeedsBuild();
    });
  }

  void _recomputeMatches() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) {
      _matches = const [];
      return;
    }
    final pool = <String>{};
    for (final p in [...mockBrowseProducts, ...mockDealProducts]) {
      if (p.name.toLowerCase().contains(q)) {
        pool.add(p.name);
        if (pool.length >= _matchLimit) break;
      }
    }
    _matches = pool.toList();
  }

  void _showOverlay() {
    if (_dimEntry != null) return;
    final rb = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb == null) return;
    final pos = rb.localToGlobal(Offset.zero);
    final size = rb.size;
    final overlayTop = pos.dy;
    final overlayLeft = pos.dx;
    final overlayWidth = size.width;
    final pillBottom = pos.dy + size.height;

    _dimEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: pillBottom,
        left: 0,
        right: 0,
        bottom: 0,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _dismissAndUnfocus,
          child: Container(color: AppColors.black.withValues(alpha: 0.45)),
        ),
      ),
    );

    _dropdownEntry = OverlayEntry(
      builder: (_) => _buildDropdownOverlay(
        top: overlayTop,
        left: overlayLeft,
        width: overlayWidth,
        pillHeight: size.height,
      ),
    );

    Overlay.of(context).insertAll([_dimEntry!, _dropdownEntry!]);
  }

  void _removeOverlay() {
    _dimEntry?.remove();
    _dropdownEntry?.remove();
    _dimEntry = null;
    _dropdownEntry = null;
  }

  void _dismissAndUnfocus() => _focusNode.unfocus();

  Future<void> _submitQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _dismissAndUnfocus();
      return;
    }
    if (widget.onSubmitted != null) {
      _dismissAndUnfocus();
      widget.onSubmitted!(trimmed);
      return;
    }
    await _history.add(trimmed);
    if (!mounted) return;
    _dismissAndUnfocus();
    await Navigator.pushNamed(
      context,
      searchScreenRoute,
      arguments: trimmed,
    );
    _controller.clear();
  }

  // ONE color for everything: pill idle, pill focused, dropdown.
  // Opaque (so dropdown is readable), and distinct from the header
  // (so the pill edge is visible against white / deep-base backgrounds).
  Color _groupFill(bool isDark) => isDark
      ? Color.lerp(AppColors.auroraDeepBase, AppColors.white, 0.08)!
      : Color.lerp(AppColors.white, AppColors.primaryPurple, 0.06)!;

  Color _dropdownFill(bool isDark) => _groupFill(isDark);

  Widget _buildDropdownOverlay({
    required double top,
    required double left,
    required double width,
    required double pillHeight,
  }) {
    return ListenableBuilder(
      listenable: _history,
      builder: (context, _) {
        return ListenableBuilder(
          listenable: ThemeService.instance,
          builder: (context, _) {
            final isDark = ThemeService.instance.isDarkMode;
            final recents = _history.recents;
            final showRecents = _query.trim().isEmpty;

            return Positioned(
              top: top + pillHeight,
              left: left,
              width: width,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: _dropdownFill(isDark),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                    // No shadow — a shadow at the pill/dropdown boundary
                    // reads as a seam. One clean fill, nothing else.
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showRecents)
                        _buildRecents(isDark, recents)
                      else
                        _buildMatches(isDark),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecents(bool isDark, List<String> recents) {
    final muted = isDark
        ? AppColors.white.withValues(alpha: 0.50)
        : AppColors.primaryPurple.withValues(alpha: 0.55);

    if (recents.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Text(
          'Start typing to search products',
          style: AppFonts.primary(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: muted,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: Text(
            'RECENT',
            style: AppFonts.primary(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: muted,
              letterSpacing: 1.4,
            ),
          ),
        ),
        for (int i = 0; i < recents.length; i++) ...[
          _row(
            label: recents[i],
            isDark: isDark,
            highlight: '',
            onTap: () => _submitQuery(recents[i]),
          ),
          if (i != recents.length - 1) _rowDivider(isDark),
        ],
        GestureDetector(
          onTap: () async => _history.clearAll(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: Align(
              alignment: Alignment.centerRight,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    AppColors.auroraPink,
                    AppColors.auroraPurple,
                    AppColors.auroraElectricBlue,
                  ],
                ).createShader(bounds),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'CLEAR ALL',
                      style: AppFonts.primary(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const FaIcon(
                      FontAwesomeIcons.trashCan,
                      size: 11,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatches(bool isDark) {
    final muted = isDark
        ? AppColors.white.withValues(alpha: 0.55)
        : AppColors.primaryPurple.withValues(alpha: 0.60);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_matches.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Text(
              'No matches. Tap See all to search anyway.',
              style: AppFonts.primary(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: muted,
              ),
            ),
          )
        else
          for (int i = 0; i < _matches.length; i++) ...[
            _row(
              label: _matches[i],
              isDark: isDark,
              highlight: _query,
              onTap: () => _submitQuery(_matches[i]),
            ),
            if (i != _matches.length - 1) _rowDivider(isDark),
          ],
        _rowDivider(isDark),
        GestureDetector(
          onTap: () => _submitQuery(_query),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    AppColors.auroraPink,
                    AppColors.auroraPurple,
                    AppColors.auroraElectricBlue,
                  ],
                ).createShader(bounds),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SEE ALL RESULTS',
                      style: AppFonts.primary(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const FaIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 13,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowDivider(bool isDark) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 1,
        color: isDark
            ? AppColors.white.withValues(alpha: 0.05)
            : AppColors.auroraPurple.withValues(alpha: 0.10),
      );

  Widget _row({
    required String label,
    required bool isDark,
    required String highlight,
    required VoidCallback onTap,
  }) {
    final textColor = isDark ? AppColors.white : AppColors.primaryPurple;
    final base = AppFonts.primary(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: textColor,
      height: 1.2,
    );
    final q = highlight.trim();
    Widget content;
    if (q.isEmpty) {
      content = Text(label, style: base);
    } else {
      final lower = label.toLowerCase();
      final idx = lower.indexOf(q.toLowerCase());
      if (idx < 0) {
        content = Text(label, style: base);
      } else {
        final before = label.substring(0, idx);
        final match = label.substring(idx, idx + q.length);
        final after = label.substring(idx + q.length);
        content = RichText(
          text: TextSpan(
            style: base,
            children: [
              TextSpan(text: before),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      AppColors.auroraPink,
                      AppColors.auroraElectricBlue,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    match,
                    style: base.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              TextSpan(text: after),
            ],
          ),
        );
      }
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        if (widget.readOnly) {
          return _buildReadOnlyPill(isDark, context);
        }
        return _buildEditablePill(isDark);
      },
    );
  }

  Widget _buildReadOnlyPill(bool isDark, BuildContext context) {
    final fill = isDark
        ? AppColors.white.withValues(alpha: 0.07)
        : AppColors.white;
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.18)
        : AppColors.auroraPurple.withValues(alpha: 0.55);
    final placeholder = isDark
        ? AppColors.white.withValues(alpha: 0.45)
        : AppColors.primaryPurple.withValues(alpha: 0.40);
    final iconColor = isDark
        ? AppColors.white.withValues(alpha: 0.50)
        : AppColors.primaryPurple.withValues(alpha: 0.55);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, searchScreenRoute),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: border, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            FaIcon(FontAwesomeIcons.magnifyingGlass, size: 14, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search for products...',
                style: AppFonts.primary(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: placeholder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditablePill(bool isDark) {
    final focused = _focusNode.hasFocus;

    final fill = isDark
        ? AppColors.white.withValues(alpha: 0.07)
        : AppColors.white;
    final borderColor = isDark
        ? AppColors.white.withValues(alpha: 0.18)
        : AppColors.auroraPurple.withValues(alpha: 0.55);
    final placeholder = isDark
        ? AppColors.white.withValues(alpha: 0.45)
        : AppColors.primaryPurple.withValues(alpha: 0.40);
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final iconColor = isDark
        ? AppColors.white.withValues(alpha: 0.50)
        : AppColors.primaryPurple.withValues(alpha: 0.55);

    const radius = BorderRadius.all(Radius.circular(22));
    const List<BoxShadow> shadow = [];

    return Container(
      key: _anchorKey,
      height: 44,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: shadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.magnifyingGlass, size: 14, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              textInputAction: TextInputAction.search,
              onSubmitted: _submitQuery,
              cursorColor: AppColors.auroraElectricBlue,
              style: AppFonts.primary(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              decoration: InputDecoration(
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: 'Search for products...',
                hintStyle: AppTextStyles.inputHint.copyWith(
                  color: placeholder,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (focused && _query.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                SystemChannels.textInput.invokeMethod('TextInput.show');
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FaIcon(
                  FontAwesomeIcons.xmark,
                  size: 13,
                  color: placeholder,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
