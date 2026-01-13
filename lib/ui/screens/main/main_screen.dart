import 'package:flutter/material.dart';

import '../../header/app_header.dart';
import '../../nav_bar/custom_bottom_nav_bar.dart';
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

  final List<Widget> _pages = const [
    BrowseScreen(),
    DealsScreen(),
    ShoppingScreen(),
    LoyaltyScreen(),
    CartScreen(),
  ];

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
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
