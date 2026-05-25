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

class CartScreen extends StatefulWidget {
  final VoidCallback? onSwitchToBrowse;

  const CartScreen({super.key, this.onSwitchToBrowse});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cart = GetIt.instance<CartService>();

  @override
  void initState() {
    super.initState();
    _cart.loadFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_cart, ThemeService.instance]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final items = _cart.displayItems;
        final Widget content = items.isEmpty
            ? const CartEmptyState()
            : Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => _cart.loadFromServer(),
                      color: AppColors.auroraPink,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                        children: [
                          ...items.map(
                            (item) => CartItemCard(
                              item: item,
                              onQuantityChanged: (newQty) =>
                                  _cart.updateQuantity(item.id, newQty),
                              onRemove: () async {
                                final confirmed = await showAuroraConfirmSheet(
                                  context,
                                  title: 'Remove item?',
                                  subtitle: item.title,
                                  icon: FontAwesomeIcons.trashCan,
                                  iconColor: AppColors.auroraRed,
                                  confirmLabel: 'Remove',
                                  confirmColor: AppColors.auroraRed,
                                );
                                if (confirmed) {
                                  final msg = await _cart.removeItem(item.id);
                                  if (msg != null && msg.isNotEmpty) {
                                    ToastService.instance.showSuccess(msg);
                                  }
                                }
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
                  ),
                  CartSummary(
                    cartService: _cart,
                    onCheckout: () => _showCheckoutGate(context),
                  ),
                ],
              );

        final bgColor =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;

        return Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: bgColor)),
            const Positioned.fill(child: CartBackground()),
            Positioned.fill(child: content),
          ],
        );
      },
    );
  }

  void _showCheckoutGate(BuildContext context) {
    final isCustomer = GetIt.instance<AuthService>().isCustomer;
    if (isCustomer) {
      Navigator.pushNamed(context, checkoutScreenRoute);
    } else {
      showAuroraLoginGate(context);
    }
  }
}
