import 'package:flutter/material.dart';

import '../ui/screens/browse/browse_screen.dart';
import '../ui/screens/cart/cart_screen.dart';
import '../ui/screens/deals/deals_screen.dart';
import '../ui/screens/forgot_password/forgot_password_screen.dart';
import '../ui/screens/loyalty/loyalty_screen.dart';
import '../ui/screens/profile/profile_screen.dart';
import '../ui/screens/orders/orders_screen.dart';
import '../ui/screens/upcoming_deliveries/upcoming_deliveries_screen.dart';
import '../ui/screens/wishlist/wishlist_screen.dart';
import '../ui/screens/addresses/addresses_screen.dart';
import '../ui/screens/payment_methods/payment_methods_screen.dart';
import '../ui/screens/settings/settings_screen.dart';
import '../ui/screens/help_support/help_support_screen.dart';
import '../ui/screens/orders/order_detail_screen.dart';
import '../ui/screens/upcoming_deliveries/delivery_detail_screen.dart';
import '../ui/screens/address_form/address_form_screen.dart';
import '../ui/screens/addresses/edit_address_screen.dart';
import '../ui/screens/payment_methods/add_card_screen.dart';
import '../ui/screens/settings/change_password_screen.dart';
import '../ui/screens/settings/privacy_settings_screen.dart';
import '../ui/screens/help_support/shipping_info_screen.dart';
import '../ui/screens/help_support/returns_exchanges_screen.dart';
import '../ui/screens/help_support/legal_page_screen.dart';
import '../ui/screens/help_support/live_chat_screen.dart';
import '../ui/screens/help_support/email_support_screen.dart';
import '../ui/screens/image_viewer/image_viewer_screen.dart';
import '../ui/screens/item_details/item_details_screen.dart';
import '../ui/screens/search/search_screen.dart';
import '../ui/screens/main/main_screen.dart';
import '../ui/screens/shopping/shopping_screen.dart';
import '../ui/screens/sign_in/sign_in_screen.dart';
import '../ui/screens/sign_up/sign_up_screen.dart';
import '../ui/screens/splash/splash_screen.dart';
import '../models/product.dart';
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
    ordersScreenRoute: (_) => const OrdersScreen(),
    upcomingDeliveriesScreenRoute: (_) => const UpcomingDeliveriesScreen(),
    wishlistScreenRoute: (_) => const WishlistScreen(),
    addressesScreenRoute: (_) => const AddressesScreen(),
    paymentMethodsScreenRoute: (_) => const PaymentMethodsScreen(),
    settingsScreenRoute: (_) => const SettingsScreen(),
    helpSupportScreenRoute: (_) => const HelpSupportScreen(),
    orderDetailScreenRoute: (_) {
      final order = settings.arguments as MockOrderDetail;
      return OrderDetailScreen(order: order);
    },
    deliveryDetailScreenRoute: (_) {
      final delivery = settings.arguments as MockDeliveryDetail;
      return DeliveryDetailScreen(delivery: delivery);
    },
    addAddressScreenRoute: (_) => const AddressFormScreen(),
    editAddressScreenRoute: (_) {
      final address = settings.arguments as MockEditAddress;
      return EditAddressScreen(address: address);
    },
    addCardScreenRoute: (_) => const AddCardScreen(),
    changePasswordScreenRoute: (_) => const ChangePasswordScreen(),
    privacySettingsScreenRoute: (_) => const PrivacySettingsScreen(),
    shippingInfoScreenRoute: (_) => const ShippingInfoScreen(),
    returnsExchangesScreenRoute: (_) => const ReturnsExchangesScreen(),
    termsConditionsScreenRoute: (_) => LegalPageScreen(
      title: 'Terms & Conditions',
      sections: LegalPageScreen.termsAndConditions,
    ),
    privacyPolicyScreenRoute: (_) => LegalPageScreen(
      title: 'Privacy Policy',
      sections: LegalPageScreen.privacyPolicy,
    ),
    liveChatScreenRoute: (_) => const LiveChatScreen(),
    emailSupportScreenRoute: (_) => const EmailSupportScreen(),
    searchScreenRoute: (_) {
      final args = settings.arguments;
      final query = args is String ? args : null;
      return SearchScreen(initialQuery: query);
    },
    productDetailScreenRoute: (_) {
      final product = settings.arguments as Product;
      return ProductDetailScreen(product: product);
    },
    itemDetailsScreenRoute: (_) {
      final product = settings.arguments as Product?;
      if (product != null) {
        return ProductDetailScreen(product: product);
      }
      return const ItemDetailsScreen();
    },
    imageViewerScreenRoute: (_) {
      final args = settings.arguments as ImageViewerArgs;
      return ImageViewerScreen(args: args);
    },
  };

  return MaterialPageRoute(
    builder: routes[settings.name] ?? (_) => const SplashScreen(),
  );
}
