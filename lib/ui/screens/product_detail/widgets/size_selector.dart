import 'package:flutter/material.dart';

import '../../../../models/product.dart';
import '../../../../themes/themes.dart';

class SizeSelector extends StatelessWidget {
  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selected,
    required this.onSelected,
    required this.onSizeGuide,
  });

  final List<SizeVariant> sizes;
  final SizeVariant? selected;
  final ValueChanged<SizeVariant> onSelected;
  final VoidCallback onSizeGuide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Size', style: AppTextStyles.label),
            GestureDetector(
              onTap: onSizeGuide,
              child: Text(
                'Size Guide',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryPurple,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Size buttons
        Wrap(
          spacing: 10,
          children: sizes.map((sizeVariant) {
            final isSelected = selected == sizeVariant;
            final isAvailable = sizeVariant.isAvailable;

            return GestureDetector(
              onTap: isAvailable ? () => onSelected(sizeVariant) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                constraints: const BoxConstraints(minWidth: 48),
                height: 36,
                decoration: BoxDecoration(
                  color: !isAvailable
                      ? AppColors.gray200
                      : isSelected
                          ? AppColors.primaryPurple
                          : AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: isAvailable && !isSelected
                      ? Border.all(color: AppColors.gray300, width: 1)
                      : null,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  sizeVariant.label,
                  style: AppTextStyles.buttonSmall.copyWith(
                    color: !isAvailable
                        ? AppColors.gray400
                        : isSelected
                            ? AppColors.white
                            : AppColors.textPrimary,
                    decoration:
                        !isAvailable ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
