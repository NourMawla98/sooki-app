import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/mock_products.dart';
import '../../../models/product.dart';
import '../../../themes/themes.dart';
import 'widgets/color_selector.dart';
import 'widgets/image_gallery.dart';
import 'widgets/product_info.dart';
import 'widgets/product_tabs.dart';
import 'widgets/quantity_selector.dart';
import 'widgets/size_selector.dart';
import 'widgets/sticky_bottom_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ColorVariant? _selectedColor;
  SizeVariant? _selectedSize;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // Pre-select first available color
    final availableColors =
        widget.product.colors.where((c) => c.isAvailable).toList();
    if (availableColors.isNotEmpty) {
      _selectedColor = availableColors.first;
    }
  }

  void _showSizeGuide() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Size Guide', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(8),
              ),
              children: [
                _buildTableRow(['Size', 'Chest', 'Waist', 'Hip'],
                    isHeader: true),
                _buildTableRow(['S', '34"', '28"', '36"']),
                _buildTableRow(['M', '36"', '30"', '38"']),
                _buildTableRow(['L', '38"', '32"', '40"']),
                _buildTableRow(['XL', '40"', '34"', '42"']),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader
          ? const BoxDecoration(color: AppColors.gray100)
          : null,
      children: cells
          .map((cell) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text(
                  cell,
                  style: isHeader
                      ? AppTextStyles.label
                      : AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // Share action placeholder
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.shareNodes,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageGallery(imageUrls: widget.product.imageUrls),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ProductInfo(product: widget.product),
                    ),
                    const SizedBox(height: 20),
                    if (widget.product.colors.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ColorSelector(
                          colors: widget.product.colors,
                          selected: _selectedColor,
                          onSelected: (color) =>
                              setState(() => _selectedColor = color),
                        ),
                      ),
                    if (widget.product.colors.isNotEmpty)
                      const SizedBox(height: 20),
                    if (widget.product.sizes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizeSelector(
                          sizes: widget.product.sizes,
                          selected: _selectedSize,
                          onSelected: (size) =>
                              setState(() => _selectedSize = size),
                          onSizeGuide: _showSizeGuide,
                        ),
                      ),
                    if (widget.product.sizes.isNotEmpty)
                      const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: QuantitySelector(
                        quantity: _quantity,
                        maxQuantity: widget.product.stockCount,
                        onChanged: (q) => setState(() => _quantity = q),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ProductTabs(
                      product: widget.product,
                      reviews: mockReviews,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Sticky bottom bar
            StickyBottomBar(
              product: widget.product,
              selectedSize: _selectedSize,
              selectedColor: _selectedColor,
              quantity: _quantity,
            ),
          ],
        ),
      ),
    );
  }
}
