import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../services/cart_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../services/toast_service.dart';
import '../../../../themes/themes.dart';

class StickyBottomBar extends StatelessWidget {
  const StickyBottomBar({
    super.key,
    required this.itemId,
    required this.itemTitle,
    this.mainImageUrl,
    this.selectedColorName,
    this.selectedSizeValueId,
    this.selectedSizeName,
    required this.unitPrice,
    required this.quantity,
    required this.hasSizes,
  });

  final int itemId;
  final String itemTitle;
  final String? mainImageUrl;
  final String? selectedColorName;
  final int? selectedSizeValueId;
  final String? selectedSizeName;
  final double unitPrice;
  final int quantity;
  final bool hasSizes;

  bool get _requiresSize => hasSizes;
  bool get _isEnabled => !_requiresSize || selectedSizeValueId != null;

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
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
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
                    _requiresSize && selectedSizeValueId == null
                        ? 'common.select_a_size'.tr()
                        : 'common.add_to_cart'.tr(),
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

  Future<void> _addToCart() async {
    final cart = GetIt.instance<CartService>();
    final msg = await cart.addToCart(
      sizeValueId: selectedSizeValueId,
      itemId: itemId,
      itemTitle: itemTitle,
      mainImageUrl: mainImageUrl,
      colorName: selectedColorName ?? '',
      sizeName: selectedSizeName ?? '',
      unitPrice: unitPrice,
      quantity: quantity,
    );
    if (msg != null && msg.isNotEmpty) {
      ToastService.instance.showSuccess(msg);
    }
  }
}
