import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../routes/route_constants.dart';
import '../../../services/cart_service.dart';
import '../../../themes/themes.dart';
import 'widgets/cart_empty_state.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/cart_summary.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onSwitchToBrowse;

  const CartScreen({super.key, this.onSwitchToBrowse});

  @override
  Widget build(BuildContext context) {
    final cartService = GetIt.instance<CartService>();

    return ListenableBuilder(
      listenable: cartService,
      builder: (context, _) {
        if (cartService.isEmpty) {
          return CartEmptyState(
            onBrowse: () => onSwitchToBrowse?.call(),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: cartService.items.length,
                itemBuilder: (context, index) {
                  final item = cartService.items[index];
                  return CartItemCard(
                    item: item,
                    onQuantityChanged: (newQty) {
                      cartService.updateQuantity(
                        item.product.id,
                        newQty,
                      );
                    },
                    onRemove: () {
                      cartService.removeItem(item.product.id);
                    },
                  );
                },
              ),
            ),
            CartSummary(
              cartService: cartService,
              onCheckout: () => _showCheckoutGate(context),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutGate(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login Required', style: AppTextStyles.heading4),
        content: Text(
          'Please log in to complete your purchase.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Continue Shopping',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, signInScreenRoute);
            },
            child: Text(
              'Log In',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
