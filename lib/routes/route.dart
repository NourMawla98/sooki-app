import 'package:flutter/material.dart';

import '../ui/screens/browse/browse_screen.dart';
import '../ui/screens/cart/cart_screen.dart';
import '../ui/screens/deals/deals_screen.dart';
import '../ui/screens/forgot_password/forgot_password_screen.dart';
import '../ui/screens/loyalty/loyalty_screen.dart';
import '../ui/screens/profile/profile_screen.dart';
import '../ui/screens/orders/orders_screen.dart';
import '../ui/screens/wishlist/wishlist_screen.dart';
import '../ui/screens/addresses/addresses_screen.dart';
import '../ui/screens/payment_methods/payment_methods_screen.dart';
import '../ui/screens/settings/settings_screen.dart';
import '../ui/screens/help_support/help_support_screen.dart';
import '../ui/screens/orders/order_detail_screen.dart';
import '../backend_integration/dtos/address/address_dto.dart';
import '../ui/screens/address_form/address_form_screen.dart';
import '../ui/screens/settings/change_password_screen.dart';
import '../ui/screens/settings/privacy_settings_screen.dart';
import '../ui/screens/help_support/shipping_info_screen.dart';
import '../ui/screens/help_support/legal_page_screen.dart';
import '../ui/screens/help_support/email_support_screen.dart';
import '../ui/screens/image_viewer/image_viewer_screen.dart';
import '../ui/screens/notifications/notifications_screen.dart';
import '../ui/screens/edit_profile/edit_profile_screen.dart';
import '../ui/screens/email_verification/email_verification_screen.dart';
import '../ui/screens/checkout/checkout_screen.dart';
import '../ui/screens/order_success/order_success_screen.dart';
import '../ui/screens/categories/category_browse_screen.dart';
import '../ui/screens/categories/category_detail_args.dart';
import '../ui/screens/categories/category_detail_screen.dart';
import '../ui/screens/search/search_screen.dart';
import '../ui/screens/main/main_screen.dart';
import '../ui/screens/shopping/shopping_screen.dart';
import '../ui/screens/sign_in/sign_in_screen.dart';
import '../ui/screens/sign_up/sign_up_screen.dart';
import '../ui/screens/splash/splash_screen.dart';
import '../ui/screens/product_detail/product_detail_screen.dart';
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
    profileScreenRoute: (_) => const ProfileScreen(),
    notificationsScreenRoute: (_) => const NotificationsScreen(),
    editProfileScreenRoute: (_) => const EditProfileScreen(),
    emailVerificationScreenRoute: (_) {
      final args = settings.arguments;
      final map = args is Map ? args : <String, String>{};
      return EmailVerificationScreen(
        email: (map['email'] as String?) ?? '',
        password: (map['password'] as String?) ?? '',
      );
    },
    checkoutScreenRoute: (_) => const CheckoutScreen(),
    orderSuccessScreenRoute: (_) {
      final args = settings.arguments;
      return OrderSuccessScreen(
        args: args is OrderSuccessArgs ? args : const OrderSuccessArgs(),
      );
    },
    ordersScreenRoute: (_) => const OrdersScreen(),
    wishlistScreenRoute: (_) => const WishlistScreen(),
    addressesScreenRoute: (_) => const AddressesScreen(),
    paymentMethodsScreenRoute: (_) => const PaymentMethodsScreen(),
    settingsScreenRoute: (_) => const SettingsScreen(),
    helpSupportScreenRoute: (_) => const HelpSupportScreen(),
    orderDetailScreenRoute: (_) {
      final id = settings.arguments as int;
      return OrderDetailScreen(orderId: id);
    },
    addAddressScreenRoute: (_) => const AddressFormScreen(),
    editAddressScreenRoute: (_) {
      final address = settings.arguments as AddressDto;
      return AddressFormScreen(initialAddress: address);
    },
    changePasswordScreenRoute: (_) => const ChangePasswordScreen(),
    privacySettingsScreenRoute: (_) => const PrivacySettingsScreen(),
    shippingInfoScreenRoute: (_) => const ShippingInfoScreen(),
    termsConditionsScreenRoute: (_) => LegalPageScreen(
      title: 'Terms & Conditions',
      sections: LegalPageScreen.termsAndConditions,
    ),
    privacyPolicyScreenRoute: (_) => LegalPageScreen(
      title: 'Privacy Policy',
      sections: LegalPageScreen.privacyPolicy,
    ),
    emailSupportScreenRoute: (_) => const EmailSupportScreen(),
    searchScreenRoute: (_) {
      final args = settings.arguments;
      final query = args is String ? args : null;
      return SearchScreen(initialQuery: query);
    },
    productDetailScreenRoute: (_) {
      final itemId = settings.arguments as int;
      return ProductDetailScreen(itemId: itemId);
    },
    itemDetailsScreenRoute: (_) {
      final itemId = settings.arguments as int;
      return ProductDetailScreen(itemId: itemId);
    },
    imageViewerScreenRoute: (_) {
      final args = settings.arguments as ImageViewerArgs;
      return ImageViewerScreen(args: args);
    },
    categoryBrowseScreenRoute: (_) => const CategoryBrowseScreen(),
    categoryDetailScreenRoute: (_) {
      final args = settings.arguments as CategoryDetailArgs;
      return CategoryDetailScreen(args: args);
    },
  };

  return MaterialPageRoute(
    builder: routes[settings.name] ?? (_) => const SplashScreen(),
  );
}
