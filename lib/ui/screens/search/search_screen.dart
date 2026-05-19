import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../data/mock_products.dart';
import '../../../models/product.dart';
import '../../../enums/sort_option.dart';
import '../../../services/search_history_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/themes.dart';
import '../../reusable_components/bars/sort_filter_bar.dart';
import '../../reusable_components/search_bar/custom_search_bar.dart';
import '../shopping/widgets/filter_sheet.dart';
import '../shopping/widgets/filter_state.dart';
import '../shopping/widgets/sort_sheet.dart';

const _trendingChips = [
  'Summer dresses',
  'Sneakers',
  'Smart watch',
  'Handbag',
  'Skincare',
  'Denim jacket',
];

const _browseCategories = [
  (label: 'Women',  colors: [AppColors.auroraPink, AppColors.auroraPurple]),
  (label: 'Men',    colors: [AppColors.auroraPurple, AppColors.auroraElectricBlue]),
  (label: 'Beauty', colors: [AppColors.auroraPink, Color(0xFFFF4D6D)]),
  (label: 'Home',   colors: [AppColors.auroraElectricBlue, Color(0xFF00E5FF)]),
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery});
  final String? initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _liveQuery = '';
  String _committedQuery = '';

  SortOption _sortOption = SortOption.newest;
  late FilterState _filterState;

  SearchHistoryService get _history => GetIt.instance<SearchHistoryService>();

  @override
  void initState() {
    super.initState();
    final initial = (widget.initialQuery ?? '').trim();
    if (initial.isNotEmpty) {
      _liveQuery = initial;
      _committedQuery = initial;
    }
    // Init filter with global price bounds
    final allPrices = _allProducts.map((p) => p.price).toList();
    final pMin = allPrices.reduce((a, b) => a < b ? a : b).floorToDouble();
    final pMax = allPrices.reduce((a, b) => a > b ? a : b).ceilToDouble();
    _filterState = FilterState.initial(priceMin: pMin, priceMax: pMax);
    _history.addListener(_onHistoryChange);
  }

  @override
  void dispose() {
    _history.removeListener(_onHistoryChange);
    super.dispose();
  }

  void _onHistoryChange() => setState(() {});

  static final _allProducts = [...mockBrowseProducts, ...mockDealProducts];

  List<Product> _search(String q) {
    final needle = q.toLowerCase().trim();
    if (needle.isEmpty) return const [];
    return _allProducts
        .where((p) =>
            p.name.toLowerCase().contains(needle) ||
            p.brand.toLowerCase().contains(needle) ||
            p.category.toLowerCase().contains(needle))
        .toList();
  }

  // Autocomplete: up to 3 name suggestions for the live query
  List<String> get _suggestions {
    final q = _liveQuery.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final seen = <String>{};
    final out = <String>[];
    for (final p in _allProducts) {
      final name = p.name.toLowerCase();
      if (name.contains(q) && seen.add(name)) {
        out.add(p.name);
        if (out.length == 3) break;
      }
    }
    return out;
  }

  double get _priceMin =>
      _allProducts.map((p) => p.price).reduce((a, b) => a < b ? a : b).floorToDouble();
  double get _priceMax =>
      _allProducts.map((p) => p.price).reduce((a, b) => a > b ? a : b).ceilToDouble();

  int get _filterCount => _filterState.activeCount(priceMin: _priceMin, priceMax: _priceMax);

  Future<void> _openSortSheet() async {
    final result = await showModalBottomSheet<SortOption>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => SortSheet(current: _sortOption),
    );
    if (result != null && mounted) setState(() => _sortOption = result);
  }

  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<FilterState>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => FilterSheet(
        initial: _filterState,
        priceMin: _priceMin,
        priceMax: _priceMax,
        availableColors: const [],
        availableSizeStandards: const [],
      ),
    );
    if (result != null && mounted) setState(() => _filterState = result);
  }

  List<Product> get _filteredSortedResults {
    final filtered = _search(_committedQuery).toList();
    switch (_sortOption) {
      case SortOption.newest:
        break;
      case SortOption.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.mostPopular:
        filtered.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case SortOption.biggestDiscount:
        break;
    }
    return filtered;
  }

  void _onChanged(String q) => setState(() => _liveQuery = q);

  void _commitSearch(String q) {
    final trimmed = q.trim();
    if (trimmed.isEmpty) return;
    _history.add(trimmed);
    setState(() {
      _liveQuery = trimmed;
      _committedQuery = trimmed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg = isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final glyph = isDark ? AppColors.white : AppColors.auroraPurple;
        final muted = isDark
            ? AppColors.white.withValues(alpha: 0.55)
            : AppColors.auroraDeepBase.withValues(alpha: 0.40);

        final isTyping = _liveQuery.trim().isNotEmpty && _committedQuery != _liveQuery.trim();
        final isResults = _committedQuery.isNotEmpty;

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(
                            child: FaIcon(FontAwesomeIcons.arrowLeft,
                                size: 20, color: glyph),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomSearchBar(
                          autofocus: true,
                          showOverlay: false,
                          onSubmitted: _commitSearch,
                          onChanged: _onChanged,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _liveQuery.trim().isEmpty
                      ? _EmptyState(
                          isDark: isDark,
                          recents: _history.recents,
                          onQueryTap: _commitSearch,
                          onRemove: _history.remove,
                          onClearAll: _history.clearAll,
                        )
                      : (!isResults || isTyping)
                          ? _TypingState(
                              query: _liveQuery.trim(),
                              suggestions: _suggestions,
                              isDark: isDark,
                              onSuggestionTap: _commitSearch,
                            )
                          : _ResultsState(
                              query: _committedQuery,
                              products: _filteredSortedResults,
                              isDark: isDark,
                              muted: muted,
                              sortOption: _sortOption,
                              filterCount: _filterCount,
                              onFilter: _openFilterSheet,
                              onSort: _openSortSheet,
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

// ─── State 2 — Typing ────────────────────────────────────────────────────────

class _TypingState extends StatelessWidget {
  final String query;
  final List<String> suggestions;
  final bool isDark;
  final ValueChanged<String> onSuggestionTap;

  const _TypingState({
    required this.query,
    required this.suggestions,
    required this.isDark,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final products = [...mockBrowseProducts, ...mockDealProducts]
        .where((p) {
          final q = query.toLowerCase();
          return p.name.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q);
        })
        .take(4)
        .toList();

    final labelColor = isDark
        ? AppColors.white.withValues(alpha: 0.45)
        : AppColors.auroraPurple.withValues(alpha: 0.50);
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.07)
        : AppColors.auroraPurple.withValues(alpha: 0.08);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Suggestion chips
        if (suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: suggestions
                  .map((s) => _SuggestionChip(
                        label: s,
                        query: query,
                        isDark: isDark,
                        onTap: () => onSuggestionTap(s),
                      ))
                  .toList(),
            ),
          ),
        // Products label
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'PRODUCTS',
            style: AppFonts.primary(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: labelColor,
              letterSpacing: 1.5,
            ),
          ),
        ),
        // Product list
        Expanded(
          child: products.isEmpty
              ? Center(
                  child: Text(
                    'No results for "$query"',
                    style: AppFonts.primary(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  itemCount: products.length,
                  separatorBuilder: (context, i) => Divider(
                    height: 1,
                    thickness: 1,
                    color: dividerColor,
                    indent: 68,
                  ),
                  itemBuilder: (_, i) => _ProductListRow(
                    product: products[i],
                    query: query,
                    isDark: isDark,
                  ),
                ),
        ),
        // See all CTA
        if (products.isNotEmpty)
          GestureDetector(
            onTap: () => onSuggestionTap(query),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: AppColors.auroraGradient,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [AppColors.white, AppColors.white],
                    ).createShader(b),
                    child: Text(
                      'See all results for "$query"',
                      style: AppFonts.primary(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const FaIcon(FontAwesomeIcons.arrowRight,
                      size: 12, color: AppColors.white),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final String query;
  final bool isDark;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.label,
    required this.query,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fill = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.white;
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.14)
        : AppColors.auroraPurple.withValues(alpha: 0.25);

    // Highlight the matching portion in gradient, rest normal
    final q = query.trim().toLowerCase();
    final lower = label.toLowerCase();
    final idx = lower.indexOf(q);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 1.2),
        ),
        child: idx < 0
            ? Text(label,
                style: AppFonts.primary(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.white : AppColors.auroraPurple))
            : RichText(
                text: TextSpan(
                  style: AppFonts.primary(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.white : AppColors.auroraPurple),
                  children: [
                    if (idx > 0) TextSpan(text: label.substring(0, idx)),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: ShaderMask(
                        shaderCallback: (b) => const LinearGradient(
                          colors: AppColors.auroraGradient,
                        ).createShader(b),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          label.substring(idx, idx + q.length),
                          style: AppFonts.primary(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white),
                        ),
                      ),
                    ),
                    if (idx + q.length < label.length)
                      TextSpan(text: label.substring(idx + q.length)),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ProductListRow extends StatelessWidget {
  final Product product;
  final String query;
  final bool isDark;

  const _ProductListRow({
    required this.product,
    required this.query,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.white : AppColors.auroraPurple;
    final mutedColor = isDark
        ? AppColors.white.withValues(alpha: 0.45)
        : AppColors.auroraPurple.withValues(alpha: 0.50);

    // Build highlighted name
    final q = query.trim().toLowerCase();
    final name = product.name;
    final nameLower = name.toLowerCase();
    final idx = nameLower.indexOf(q);

    Widget nameWidget;
    if (idx < 0) {
      nameWidget = Text(name,
          style: AppFonts.primary(
              fontSize: 14, fontWeight: FontWeight.w600, color: textColor));
    } else {
      nameWidget = RichText(
        text: TextSpan(
          style: AppFonts.primary(
              fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
          children: [
            if (idx > 0) TextSpan(text: name.substring(0, idx)),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: AppColors.auroraGradient,
                ).createShader(b),
                blendMode: BlendMode.srcIn,
                child: Text(
                  name.substring(idx, idx + q.length),
                  style: AppFonts.primary(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white),
                ),
              ),
            ),
            if (idx + q.length < name.length)
              TextSpan(text: name.substring(idx + q.length)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  AppColors.auroraPink.withValues(alpha: 0.7),
                  AppColors.auroraPurple.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: product.thumbnailUrl.isNotEmpty
                ? Image.asset(product.thumbnailUrl, fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => const SizedBox())
                : const SizedBox(),
          ),
          const SizedBox(width: 12),
          // Name + brand·category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                nameWidget,
                const SizedBox(height: 3),
                Text(
                  '${product.brand} · ${product.category}',
                  style: AppFonts.primary(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: mutedColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Price in gradient
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: AppColors.auroraGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(b),
            blendMode: BlendMode.srcIn,
            child: Text(
              '\$${product.price.toStringAsFixed(0)}',
              style: AppFonts.primary(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── State 3 — Results (grid) ─────────────────────────────────────────────────

class _ResultsState extends StatelessWidget {
  final String query;
  final List<Product> products;
  final bool isDark;
  final Color muted;
  final SortOption sortOption;
  final int filterCount;
  final VoidCallback onFilter;
  final VoidCallback onSort;

  const _ResultsState({
    required this.query,
    required this.products,
    required this.isDark,
    required this.muted,
    required this.sortOption,
    required this.filterCount,
    required this.onFilter,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SortFilterBar(
          sortOption: sortOption,
          filterCount: filterCount,
          productCount: products.length,
          onFilter: onFilter,
          onSort: onSort,
        ),
        const SizedBox(height: 10),
        if (products.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                'No results for "$query"',
                style: AppFonts.primary(
                    fontSize: 14, fontWeight: FontWeight.w500, color: muted),
              ),
            ),
          )
        else
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.70,
              ),
              itemCount: products.length,
              itemBuilder: (_, i) => _SearchProductCard(product: products[i]),
            ),
          ),
      ],
    );
  }
}

// ─── Empty state (state 1 — Discovery) ───────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final List<String> recents;
  final ValueChanged<String> onQueryTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  const _EmptyState({
    required this.isDark,
    required this.recents,
    required this.onQueryTap,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark
        ? AppColors.white.withValues(alpha: 0.45)
        : AppColors.auroraPurple.withValues(alpha: 0.50);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Trending ──────────────────────────────────────────────────
          Row(
            children: [
              FaIcon(FontAwesomeIcons.fire,
                  size: 11,
                  color: AppColors.auroraPink),
              const SizedBox(width: 6),
              Text(
                'TRENDING',
                style: AppFonts.primary(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: labelColor,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final chip in _trendingChips)
                _TrendingChip(
                  label: chip,
                  isDark: isDark,
                  onTap: () => onQueryTap(chip),
                ),
            ],
          ),

          // ── Recent ────────────────────────────────────────────────────
          if (recents.isNotEmpty) ...[
            const SizedBox(height: 28),
            Row(
              children: [
                Text(
                  'RECENT',
                  style: AppFonts.primary(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: labelColor,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onClearAll,
                  behavior: HitTestBehavior.opaque,
                  child: ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: AppColors.auroraGradient,
                    ).createShader(b),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      'Clear all',
                      style: AppFonts.primary(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < recents.length; i++) ...[
              if (i > 0)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.06)
                      : AppColors.auroraPurple.withValues(alpha: 0.08),
                  indent: 36,
                ),
              _RecentRow(
                query: recents[i],
                isDark: isDark,
                onTap: () => onQueryTap(recents[i]),
                onRemove: () => onRemove(recents[i]),
              ),
            ],
          ],

          // ── Browse by Category ────────────────────────────────────────
          const SizedBox(height: 28),
          Text(
            'BROWSE BY CATEGORY',
            style: AppFonts.primary(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: labelColor,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final cat in _browseCategories)
                _CategoryCircle(
                  label: cat.label,
                  colors: cat.colors,
                  isDark: isDark,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendingChip extends StatelessWidget {
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _TrendingChip({
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fill = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.white;
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.12)
        : AppColors.auroraPurple.withValues(alpha: 0.22);
    final textColor = isDark
        ? AppColors.white.withValues(alpha: 0.85)
        : AppColors.auroraPurple;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 1.2),
        ),
        child: Text(
          label,
          style: AppFonts.primary(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _RecentRow extends StatelessWidget {
  final String query;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentRow({
    required this.query,
    required this.isDark,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDark
        ? AppColors.white.withValues(alpha: 0.30)
        : AppColors.auroraPurple.withValues(alpha: 0.35);
    final textColor = isDark
        ? AppColors.white.withValues(alpha: 0.85)
        : AppColors.auroraPurple;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            FaIcon(FontAwesomeIcons.clockRotateLeft, size: 13, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                query,
                style: AppFonts.primary(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: FaIcon(FontAwesomeIcons.xmark, size: 12, color: iconColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCircle extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final bool isDark;

  const _CategoryCircle({
    required this.label,
    required this.colors,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark
        ? AppColors.white.withValues(alpha: 0.75)
        : AppColors.auroraPurple;

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppFonts.primary(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

// Temporary card — search API not yet wired. Remove when real search API is integrated.
class _SearchProductCard extends StatelessWidget {
  final Product product;
  const _SearchProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    final cardBg = isDark ? AppColors.white.withValues(alpha: 0.04) : AppColors.white;
    final border = isDark
        ? Border.all(color: AppColors.white.withValues(alpha: 0.08))
        : Border.all(color: AppColors.auroraPurple.withValues(alpha: 0.10));
    final nameColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final priceColor = isDark ? AppColors.auroraElectricBlue : AppColors.auroraPurple;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                product.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.auroraPurple.withValues(alpha: 0.35),
                        AppColors.auroraPink.withValues(alpha: 0.20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(9, 8, 9, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.productName.copyWith(color: nameColor, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: AppTextStyles.productPrice.copyWith(color: priceColor, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
