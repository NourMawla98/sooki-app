import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Custom search bar component for the header
class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.gray200, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 16,
              color: AppColors.gray400,
            ),
            const SizedBox(width: 12),
            Text(
              'Search for products...',
              style: AppTextStyles.inputHint.copyWith(
                color: AppColors.gray400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
