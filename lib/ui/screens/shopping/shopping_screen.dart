import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/apis/categories_api.dart';
import '../../../backend_integration/apis/colors_api.dart';
import '../../../backend_integration/apis/items_api.dart';
import '../../../backend_integration/apis/size_standards_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../backend_integration/dtos/category/category_dto.dart';
import '../../../backend_integration/dtos/category/sub_category_dto.dart';
import '../../../backend_integration/dtos/item/color_dto.dart';
import '../../../backend_integration/dtos/item/item_list_item_dto.dart';
import '../../../backend_integration/dtos/item/size_standard_dto.dart';
import '../../../enums/sort_option.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../../utils/number_localization.dart';
import '../../reusable_components/bars/sort_filter_bar.dart';
import '../../reusable_components/category_pill/aurora_category_l1_pill.dart';
import '../../reusable_components/category_pill/l1_pill_row_skeleton.dart';
import '../../reusable_components/product_card/product_grid_card.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/filter_state.dart';
import 'widgets/sort_sheet.dart';

const _sweepColors = [
  AppColors.auroraPink,
  AppColors.auroraPurple,
  AppColors.auroraElectricBlue,
  AppColors.auroraPurple,
  AppColors.auroraPink,
];
const _sweepStops = [0.0, 0.25, 0.5, 0.75, 1.0];

const _take = 6;

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  // Taxonomy
  List<CategoryDto> _categories = [];
  bool _taxonomyLoading = true;
  String? _selectedL1;
  String? _selectedL2;
  String? _selectedL3;

  // Items
  final List<ItemListItemDto> _items = [];
  int _totalCount = 0;
  bool _isLoadingItems = false;
  bool _isLastPage = false;
  bool _hasItemsError = false;
  int _skip = 0;

  // Dynamic price bounds (updated from first page of each category load)
  double _priceMin = 0.0;
  double _priceMax = 9999.0;

  // Filter catalogue data
  List<ColorDto> _allColors = [];
  List<SizeStandardDto> _allSizeStandards = [];
  List<int> _availableSizeStandardIds = [];

  // Sort & filter
  FilterState _filterState = FilterState.initial(priceMin: 0.0, priceMax: 9999.0);
  SortOption _sortOption = SortOption.newest;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _fetchCategories();
    _fetchFilterCatalogue();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoadingItems &&
        !_isLastPage) {
      _loadItems();
    }
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

  Future<void> _fetchCategories() async {
    setState(() => _taxonomyLoading = true);
    final result = await serviceLocator<CategoriesApi>().getCategories();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _taxonomyLoading = false),
      (categories) {
        setState(() {
          _categories = categories;
          _selectedL1 = categories.isNotEmpty ? categories.first.name : null;
          _taxonomyLoading = false;
        });
        _loadItems(reset: true);
      },
    );
  }

  Future<void> _loadItems({bool reset = false}) async {
    if (!reset && (_isLoadingItems || _isLastPage)) return;

    if (reset) {
      setState(() {
        _items.clear();
        _skip = 0;
        _isLastPage = false;
        _isLoadingItems = true;
        _hasItemsError = false;
      });
    } else {
      setState(() => _isLoadingItems = true);
    }

    final price = _filterState.priceRange;
    final result = await serviceLocator<ItemsApi>().getItems(
      mainCategoryId: _selectedL1Id,
      subCategoryId: _selectedL2Id,
      detailCategoryId: _selectedL3Id,
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
        _isLoadingItems = false;
        if (reset) _hasItemsError = true;
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
        _isLoadingItems = false;
        _hasItemsError = false;
      }),
    );
  }

  Future<void> _refresh() async => _fetchCategories();

  // ─── Active DTO lookups ───────────────────────────────────────────────────

  CategoryDto? get _activeL1 =>
      _categories.where((c) => c.name == _selectedL1).firstOrNull;

  SubCategoryDto? get _activeL2 {
    final l1 = _activeL1;
    if (l1 == null || _selectedL2 == null) return null;
    return l1.subCategories.where((s) => s.name == _selectedL2).firstOrNull;
  }

  int? get _selectedL1Id => _activeL1?.id;
  int? get _selectedL2Id => _activeL2?.id;
  int? get _selectedL3Id {
    final l2 = _activeL2;
    if (l2 == null || _selectedL3 == null) return null;
    return l2.detailCategories
        .where((d) => d.name == _selectedL3)
        .firstOrNull
        ?.id;
  }

  // ─── Handlers ─────────────────────────────────────────────────────────────

  void _onL1Selected(String label) {
    setState(() {
      _selectedL1 = label;
      _selectedL2 = null;
      _selectedL3 = null;
    });
    _loadItems(reset: true);
  }

  void _onL2Selected(String label) {
    setState(() {
      _selectedL2 = _selectedL2 == label ? null : label;
      _selectedL3 = null;
    });
    _loadItems(reset: true);
  }

  void _onL3Selected(String label) {
    setState(() => _selectedL3 = _selectedL3 == label ? null : label);
    _loadItems(reset: true);
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

  int get _filterCount =>
      _filterState.activeCount(priceMin: _priceMin, priceMax: _priceMax);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: _taxonomyLoading
              ? _LoadingBody(isDark: isDark)
              : _LoadedBody(
                  categories: _categories,
                  selectedL1: _selectedL1,
                  selectedL2: _selectedL2,
                  selectedL3: _selectedL3,
                  activeL1: _activeL1,
                  activeL2: _activeL2,
                  filterCount: _filterCount,
                  currentSort: _sortOption,
                  totalCount: _totalCount,
                  items: _items,
                  isLoadingItems: _isLoadingItems,
                  isLastPage: _isLastPage,
                  hasItemsError: _hasItemsError,
                  scrollController: _scrollController,
                  isDark: isDark,
                  onL1Selected: _onL1Selected,
                  onL2Selected: _onL2Selected,
                  onL3Selected: _onL3Selected,
                  onFilter: _openFilterSheet,
                  onSort: _openSortSheet,
                  onRefresh: _refresh,
                  onRetry: () => _loadItems(reset: true),
                ),
        );
      },
    );
  }
}

// ─── Loading body (taxonomy still fetching) ───────────────────────────────────

class _LoadingBody extends StatelessWidget {
  final bool isDark;
  const _LoadingBody({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const L1PillRowSkeleton(),
        const SizedBox(height: 10),
        _LevelSeparator(isDark: isDark),
        const Expanded(child: _SkeletonGrid()),
      ],
    );
  }
}

// ─── Loaded body ──────────────────────────────────────────────────────────────

class _LoadedBody extends StatelessWidget {
  final List<CategoryDto> categories;
  final String? selectedL1;
  final String? selectedL2;
  final String? selectedL3;
  final CategoryDto? activeL1;
  final SubCategoryDto? activeL2;
  final int filterCount;
  final SortOption currentSort;
  final int totalCount;
  final List<ItemListItemDto> items;
  final bool isLoadingItems;
  final bool isLastPage;
  final bool hasItemsError;
  final ScrollController scrollController;
  final bool isDark;
  final ValueChanged<String> onL1Selected;
  final ValueChanged<String> onL2Selected;
  final ValueChanged<String> onL3Selected;
  final VoidCallback onFilter;
  final VoidCallback onSort;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;

  const _LoadedBody({
    required this.categories,
    required this.selectedL1,
    required this.selectedL2,
    required this.selectedL3,
    required this.activeL1,
    required this.activeL2,
    required this.filterCount,
    required this.currentSort,
    required this.totalCount,
    required this.items,
    required this.isLoadingItems,
    required this.isLastPage,
    required this.hasItemsError,
    required this.scrollController,
    required this.isDark,
    required this.onL1Selected,
    required this.onL2Selected,
    required this.onL3Selected,
    required this.onFilter,
    required this.onSort,
    required this.onRefresh,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l2Labels =
        activeL1?.subCategories.map((s) => s.name).toList() ?? [];
    final l3Labels =
        activeL2?.detailCategories.map((d) => d.name).toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _L1Row(
          categories: categories,
          selected: selectedL1,
          onSelected: onL1Selected,
        ),
        const SizedBox(height: 10),
        _LevelSeparator(isDark: isDark),
        if (l2Labels.isNotEmpty) ...[
          const SizedBox(height: 10),
          _L2Row(
            subcategories: l2Labels,
            selected: selectedL2,
            onSelected: onL2Selected,
            isDark: isDark,
          ),
        ],
        if (l3Labels.isNotEmpty) ...[
          const SizedBox(height: 10),
          _LevelSeparator(isDark: isDark),
          const SizedBox(height: 10),
          _L3Row(
            details: l3Labels,
            selected: selectedL3,
            onSelected: onL3Selected,
            isDark: isDark,
          ),
        ],
        const SizedBox(height: 14),
        SortFilterBar(
          sortOption: currentSort,
          filterCount: filterCount,
          onFilter: onFilter,
          onSort: onSort,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'shopping_screen.style_count'
                .tr(namedArgs: {'count': localizedNumber(totalCount)}),
            style: AppTextStyles.captionSmall.copyWith(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.55)
                  : AppColors.primaryPurple.withValues(alpha: 0.65),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            color: AppColors.auroraPink,
            child: _buildItemsArea(isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsArea(bool isDark) {
    if (isLoadingItems && items.isEmpty) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: _SkeletonGrid(),
      );
    }

    if (hasItemsError) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _ErrorState(onRetry: onRetry, isDark: isDark),
      );
    }

    if (items.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _EmptyState(isDark: isDark),
      );
    }

    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
        if (isLoadingItems)
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
        if (isLastPage)
          SliverToBoxAdapter(child: _EndLabel(isDark: isDark)),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}

// ─── L1 pills ─────────────────────────────────────────────────────────────────

class _L1Row extends StatelessWidget {
  final List<CategoryDto> categories;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _L1Row({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => AuroraCategoryL1Pill(
          label: categories[i].name,
          isSelected: categories[i].name == selected,
          onTap: () => onSelected(categories[i].name),
        ),
      ),
    );
  }
}

// ─── Separator ────────────────────────────────────────────────────────────────

class _LevelSeparator extends StatelessWidget {
  final bool isDark;
  const _LevelSeparator({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: isDark
          ? AppColors.white.withValues(alpha: 0.05)
          : AppColors.primaryPurple.withValues(alpha: 0.10),
    );
  }
}

// ─── L2 tabs ──────────────────────────────────────────────────────────────────

class _L2Row extends StatelessWidget {
  final List<String> subcategories;
  final String? selected;
  final ValueChanged<String> onSelected;
  final bool isDark;

  const _L2Row({
    required this.subcategories,
    required this.selected,
    required this.onSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: subcategories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 22),
        itemBuilder: (_, i) => _L2Tab(
          label: subcategories[i],
          isSelected: subcategories[i] == selected,
          isDark: isDark,
          onTap: () => onSelected(subcategories[i]),
        ),
      ),
    );
  }
}

class _L2Tab extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _L2Tab({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_L2Tab> createState() => _L2TabState();
}

class _L2TabState extends State<_L2Tab> with SingleTickerProviderStateMixin {
  late final AnimationController _sweep;

  @override
  void initState() {
    super.initState();
    _sweep = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    if (widget.isSelected) _sweep.repeat();
  }

  @override
  void didUpdateWidget(covariant _L2Tab old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !_sweep.isAnimating) {
      _sweep.repeat();
    } else if (!widget.isSelected && _sweep.isAnimating) {
      _sweep.stop();
    }
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTextColor =
        widget.isDark ? AppColors.white : AppColors.primaryPurple;
    final mutedText = widget.isDark
        ? AppColors.white.withValues(alpha: 0.50)
        : AppColors.primaryPurple.withValues(alpha: 0.55);

    final textStyle = AppTextStyles.caption.copyWith(
      fontSize: 12,
      fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w600,
      letterSpacing: 0.2,
      height: 1.0,
    );

    if (!widget.isSelected) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(widget.label,
                  style: textStyle.copyWith(color: mutedText)),
            ),
            const SizedBox(height: 2.5),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _sweep,
        builder: (context, _) {
          final phase = _sweep.value;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: _sweepColors,
                    stops: _sweepStops,
                    tileMode: TileMode.repeated,
                  ).createShader(
                    Rect.fromLTWH(
                      bounds.left + phase * bounds.width,
                      bounds.top,
                      bounds.width,
                      bounds.height,
                    ),
                  ),
                  blendMode: BlendMode.srcIn,
                  child: Text(widget.label,
                      style: textStyle.copyWith(color: selectedTextColor)),
                ),
              ),
              SizedBox(
                height: 2.5,
                width: _textWidth(widget.label, textStyle) + 4,
                child: RepaintBoundary(
                  child: CustomPaint(painter: _L2SweepPainter(phase: phase)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _textWidth(String text, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }
}

class _L2SweepPainter extends CustomPainter {
  final double phase;
  _L2SweepPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2));

    final glowPaint = Paint()
      ..color = AppColors.auroraPink.withValues(alpha: 0.55)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);
    canvas.drawRRect(rrect, glowPaint);

    final shaderRect =
        Rect.fromLTWH(phase * size.width, 0, size.width, size.height);
    final shader = LinearGradient(
      colors: _sweepColors,
      stops: _sweepStops,
      tileMode: TileMode.repeated,
    ).createShader(shaderRect);

    canvas.drawRRect(rrect, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_L2SweepPainter old) => old.phase != phase;
}

// ─── L3 pill buttons ──────────────────────────────────────────────────────────

class _L3Row extends StatelessWidget {
  final List<String> details;
  final String? selected;
  final ValueChanged<String> onSelected;
  final bool isDark;

  const _L3Row({
    required this.details,
    required this.selected,
    required this.onSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            for (var i = 0; i < details.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: _L3Button(
                  label: details[i],
                  isSelected: details[i] == selected,
                  isDark: isDark,
                  onTap: () => onSelected(details[i]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _L3Button extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _L3Button({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_L3Button> createState() => _L3ButtonState();
}

class _L3ButtonState extends State<_L3Button>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (widget.isSelected) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _L3Button old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.isSelected && _pulse.isAnimating) {
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mutedText = widget.isDark
        ? AppColors.white.withValues(alpha: 0.65)
        : AppColors.primaryPurple.withValues(alpha: 0.75);
    final mutedFill = widget.isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.primaryPurple.withValues(alpha: 0.05);
    final mutedBorder = widget.isDark
        ? AppColors.white.withValues(alpha: 0.12)
        : AppColors.primaryPurple.withValues(alpha: 0.20);

    if (!widget.isSelected) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 32,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: mutedFill,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: mutedBorder),
          ),
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              height: 1.0,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final t = _pulse.value;
          return Container(
            height: 32,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.auroraCartButtonGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color:
                      AppColors.auroraPink.withValues(alpha: 0.30 + 0.25 * t),
                  blurRadius: 10 + 8 * t,
                ),
              ],
            ),
            child: child,
          );
        },
        child: Text(
          widget.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

// ─── Skeleton grid ────────────────────────────────────────────────────────────

class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 20),
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
        : AppColors.primaryPurple.withValues(alpha: 0.65);
    return SizedBox(
      height: 300,
      child: Center(
        child: GestureDetector(
          onTap: onRetry,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(FontAwesomeIcons.arrowsRotate, size: 32, color: color),
              const SizedBox(height: 10),
              Text('shopping_screen.tap_to_retry'.tr(),
                  style: AppTextStyles.caption.copyWith(color: color)),
            ],
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
        : AppColors.primaryPurple.withValues(alpha: 0.35);
    final mutedText = isDark
        ? AppColors.white.withValues(alpha: 0.60)
        : AppColors.primaryPurple.withValues(alpha: 0.70);
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.boxOpen, size: 48, color: mutedIcon),
            const SizedBox(height: 16),
            Text(
              'shopping_screen.empty_category'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(color: mutedText),
            ),
          ],
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
        : AppColors.primaryPurple.withValues(alpha: 0.35);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          'shopping_screen.all_caught_up'.tr(),
          style: AppTextStyles.captionSmall.copyWith(
            color: color,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
