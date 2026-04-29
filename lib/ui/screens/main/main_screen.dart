import 'package:flutter/material.dart';

import '../../../services/toast_service.dart';
import '../../header/app_header.dart';
import '../../nav_bar/custom_bottom_nav_bar.dart';
import '../../reusable_components/aurora/aurora_shopping_fab.dart';
import '../browse/browse_screen.dart';
import '../cart/cart_screen.dart';
import '../deals/deals_screen.dart';
import '../loyalty/loyalty_screen.dart';
import '../shopping/shopping_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Default to Browse tab

  late final List<Widget> _pages = [
    const BrowseScreen(),
    const DealsScreen(),
    const ShoppingScreen(),
    const LoyaltyScreen(),
    CartScreen(onSwitchToBrowse: () => _onTabTapped(0)),
  ];

  @override
  void initState() {
    super.initState();
    // Toasts on this screen must sit above the 68px nav bar.
    ToastService.setBottomInset(68);
  }

  @override
  void dispose() {
    ToastService.setBottomInset(0);
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed header at the top
          const AppHeader(),
          // Page content below header
          Expanded(
            child: Stack(
              children: [
                for (int i = 0; i < _pages.length; i++)
                  Offstage(
                    offstage: i != _currentIndex,
                    child: IgnorePointer(
                      ignoring: i != _currentIndex,
                      child: _pages[i],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      // FAB lives in the Scaffold's slot (not nested inside the nav bar's
      // Stack) so Flutter hit-tests its entire circle — including the half
      // that overflows above the nav bar. Docking centers it on the nav
      // bar's top edge.
      floatingActionButton: AuroraShoppingFab(
        isSelected: _currentIndex == 2,
        onTap: () => _onTabTapped(2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
