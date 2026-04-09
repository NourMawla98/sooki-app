import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLabel = 'Home';

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
          'Add Address',
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label selector
              _buildSectionTitle('Address Label'),
              const SizedBox(height: 8),
              Row(
                children: ['Home', 'Office', 'Other'].map((label) {
                  final isSelected = _selectedLabel == label;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      selectedColor: AppColors.primaryPurple,
                      backgroundColor: AppColors.white,
                      labelStyle: AppTextStyles.bodySmall.copyWith(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryPurple
                              : AppColors.gray200,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedLabel = label);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              _buildSectionTitle('Contact Information'),
              const SizedBox(height: 8),
              _buildTextField(
                label: 'Full Name',
                hint: 'John Doe',
                icon: FontAwesomeIcons.user,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Phone Number',
                hint: '+1 (555) 123-4567',
                icon: FontAwesomeIcons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              _buildSectionTitle('Address Details'),
              const SizedBox(height: 8),
              _buildTextField(
                label: 'Street Address',
                hint: '123 Main Street',
                icon: FontAwesomeIcons.road,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Apt / Suite / Floor',
                hint: 'Apt 4B (optional)',
                icon: FontAwesomeIcons.building,
                isRequired: false,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'City',
                      hint: 'New York',
                      icon: FontAwesomeIcons.city,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      label: 'State',
                      hint: 'NY',
                      icon: FontAwesomeIcons.mapPin,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'ZIP Code',
                      hint: '10001',
                      icon: FontAwesomeIcons.envelopeOpenText,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      label: 'Country',
                      hint: 'United States',
                      icon: FontAwesomeIcons.globe,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Set as default checkbox
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (_) {},
                      activeColor: AppColors.primaryPurple,
                    ),
                    Text(
                      'Set as default address',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address saved! (mock)'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save Address',
                    style: AppTextStyles.buttonLarge,
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(
          color: AppColors.gray500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required FaIconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTextStyles.bodySmall,
        hintStyle: AppTextStyles.inputHint,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: FaIcon(icon, size: 16, color: AppColors.gray400),
        ),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryPurple,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
