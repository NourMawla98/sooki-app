import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../reusable_components/coming_soon/coming_soon_screen.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      featureName: 'PAYMENT METHODS',
      tagline: 'Securely save your cards for faster checkout. Almost here.',
      icon: FontAwesomeIcons.creditCard,
      showBackButton: true,
    );
  }
}
