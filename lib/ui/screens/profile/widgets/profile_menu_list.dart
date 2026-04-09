import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/route_constants.dart';
import '../../../../themes/app_colors.dart';
import 'profile_menu_item.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          iconBackgroundColor: AppColors.profileIconOrange,
          icon: FontAwesomeIcons.box,
          title: 'Orders',
          subtitle: 'Track your orders',
          onTap: () => Navigator.pushNamed(context, ordersScreenRoute),
        ),
        ProfileMenuItem(
          iconBackgroundColor: AppColors.profileIconGreen,
          icon: FontAwesomeIcons.truck,
          title: 'Upcoming Deliveries',
          subtitle: "See what's on the way",
          onTap: () =>
              Navigator.pushNamed(context, upcomingDeliveriesScreenRoute),
        ),
        ProfileMenuItem(
          iconBackgroundColor: AppColors.profileIconPink,
          icon: FontAwesomeIcons.heart,
          title: 'Wishlist',
          subtitle: 'Your saved items',
          onTap: () => Navigator.pushNamed(context, wishlistScreenRoute),
        ),
        ProfileMenuItem(
          iconBackgroundColor: AppColors.profileIconYellow,
          icon: FontAwesomeIcons.locationDot,
          title: 'Addresses',
          subtitle: 'Manage shipping addresses',
          onTap: () => Navigator.pushNamed(context, addressesScreenRoute),
        ),
        ProfileMenuItem(
          iconBackgroundColor: AppColors.profileIconTeal,
          icon: FontAwesomeIcons.creditCard,
          title: 'Payment Methods',
          subtitle: 'Manage your cards',
          onTap: () => Navigator.pushNamed(context, paymentMethodsScreenRoute),
        ),
        ProfileMenuItem(
          iconBackgroundColor: AppColors.profileIconGray,
          icon: FontAwesomeIcons.gear,
          title: 'Settings',
          subtitle: 'Account preferences',
          onTap: () => Navigator.pushNamed(context, settingsScreenRoute),
        ),
        ProfileMenuItem(
          iconBackgroundColor: AppColors.profileIconHelpPink,
          icon: FontAwesomeIcons.circleQuestion,
          title: 'Help & Support',
          subtitle: 'Get assistance',
          onTap: () => Navigator.pushNamed(context, helpSupportScreenRoute),
        ),
      ],
    );
  }
}
