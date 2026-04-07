import 'package:flutter/material.dart';

import '../../../../services/cart_service.dart';
import '../../../../themes/themes.dart';
import '../../../reusable_components/buttons/primary_button.dart';

class CartSummary extends StatelessWidget {
  final CartService cartService;
  final VoidCallback onCheckout;

  const CartSummary({
    super.key,
    required this.cartService,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = cartService.subtotal;
    final shipping = cartService.shippingCost;
    final total = cartService.total;
    final freeShipping = shipping == 0;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtotal
            _buildRow(
              'Subtotal',
              '\$${subtotal.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            // Shipping
            _buildRow(
              'Shipping',
              freeShipping ? 'Free' : '\$${shipping.toStringAsFixed(2)}',
              valueColor: freeShipping ? AppColors.accentGreen : null,
            ),
            if (freeShipping) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Free shipping on orders over \$50!',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accentGreen,
                  ),
                ),
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: AppColors.borderLight),
            ),
            // Total
            _buildRow(
              'Total',
              '\$${total.toStringAsFixed(2)}',
              labelStyle: AppTextStyles.heading4,
              valueStyle: AppTextStyles.heading3,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Proceed to Checkout',
              onPressed: onCheckout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle ?? AppTextStyles.bodyMedium),
        Text(
          value,
          style: (valueStyle ?? AppTextStyles.bodyMedium).copyWith(
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
