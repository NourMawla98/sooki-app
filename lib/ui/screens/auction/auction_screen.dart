import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../reusable_components/coming_soon/coming_soon_screen.dart';

class AuctionScreen extends StatelessWidget {
  const AuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonScreen(
      featureName: 'auction_screen.feature_name'.tr(),
      tagline: 'auction_screen.tagline'.tr(),
      icon: FontAwesomeIcons.gavel,
    );
  }
}
