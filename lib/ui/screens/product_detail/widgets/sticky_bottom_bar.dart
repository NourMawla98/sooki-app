import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../models/product.dart';
import '../../../../services/cart_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../services/toast_service.dart';
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

  bool get _requiresSize => product.sizes.isNotEmpty;
  bool get _isEnabled => !_requiresSize || selectedSize != null;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final bg =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final divider = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.primaryPurple.withValues(alpha: 0.12);

        return Container(
          decoration: BoxDecoration(
            color: bg,
            border: Border(top: BorderSide(color: divider)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: GestureDetector(
            onTap: _isEnabled ? () => _addToCart() : null,
            behavior: HitTestBehavior.opaque,
            child: Opacity(
              opacity: _isEnabled ? 1.0 : 0.45,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.auroraPink,
                      AppColors.auroraPurple,
                      AppColors.auroraElectricBlue,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _isEnabled
                      ? [
                          BoxShadow(
                            color: AppColors.auroraPurple
                                .withValues(alpha: 0.40),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    _requiresSize && selectedSize == null
                        ? 'SELECT A SIZE'
                        : 'ADD TO CART',
                    style: AppFonts.primary(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      letterSpacing: 2.0,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addToCart() {
    final cartService = GetIt.instance<CartService>();
    cartService.addItem(
      product,
      color: selectedColor,
      size: selectedSize,
      quantity: quantity,
    );
    ToastService.instance.showSuccess('${product.name} added to cart');
  }
}
