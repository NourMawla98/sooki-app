import 'package:flutter/material.dart';

import '../../../themes/themes.dart';

/// A compact product card for the flash deals section.
///
/// Displays a product image, sale price, original price,
/// and remaining stock count in a fixed-width card.
class FlashDealCard extends StatelessWidget {
  final String imageUrl;
  final double salePrice;
  final double originalPrice;
  final int stockLeft;
  final VoidCallback? onTap;

  const FlashDealCard({
    super.key,
    required this.imageUrl,
    required this.salePrice,
    required this.originalPrice,
    required this.stockLeft,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.infinity,
                height: 112,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.gray200,
                    child: Center(
                      child: FittedBox(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.gray400,
                        ),
                      ),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(color: AppColors.gray200);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Price row
            Row(
              children: [
                Text(
                  '\$${salePrice.toStringAsFixed(0)}',
                  style: AppTextStyles.productPrice.copyWith(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  '\$${originalPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.productOriginalPrice,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Stock count
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$stockLeft left',
                style: AppTextStyles.productStock,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
