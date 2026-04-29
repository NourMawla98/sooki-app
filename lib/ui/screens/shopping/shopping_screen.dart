import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/mock_products.dart';
import '../../../data/mock_taxonomy.dart';
import '../../../enums/sort_option.dart';
import '../../../models/product.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/category_pill/aurora_category_l1_pill.dart';
import '../../reusable_components/category_pill/l1_pill_row_skeleton.dart';
import '../../reusable_components/product_card/product_grid_card.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/filter_state.dart';
import 'widgets/sort_sheet.dart';

/// Shopping screen — one-page browse with three differentiated taxonomy
/// rows above a grid of [ProductGridCard]s.
///
/// - **L1:** rotating neon-border pill (shared [AuroraCategoryL1Pill]). A
///   [L1PillRowSkeleton] stands in while the taxonomy is loading.
/// - **L2:** text tab whose active label + 2.5px underline both sweep the
///   same aurora gradient in lock-step.
/// - **L3:** one rounded glass "segmented control" container holding every
///   detail label; the active label is a pill-within-pill with aurora fill
///   and a breathing pink glow.
///
/// Filter + Sort open placeholder bottom sheets in Phase 1.

/// Aurora gradient palette shared between the L2 text shader and the L2
/// underline painter — keeps the label colour sweep and the bar colour
/// sweep visually identical.
const _sweepColors = [
  AppColors.auroraPink,
  AppColors.auroraPurple,
  AppColors.auroraElectricBlue,
  AppColors.auroraPurple,
  AppColors.auroraPink,
];
const _sweepStops = [0.0, 0.25, 0.5, 0.75, 1.0];

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  late String _selectedL1 = mockTaxonomy.first.label;
  String? _selectedL2;
  String? _selectedL3;

  // Catalog-wide price bounds. Computed once on first access so the
  // filter slider's extent stays stable even as the user drills into a
  // narrower L1/L2/L3 branch.
  late final double _priceMin = _allProducts
      .map((p) => p.price)
      .reduce((a, b) => a < b ? a : b)
      .floorToDouble();
  late final double _priceMax = _allProducts
      .map((p) => p.price)
      .reduce((a, b) => a > b ? a : b)
      .ceilToDouble();

  late FilterState _filterState = FilterState.initial(
    priceMin: _priceMin,
    priceMax: _priceMax,
  );
  SortOption _sortOption = SortOption.newest;

  // One-shot loading simulation so the skeleton appears on first mount.
  // TODO(backend): replace with the real taxonomy loading state once the
  // API is wired up.
  bool _isTaxonomyLoading = true;
  Timer? _loadTimer;

  @override
  void initState() {
    super.initState();
    _loadTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isTaxonomyLoading = false);
    });
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    super.dispose();
  }

  List<Product> get _allProducts => [
        ...mockBrowseProducts,
        ...mockDealProducts,
      ];

  /// Products matching the current L1 / L2 / L3 selection, with the `Sale`
  /// view applied as a simple global discount filter.
  ///
  /// Sale is a view, not a branch: selecting it shows every discounted
  /// product across the catalog. The prior branch's L2/L3 context is not
  /// preserved in Phase 1 — that's tracked for Phase 4 polish.
  List<Product> get _scopedProducts {
    if (_selectedL1 == 'Sale') {
      return _allProducts
          .where((p) => p.discountPercentage != null)
          .toList();
    }

    return _allProducts.where((p) {
      if (p.category != _selectedL1) return false;
      if (_selectedL2 != null && p.subCategory != _selectedL2) return false;
      if (_selectedL3 != null && p.detailedCategory != _selectedL3) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Scoped products after the Filter sheet's conditions, ordered per the
  /// current [SortOption]. This is what ultimately feeds the grid.
  List<Product> get _displayProducts {
    final filtered =
        _scopedProducts.where(_filterState.matches).toList();

    switch (_sortOption) {
      case SortOption.newest:
        // No timestamps in mock data — list order is the proxy for "newest".
        break;
      case SortOption.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.mostPopular:
        filtered.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }
    return filtered;
  }

  /// Distinct colour variants present in the current taxonomy scope.
  /// Drives the Filter sheet's colour swatches.
  List<ColorVariant> get _availableColors {
    final seen = <String>{};
    final out = <ColorVariant>[];
    for (final p in _scopedProducts) {
      for (final c in p.colors) {
        if (seen.add(c.name)) out.add(c);
      }
    }
    return out;
  }

  /// Distinct size variants present in the current taxonomy scope. A size
  /// is marked unavailable iff no scoped product actually stocks it.
  List<SizeVariant> get _availableSizes {
    final stocked = <String>{};
    final seen = <String>{};
    final out = <SizeVariant>[];
    for (final p in _scopedProducts) {
      for (final s in p.sizes) {
        if (s.isAvailable) stocked.add(s.label);
        if (seen.add(s.label)) out.add(s);
      }
    }
    // Ensure the `isAvailable` flag reflects aggregated stock across the
    // scope rather than a single product's state.
    return [
      for (final s in out)
        SizeVariant(label: s.label, isAvailable: stocked.contains(s.label)),
    ];
  }

  CategoryNode? get _activeL1Node =>
      mockTaxonomy.where((n) => n.label == _selectedL1).firstOrNull;

  CategoryNode? get _activeL2Node {
    final l1 = _activeL1Node;
    if (l1 == null || _selectedL2 == null) return null;
    return l1.children.where((n) => n.label == _selectedL2).firstOrNull;
  }

  int get _activeFilterCount => _filterState.activeCount(
        priceMin: _priceMin,
        priceMax: _priceMax,
      );

  void _onL1Selected(String label) {
    setState(() {
      _selectedL1 = label;
      _selectedL2 = null;
      _selectedL3 = null;
    });
  }

  void _onL2Selected(String label) {
    setState(() {
      _selectedL2 = _selectedL2 == label ? null : label;
      _selectedL3 = null;
    });
  }

  void _onL3Selected(String label) {
    setState(() {
      _selectedL3 = _selectedL3 == label ? null : label;
    });
  }

  Future<void> _openFilterSheet() async {
    final result = await showDialog<FilterState>(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: FilterSheet(
          initial: _filterState,
          priceMin: _priceMin,
          priceMax: _priceMax,
          availableColors: _availableColors,
          availableSizes: _availableSizes,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() => _filterState = result);
    }
  }

  Future<void> _openSortSheet() async {
    final result = await showDialog<SortOption>(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SortSheet(current: _sortOption),
      ),
    );
    if (result != null && mounted) {
      setState(() => _sortOption = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: _isTaxonomyLoading
              ? _LoadingBody(isDark: isDark)
              : _LoadedBody(
                  selectedL1: _selectedL1,
                  selectedL2: _selectedL2,
                  selectedL3: _selectedL3,
                  activeL1Node: _activeL1Node,
                  activeL2Node: _activeL2Node,
                  filterCount: _activeFilterCount,
                  currentSort: _sortOption,
                  products: _displayProducts,
                  isDark: isDark,
                  onL1Selected: _onL1Selected,
                  onL2Selected: _onL2Selected,
                  onL3Selected: _onL3Selected,
                  onFilter: _openFilterSheet,
                  onSort: _openSortSheet,
                ),
        );
      },
    );
  }
}

// ─── Loading body — L1 skeleton above a grid skeleton ────────────────────────

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
        const Expanded(
          child: _GridLoadingStub(),
        ),
      ],
    );
  }
}

/// Faint placeholder grid under the L1 skeleton — just enough shape to
/// show "products will land here" without faking detail.
class _GridLoadingStub extends StatelessWidget {
  const _GridLoadingStub();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.70,
      ),
      itemCount: 4,
      itemBuilder: (_, _) => ListenableBuilder(
        listenable: ThemeService.instance,
        builder: (context, _) {
          final isDark = ThemeService.instance.isDarkMode;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.08)
                    : AppColors.primaryPurple.withValues(alpha: 0.12),
              ),
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.02)
                  : AppColors.primaryPurple.withValues(alpha: 0.03),
            ),
          );
        },
      ),
    );
  }
}

// ─── Loaded body ─────────────────────────────────────────────────────────────

class _LoadedBody extends StatelessWidget {
  final String selectedL1;
  final String? selectedL2;
  final String? selectedL3;
  final CategoryNode? activeL1Node;
  final CategoryNode? activeL2Node;
  final int filterCount;
  final SortOption currentSort;
  final List<Product> products;
  final bool isDark;
  final ValueChanged<String> onL1Selected;
  final ValueChanged<String> onL2Selected;
  final ValueChanged<String> onL3Selected;
  final VoidCallback onFilter;
  final VoidCallback onSort;

  const _LoadedBody({
    required this.selectedL1,
    required this.selectedL2,
    required this.selectedL3,
    required this.activeL1Node,
    required this.activeL2Node,
    required this.filterCount,
    required this.currentSort,
    required this.products,
    required this.isDark,
    required this.onL1Selected,
    required this.onL2Selected,
    required this.onL3Selected,
    required this.onFilter,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _L1Row(
          selected: selectedL1,
          onSelected: onL1Selected,
        ),
        const SizedBox(height: 10),
        _LevelSeparator(isDark: isDark),
        if (activeL1Node != null && activeL1Node!.hasChildren) ...[
          const SizedBox(height: 10),
          _L2Row(
            subcategories: activeL1Node!.children.map((n) => n.label).toList(),
            selected: selectedL2,
            onSelected: onL2Selected,
            isDark: isDark,
          ),
        ],
        if (activeL2Node != null && activeL2Node!.hasChildren) ...[
          const SizedBox(height: 10),
          _LevelSeparator(isDark: isDark),
          const SizedBox(height: 10),
          _L3Row(
            details: activeL2Node!.children.map((n) => n.label).toList(),
            selected: selectedL3,
            onSelected: onL3Selected,
            isDark: isDark,
          ),
        ],
        const SizedBox(height: 14),
        _FilterSortRow(
          filterCount: filterCount,
          currentSort: currentSort,
          isDark: isDark,
          onFilter: onFilter,
          onSort: onSort,
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${products.length} styles',
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
          child: products.isEmpty
              ? _EmptyState(isDark: isDark)
              : _ProductGrid(products: products),
        ),
      ],
    );
  }
}

// ─── L1 · Neon-border pills ──────────────────────────────────────────────────

class _L1Row extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;
  const _L1Row({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final labels = mockTaxonomy.map((n) => n.label).toList();
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => AuroraCategoryL1Pill(
          label: labels[i],
          isSelected: labels[i] == selected,
          onTap: () => onSelected(labels[i]),
        ),
      ),
    );
  }
}

// ─── Separator between taxonomy rows ─────────────────────────────────────────

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

// ─── L2 · Gradient-text word + gradient underline, synced sweep ──────────────

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
              child: Text(
                widget.label,
                style: textStyle.copyWith(color: mutedText),
              ),
            ),
            const SizedBox(height: 2.5),
          ],
        ),
      );
    }

    // Active branch — text and underline share the same phase so their
    // colour sweeps stay in lock-step.
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
                  child: Text(
                    widget.label,
                    style: textStyle.copyWith(color: selectedTextColor),
                  ),
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

  /// Measures the rendered width of [text] at [style] so the underline bar
  /// matches the label's footprint exactly.
  double _textWidth(String text, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }
}

/// Paints a rounded-rect underline whose LinearGradient colours slide
/// horizontally. The slide is driven by [phase] (0..1), which repeats —
/// producing the "colours travelling through the bar" effect.
class _L2SweepPainter extends CustomPainter {
  final double phase;
  _L2SweepPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2));

    // Soft pink glow behind the bar (outer blur only — doesn't dim the fill).
    final glowPaint = Paint()
      ..color = AppColors.auroraPink.withValues(alpha: 0.55)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);
    canvas.drawRRect(rrect, glowPaint);

    // Slide the shader origin so colours appear to travel through the bar.
    // tileMode.repeated wraps the gradient seamlessly at the edges.
    final shaderRect = Rect.fromLTWH(
      phase * size.width,
      0,
      size.width,
      size.height,
    );
    final shader = LinearGradient(
      colors: _sweepColors,
      stops: _sweepStops,
      tileMode: TileMode.repeated,
    ).createShader(shaderRect);

    final fillPaint = Paint()..shader = shader;
    canvas.drawRRect(rrect, fillPaint);
  }

  @override
  bool shouldRepaint(_L2SweepPainter old) => old.phase != phase;
}

// ─── L3 · Full-width rounded pill buttons ────────────────────────────────────

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

// ─── Filter + Sort row ───────────────────────────────────────────────────────

class _FilterSortRow extends StatelessWidget {
  final int filterCount;
  final SortOption currentSort;
  final bool isDark;
  final VoidCallback onFilter;
  final VoidCallback onSort;

  const _FilterSortRow({
    required this.filterCount,
    required this.currentSort,
    required this.isDark,
    required this.onFilter,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _GlassButton(
              icon: FontAwesomeIcons.sliders,
              label: 'FILTER',
              isDark: isDark,
              badgeCount: filterCount,
              onTap: onFilter,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _GlassButton(
              icon: currentSort.icon,
              label: 'SORT \u00b7 ${currentSort.buttonLabel}',
              isDark: isDark,
              onTap: onSort,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final bool isDark;
  final int badgeCount;
  final VoidCallback onTap;

  const _GlassButton({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final fill = isDark
        ? AppColors.white.withValues(alpha: 0.04)
        : AppColors.primaryPurple.withValues(alpha: 0.04);
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.primaryPurple.withValues(alpha: 0.18);
    final fg = isDark ? AppColors.white : AppColors.primaryPurple;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(icon, size: 13, color: fg),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: fg,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            if (badgeCount > 0)
              Positioned(
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.auroraPink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: AppTextStyles.captionSmall.copyWith(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Product grid & empty state ──────────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  final List<Product> products;
  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.70,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => ProductGridCard(product: products[i]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final mutedText = isDark
        ? AppColors.white.withValues(alpha: 0.60)
        : AppColors.primaryPurple.withValues(alpha: 0.70);
    final mutedIcon = isDark
        ? AppColors.white.withValues(alpha: 0.20)
        : AppColors.primaryPurple.withValues(alpha: 0.35);

    return Center(
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
    );
  }
}

