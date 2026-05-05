import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../reusable_components/coming_soon/coming_soon_screen.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      featureName: 'LOYALTY',
      tagline: 'Rewards that actually reward you. Almost here.',
      icon: FontAwesomeIcons.gift,
      showBackButton: true,
    );
  }
}
