import 'package:flutter/material.dart';

import '../../../services/route_history_service.dart';
import '../../../services/toast_service.dart';
import '../../header/app_header.dart';
import '../../nav_bar/custom_bottom_nav_bar.dart';
import '../../reusable_components/aurora/aurora_shopping_fab.dart';
import '../browse/browse_screen.dart';
import '../cart/cart_screen.dart';
import '../categories/category_browse_screen.dart';
import '../deals/deals_screen.dart';
import '../auction/auction_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialTabIndex = 0});

  /// Tab to open on. Defaults to Browse, and is supplied when the screen is
  /// rebuilt after a language change so the customer keeps their tab.
  final int initialTabIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex = widget.initialTabIndex;

  static const int _cartIndex = 4;

  late final List<Widget> _keptAlivePages = [
    const BrowseScreen(),
    const DealsScreen(),
    const CategoryBrowseScreen(),
    const AuctionScreen(),
  ];

  /// Tabs stay mounted, so a page that has to refetch on focus needs to be told
  /// which tab is showing. Only the cart does today.
  List<Widget> _pages() => [
    ..._keptAlivePages,
    CartScreen(
      isActive: _currentIndex == _cartIndex,
      onSwitchToBrowse: () => _onTabTapped(0),
    ),
  ];

  @override
  void initState() {
    super.initState();
    RouteHistoryService.instance.mainTabIndex = widget.initialTabIndex;
    // Toasts on this screen must sit above the 68px nav bar.
    ToastService.setBottomInset(68);
  }

  @override
  void dispose() {
    ToastService.setBottomInset(0);
    super.dispose();
  }

  void _onTabTapped(int index) {
    RouteHistoryService.instance.mainTabIndex = index;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages();

    return Scaffold(
      body: Column(
        children: [
          // Fixed header at the top
          const AppHeader(),
          // Page content below header
          Expanded(
            child: Stack(
              children: [
                for (int i = 0; i < pages.length; i++)
                  Offstage(
                    offstage: i != _currentIndex,
                    child: IgnorePointer(
                      ignoring: i != _currentIndex,
                      child: pages[i],
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
