import 'package:flutter/material.dart';

import '../../../../data/mock_products.dart';
import '../../../../models/product.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_gradient_text.dart';
import '../../../reusable_components/category_pill/aurora_category_pill.dart';
import '../../../reusable_components/product_card/arrival_card.dart';

/// Section 7 — Categories + New Arrivals.
///
/// Horizontally scrollable category pills filter a 2-column grid of the
/// latest products. Tapping a card opens item details.
class CategoriesArrivalsSection extends StatefulWidget {
  const CategoriesArrivalsSection({super.key});

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

  List<Product> get _filteredProducts {
    final base = _selectedCategory == 'All'
        ? mockBrowseProducts
        : mockBrowseProducts
            .where((p) => p.subCategory == _selectedCategory)
            .toList();
    return base.take(6).toList();
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
            onSelected: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _ProductGrid(products: _filteredProducts),
          ),
        ],
      ),
    );
  }
}

// ─── Category pills ───────────────────────────────────────────────────────────

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
        itemBuilder: (_, i) => AuroraCategoryPill(
          label: categories[i],
          isSelected: categories[i] == selected,
          onTap: () => onSelected(categories[i]),
        ),
      ),
    );
  }
}

// ─── Product grid ─────────────────────────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  final List<Product> products;
  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return ListenableBuilder(
        listenable: ThemeService.instance,
        builder: (context, _) {
          final isDark = ThemeService.instance.isDarkMode;
          final emptyText = isDark
              ? AppColors.white.withValues(alpha: 0.6)
              : AppColors.primaryPurple.withValues(alpha: 0.7);
          return SizedBox(
            height: 180,
            child: Center(
              child: Text(
                'No items in this category yet',
                style: AppTextStyles.caption.copyWith(color: emptyText),
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
      itemCount: products.length,
      itemBuilder: (_, i) => ArrivalCard(product: products[i]),
    );
  }
}
