import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../backend_integration/dtos/address/address_dto.dart';
import '../../../../routes/route_constants.dart';
import '../../../../services/address_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/aurora/aurora_primary_button.dart';
import '_cart_surface_theme.dart';

Future<void> showAddressPickerSheet(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: const _AddressPickerSheet(),
    ),
  );
}

class _AddressPickerSheet extends StatefulWidget {
  const _AddressPickerSheet();

  @override
  State<_AddressPickerSheet> createState() => _AddressPickerSheetState();
}

class _AddressPickerSheetState extends State<_AddressPickerSheet> {
  @override
  void initState() {
    super.initState();
    final service = GetIt.instance<AddressService>();
    if (service.addresses.isEmpty) {
      service.loadFromServer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressService = GetIt.instance<AddressService>();
    return ListenableBuilder(
      listenable: Listenable.merge([addressService, ThemeService.instance]),
      builder: (context, _) {
        final c = CartSurfaceColors.of(isDark: ThemeService.instance.isDarkMode);
        final addresses = addressService.addresses;
        final selectedId = addressService.selectedId;

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
          child: Container(
            decoration: BoxDecoration(
              color: c.sheet,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: c.sheetTop, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
                    children: [
                      ...addresses.map(
                        (a) => _AddressRow(
                          addr: a,
                          selected: a.id == selectedId,
                          surfaceColors: c,
                          onTap: () {
                            addressService.select(a.id);
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
    final navigator = Navigator.of(context);
    final result = await navigator.pushNamed(addAddressScreenRoute);
    if (result == true) {
      if (navigator.canPop()) navigator.pop();
    }
  }
}

class _AddressRow extends StatelessWidget {
  final AddressDto addr;
  final bool selected;
  final CartSurfaceColors surfaceColors;
  final VoidCallback onTap;

  const _AddressRow({
    required this.addr,
    required this.selected,
    required this.surfaceColors,
    required this.onTap,
  });

  String get _locationLine {
    final parts = <String>[addr.city.name];
    if (addr.area != null) parts.add(addr.area!.name);
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final pink = AppColors.auroraPurple;
    final bg = selected ? pink.withValues(alpha: 0.10) : surfaceColors.chipFill;
    final border = selected ? pink.withValues(alpha: 0.40) : surfaceColors.chipBorder;

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
                  _RadioDot(selected: selected, surfaceColors: surfaceColors),
                  const SizedBox(width: 10),
                  Text(
                    addr.label ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: surfaceColors.text,
                    ),
                  ),
                  if (addr.isDefault) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.auroraElectricBlue.withValues(alpha: 0.14),
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
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addr.fullName,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: surfaceColors.textMute,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _locationLine,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        height: 1.4,
                        color: surfaceColors.textMute,
                      ),
                    ),
                  ],
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
          color: selected ? AppColors.auroraPurple : surfaceColors.chipBorder,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
            )
          : null,
    );
  }
}
