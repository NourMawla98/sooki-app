import 'package:flutter/material.dart';

import '../../../../backend_integration/apis/categories_api.dart';
import '../../../../backend_integration/apis/items_api.dart';
import '../../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../../backend_integration/dtos/category/category_dto.dart';
import '../../../../backend_integration/dtos/item/item_list_item_dto.dart';
import '../../../../routes/route_constants.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_gradient_text.dart';
import '../../../reusable_components/category_pill/aurora_category_l1_pill.dart';
import '../../../reusable_components/refresh/refresh_scope.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';

const _take = 20;

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
              'New Arrivals',
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
                'No items in this category yet',
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
        itemBuilder: (_, i) => _NewArrivalCard(item: _items[i]),
      ),
    );
  }
}

// ─── Item card ────────────────────────────────────────────────────────────────

class _NewArrivalCard extends StatelessWidget {
  final ItemListItemDto item;
  const _NewArrivalCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final cardBg = isDark ? AppColors.white.withValues(alpha: 0.04) : AppColors.white;
        final shadow = isDark
            ? null
            : [BoxShadow(color: AppColors.shadowMedium, blurRadius: 8, offset: const Offset(0, 2))];
        final border = isDark
            ? Border.all(color: AppColors.white.withValues(alpha: 0.08))
            : Border.all(color: AppColors.auroraPurple.withValues(alpha: 0.10));
        final nameColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final storeColor = isDark
            ? AppColors.white.withValues(alpha: 0.45)
            : AppColors.auroraPurple.withValues(alpha: 0.50);
        final priceColor = isDark ? AppColors.auroraElectricBlue : AppColors.auroraPurple;
        final origColor = isDark
            ? AppColors.white.withValues(alpha: 0.35)
            : AppColors.auroraPurple.withValues(alpha: 0.40);

        final thumbnail = item.colorImages.isNotEmpty ? item.colorImages.first : null;
        final hasDiscount = item.discountedPrice != null;

        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            itemDetailsScreenRoute,
            arguments: item.id,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: border,
              boxShadow: shadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (thumbnail != null)
                          Image.network(
                            thumbnail,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, progress) =>
                                progress == null ? child : const SkeletonShimmer(),
                            errorBuilder: (_, _, _) => _placeholder(),
                          )
                        else
                          _placeholder(),
                        if (hasDiscount)
                          Positioned(
                            top: 8, left: 8,
                            child: _DiscountBadge(
                              original: item.originalPrice,
                              discounted: item.discountedPrice!,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(9, 8, 9, 9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.productName.copyWith(
                            color: nameColor,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.storeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: storeColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _fmt(hasDiscount ? item.discountedPrice! : item.originalPrice),
                              style: AppTextStyles.productPrice.copyWith(
                                color: priceColor,
                                fontSize: 13,
                              ),
                            ),
                            if (hasDiscount) ...[
                              const SizedBox(width: 5),
                              Text(
                                _fmt(item.originalPrice),
                                style: AppTextStyles.productPrice.copyWith(
                                  color: origColor,
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _placeholder() => Container(
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
      );

  String _fmt(double p) {
    final hasDecimals = p.truncateToDouble() != p;
    return '\$${p.toStringAsFixed(hasDecimals ? 2 : 0)}';
  }
}

class _DiscountBadge extends StatelessWidget {
  final double original;
  final double discounted;
  const _DiscountBadge({required this.original, required this.discounted});

  @override
  Widget build(BuildContext context) {
    final pct = ((1 - discounted / original) * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.auroraRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '-$pct%',
        style: AppTextStyles.badgeText.copyWith(
          color: AppColors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          height: 1.0,
        ),
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
                padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
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
              '— You\'re all caught up —',
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
