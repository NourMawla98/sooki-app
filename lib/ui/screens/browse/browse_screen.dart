import 'package:flutter/material.dart';

import '../../../data/mock_products.dart';
import '../../../models/product.dart';
import '../../reusable_components/category_tabs/category_pill_bar.dart';
import 'widgets/browse_banner_section.dart';
import 'widgets/flash_deals_section.dart';
import 'widgets/new_arrivals_section.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = const [
    'All',
    'Dresses',
    'Tops',
    'Shoes',
    'Accessories',
    'Sale',
  ];

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'All') return mockBrowseProducts;
    return mockBrowseProducts
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner carousel (edge-to-edge, no top padding)
            const BrowseBannerSection(),

            const SizedBox(height: 20),

            // Flash deals section
            const FlashDealsSection(),

            const SizedBox(height: 24),

            // Category filter pills
            CategoryPillBar(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() => _selectedCategory = category);
              },
            ),

            const SizedBox(height: 16),

            // New arrivals product grid
            NewArrivalsSection(
              products: _filteredProducts,
              selectedCategory: _selectedCategory,
            ),

            const SizedBox(height: 100), // bottom padding for nav bar
          ],
        ),
      ),
    );
  }
}
