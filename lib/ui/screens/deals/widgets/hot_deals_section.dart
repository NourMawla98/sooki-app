import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../data/mock_products.dart';
import '../../../../models/product.dart';
import '../../../../routes/route_constants.dart';
import '../../../../themes/themes.dart';
import '../../../reusable_components/product_card/product_card.dart';

class HotDealsSection extends StatefulWidget {
  const HotDealsSection({super.key});

  @override
  State<HotDealsSection> createState() => _HotDealsSectionState();
}

class _HotDealsSectionState extends State<HotDealsSection> {
  bool _sortAscending = true;
  late List<Product> _products;

  @override
  void initState() {
    super.initState();
    _products = List<Product>.from(mockDealProducts);
    _sortProducts();
  }

  void _sortProducts() {
    _products.sort((a, b) => _sortAscending
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price));
  }

  void _toggleSort() {
    setState(() {
      _sortAscending = !_sortAscending;
      _sortProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Hot Deals 🔥',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(width: 8),
              Text(
                '${_products.length} items',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.gray400),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _toggleSort,
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.sliders,
                      size: 16,
                      color: AppColors.primaryPurple,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Sort',
                      style: AppTextStyles.buttonSmall
                          .copyWith(color: AppColors.primaryPurple),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Product grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.58,
            ),
            itemBuilder: (context, index) {
              final product = _products[index];
              return ProductCard(
                product: product,
                showStock: true,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    productDetailScreenRoute,
                    arguments: product,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
