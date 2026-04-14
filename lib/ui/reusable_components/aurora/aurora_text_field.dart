import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Theme-aware aurora text field. Mirrors the API surface of [CustomTextField]
/// (label, hint, controller, isPassword, validator, prefixIcon) but renders
/// with the aurora dark-glass / light-glass treatment and a focus glow.
class AuroraTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final bool enabled;

  const AuroraTextField({
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
  State<AuroraTextField> createState() => _AuroraTextFieldState();
}

class _AuroraTextFieldState extends State<AuroraTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        final fill = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.white.withValues(alpha: 0.85);
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.gray200;
        final focused = isDark
            ? AppColors.auroraPink
            : AppColors.auroraPurple;
        final textColor =
            isDark ? AppColors.white : AppColors.primaryPurple;
        final hintColor = isDark
            ? AppColors.white.withValues(alpha: 0.4)
            : AppColors.gray400;
        final labelColor = isDark ? AppColors.white : AppColors.primaryPurple;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: AppTextStyles.inputLabel.copyWith(color: labelColor),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword && _obscureText,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              enabled: widget.enabled,
              style: AppTextStyles.inputText.copyWith(color: textColor),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle:
                    AppTextStyles.inputHint.copyWith(color: hintColor),
                prefixIcon: widget.prefixIcon != null
                    ? Center(child: widget.prefixIcon)
                    : null,
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 56, maxWidth: 56),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: FaIcon(
                          _obscureText
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye,
                          color: hintColor,
                          size: 18,
                        ),
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      )
                    : null,
                filled: true,
                fillColor: fill,
                border: _outline(border),
                enabledBorder: _outline(border),
                focusedBorder: _outline(focused, width: 2),
                errorBorder: _outline(AppColors.error),
                focusedErrorBorder: _outline(AppColors.error, width: 2),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  OutlineInputBorder _outline(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
}
