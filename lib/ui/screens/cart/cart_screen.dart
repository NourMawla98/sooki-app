import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../routes/route_constants.dart';
import '../../../services/auth_service.dart';
import '../../../services/cart_service.dart';
import '../../../services/toast_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../reusable_components/dialogs/aurora_confirm_sheet.dart';
import 'widgets/address_pill.dart';
import 'widgets/aurora_login_gate_dialog.dart';
import 'widgets/cart_background.dart';
import 'widgets/cart_empty_state.dart';
import '../../reusable_components/cart_item_card.dart';
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
      listenable: Listenable.merge([cartService, ThemeService.instance]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final Widget content = cartService.isEmpty
            ? const CartEmptyState()
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
                            onRemove: () => showAuroraConfirmSheet(
                              context,
                              title: 'Remove item?',
                              subtitle: item.product.name,
                              icon: FontAwesomeIcons.trashCan,
                              iconColor: AppColors.auroraRed,
                              confirmLabel: 'Remove',
                              confirmColor: AppColors.auroraRed,
                              onConfirm: () {
                                cartService.removeItem(item.product.id);
                                ToastService.instance.showSuccess(
                                  '${item.product.name} removed from cart',
                                );
                              },
                            ),
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

        final bgColor =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;

        return Stack(
          children: [
            // Solid opaque layer — always drawn first so nothing bleeds through
            // from screens behind this one in the tab stack.
            Positioned.fill(child: ColoredBox(color: bgColor)),
            const Positioned.fill(child: CartBackground()),
            Positioned.fill(child: content),
          ],
        );
      },
    );
  }

  void _showCheckoutGate(BuildContext context) {
    final isLoggedIn = GetIt.instance<AuthService>().isSignedIn;
    if (isLoggedIn) {
      Navigator.pushNamed(context, orderSuccessScreenRoute);
    } else {
      showAuroraLoginGate(context);
    }
  }
}
