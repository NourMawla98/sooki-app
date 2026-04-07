import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../themes/themes.dart';
import '../../../reusable_components/buttons/primary_button.dart';

class CartEmptyState extends StatelessWidget {
  final VoidCallback onBrowse;

  const CartEmptyState({super.key, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Green circle with cart icon
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.accentGreen,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.cartShopping,
                  size: 32,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Shopping Cart',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Your cart is empty. Time to shop!',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Browse Products',
              onPressed: onBrowse,
              isFullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
