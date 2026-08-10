import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../reusable_components/coming_soon/coming_soon_screen.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonScreen(
      featureName: 'payment_methods_screen.feature_name'.tr(),
      tagline: 'payment_methods_screen.tagline'.tr(),
      icon: FontAwesomeIcons.creditCard,
      showBackButton: true,
    );
  }
}
