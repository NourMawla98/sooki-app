import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/mock_products.dart';
import '../../../models/product.dart';
import '../../../routes/route_constants.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<Product> _results = [];
  bool _hasSearched = false;

  List<Product> get _allProducts => [
        ...mockBrowseProducts,
        ...mockDealProducts,
      ];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _hasSearched = q.isNotEmpty;
      if (q.isEmpty) {
        _results = [];
        return;
      }
      _results = _allProducts
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: 20,
            color: AppColors.primaryPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: AppTextStyles.bodyMedium,
          onChanged: _search,
          decoration: InputDecoration(
            hintText: 'Search for products...',
            hintStyle: AppTextStyles.inputHint,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.xmark,
                      size: 16,
                      color: AppColors.gray400,
                    ),
                    onPressed: () {
                      _controller.clear();
                      _search('');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_hasSearched) {
      return _buildSuggestions();
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 48,
              color: AppColors.gray300,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different search term',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final product = _results[index];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            productDetailScreenRoute,
            arguments: product,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    product.thumbnailUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(product.brand, style: AppTextStyles.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.productPrice.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 12,
                  color: AppColors.gray400,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestions() {
    final suggestions = ['Dresses', 'Shoes', 'Tops', 'Accessories', 'Electronics', 'Jackets'];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches',
            style: AppTextStyles.label.copyWith(
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions
                .map((s) => GestureDetector(
                      onTap: () {
                        _controller.text = s;
                        _search(s);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.gray200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: 12,
                              color: AppColors.gray400,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              s,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
