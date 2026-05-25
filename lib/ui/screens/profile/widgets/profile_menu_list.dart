import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/route_constants.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import 'profile_menu_item.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({
    super.key,
    required this.isDark,
    required this.isLoggedIn,
    this.activeOrderCount = 0,
  });

  final bool isDark;
  final bool isLoggedIn;
  final int activeOrderCount;

  @override
  Widget build(BuildContext context) {
    final ordersItems = [
      ProfileMenuItem(
        icon: FontAwesomeIcons.box,
        iconBg: AppColors.auroraElectricBlue
            .withValues(alpha: isDark ? 0.12 : 0.10),
        iconColor: AppColors.auroraElectricBlue,
        title: 'My Orders',
        subtitle:
            isLoggedIn ? 'Track and manage your orders' : 'Sign in to view',
        badge: isLoggedIn && activeOrderCount > 0 ? '$activeOrderCount' : null,
        isDark: isDark,
        onTap: () => Navigator.pushNamed(context, ordersScreenRoute),
      ),
      ProfileMenuItem(
        icon: FontAwesomeIcons.gift,
        iconBg: AppColors.auroraGold.withValues(alpha: isDark ? 0.12 : 0.10),
        iconColor: AppColors.auroraGold,
        title: 'Loyalty',
        subtitle: 'Points, rewards & tiers',
        isDark: isDark,
        onTap: () => Navigator.pushNamed(context, loyaltyScreenRoute),
      ),
    ];

    final wishlistItem = ProfileMenuItem(
      icon: FontAwesomeIcons.heart,
      iconBg: AppColors.auroraPink.withValues(alpha: isDark ? 0.12 : 0.10),
      iconColor: AppColors.auroraPink,
      title: 'Wishlist',
      subtitle: "Items you've saved",
      isDark: isDark,
      onTap: () => Navigator.pushNamed(context, wishlistScreenRoute),
    );

    final accountItems = [
      if (isLoggedIn)
        ProfileMenuItem(
          icon: FontAwesomeIcons.locationDot,
          iconBg:
              AppColors.auroraPurple.withValues(alpha: isDark ? 0.12 : 0.10),
          iconColor: AppColors.auroraPurple,
          title: 'Addresses',
          subtitle: 'Manage saved locations',
          isDark: isDark,
          onTap: () => Navigator.pushNamed(context, addressesScreenRoute),
        ),
      ProfileMenuItem(
        icon: FontAwesomeIcons.gear,
        iconBg:
            AppColors.auroraPurple.withValues(alpha: isDark ? 0.12 : 0.10),
        iconColor: AppColors.auroraPurple,
        title: 'Settings',
        subtitle: 'Preferences and security',
        isDark: isDark,
        onTap: () => Navigator.pushNamed(context, settingsScreenRoute),
      ),
      ProfileMenuItem(
        icon: FontAwesomeIcons.circleQuestion,
        iconBg:
            AppColors.auroraPurple.withValues(alpha: isDark ? 0.12 : 0.10),
        iconColor: AppColors.auroraPurple,
        title: 'Help & Support',
        subtitle: 'FAQs, contact us',
        isDark: isDark,
        onTap: () => Navigator.pushNamed(context, helpSupportScreenRoute),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(label: 'Shopping', isDark: isDark),
        _MenuGroup(
          isDark: isDark,
          locked: !isLoggedIn,
          items: ordersItems,
        ),
        _SectionHeader(label: 'Wishlist', isDark: isDark),
        _MenuGroup(isDark: isDark, items: [wishlistItem]),
        _SectionHeader(
          label: isLoggedIn ? 'Account' : 'General',
          isDark: isDark,
        ),
        _MenuGroup(isDark: isDark, items: accountItems),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.dsSectionLabel.copyWith(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.3)
              : AppColors.auroraPurple.withValues(alpha: 0.4),
          letterSpacing: 1.6,
        ),
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({
    required this.isDark,
    required this.items,
    this.locked = false,
  });

  final bool isDark;
  final List<Widget> items;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: isDark
          ? AppColors.white.withValues(alpha: 0.05)
          : AppColors.auroraPurple.withValues(alpha: 0.07),
    );

    final group = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.03)
            : AppColors.auroraPurple.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.07)
              : AppColors.auroraPurple.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1) divider,
          ],
        ],
      ),
    );

    if (locked) {
      return IgnorePointer(child: Opacity(opacity: 0.3, child: group));
    }
    return group;
  }
}
