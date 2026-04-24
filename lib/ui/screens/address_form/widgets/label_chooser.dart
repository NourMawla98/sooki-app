import 'package:flutter/material.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../cart/widgets/_cart_surface_theme.dart';

enum AddressLabelType { home, office, other }

class LabelChooser extends StatelessWidget {
  final AddressLabelType selected;
  final ValueChanged<AddressLabelType> onChanged;
  final CartSurfaceColors surfaceColors;

  const LabelChooser({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.surfaceColors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _pill(AddressLabelType.home, 'Home')),
        const SizedBox(width: 8),
        Expanded(child: _pill(AddressLabelType.office, 'Office')),
        const SizedBox(width: 8),
        Expanded(child: _pill(AddressLabelType.other, 'Other')),
      ],
    );
  }

  Widget _pill(AddressLabelType type, String label) {
    final isSelected = selected == type;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(type),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: AppColors.auroraCartButtonGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : surfaceColors.chipFill,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : surfaceColors.chipBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isSelected ? AppColors.white : surfaceColors.text,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
