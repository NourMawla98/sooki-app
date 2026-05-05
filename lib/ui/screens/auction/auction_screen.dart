import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../reusable_components/coming_soon/coming_soon_screen.dart';

class AuctionScreen extends StatelessWidget {
  const AuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      featureName: 'AUCTION',
      tagline: 'Bid, win, and own it. Live auctions are on their way.',
      icon: FontAwesomeIcons.gavel,
    );
  }
}
