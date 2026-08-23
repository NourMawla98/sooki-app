import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
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
import 'widgets/payment_method_picker.dart';
import 'widgets/promo_row.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback? onSwitchToBrowse;

  /// Whether the cart tab is the one on screen. The tab shell keeps every tab
  /// mounted, so this is how the screen learns it has regained focus.
  final bool isActive;

  const CartScreen({super.key, this.onSwitchToBrowse, this.isActive = true});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cart = GetIt.instance<CartService>();

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());
  }

  @override
  void didUpdateWidget(CartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The shell parks inactive tabs behind an Offstage instead of disposing
    // them, so initState runs once for the life of the shell. Without this a
    // row added anywhere else stays invisible until the whole screen rebuilds.
    if (widget.isActive && !oldWidget.isActive) unawaited(_refresh());
  }

  /// The one loader for this screen. Entry, tab focus and pull to refresh all
  /// go through it, so none of them can drift out of step with the others.
  Future<void> _refresh() async {
    await _cart.loadFromServer();
    await _cart.refreshDeliveryFee(force: true);
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
                      onRefresh: _refresh,
                      color: AppColors.auroraPink,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          14,
                          12,
                          14,
                          8,
                        ),
                        children: [
                          ...items.map(
                            (item) => CartItemCard(
                              item: item,
                              onTap: () => Navigator.pushNamed(
                                context,
                                itemDetailsScreenRoute,
                                arguments: item.itemId,
                              ),
                              onQuantityChanged: (newQty) =>
                                  _cart.updateQuantity(item.id, newQty),
                              onRemove: () async {
                                final confirmed = await showAuroraConfirmSheet(
                                  context,
                                  title: 'cart_screen.remove_item_title'.tr(),
                                  // Two colours of one product make two rows
                                  // with the same title, so the variant is
                                  // what tells the shopper which one goes.
                                  subtitle: 'cart_screen.remove_item_subtitle'
                                      .tr(
                                        namedArgs: {
                                          'title': item.title,
                                          'color': item.colorName,
                                          'size': item.sizeName,
                                        },
                                      ),
                                  icon: FontAwesomeIcons.trashCan,
                                  iconColor: AppColors.auroraRed,
                                  confirmLabel: 'cart_screen.remove'.tr(),
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
                          const PaymentMethodPicker(),
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

        final bgColor = isDark
            ? AppColors.auroraDeepBase
            : AppColors.auroraLightBase;

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
