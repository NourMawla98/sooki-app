import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/mock_products.dart';
import '../../../models/product.dart';
import '../../../routes/route_constants.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  String _selectedCategory = 'All';
  String _sortBy = 'Popular';

  List<Product> get _allProducts => [
        ...mockBrowseProducts,
        ...mockDealProducts,
      ];

  List<Product> get _filteredProducts {
    var products = _allProducts;
    if (_selectedCategory != 'All') {
      products =
          products.where((p) => p.category == _selectedCategory).toList();
    }
    switch (_sortBy) {
      case 'Price: Low':
        products.sort((a, b) => a.price.compareTo(b.price));
      case 'Price: High':
        products.sort((a, b) => b.price.compareTo(a.price));
      case 'Rating':
        products.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return products;
  }

  List<String> get _categories {
    final cats = _allProducts.map((p) => p.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Filter bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                // Category chips
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryPurple
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryPurple
                                  : AppColors.gray200,
                            ),
                          ),
                          child: Text(
                            cat,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Results count + sort
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${products.length} products',
                      style: AppTextStyles.bodySmall,
                    ),
                    PopupMenuButton<String>(
                      onSelected: (v) => setState(() => _sortBy = v),
                      itemBuilder: (_) => [
                        'Popular',
                        'Price: Low',
                        'Price: High',
                        'Rating',
                      ]
                          .map((s) => PopupMenuItem(
                                value: s,
                                child: Text(
                                  s,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: _sortBy == s
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ))
                          .toList(),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.arrowDownWideShort,
                            size: 14,
                            color: AppColors.primaryPurple,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _sortBy,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Product grid
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.boxOpen,
                          size: 48,
                          color: AppColors.gray300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.gray400,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _ShopProductCard(product: product);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ShopProductCard extends StatelessWidget {
  const _ShopProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        productDetailScreenRoute,
        arguments: product,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.asset(
                        product.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (product.discountPercentage != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentRed,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${product.discountPercentage!.toInt()}%',
                          style: AppTextStyles.badgeTextSmall,
                        ),
                      ),
                    ),
                  if (product.isNew)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'NEW',
                          style: AppTextStyles.badgeTextSmall.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.brand,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        if (product.rating > 0) ...[
                          FaIcon(
                            FontAwesomeIcons.solidStar,
                            size: 10,
                            color: AppColors.accentYellow,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: AppTextStyles.captionSmall,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.productPrice.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '\$${product.originalPrice!.toStringAsFixed(0)}',
                            style: AppTextStyles.productOriginalPrice,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
