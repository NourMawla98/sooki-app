import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../models/delivery_address.dart';
import '../../../../routes/route_constants.dart';
import '../../../../services/address_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_primary_button.dart';
import '_cart_surface_theme.dart';

Future<void> showAddressPickerSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _AddressPickerSheet(),
  );
}

class _AddressPickerSheet extends StatelessWidget {
  const _AddressPickerSheet();

  @override
  Widget build(BuildContext context) {
    final addressService = GetIt.instance<AddressService>();
    return ListenableBuilder(
      listenable: Listenable.merge([addressService, ThemeService.instance]),
      builder: (context, _) {
        final c = CartSurfaceColors.of(
          isDark: ThemeService.instance.isDarkMode,
        );
        final addresses = addressService.addresses;
        final selectedId = addressService.selectedId;

        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: c.sheet,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              border: Border(top: BorderSide(color: c.sheetTop, width: 1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
                  child: Column(
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
                        'CHOOSE ADDRESS',
                        style: AppTextStyles.label.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: AppColors.auroraPink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Where to deliver',
                        style: AppTextStyles.heading3.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: c.text,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
                    children: [
                      ...addresses.map(
                        (a) => _AddressRow(
                          addr: a,
                          selected: a.id == selectedId,
                          surfaceColors: c,
                          onTap: () async {
                            await addressService.select(a.id);
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      AuroraPrimaryButton(
                        text: '+ ADD NEW ADDRESS',
                        onPressed: () => _onAddNew(context),
                        height: 48,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddNew(BuildContext context) async {
    // TODO(auth): once AuthService lands, show the login-gate dialog first
    // for guest users and only push the form after successful sign-in.
    final navigator = Navigator.of(context);
    final result = await navigator.pushNamed(addAddressScreenRoute);
    if (result is String) {
      // The form returned a new address id. Close the picker so the cart's
      // AddressPill re-renders with the freshly selected address.
      if (navigator.canPop()) navigator.pop();
    }
  }
}

class _AddressRow extends StatelessWidget {
  final DeliveryAddress addr;
  final bool selected;
  final CartSurfaceColors surfaceColors;
  final VoidCallback onTap;

  const _AddressRow({
    required this.addr,
    required this.selected,
    required this.surfaceColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pink = AppColors.auroraPurple;
    final bg = selected
        ? pink.withValues(alpha: 0.10)
        : surfaceColors.chipFill;
    final border = selected
        ? pink.withValues(alpha: 0.40)
        : surfaceColors.chipBorder;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _RadioDot(
                    selected: selected,
                    surfaceColors: surfaceColors,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    addr.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: surfaceColors.text,
                    ),
                  ),
                  if (addr.isDefault) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.auroraElectricBlue.withValues(
                          alpha: 0.14,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'DEFAULT',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: AppColors.auroraElectricBlue,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    addr.phone,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      color: surfaceColors.textMute2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text(
                  addr.line,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11,
                    height: 1.4,
                    color: surfaceColors.textMute,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  final CartSurfaceColors surfaceColors;

  const _RadioDot({required this.selected, required this.surfaceColors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.auroraPurple : Colors.transparent,
        border: Border.all(
          color: selected
              ? AppColors.auroraPurple
              : surfaceColors.chipBorder,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
            )
          : null,
    );
  }
}

