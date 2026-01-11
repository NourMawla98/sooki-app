import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/themes.dart';
import 'widget/pulsing_shopping_button.dart';
import 'widget/rainbow_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rainbow bar
        const RainbowBar(),

        // Navigation bar with middle button
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Bottom navigation bar (wrapped for rounded corners)
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    currentIndex: currentIndex == 2 ? 2 : currentIndex,
                    onTap: (index) {
                      if (index == 2) {
                        return;
                      }
                      onTap(index);
                    },
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent,
                    selectedItemColor: AppColors.accentRed,
                    unselectedItemColor: AppColors.textSecondary,
                    selectedLabelStyle: AppTextStyles.navLabelActive,
                    unselectedLabelStyle: AppTextStyles.navLabel,
                    elevation: 0,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    enableFeedback: true,
                    items: [
                      // Browse
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FaIcon(FontAwesomeIcons.solidHouse, size: 20),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FaIcon(FontAwesomeIcons.solidHouse, size: 20),
                        ),
                        label: 'Browse',
                      ),
                      // Deals
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FaIcon(FontAwesomeIcons.bolt, size: 20),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FaIcon(FontAwesomeIcons.bolt, size: 20),
                        ),
                        label: 'Deals',
                      ),
                      // Placeholder for middle button (Shopping)
                      const BottomNavigationBarItem(
                        icon: SizedBox(width: 48), // Empty space for FAB
                        label: '',
                      ),
                      // Loyalty
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FaIcon(FontAwesomeIcons.gift, size: 20),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FaIcon(FontAwesomeIcons.gift, size: 20),
                        ),
                        label: 'Loyalty',
                      ),
                      // Cart
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FaIcon(
                            FontAwesomeIcons.cartShopping,
                            size: 20,
                          ),
                        ),
                        activeIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FaIcon(
                            FontAwesomeIcons.cartShopping,
                            size: 20,
                          ),
                        ),
                        label: 'Cart',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Pulsing shopping button positioned above nav bar
            // 40% above rainbow bar, 60% below
            Positioned(
              top: -24,
              child: PulsingShoppingButton(
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
