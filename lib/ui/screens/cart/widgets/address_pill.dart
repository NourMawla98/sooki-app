import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../../enums/address_label_type.dart';
import '../../../../backend_integration/dtos/address/address_dto.dart';
import '../../../../services/address_service.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '_cart_surface_theme.dart';
import 'address_picker_sheet.dart';
import 'aurora_login_gate_dialog.dart';

String _addressLine(AddressDto addr) {
  final parts = <String>[addr.city.name];
  if (addr.area != null) parts.add(addr.area!.name);
  return parts.join(', ');
}

/// A1 compact delivery-address pill. Tap anywhere on the row (or on CHANGE)
/// to open the picker sheet with all saved addresses.
/// When the user is not signed in the pill is visually dimmed and tapping
/// shows the login gate instead of the address picker.
class AddressPill extends StatelessWidget {
  const AddressPill({super.key});

  @override
  Widget build(BuildContext context) {
    final addressService = GetIt.instance<AddressService>();
    final authService = GetIt.instance<AuthService>();

    return ListenableBuilder(
      listenable: Listenable.merge([
        addressService,
        authService,
        ThemeService.instance,
      ]),
      builder: (context, _) {
        final c = CartSurfaceColors.of(
          isDark: ThemeService.instance.isDarkMode,
        );
        final addr = addressService.selectedAddress;
        final isLoggedIn = authService.isCustomer;

        return Opacity(
          opacity: isLoggedIn ? 1.0 : 0.45,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => isLoggedIn
                ? showAddressPickerSheet(context)
                : showAuroraLoginGate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: c.glassFill,
                border: Border.all(color: c.glassBorder, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.auroraPurple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.locationDot,
                      size: 12,
                      color: AppColors.auroraPurple,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: addr == null
                          ? [
                              Text(
                                'address_pill.no_delivery_address'.tr(),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: c.text,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'address_pill.tap_to_add_one'.tr(),
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 10.5,
                                  color: c.textMute,
                                ),
                              ),
                            ]
                          : [
                              _TitleLine(addr: addr, surfaceColors: c),
                              const SizedBox(height: 1),
                              Text(
                                _addressLine(addr),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 10.5,
                                  color: c.textMute,
                                ),
                              ),
                            ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: AppColors.auroraPurple.withValues(alpha: 0.50),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'address_pill.change'.tr(),
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        color: AppColors.auroraPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TitleLine extends StatelessWidget {
  final AddressDto addr;
  final CartSurfaceColors surfaceColors;

  const _TitleLine({required this.addr, required this.surfaceColors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text.rich(
            TextSpan(
              text: 'address_pill.deliver_to_prefix'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: surfaceColors.text,
              ),
              children: [
                TextSpan(
                  text: localizedAddressLabel(addr.label),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.auroraPurple,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
              'address_pill.default_badge'.tr(),
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
    );
  }
}
