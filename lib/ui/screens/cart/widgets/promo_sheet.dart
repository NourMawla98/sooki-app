import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../services/cart_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '_cart_surface_theme.dart';

Future<void> showPromoSheet(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: const _PromoSheet(),
    ),
  );
}

class _PromoSheet extends StatefulWidget {
  const _PromoSheet();

  @override
  State<_PromoSheet> createState() => _PromoSheetState();
}

class _PromoSheetState extends State<_PromoSheet> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final cart = GetIt.instance<CartService>();
    final ok = cart.applyPromo(_controller.text);
    if (ok) {
      Navigator.of(context).pop();
    } else {
      setState(() => _error = 'promo_sheet.invalid_code'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final c = CartSurfaceColors.of(
          isDark: ThemeService.instance.isDarkMode,
        );
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            decoration: BoxDecoration(
              color: c.sheet,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: c.sheetTop, width: 1),
            ),
            padding: const EdgeInsetsDirectional.fromSTEB(18, 20, 18, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'promo_sheet.promo_code'.tr(),
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: AppColors.auroraPink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'promo_sheet.enter_your_code'.tr(),
                  style: AppTextStyles.heading3.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: c.text,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: c.chipFill,
                          border: Border.all(
                            color: _error != null
                                ? AppColors.auroraPink
                                : c.chipBorder,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _controller,
                          onChanged: (_) {
                            if (_error != null) {
                              setState(() => _error = null);
                            }
                          },
                          onSubmitted: (_) => _submit(),
                          textCapitalization: TextCapitalization.characters,
                          textAlignVertical: TextAlignVertical.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: c.text,
                            letterSpacing: 1,
                          ),
                          decoration: InputDecoration(
                            hintText: 'promo_sheet.code_hint'.tr(),
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 14,
                              color: c.textMute2,
                              letterSpacing: 1,
                            ),
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            filled: false,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _submit,
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.auroraCartButtonGradient,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'promo_sheet.apply'.tr(),
                          style: AppTextStyles.buttonSmall.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.auroraPink,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
