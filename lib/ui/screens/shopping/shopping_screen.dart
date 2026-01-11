import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/themes.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping', style: AppTextStyles.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.bagShopping,
              size: 64,
              color: AppColors.primaryPurple,
            ),
            const SizedBox(height: 16),
            Text('Shopping', style: AppTextStyles.heading1),
            const SizedBox(height: 8),
            Text(
              'Shop coming soon...',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
