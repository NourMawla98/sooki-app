import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/cart_service.dart';
import '../../../../themes/themes.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  Widget _buildThumbnail() {
    final url = item.product.thumbnailUrl;
    final image = url.startsWith('http')
        ? Image.network(url, fit: BoxFit.cover)
        : Image.asset(url, fit: BoxFit.cover);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(width: 80, height: 80, child: image),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasVariants =
        item.selectedColor != null || item.selectedSize != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThumbnail(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      item.product.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hasVariants) ...[
                      const SizedBox(height: 4),
                      Text(
                        [
                          if (item.selectedColor != null)
                            'Color: ${item.selectedColor!.name}',
                          if (item.selectedSize != null)
                            'Size: ${item.selectedSize!.label}',
                        ].join(' | '),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Quantity + price row
                    Row(
                      children: [
                        _QuantityControls(
                          quantity: item.quantity,
                          onChanged: onQuantityChanged,
                        ),
                        const Spacer(),
                        Text(
                          '\$${item.totalPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.productPrice,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // Remove button
              GestureDetector(
                onTap: onRemove,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: FaIcon(
                    FontAwesomeIcons.trash,
                    size: 16,
                    color: AppColors.gray400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.borderLight),
        ],
      ),
    );
  }
}

/// Compact +/- quantity controls for the cart card.
class _QuantityControls extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantityControls({
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _circleButton(
          icon: FontAwesomeIcons.minus,
          enabled: quantity > 1,
          onTap: () => onChanged(quantity - 1),
        ),
        SizedBox(
          width: 32,
          child: Center(
            child: Text('$quantity', style: AppTextStyles.bodyLarge),
          ),
        ),
        _circleButton(
          icon: FontAwesomeIcons.plus,
          enabled: true,
          onTap: () => onChanged(quantity + 1),
        ),
      ],
    );
  }

  Widget _circleButton({
    required FaIconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? AppColors.gray100 : AppColors.gray200,
        ),
        child: Center(
          child: FaIcon(
            icon,
            size: 10,
            color: enabled ? AppColors.textPrimary : AppColors.gray400,
          ),
        ),
      ),
    );
  }
}
