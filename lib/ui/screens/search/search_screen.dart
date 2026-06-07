import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../backend_integration/apis/colors_api.dart';
import '../../../backend_integration/apis/items_api.dart';
import '../../../backend_integration/apis/size_standards_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../backend_integration/dtos/item/item_list_item_dto.dart';
import '../../../backend_integration/dtos/item/color_dto.dart';
import '../../../backend_integration/dtos/item/size_standard_dto.dart';
import '../../../enums/sort_option.dart';
import '../../../services/search_history_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/themes.dart';
import '../../reusable_components/bars/sort_filter_bar.dart';
import '../../reusable_components/product_card/product_grid_card.dart';
import '../../reusable_components/search_bar/custom_search_bar.dart';
import '../shopping/widgets/filter_sheet.dart';
import '../shopping/widgets/filter_state.dart';
import '../shopping/widgets/sort_sheet.dart';

const _take = 6;

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
  FilterState _filterState = FilterState.initial(priceMin: 0, priceMax: 9999);

  List<ItemListItemDto> _items = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isLastPage = false;
  double _priceMin = 0;
  double _priceMax = 9999;

  List<ColorDto> _allColors = [];
  List<SizeStandardDto> _allSizeStandards = [];

  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  SearchHistoryService get _history => GetIt.instance<SearchHistoryService>();

  @override
  void initState() {
    super.initState();
    final initial = (widget.initialQuery ?? '').trim();
    if (initial.isNotEmpty) {
      _liveQuery = initial;
      _committedQuery = initial;
    }
    _history.addListener(_onHistoryChange);
    _scrollController.addListener(_onScroll);
    _fetchFilterCatalogue();
    if (_committedQuery.isNotEmpty) _loadResults(reset: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _history.removeListener(_onHistoryChange);
    _scrollController.dispose();
    super.dispose();
  }

  void _onHistoryChange() => setState(() {});

  Future<void> _fetchFilterCatalogue() async {
    final colorResult = await serviceLocator<ColorsApi>().getColors();
    final sizeResult = await serviceLocator<SizeStandardsApi>().getSizeStandards();
    if (!mounted) return;
    colorResult.fold((_) {}, (colors) => setState(() => _allColors = colors));
    sizeResult.fold((_) {}, (sizes) => setState(() => _allSizeStandards = sizes));
  }

  Future<void> _loadResults({bool reset = false}) async {
    if (_isLoading || _isLoadingMore) return;
    if (!reset && _isLastPage) return;

    final skip = reset ? 0 : _items.length;
    setState(() {
      if (reset) {
        _isLoading = true;
        _items = [];
      } else {
        _isLoadingMore = true;
      }
    });

    final result = await serviceLocator<ItemsApi>().getItems(
      searchQuery: _committedQuery,
      sortBy: _sortOption.toSortBy(),
      minPrice: _filterState.priceRange.start > _priceMin ? _filterState.priceRange.start : null,
      maxPrice: _filterState.priceRange.end < _priceMax ? _filterState.priceRange.end : null,
      colorIds: _filterState.colorIds.toList(),
      sizeValueIds: _filterState.sizeValueIds.toList(),
      skip: skip,
      take: _take,
    );

    if (!mounted) return;
    result.fold(
      (_) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      },
      (page) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
          _isLastPage = page.isLastPage;
          if (reset) {
            _items = page.items;
            _priceMin = page.priceMin;
            _priceMax = page.priceMax;
            _filterState = FilterState.initial(
              priceMin: page.priceMin,
              priceMax: page.priceMax,
            );
          } else {
            _items = [..._items, ...page.items];
          }
        });
      },
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadResults();
    }
  }

  Future<void> _openSortSheet() async {
    final result = await showModalBottomSheet<SortOption>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => SortSheet(current: _sortOption),
    );
    if (result != null && mounted) {
      setState(() => _sortOption = result);
      _loadResults(reset: true);
    }
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
        availableColors: _allColors,
        availableSizeStandards: _allSizeStandards,
      ),
    );
    if (result != null && mounted) {
      setState(() => _filterState = result);
      _loadResults(reset: true);
    }
  }

  int get _filterCount => _filterState.activeCount(priceMin: _priceMin, priceMax: _priceMax);

  void _onChanged(String q) {
    setState(() => _liveQuery = q);
    _debounce?.cancel();
  }

  void _commitSearch(String q) {
    final trimmed = q.trim();
    if (trimmed.isEmpty) return;
    _debounce?.cancel();
    _history.add(trimmed);
    setState(() {
      _liveQuery = trimmed;
      _committedQuery = trimmed;
    });
    _loadResults(reset: true);
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
                          initialValue: _committedQuery.isNotEmpty ? _committedQuery : null,
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
                              isDark: isDark,
                              onSuggestionTap: _commitSearch,
                            )
                          : _ResultsState(
                              query: _committedQuery,
                              items: _items,
                              isLoading: _isLoading,
                              isLoadingMore: _isLoadingMore,
                              isDark: isDark,
                              muted: muted,
                              sortOption: _sortOption,
                              filterCount: _filterCount,
                              onFilter: _openFilterSheet,
                              onSort: _openSortSheet,
                              scrollController: _scrollController,
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
  final bool isDark;
  final ValueChanged<String> onSuggestionTap;

  const _TypingState({
    required this.query,
    required this.isDark,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () => onSuggestionTap(query),
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
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
                Text(
                  'Search for "$query"',
                  style: AppFonts.primary(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
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

// ─── State 3 — Results (grid) ─────────────────────────────────────────────────

class _ResultsState extends StatelessWidget {
  final String query;
  final List<ItemListItemDto> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isDark;
  final Color muted;
  final SortOption sortOption;
  final int filterCount;
  final VoidCallback onFilter;
  final VoidCallback onSort;
  final ScrollController scrollController;

  const _ResultsState({
    required this.query,
    required this.items,
    required this.isLoading,
    required this.isLoadingMore,
    required this.isDark,
    required this.muted,
    required this.sortOption,
    required this.filterCount,
    required this.onFilter,
    required this.onSort,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SortFilterBar(
          sortOption: sortOption,
          filterCount: filterCount,
          productCount: items.length,
          onFilter: onFilter,
          onSort: onSort,
        ),
        const SizedBox(height: 10),
        if (isLoading)
          const Expanded(child: SingleChildScrollView(child: ProductGridSkeleton()))
        else if (items.isEmpty)
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
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.70,
              ),
              itemCount: items.length + (isLoadingMore ? 2 : 0),
              itemBuilder: (_, i) {
                if (i >= items.length) {
                  return const ProductGridCardSkeleton();
                }
                return ProductGridCard(item: items[i]);
              },
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

    if (recents.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Recent ────────────────────────────────────────────────────
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

