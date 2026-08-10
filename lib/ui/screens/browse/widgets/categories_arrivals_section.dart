import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../backend_integration/apis/categories_api.dart';
import '../../../../backend_integration/apis/items_api.dart';
import '../../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../../backend_integration/dtos/category/category_dto.dart';
import '../../../../backend_integration/dtos/item/item_list_item_dto.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_gradient_text.dart';
import '../../../reusable_components/category_pill/aurora_category_l1_pill.dart';
import '../../../reusable_components/product_card/product_grid_card.dart';
import '../../../reusable_components/refresh/refresh_scope.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

const _take = 6;

class CategoriesArrivalsSection extends StatefulWidget {
  final ScrollController scrollController;
  const CategoriesArrivalsSection({super.key, required this.scrollController});

  @override
  State<CategoriesArrivalsSection> createState() =>
      _CategoriesArrivalsSectionState();
}

class _CategoriesArrivalsSectionState extends State<CategoriesArrivalsSection>
    with AutoRefreshMixin {
  List<CategoryDto>? _categories; // null = loading
  int? _selectedCategoryId;

  final List<ItemListItemDto> _items = [];
  bool _isLoadingItems = false;
  bool _isLastPage = false;
  int _skip = 0;

  bool _categoriesError = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    _fetchCategories();
  }

  @override
  void didUpdateWidget(CategoriesArrivalsSection old) {
    super.didUpdateWidget(old);
    if (old.scrollController != widget.scrollController) {
      old.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Future<void> onRefresh() async {
    await _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() { _categories = null; _categoriesError = false; });
    final result = await serviceLocator<CategoriesApi>().getCategories();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _categoriesError = true),
      (cats) {
        setState(() => _categories = cats);
        if (cats.isNotEmpty) {
          _selectedCategoryId = cats.first.id;
          _fetchItems(reset: true);
        }
      },
    );
  }

  Future<void> _fetchItems({bool reset = false}) async {
    if (_isLoadingItems) return;
    if (!reset && _isLastPage) return;

    if (reset) {
      setState(() {
        _items.clear();
        _skip = 0;
        _isLastPage = false;
      });
    }

    setState(() => _isLoadingItems = true);

    final result = await serviceLocator<ItemsApi>().getItems(
      mainCategoryId: _selectedCategoryId,
      skip: _skip,
      take: _take,
    );

    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoadingItems = false),
      (page) => setState(() {
        _items.addAll(page.items);
        _isLastPage = page.isLastPage;
        _skip += page.items.length;
        _isLoadingItems = false;
      }),
    );
  }

  void _onScroll() {
    final sc = widget.scrollController;
    if (!sc.hasClients) return;
    if (sc.offset >= sc.position.maxScrollExtent - 300 &&
        !_isLoadingItems &&
        !_isLastPage) {
      _fetchItems();
    }
  }

  void _onCategorySelected(int categoryId) {
    if (categoryId == _selectedCategoryId) return;
    setState(() => _selectedCategoryId = categoryId);
    _fetchItems(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AuroraGradientText(
              'categories_arrivals_section.new_arrivals'.tr(),
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _buildPillRow(),
          const SizedBox(height: 12),
          _buildGrid(),
          if (_isLoadingItems && _items.isNotEmpty) _LoadingIndicator(),
          if (_isLastPage && _items.isNotEmpty) _EndOfFeedLabel(),
        ],
      ),
    );
  }

  Widget _buildPillRow() {
    final cats = _categories;

    if (_categoriesError) return const SizedBox.shrink();

    // Skeleton pills while loading
    if (cats == null) {
      return SizedBox(
        height: 32,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, _) => SizedBox(
            width: 72,
            child: SkeletonShimmer(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      );
    }

    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cats.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => AuroraCategoryL1Pill(
          label: cats[i].name,
          isSelected: cats[i].id == _selectedCategoryId,
          onTap: () => _onCategorySelected(cats[i].id),
          disabledStyleWhenUnselected: true,
        ),
      ),
    );
  }

  Widget _buildGrid() {
    // Initial load skeleton
    if (_items.isEmpty && _isLoadingItems) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.70,
          ),
          itemCount: 6,
          itemBuilder: (_, _) => const _ItemCardSkeleton(),
        ),
      );
    }

    if (_items.isEmpty && !_isLoadingItems) {
      return ListenableBuilder(
        listenable: ThemeService.instance,
        builder: (context, _) {
          final isDark = ThemeService.instance.isDarkMode;
          final color = isDark
              ? AppColors.white.withValues(alpha: 0.4)
              : AppColors.auroraPurple.withValues(alpha: 0.5);
          return SizedBox(
            height: 160,
            child: Center(
              child: Text(
                'categories_arrivals_section.no_items_in_category'.tr(),
                style: AppTextStyles.caption.copyWith(color: color),
              ),
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.70,
        ),
        itemCount: _items.length,
        itemBuilder: (_, i) => ProductGridCard(item: _items[i]),
      ),
    );
  }
}

// ─── Skeleton card ────────────────────────────────────────────────────────────

class _ItemCardSkeleton extends StatelessWidget {
  const _ItemCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.auroraPurple.withValues(alpha: 0.10);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: SkeletonShimmer(borderRadius: BorderRadius.circular(11)),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 7, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10, width: 80, child: SkeletonShimmer(borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 4),
                    SizedBox(height: 9, width: 55, child: SkeletonShimmer(borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 5),
                    SizedBox(height: 10, width: 45, child: SkeletonShimmer(borderRadius: BorderRadius.circular(2))),
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

// ─── Loading indicator ───────────────────────────────────────────────────────

class _LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
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
    );
  }
}

// ─── End of feed label ───────────────────────────────────────────────────────

class _EndOfFeedLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final color = isDark
            ? AppColors.white.withValues(alpha: 0.25)
            : AppColors.auroraPurple.withValues(alpha: 0.35);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              'categories_arrivals_section.all_caught_up'.tr(),
              style: AppTextStyles.captionSmall.copyWith(
                color: color,
                letterSpacing: 0.8,
              ),
            ),
          ),
        );
      },
    );
  }
}
