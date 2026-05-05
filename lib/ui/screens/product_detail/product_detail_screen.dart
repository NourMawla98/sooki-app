import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../data/mock_products.dart';
import '../../../models/product.dart';
import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../services/wishlist_service.dart';
import '../../../themes/themes.dart';
import '../image_viewer/image_viewer_screen.dart';
import 'widgets/color_selector.dart';
import 'widgets/image_gallery.dart';
import 'widgets/price_quantity_row.dart';
import 'widgets/product_info.dart';
import 'widgets/product_tabs.dart';
import 'widgets/size_guide_sheet.dart';
import 'widgets/size_selector.dart';
import 'widgets/sticky_bottom_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final WishlistService _wishlist = GetIt.instance<WishlistService>();
  final GlobalKey<ImageGalleryState> _galleryKey = GlobalKey();

  ColorVariant? _selectedColor;
  SizeVariant? _selectedSize;
  int _quantity = 1;

  late List<String> _masterImages;
  late Map<String, int> _colorFirstIndex;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _buildMasterImages();

    final availableColors =
        widget.product.colors.where((c) => c.isAvailable).toList();
    if (availableColors.isNotEmpty) {
      _selectedColor = availableColors.first;
    }
  }

  void _buildMasterImages() {
    final images = <String>[];
    final colorIndex = <String, int>{};

    for (final color in widget.product.colors) {
      final urls = color.imageUrls;
      if (urls != null && urls.isNotEmpty) {
        colorIndex[color.name] = images.length;
        images.addAll(urls);
      }
    }

    if (images.isEmpty) {
      _masterImages = List.of(widget.product.imageUrls);
      _colorFirstIndex = const {};
    } else {
      _masterImages = images;
      _colorFirstIndex = colorIndex;
    }
  }

  ColorVariant? _colorForImageIndex(int index) {
    ColorVariant? owner;
    var bestStart = -1;
    for (final color in widget.product.colors) {
      final start = _colorFirstIndex[color.name];
      if (start == null) continue;
      if (start <= index && start > bestStart) {
        bestStart = start;
        owner = color;
      }
    }
    return owner;
  }

  void _onColorSelected(ColorVariant color) {
    setState(() => _selectedColor = color);
    final target = _colorFirstIndex[color.name];
    if (target != null) {
      _galleryKey.currentState?.jumpToIndex(target);
    }
  }

  void _onGalleryIndexChanged(int index) {
    final owner = _colorForImageIndex(index);
    if (owner == null || owner == _selectedColor) return;
    if (!owner.isAvailable) return;
    setState(() => _selectedColor = owner);
  }

  void _showSizeGuide() {
    SizeGuideSheet.show(context, selectedLabel: _selectedSize?.label);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService.instance, _wishlist]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bgColor =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final isWishlisted = _wishlist.isWishlisted(widget.product.id);

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _HeaderIcon(
                        icon: FontAwesomeIcons.arrowLeft,
                        isDark: isDark,
                        onTap: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          _HeaderIcon(
                            icon: FontAwesomeIcons.shareNodes,
                            isDark: isDark,
                            onTap: () {},
                          ),
                          _HeaderIcon(
                            icon: isWishlisted
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            isDark: isDark,
                            activeColor: AppColors.auroraRed,
                            onTap: () =>
                                _wishlist.toggle(widget.product.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    color: AppColors.auroraPink,
                    child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageGallery(
                          key: _galleryKey,
                          imageUrls: _masterImages,
                          isVerified: widget.product.isVerified,
                          discountPercentage:
                              widget.product.discountPercentage,
                          onIndexChanged: _onGalleryIndexChanged,
                          onHeroTap: (index) => Navigator.pushNamed(
                            context,
                            imageViewerScreenRoute,
                            arguments: ImageViewerArgs(
                              imageUrls: _masterImages,
                              initialIndex: index,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: ProductInfo(product: widget.product),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: PriceQuantityRow(
                            unitPrice: widget.product.price,
                            originalUnitPrice: widget.product.originalPrice,
                            quantity: _quantity,
                            maxQuantity: widget.product.stockCount,
                            onQuantityChanged: (q) =>
                                setState(() => _quantity = q),
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (widget.product.colors.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: ColorSelector(
                              colors: widget.product.colors,
                              selected: _selectedColor,
                              onSelected: _onColorSelected,
                            ),
                          ),
                        if (widget.product.colors.isNotEmpty)
                          const SizedBox(height: 18),
                        if (widget.product.sizes.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: SizeSelector(
                              sizes: widget.product.sizes,
                              selected: _selectedSize,
                              onSelected: (size) =>
                                  setState(() => _selectedSize = size),
                              onSizeGuide: _showSizeGuide,
                            ),
                          ),
                        if (widget.product.sizes.isNotEmpty)
                          const SizedBox(height: 18),
                        ProductTabs(
                          product: widget.product,
                          reviews: mockReviews,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    ),
                  ),
                ),
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
      },
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.isDark,
    this.onTap,
    this.activeColor,
  });

  final FaIconData icon;
  final bool isDark;
  final VoidCallback? onTap;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final glyph = activeColor ??
        (isDark ? AppColors.white : AppColors.auroraPurple);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: FaIcon(icon, size: 20, color: glyph),
        ),
      ),
    );
  }
}
