import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../services/cart_service.dart';
import 'widgets/address_pill.dart';
import 'widgets/aurora_login_gate_dialog.dart';
import 'widgets/cart_background.dart';
import 'widgets/cart_empty_state.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/cart_summary.dart';
import 'widgets/cash_on_delivery_pill.dart';
import 'widgets/promo_row.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onSwitchToBrowse;

  const CartScreen({super.key, this.onSwitchToBrowse});

  @override
  Widget build(BuildContext context) {
    final cartService = GetIt.instance<CartService>();

    return ListenableBuilder(
      listenable: cartService,
      builder: (context, _) {
        final Widget content = cartService.isEmpty
            ? CartEmptyState(onBrowse: () => onSwitchToBrowse?.call())
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                      children: [
                        ...cartService.items.map(
                          (item) => CartItemCard(
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
                          ),
                        ),
                        const SizedBox(height: 4),
                        const AddressPill(),
                        const SizedBox(height: 8),
                        const PromoRow(),
                        const SizedBox(height: 8),
                        const CashOnDeliveryPill(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  CartSummary(
                    cartService: cartService,
                    onCheckout: () => _showCheckoutGate(context),
                  ),
                ],
              );

        return Stack(
          children: [
            const Positioned.fill(child: CartBackground()),
            Positioned.fill(child: content),
          ],
        );
      },
    );
  }

  void _showCheckoutGate(BuildContext context) {
    showAuroraLoginGate(context);
  }
}
