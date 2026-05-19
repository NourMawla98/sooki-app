import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/apis/colors_api.dart';
import '../../../backend_integration/apis/items_api.dart';
import '../../../backend_integration/apis/size_standards_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../backend_integration/dtos/item/color_dto.dart';
import '../../../backend_integration/dtos/item/item_list_item_dto.dart';
import '../../../backend_integration/dtos/item/size_standard_dto.dart';
import '../../../enums/sort_option.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/bars/sort_filter_bar.dart';
import '../../reusable_components/category_pill/aurora_detail_chip.dart';
import '../../reusable_components/product_card/product_grid_card.dart';
import '../shopping/widgets/filter_sheet.dart';
import '../shopping/widgets/filter_state.dart';
import '../shopping/widgets/sort_sheet.dart';
import '../splash/widgets/aurora_glow_blob.dart';
import 'category_detail_args.dart';

const _take = 6;

class CategoryDetailScreen extends StatefulWidget {
  final CategoryDetailArgs args;

  const CategoryDetailScreen({super.key, required this.args});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  String? _selectedDetail;
  int? _selectedDetailId;
  SortOption _sortOption = SortOption.newest;
  FilterState _filterState = FilterState.initial(priceMin: 0.0, priceMax: 9999.0);

  final List<ItemListItemDto> _items = [];
  int _totalCount = 0;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasError = false;
  bool _isLastPage = false;
  int _skip = 0;

  double _priceMin = 0.0;
  double _priceMax = 9999.0;
  List<ColorDto> _allColors = [];
  List<SizeStandardDto> _allSizeStandards = [];
  List<int> _availableSizeStandardIds = [];

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadItems(reset: true);
    _fetchFilterCatalogue();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchFilterCatalogue() async {
    final colorResult = await serviceLocator<ColorsApi>().getColors();
    final sizeResult =
        await serviceLocator<SizeStandardsApi>().getSizeStandards();
    if (!mounted) return;
    colorResult.fold((_) {}, (colors) => setState(() => _allColors = colors));
    sizeResult.fold(
        (_) {}, (standards) => setState(() => _allSizeStandards = standards));
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoadingMore &&
        !_isLastPage) {
      _loadItems();
    }
  }

  Future<void> _loadItems({bool reset = false}) async {
    if (!reset && (_isLoadingMore || _isLastPage)) return;

    if (reset) {
      setState(() {
        _items.clear();
        _skip = 0;
        _isLastPage = false;
        _isLoading = true;
        _hasError = false;
      });
    } else {
      setState(() => _isLoadingMore = true);
    }

    final price = _filterState.priceRange;
    final result = await serviceLocator<ItemsApi>().getItems(
      mainCategoryId: widget.args.mainCategory.id,
      subCategoryId: widget.args.subCategory?.id,
      detailCategoryId: _selectedDetailId,
      sortBy: _sortOption.toSortBy(),
      minPrice: price.start > _priceMin ? price.start : null,
      maxPrice: price.end < _priceMax ? price.end : null,
      colorIds: _filterState.colorIds.toList(),
      sizeValueIds: _filterState.sizeValueIds.toList(),
      skip: _skip,
      take: _take,
    );

    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        if (reset) _hasError = true;
      }),
      (page) => setState(() {
        if (reset) {
          _priceMin = page.priceMin;
          _priceMax = page.priceMax > page.priceMin
              ? page.priceMax
              : (_priceMin + 9999.0);
          _availableSizeStandardIds = page.availableSizeStandardIds;
        }
        _items.addAll(page.items);
        _totalCount = page.totalCount;
        _isLastPage = page.isLastPage;
        _skip += page.items.length;
        _isLoading = false;
        _isLoadingMore = false;
        _hasError = false;
      }),
    );
  }

  void _onDetailSelected(String name) {
    final isDeselecting = _selectedDetail == name;
    setState(() {
      _selectedDetail = isDeselecting ? null : name;
      _selectedDetailId = isDeselecting
          ? null
          : widget.args.subCategory?.detailCategories
              .where((d) => d.name == name)
              .firstOrNull
              ?.id;
    });
    _loadItems(reset: true);
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
      _loadItems(reset: true);
    }
  }

  Future<void> _openFilterSheet() async {
    final relevantStandards = _allSizeStandards
        .where((s) => _availableSizeStandardIds.contains(s.id))
        .toList();
    final result = await showModalBottomSheet<FilterState>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => FilterSheet(
        initial: _filterState.copyWith(
          priceRange: RangeValues(
            _filterState.priceRange.start.clamp(_priceMin, _priceMax),
            _filterState.priceRange.end.clamp(_priceMin, _priceMax),
          ),
        ),
        priceMin: _priceMin,
        priceMax: _priceMax,
        availableColors: _allColors,
        availableSizeStandards: relevantStandards,
      ),
    );
    if (result != null && mounted) {
      setState(() => _filterState = result);
      _loadItems(reset: true);
    }
  }

  int get _filterCount =>
      _filterState.activeCount(priceMin: _priceMin, priceMax: _priceMax);

  List<String> get _detailCategories =>
      widget.args.subCategory?.detailCategories.map((d) => d.name).toList() ??
      [];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -60,
                right: -60,
                size: 280,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.18 : 0.09,
              ),
              AuroraGlowBlob(
                bottom: 100,
                left: -60,
                size: 280,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.16 : 0.08,
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopBar(
                      title: widget.args.subCategory?.name ??
                          widget.args.mainCategory.name,
                      isDark: isDark,
                    ),
                    _StickyZone(
                      isDark: isDark,
                      mainCategory: widget.args.mainCategory.name,
                      subCategory: widget.args.subCategory?.name,
                      detailCategories: _detailCategories,
                      selectedDetail: _selectedDetail,
                      filterCount: _filterCount,
                      sortOption: _sortOption,
                      totalCount: _totalCount,
                      onDetailSelected: _onDetailSelected,
                      onFilter: _openFilterSheet,
                      onSort: _openSortSheet,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async => _loadItems(reset: true),
                        color: AppColors.auroraPink,
                        child: _isLoading
                            ? _SkeletonGrid()
                            : _hasError
                                ? _ErrorState(onRetry: () => _loadItems(reset: true), isDark: isDark)
                                : _items.isEmpty
                                    ? _EmptyState(isDark: isDark)
                                    : _ItemGrid(
                                        items: _items,
                                        isLoadingMore: _isLoadingMore,
                                        isLastPage: _isLastPage,
                                        scrollController: _scrollController,
                                        isDark: isDark,
                                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Rule #9 top bar ──────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String title;
  final bool isDark;

  const _TopBar({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? AppColors.white : AppColors.auroraPurple;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 18, color: fg),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                color: fg,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sticky zone: breadcrumb + chips + sort/filter ────────────────────────────

class _StickyZone extends StatelessWidget {
  final bool isDark;
  final String mainCategory;
  final String? subCategory;
  final List<String> detailCategories;
  final String? selectedDetail;
  final int filterCount;
  final SortOption sortOption;
  final int totalCount;
  final ValueChanged<String> onDetailSelected;
  final VoidCallback onFilter;
  final VoidCallback onSort;

  const _StickyZone({
    required this.isDark,
    required this.mainCategory,
    required this.subCategory,
    required this.detailCategories,
    required this.selectedDetail,
    required this.filterCount,
    required this.sortOption,
    required this.totalCount,
    required this.onDetailSelected,
    required this.onFilter,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? AppColors.auroraDeepBase.withValues(alpha: 0.92)
        : AppColors.auroraLightBase.withValues(alpha: 0.94);
    final mutedText = isDark
        ? AppColors.white.withValues(alpha: 0.30)
        : AppColors.auroraPurple.withValues(alpha: 0.40);
    final sepColor = isDark
        ? AppColors.white.withValues(alpha: 0.30)
        : AppColors.auroraPurple.withValues(alpha: 0.22);
    final activeText = isDark
        ? AppColors.white.withValues(alpha: 0.70)
        : AppColors.auroraPurple;
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.07)
        : AppColors.auroraPurple.withValues(alpha: 0.10);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Text(
                      'Categories',
                      style: AppTextStyles.captionSmall.copyWith(
                        color: mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text('›',
                          style: TextStyle(
                              color: sepColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                    Text(
                      mainCategory,
                      style: AppTextStyles.captionSmall.copyWith(
                        color: mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subCategory != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text('›',
                            style: TextStyle(
                                color: sepColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        subCategory!,
                        style: AppTextStyles.captionSmall.copyWith(
                          color: activeText,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (detailCategories.isNotEmpty) ...[
                const SizedBox(height: 10),
                AuroraDetailChipRow(
                  labels: detailCategories,
                  selected: selectedDetail,
                  onSelected: onDetailSelected,
                ),
              ],
              SortFilterBar(
                sortOption: sortOption,
                filterCount: filterCount,
                productCount: totalCount,
                onFilter: onFilter,
                onSort: onSort,
              ),
              const SizedBox(height: 10),
              Container(
                height: 1,
                color: dividerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Item grid ────────────────────────────────────────────────────────────────

class _ItemGrid extends StatelessWidget {
  final List<ItemListItemDto> items;
  final bool isLoadingMore;
  final bool isLastPage;
  final ScrollController scrollController;
  final bool isDark;

  const _ItemGrid({
    required this.items,
    required this.isLoadingMore,
    required this.isLastPage,
    required this.scrollController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (_, i) => ProductGridCard(item: items[i]),
              childCount: items.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.70,
            ),
          ),
        ),
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.auroraPurple,
                  ),
                ),
              ),
            ),
          ),
        if (isLastPage && items.isNotEmpty)
          SliverToBoxAdapter(
            child: _EndLabel(isDark: isDark),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}

// ─── Skeleton grid ────────────────────────────────────────────────────────────

class _SkeletonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.70,
      ),
      itemCount: 6,
      itemBuilder: (_, _) => const ProductGridCardSkeleton(),
    );
  }
}

// ─── States ───────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final bool isDark;
  const _ErrorState({required this.onRetry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? AppColors.white.withValues(alpha: 0.55)
        : AppColors.auroraPurple.withValues(alpha: 0.65);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 300,
        child: Center(
          child: GestureDetector(
            onTap: onRetry,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(FontAwesomeIcons.arrowsRotate, size: 32, color: color),
                const SizedBox(height: 10),
                Text('Tap to retry',
                    style: AppTextStyles.caption.copyWith(color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final mutedIcon = isDark
        ? AppColors.white.withValues(alpha: 0.20)
        : AppColors.auroraPurple.withValues(alpha: 0.35);
    final mutedText = isDark
        ? AppColors.white.withValues(alpha: 0.60)
        : AppColors.auroraPurple.withValues(alpha: 0.70);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.boxOpen, size: 48, color: mutedIcon),
              const SizedBox(height: 16),
              Text(
                'No products in this category yet',
                style: AppTextStyles.bodyMedium.copyWith(color: mutedText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EndLabel extends StatelessWidget {
  final bool isDark;
  const _EndLabel({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? AppColors.white.withValues(alpha: 0.25)
        : AppColors.auroraPurple.withValues(alpha: 0.35);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          "— You're all caught up —",
          style: AppTextStyles.captionSmall.copyWith(
            color: color,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
