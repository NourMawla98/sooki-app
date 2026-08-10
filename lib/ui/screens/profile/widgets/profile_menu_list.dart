import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/route_constants.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../utils/number_localization.dart';
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
        title: 'profile_menu_list.my_orders'.tr(),
        subtitle: isLoggedIn
            ? 'profile_menu_list.orders_subtitle'.tr()
            : 'profile_menu_list.sign_in_to_view'.tr(),
        badge: isLoggedIn && activeOrderCount > 0
            ? localizedNumber(activeOrderCount)
            : null,
        isDark: isDark,
        onTap: () => Navigator.pushNamed(context, ordersScreenRoute),
      ),
      ProfileMenuItem(
        icon: FontAwesomeIcons.gift,
        iconBg: AppColors.auroraGold.withValues(alpha: isDark ? 0.12 : 0.10),
        iconColor: AppColors.auroraGold,
        title: 'profile_menu_list.loyalty'.tr(),
        subtitle: 'profile_menu_list.loyalty_subtitle'.tr(),
        isDark: isDark,
        onTap: () => Navigator.pushNamed(context, loyaltyScreenRoute),
      ),
    ];

    final wishlistItem = ProfileMenuItem(
      icon: FontAwesomeIcons.heart,
      iconBg: AppColors.auroraPink.withValues(alpha: isDark ? 0.12 : 0.10),
      iconColor: AppColors.auroraPink,
      title: 'common.wishlist'.tr(),
      subtitle: 'profile_menu_list.wishlist_subtitle'.tr(),
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
          title: 'profile_menu_list.addresses'.tr(),
          subtitle: 'profile_menu_list.addresses_subtitle'.tr(),
          isDark: isDark,
          onTap: () => Navigator.pushNamed(context, addressesScreenRoute),
        ),
      ProfileMenuItem(
        icon: FontAwesomeIcons.gear,
        iconBg:
            AppColors.auroraPurple.withValues(alpha: isDark ? 0.12 : 0.10),
        iconColor: AppColors.auroraPurple,
        title: 'common.settings'.tr(),
        subtitle: 'profile_menu_list.settings_subtitle'.tr(),
        isDark: isDark,
        onTap: () => Navigator.pushNamed(context, settingsScreenRoute),
      ),
      ProfileMenuItem(
        icon: FontAwesomeIcons.circleQuestion,
        iconBg:
            AppColors.auroraPurple.withValues(alpha: isDark ? 0.12 : 0.10),
        iconColor: AppColors.auroraPurple,
        title: 'profile_menu_list.help_support'.tr(),
        subtitle: 'profile_menu_list.help_support_subtitle'.tr(),
        isDark: isDark,
        onTap: () => Navigator.pushNamed(context, helpSupportScreenRoute),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          label: 'profile_menu_list.section_shopping'.tr(),
          isDark: isDark,
        ),
        _MenuGroup(
          isDark: isDark,
          locked: !isLoggedIn,
          items: ordersItems,
        ),
        _SectionHeader(label: 'common.wishlist'.tr(), isDark: isDark),
        _MenuGroup(isDark: isDark, items: [wishlistItem]),
        _SectionHeader(
          label: isLoggedIn
              ? 'profile_menu_list.section_account'.tr()
              : 'profile_menu_list.section_general'.tr(),
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
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 8),
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
