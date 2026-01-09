import 'package:flutter/material.dart';

import '../../../themes/themes.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primaryPurple,
          side: BorderSide(color: AppColors.borderMedium, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppTextStyles.buttonLarge.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
      ),
    );
  }
}
