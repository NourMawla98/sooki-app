import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../reusable_components/coming_soon/coming_soon_screen.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonScreen(
      featureName: 'loyalty_screen.feature_name'.tr(),
      tagline: 'loyalty_screen.tagline'.tr(),
      icon: FontAwesomeIcons.gift,
      showBackButton: true,
    );
  }
}
