import 'package:flutter/material.dart';

import '../../../../data/mock_products.dart';
import '../../../../models/product.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_gradient_text.dart';
import '../../../reusable_components/category_pill/aurora_category_l1_pill.dart';
import '../../../reusable_components/product_card/product_grid_card.dart';

const _pageSize = 6;

class CategoriesArrivalsSection extends StatefulWidget {
  final ScrollController scrollController;
  const CategoriesArrivalsSection({super.key, required this.scrollController});

  @override
  State<CategoriesArrivalsSection> createState() =>
      _CategoriesArrivalsSectionState();
}

class _CategoriesArrivalsSectionState
    extends State<CategoriesArrivalsSection> {
  static const _categories = <String>[
    'All',
    'Dresses',
    'Tops',
    'Shoes',
    'Accessories',
  ];

  String _selectedCategory = 'All';
  final List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 0;

  List<Product> get _basePool {
    if (_selectedCategory == 'All') return mockBrowseProducts;
    return mockBrowseProducts
        .where((p) => p.subCategory == _selectedCategory)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadPage();
    widget.scrollController.addListener(_onScroll);
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

  void _onScroll() {
    final sc = widget.scrollController;
    if (!sc.hasClients) return;
    final threshold = sc.position.maxScrollExtent - 200;
    if (sc.offset >= threshold && !_isLoading && _hasMore) {
      _loadPage();
    }
  }

  void _onCategoryChanged(String cat) {
    if (cat == _selectedCategory) return;
    setState(() {
      _selectedCategory = cat;
      _products.clear();
      _page = 0;
      _hasMore = true;
      _isLoading = false;
    });
    _loadPage();
  }

  Future<void> _loadPage() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final pool = _basePool;
    if (pool.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
      return;
    }

    // Cycle through pool to mock pagination endlessly (up to 5 pages)
    final maxPages = 5;
    if (_page >= maxPages) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
      return;
    }

    final start = (_page * _pageSize) % pool.length;
    final newItems = List.generate(
      _pageSize,
      (i) => pool[(start + i) % pool.length],
    );

    setState(() {
      _products.addAll(newItems);
      _page++;
      _isLoading = false;
      _hasMore = _page < maxPages;
    });
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
          _CategoryPillRow(
            categories: _categories,
            selected: _selectedCategory,
            onSelected: _onCategoryChanged,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildGrid(),
          ),
          if (_isLoading) _LoadingIndicator(),
          if (!_hasMore && _products.isNotEmpty) _EndOfFeedLabel(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    if (_products.isEmpty && !_isLoading) {
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: _products.length,
      itemBuilder: (_, i) => ProductGridCard(product: _products[i]),
    );
  }
}

// ─── Loading indicator ───────────────────────────────────────────────────────

class _LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
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

// ─── Category pills ──────────────────────────────────────────────────────────

class _CategoryPillRow extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoryPillRow({
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
          label: categories[i],
          isSelected: categories[i] == selected,
          onTap: () => onSelected(categories[i]),
        ),
      ),
    );
  }
}
