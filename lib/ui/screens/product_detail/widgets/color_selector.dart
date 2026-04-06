import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/product.dart';
import '../../../../themes/themes.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({
    super.key,
    required this.colors,
    this.selected,
    required this.onSelected,
  });

  final List<ColorVariant> colors;
  final ColorVariant? selected;
  final ValueChanged<ColorVariant> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Color', style: AppTextStyles.label),
            const SizedBox(width: 8),
            Text(
              selected?.name ?? 'Select',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: colors.map((color) => _buildColorButton(color)).toList(),
        ),
      ],
    );
  }

  Widget _buildColorButton(ColorVariant color) {
    final bool isSelected = selected == color;
    final Color fillColor = Color(
      int.parse(color.hexCode.replaceFirst('#', '0xFF')),
    );

    return GestureDetector(
      onTap: color.isAvailable ? () => onSelected(color) : null,
      child: Opacity(
        opacity: color.isAvailable ? 1.0 : 0.3,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fillColor,
            border: Border.all(
              color: isSelected ? AppColors.primaryPurple : AppColors.gray300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: isSelected
              ? Center(
                  child: FaIcon(
                    FontAwesomeIcons.check,
                    size: 14,
                    color: AppColors.white,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
