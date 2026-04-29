import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// Aurora-styled phone field with integrated country picker.
///
/// Focused state uses the same gradient-border pattern as [AuroraInputField].
/// The [controller] stores only the local number digits; the selected country
/// code is managed internally. Set [defaultCountryCode] to an ISO-3166-1
/// alpha-2 code (e.g. 'LB', 'US') to override the default Lebanon preset.
class AuroraPhoneField extends StatefulWidget {
  final String? label;
  final bool required;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String defaultCountryCode;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final String? errorText;
  final VoidCallback? onBlur;

  const AuroraPhoneField({
    super.key,
    this.label,
    this.required = false,
    this.controller,
    this.focusNode,
    this.defaultCountryCode = 'LB',
    this.onChanged,
    this.textInputAction,
    this.errorText,
    this.onBlur,
  });

  @override
  State<AuroraPhoneField> createState() => _AuroraPhoneFieldState();
}

class _AuroraPhoneFieldState extends State<AuroraPhoneField> {
  late Country _country;
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _country = CountryParser.parseCountryCode(widget.defaultCountryCode);
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _hasText = widget.controller?.text.isNotEmpty ?? false;
    widget.controller?.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    widget.controller?.removeListener(_onTextChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() => _isFocused = _focusNode.hasFocus);
      if (!_focusNode.hasFocus) widget.onBlur?.call();
    }
  }

  void _onTextChange() {
    if (mounted) {
      final hasText = widget.controller?.text.isNotEmpty ?? false;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    }
  }

  void _pickCountry(bool isDark) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        backgroundColor:
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
        textStyle: AppTextStyles.dsBody.copyWith(
          color: isDark ? AppColors.white : AppColors.auroraDeepBase,
          fontSize: 14,
        ),
        searchTextStyle: AppTextStyles.dsBody.copyWith(
          color: isDark ? AppColors.white : AppColors.auroraDeepBase,
          fontSize: 14,
        ),
        inputDecoration: InputDecoration(
          hintText: 'Search',
          hintStyle: AppTextStyles.dsBody.copyWith(
            color: isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight,
          ),
          prefixIcon: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 14,
            color: isDark
                ? AppColors.white.withValues(alpha: 0.4)
                : AppColors.auroraPurple.withValues(alpha: 0.5),
          ),
          filled: true,
          fillColor: isDark
              ? AppColors.white.withValues(alpha: 0.06)
              : AppColors.auroraPurple.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.10)
                  : AppColors.auroraPurple.withValues(alpha: 0.18),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.10)
                  : AppColors.auroraPurple.withValues(alpha: 0.18),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.auroraPurple.withValues(alpha: 0.5),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
      onSelect: (c) => setState(() {
        _country = c;
        widget.controller?.clear();
        widget.onChanged?.call('');
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final labelColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final hintColor =
            isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;
        final borderAlpha = _hasText
            ? (isDark ? 0.32 : 0.50)
            : (isDark ? 0.12 : 0.28);
        final borderNormal = isDark
            ? AppColors.white.withValues(alpha: borderAlpha)
            : AppColors.auroraPurple.withValues(alpha: borderAlpha);
        final dividerColor = isDark
            ? AppColors.white.withValues(alpha: 0.10)
            : AppColors.auroraPurple.withValues(alpha: 0.18);
        final chevronColor = isDark
            ? AppColors.white.withValues(alpha: 0.38)
            : AppColors.auroraPurple.withValues(alpha: 0.45);

        final phoneRow = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _pickCountry(isDark),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _country.flagEmoji,
                        style: const TextStyle(fontSize: 18, height: 1),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '+${_country.phoneCode}',
                        style: AppTextStyles.dsBody.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      FaIcon(
                        FontAwesomeIcons.chevronDown,
                        size: 9,
                        color: chevronColor,
                      ),
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: 22, color: dividerColor),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: widget.textInputAction,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[\d\s\-()+]')),
                  ],
                  onChanged: widget.onChanged,
                  style: AppTextStyles.dsBody.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    height: 1.0,
                  ),
                  decoration: InputDecoration(
                    hintText: _country.example,
                    hintStyle: AppTextStyles.dsBody.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: hintColor,
                      height: 1.0,
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                ),
              ),
            ],
        );

        final hasError = widget.errorText != null;

        Widget field;
        if (hasError) {
          final fieldFill = isDark
              ? AppColors.white.withValues(alpha: 0.04)
              : AppColors.white;
          field = Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: fieldFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.auroraRed, width: 1.5),
            ),
            child: phoneRow,
          );
        } else if (_isFocused) {
          final innerFill =
              isDark ? AppColors.auroraDeepBase : AppColors.white;
          field = Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.auroraGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.auroraPurple
                      .withValues(alpha: isDark ? 0.55 : 0.30),
                  blurRadius: 22,
                ),
              ],
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: innerFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: phoneRow,
            ),
          );
        } else {
          final fieldFill = isDark
              ? AppColors.white.withValues(alpha: 0.04)
              : AppColors.white;
          field = Container(
            decoration: BoxDecoration(
              color: fieldFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderNormal, width: 1.5),
            ),
            child: phoneRow,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null) ...[
              RichText(
                text: TextSpan(
                  text: widget.label!,
                  style: AppTextStyles.dsFieldLabel
                      .copyWith(color: labelColor),
                  children: widget.required
                      ? [
                          TextSpan(
                            text: ' *',
                            style: AppTextStyles.dsFieldLabel
                                .copyWith(color: AppColors.auroraPink),
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(height: 6),
            ],
            field,
            if (hasError) ...[
              const SizedBox(height: 5),
              Text(
                widget.errorText!,
                style: AppTextStyles.captionSmall.copyWith(
                  color: AppColors.auroraRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
