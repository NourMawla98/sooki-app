import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/mock_products.dart';
import '../../../data/mock_taxonomy.dart';
import '../../../enums/sort_option.dart';
import '../../../models/product.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/buttons/aurora_glass_action_button.dart';
import '../../reusable_components/category_pill/aurora_detail_chip.dart';
import '../../reusable_components/product_card/product_grid_card.dart';
import '../shopping/widgets/filter_sheet.dart';
import '../shopping/widgets/filter_state.dart';
import '../shopping/widgets/sort_sheet.dart';
import '../splash/widgets/aurora_glow_blob.dart';
import 'category_detail_args.dart';

/// Screen 2 — detail categories + products.
///
/// Receives [CategoryDetailArgs] via route arguments.
/// Sticky zone (breadcrumb + L3 chip row + sort/filter) stays fixed at top
/// while the product grid scrolls underneath it.
class CategoryDetailScreen extends StatefulWidget {
  final CategoryDetailArgs args;

  const CategoryDetailScreen({super.key, required this.args});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  String? _selectedDetail;

  late final List<Product> _allProducts = [
    ...mockBrowseProducts,
    ...mockDealProducts,
  ];

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

  List<String> get _detailCategories {
    final sub = findSubCategory(
      widget.args.mainCategory,
      widget.args.subCategory ?? '',
    );
    if (sub != null && sub.hasChildren) {
      return sub.children.map((n) => n.label).toList();
    }
    // Fallback: show L2 subcategories of the main category.
    final main = findCategory(widget.args.mainCategory);
    if (main != null && main.hasChildren) {
      return main.children.map((n) => n.label).toList();
    }
    return [];
  }

  List<Product> get _scopedProducts {
    return _allProducts.where((p) {
      if (p.category != widget.args.mainCategory) return false;
      final sub = widget.args.subCategory;
      if (sub != null && p.subCategory != sub) return false;
      if (_selectedDetail != null && p.detailedCategory != _selectedDetail) {
        return false;
      }
      return true;
    }).toList();
  }

  List<Product> get _displayProducts {
    final filtered = _scopedProducts.where(_filterState.matches).toList();
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
    }
    return filtered;
  }

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
    return [
      for (final s in out)
        SizeVariant(label: s.label, isAvailable: stocked.contains(s.label)),
    ];
  }

  int get _filterCount => _filterState.activeCount(
        priceMin: _priceMin,
        priceMax: _priceMax,
      );

  Future<void> _openSortSheet() async {
    final result = await showModalBottomSheet<SortOption>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SortSheet(current: _sortOption),
    );
    if (result != null && mounted) setState(() => _sortOption = result);
  }

  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<FilterState>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSheet(
        initial: _filterState,
        priceMin: _priceMin,
        priceMax: _priceMax,
        availableColors: _availableColors,
        availableSizes: _availableSizes,
      ),
    );
    if (result != null && mounted) setState(() => _filterState = result);
  }

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
              if (isDark)
                AuroraGlowBlob(
                  top: -60,
                  right: -60,
                  size: 280,
                  color: AppColors.auroraPurple,
                  intensity: 0.18,
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
                    // ── Rule #9 top bar ──────────────────────────────────
                    _TopBar(
                      title: widget.args.subCategory ??
                          widget.args.mainCategory,
                      isDark: isDark,
                    ),
                    // ── Sticky zone ──────────────────────────────────────
                    _StickyZone(
                      isDark: isDark,
                      mainCategory: widget.args.mainCategory,
                      subCategory: widget.args.subCategory,
                      detailCategories: _detailCategories,
                      selectedDetail: _selectedDetail,
                      filterCount: _filterCount,
                      sortOption: _sortOption,
                      productCount: _displayProducts.length,
                      onDetailSelected: (label) => setState(
                        () => _selectedDetail =
                            _selectedDetail == label ? null : label,
                      ),
                      onFilter: _openFilterSheet,
                      onSort: _openSortSheet,
                    ),
                    // ── Product grid ─────────────────────────────────────
                    Expanded(
                      child: _displayProducts.isEmpty
                          ? _EmptyState(isDark: isDark)
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.70,
                              ),
                              itemCount: _displayProducts.length,
                              itemBuilder: (_, i) =>
                                  ProductGridCard(product: _displayProducts[i]),
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
  final int productCount;
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
    required this.productCount,
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
              // Breadcrumb
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
                      child: Text(
                        '›',
                        style: TextStyle(
                          color: sepColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                        child: Text(
                          '›',
                          style: TextStyle(
                            color: sepColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
              // Detail category chip row
              if (detailCategories.isNotEmpty) ...[
                const SizedBox(height: 10),
                AuroraDetailChipRow(
                  labels: detailCategories,
                  selected: selectedDetail,
                  onSelected: onDetailSelected,
                ),
              ],
              // Sort + Filter
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: AuroraGlassActionButton(
                        icon: FontAwesomeIcons.sliders,
                        label: 'FILTER',
                        badgeCount: filterCount,
                        onTap: onFilter,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AuroraGlassActionButton(
                        icon: sortOption.icon,
                        label: 'SORT · ${sortOption.buttonLabel}',
                        onTap: onSort,
                      ),
                    ),
                  ],
                ),
              ),
              // Result count
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 9, 16, 10),
                child: Text(
                  '$productCount items',
                  style: AppTextStyles.captionSmall.copyWith(
                    color: mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Divider
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                color: dividerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Empty state ─────────────────────────────────────────────────────────────

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
