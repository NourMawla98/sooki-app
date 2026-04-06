import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../models/product.dart';
import '../../../services/wishlist_service.dart';
import '../../../themes/themes.dart';
import '../rating_stars/star_rating.dart';

/// Full product card used across Browse and Deals pages.
///
/// Displays product image with overlay badges (NEW, discount, verified),
/// a wishlist heart button, star rating, name, price, optional stock count,
/// and an "Add to Cart" button.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showStock;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showStock = false,
  });

  static final _serviceLocator = GetIt.instance;

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: AppColors.gray200,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryPurple,
              ),
            ),
          );
        },
      );
    }
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.gray200,
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.image,
          color: AppColors.gray400,
          size: 32,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistService = _serviceLocator<WishlistService>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: product.isVerified
              ? Border.all(color: AppColors.verifiedGreenBorder, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            _buildImageSection(wishlistService),

            // Info section
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the image area with overlay badges and heart button.
  Widget _buildImageSection(WishlistService wishlistService) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Product image — supports both asset paths and network URLs
            _buildProductImage(product.thumbnailUrl),

            // Top-left badge (discount takes priority over NEW)
            if (product.discountPercentage != null)
              Positioned(
                top: 8,
                left: 8,
                child: _buildPillBadge(
                  '-${product.discountPercentage}%',
                  AppColors.discountBadge,
                ),
              )
            else if (product.isNew)
              Positioned(
                top: 8,
                left: 8,
                child: _buildPillBadge('NEW', AppColors.accentGreen),
              ),

            // Bottom-left verified badge
            if (product.isVerified)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.verifiedGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.circleCheck,
                        size: 10,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 4),
                      Text('VERIFIED', style: AppTextStyles.verifiedBadge),
                    ],
                  ),
                ),
              ),

            // Top-right heart button
            Positioned(
              top: 8,
              right: 8,
              child: _buildHeartButton(wishlistService),
            ),
          ],
        ),
      ),
    );
  }

  /// Heart toggle button backed by [WishlistService].
  Widget _buildHeartButton(WishlistService wishlistService) {
    return ListenableBuilder(
      listenable: wishlistService,
      builder: (context, _) {
        final isWishlisted = wishlistService.isWishlisted(product.id);
        return GestureDetector(
          onTap: () => wishlistService.toggle(product.id),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                isWishlisted
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                size: 14,
                color:
                    isWishlisted ? AppColors.accentRed : AppColors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Small pill badge used for NEW and discount overlays.
  Widget _buildPillBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: AppTextStyles.badgeText),
    );
  }

  /// Info section below the image: rating, name, price, stock.
  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Star rating
          StarRating(rating: product.rating, size: 12, showValue: false),
          const SizedBox(height: 6),

          // Product name (with optional verified checkmark)
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: AppTextStyles.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (product.isVerified) ...[
                const SizedBox(width: 4),
                const FaIcon(
                  FontAwesomeIcons.circleCheck,
                  size: 12,
                  color: AppColors.verifiedGreen,
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),

          // Price row
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: AppTextStyles.productPrice,
              ),
              if (product.originalPrice != null) ...[
                const SizedBox(width: 6),
                Text(
                  '\$${product.originalPrice!.toStringAsFixed(2)}',
                  style: AppTextStyles.productOriginalPrice,
                ),
              ],
            ],
          ),

          // Stock count
          if (showStock && product.stockCount > 0) ...[
            const SizedBox(height: 4),
            Text(
              '${product.stockCount} left',
              style: AppTextStyles.productStock,
            ),
          ],
        ],
      ),
    );
  }
}
