import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/route_constants.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import 'edit_address_screen.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  static const _mockAddresses = [
    _MockAddress(
      label: 'Home',
      name: 'John Doe',
      street: '123 Main Street, Apt 4B',
      city: 'New York, NY 10001',
      phone: '+1 (555) 123-4567',
      isDefault: true,
      icon: FontAwesomeIcons.house,
    ),
    _MockAddress(
      label: 'Office',
      name: 'John Doe',
      street: '456 Business Ave, Floor 12',
      city: 'New York, NY 10018',
      phone: '+1 (555) 987-6543',
      isDefault: false,
      icon: FontAwesomeIcons.building,
    ),
    _MockAddress(
      label: 'Parents',
      name: 'Jane Doe',
      street: '789 Oak Lane',
      city: 'Brooklyn, NY 11201',
      phone: '+1 (555) 456-7890',
      isDefault: false,
      icon: FontAwesomeIcons.heart,
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
          'Addresses',
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockAddresses.length,
        itemBuilder: (context, index) {
          final address = _mockAddresses[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: address.isDefault
                  ? Border.all(color: AppColors.primaryPurple, width: 2)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: FaIcon(
                            address.icon,
                            size: 16,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        address.label,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple,
                            borderRadius: BorderRadius.circular(10),
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
                      const Spacer(),
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.penToSquare,
                          size: 16,
                          color: AppColors.gray400,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            editAddressScreenRoute,
                            arguments: MockEditAddress(
                              label: address.label,
                              name: address.name,
                              phone: address.phone,
                              street: address.street.split(',')[0],
                              apt: address.street.contains(',')
                                  ? address.street.split(',')[1].trim()
                                  : '',
                              city: address.city.split(',')[0],
                              state: address.city.contains(',')
                                  ? address.city.split(',')[1].trim().split(' ')[0]
                                  : '',
                              zip: address.city.contains(' ')
                                  ? address.city.split(' ').last
                                  : '',
                              country: 'United States',
                              isDefault: address.isDefault,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(address.name, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 4),
                  Text(address.street, style: AppTextStyles.bodySmall),
                  Text(address.city, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.phone,
                        size: 12,
                        color: AppColors.gray400,
                      ),
                      const SizedBox(width: 8),
                      Text(address.phone, style: AppTextStyles.bodySmall),
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
            Navigator.pushNamed(context, addAddressScreenRoute),
        child: FaIcon(FontAwesomeIcons.plus, size: 20, color: AppColors.white),
      ),
    );
  }
}

class _MockAddress {
  const _MockAddress({
    required this.label,
    required this.name,
    required this.street,
    required this.city,
    required this.phone,
    required this.isDefault,
    required this.icon,
  });

  final String label;
  final String name;
  final String street;
  final String city;
  final String phone;
  final bool isDefault;
  final FaIconData icon;
}
