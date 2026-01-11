import 'package:flutter/material.dart';

import '../ui/screens/browse/browse_screen.dart';
import '../ui/screens/cart/cart_screen.dart';
import '../ui/screens/deals/deals_screen.dart';
import '../ui/screens/forgot_password/forgot_password_screen.dart';
import '../ui/screens/loyalty/loyalty_screen.dart';
import '../ui/screens/main/main_screen.dart';
import '../ui/screens/shopping/shopping_screen.dart';
import '../ui/screens/sign_in/sign_in_screen.dart';
import '../ui/screens/sign_up/sign_up_screen.dart';
import '../ui/screens/splash/splash_screen.dart';
import 'route_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final routes = {
    splashScreenRoute: (_) => const SplashScreen(),
    signUpScreenRoute: (_) => const SignUpScreen(),
    signInScreenRoute: (_) => const SignInScreen(),
    forgotPasswordScreenRoute: (_) => const ForgotPasswordScreen(),
    mainScreenRoute: (_) => const MainScreen(),
    browseScreenRoute: (_) => const BrowseScreen(),
    dealsScreenRoute: (_) => const DealsScreen(),
    shoppingScreenRoute: (_) => const ShoppingScreen(),
    loyaltyScreenRoute: (_) => const LoyaltyScreen(),
    cartScreenRoute: (_) => const CartScreen(),
  };

  return MaterialPageRoute(
    builder: routes[settings.name] ?? (_) => const SplashScreen(),
  );
}
