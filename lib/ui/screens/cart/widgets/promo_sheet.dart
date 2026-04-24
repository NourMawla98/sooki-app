import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../services/cart_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '_cart_surface_theme.dart';

Future<void> showPromoSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _PromoSheet(),
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
      setState(() => _error = 'Invalid code');
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              border: Border(top: BorderSide(color: c.sheetTop, width: 1)),
            ),
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: c.textMute3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'PROMO CODE',
                  style: AppTextStyles.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: AppColors.auroraPink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter your code',
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
                            hintText: 'e.g. AURORA20',
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
                          'APPLY',
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
