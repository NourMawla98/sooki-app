import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../themes/themes.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.inputLabel,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          enabled: widget.enabled,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: widget.prefixIcon != null
                ? Center(child: widget.prefixIcon)
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 56,
              maxWidth: 56,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: FaIcon(
                      _obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                      color: AppColors.gray400,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderMedium),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderMedium),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryPurple, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
