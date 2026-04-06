import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../../models/product.dart';
import '../../../../services/cart_service.dart';
import '../../../../services/wishlist_service.dart';
import '../../../../themes/themes.dart';

class StickyBottomBar extends StatelessWidget {
  final Product product;
  final SizeVariant? selectedSize;
  final ColorVariant? selectedColor;
  final int quantity;

  const StickyBottomBar({
    super.key,
    required this.product,
    this.selectedSize,
    this.selectedColor,
    this.quantity = 1,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistService = GetIt.instance<WishlistService>();
    final cartService = GetIt.instance<CartService>();
    final isEnabled = selectedSize != null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          ListenableBuilder(
            listenable: wishlistService,
            builder: (context, _) {
              final isWishlisted = wishlistService.isWishlisted(product.id);
              return GestureDetector(
                onTap: () => wishlistService.toggle(product.id),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.gray300,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: FaIcon(
                      isWishlisted
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: isWishlisted
                          ? AppColors.accentRed
                          : AppColors.gray400,
                      size: 20,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: isEnabled
                  ? () {
                      cartService.addItem(
                        product,
                        color: selectedColor,
                        size: selectedSize,
                        quantity: quantity,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart!')),
                      );
                    }
                  : null,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppColors.primaryPurple
                      : AppColors.gray300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Add to Cart',
                    style: AppTextStyles.buttonLarge,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
