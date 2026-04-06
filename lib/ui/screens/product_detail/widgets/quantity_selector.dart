import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../themes/themes.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
  });

  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isMinusDisabled = quantity == 1;
    final bool isPlusDisabled = quantity == maxQuantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quantity', style: AppTextStyles.label),
        const SizedBox(height: 12),
        Row(
          children: [
            // Minus button
            GestureDetector(
              onTap: isMinusDisabled ? null : () => onChanged(quantity - 1),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isMinusDisabled
                      ? AppColors.gray200
                      : AppColors.gray100,
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.minus,
                    size: 14,
                    color: isMinusDisabled
                        ? AppColors.gray400
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Quantity display
            SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  '$quantity',
                  style: AppTextStyles.heading4,
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Plus button
            GestureDetector(
              onTap: isPlusDisabled ? null : () => onChanged(quantity + 1),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPlusDisabled
                      ? AppColors.gray200
                      : AppColors.primaryPurple,
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.plus,
                    size: 14,
                    color: isPlusDisabled
                        ? AppColors.gray400
                        : AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
