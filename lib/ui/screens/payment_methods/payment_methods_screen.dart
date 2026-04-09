import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/route_constants.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  static const _mockCards = [
    _MockCard(
      type: 'Visa',
      lastFour: '4242',
      expiryDate: '12/27',
      holderName: 'John Doe',
      icon: FontAwesomeIcons.ccVisa,
      gradientStart: Color(0xFF1A1A2E),
      gradientEnd: Color(0xFF16213E),
      isDefault: true,
    ),
    _MockCard(
      type: 'Mastercard',
      lastFour: '8531',
      expiryDate: '08/26',
      holderName: 'John Doe',
      icon: FontAwesomeIcons.ccMastercard,
      gradientStart: Color(0xFF4D4C7D),
      gradientEnd: Color(0xFF6B6AA3),
      isDefault: false,
    ),
    _MockCard(
      type: 'Apple Pay',
      lastFour: '9012',
      expiryDate: '03/28',
      holderName: 'John Doe',
      icon: FontAwesomeIcons.ccApplePay,
      gradientStart: Color(0xFF2D3436),
      gradientEnd: Color(0xFF636E72),
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: 20,
            color: AppColors.primaryPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Methods',
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockCards.length,
        itemBuilder: (context, index) {
          final card = _mockCards[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 190,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [card.gradientStart, card.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FaIcon(card.icon, size: 32, color: AppColors.white),
                      if (card.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Default',
                            style: AppTextStyles.captionSmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '**** **** **** ${card.lastFour}',
                    style: AppTextStyles.heading4.copyWith(
                      color: AppColors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARD HOLDER',
                            style: AppTextStyles.captionSmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.6),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            card.holderName,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'EXPIRES',
                            style: AppTextStyles.captionSmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.6),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            card.expiryDate,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryPurple,
        onPressed: () =>
            Navigator.pushNamed(context, addCardScreenRoute),
        child: FaIcon(FontAwesomeIcons.plus, size: 20, color: AppColors.white),
      ),
    );
  }
}

class _MockCard {
  const _MockCard({
    required this.type,
    required this.lastFour,
    required this.expiryDate,
    required this.holderName,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.isDefault,
  });

  final String type;
  final String lastFour;
  final String expiryDate;
  final String holderName;
  final FaIconData icon;
  final Color gradientStart;
  final Color gradientEnd;
  final bool isDefault;
}
