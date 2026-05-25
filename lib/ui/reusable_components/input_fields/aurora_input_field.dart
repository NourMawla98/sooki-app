import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

/// V2 aurora input — matches agreed HTML spec.
///
/// Error state is driven by EITHER [errorText] (manual) OR by the [validator]
/// returning a non-null string when the parent Form validates. In both cases
/// the field switches to the red-border + 4px-glow container and shows the
/// error message below. TextFormField's built-in error text is suppressed
/// (fontSize 0) so there is never double error text.
class AuroraInputField extends StatefulWidget {
  final String? label;
  final bool required;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final FaIconData? prefixIcon;
  final bool enabled;
  final bool readOnly;
  final String? errorText;
  final String? helperText;
  final int maxLines;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const AuroraInputField({
    super.key,
    this.label,
    this.required = false,
    this.hint,
    this.controller,
    this.focusNode,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.errorText,
    this.helperText,
    this.maxLines = 1,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  @override
  State<AuroraInputField> createState() => _AuroraInputFieldState();
}

class _AuroraInputFieldState extends State<AuroraInputField> {
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  bool _isFocused = false;
  bool _hasText = false;
  bool _obscureText = true;
  // Captured from validator on Form.validate()
  String? _validationError;

  @override
  void initState() {
    super.initState();
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
    if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _onTextChange() {
    if (mounted) {
      setState(() {
        _hasText = widget.controller?.text.isNotEmpty ?? false;
        _validationError = null; // clear error as user edits
      });
    }
  }

  /// Wraps [widget.validator] so validation errors are captured into state,
  /// triggering the red-border container. Uses addPostFrameCallback to avoid
  /// calling setState during a build/layout phase.
  String? _runValidator(String? value) {
    final error = widget.validator?.call(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _validationError != error) {
        setState(() => _validationError = error);
      }
    });
    return error;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        // Error: manual prop takes priority; falls back to captured validator error
        final errorMessage = widget.errorText ?? _validationError;
        final hasError = errorMessage != null;
        final isReadOnly = widget.readOnly || !widget.enabled;

        // Label and icon always match: auroraPurple (light) / white (dark)
        final labelAndIconColor =
            isDark ? AppColors.white : AppColors.auroraPurple;
        final iconColor =
            hasError ? AppColors.auroraRed : labelAndIconColor;

        final hintColor =
            isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;
        final textColor =
            isDark ? AppColors.white : AppColors.auroraDeepBase;

        // ── Inner TextField ──────────────────────────────────────────────
        // filled: false — Container provides the rounded background.
        // errorStyle is invisible — we render our own error text below.
        Widget buildTextField() {
          return TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword && _obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator != null ? _runValidator : null,
            enabled: widget.enabled && !widget.readOnly,
            readOnly: widget.readOnly,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            textInputAction: widget.textInputAction,
            textAlignVertical: widget.maxLines > 1
                ? TextAlignVertical.top
                : TextAlignVertical.center,
            style: AppTextStyles.dsBody.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
              height: 1.0,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.dsBody.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: hintColor,
                height: 1.0,
              ),
              // Single-line: icon in the dedicated prefixIcon slot (left-edge, vertically centered).
              // Multi-line: icon as an inline prefix so it sits on the same baseline as the cursor.
              prefixIcon: (widget.prefixIcon != null && widget.maxLines == 1)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 14, right: 10),
                      child: FaIcon(widget.prefixIcon!, size: 16, color: iconColor),
                    )
                  : null,
              prefix: (widget.prefixIcon != null && widget.maxLines > 1)
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FaIcon(widget.prefixIcon!, size: 16, color: iconColor),
                    )
                  : null,
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () =>
                          setState(() => _obscureText = !_obscureText),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: FaIcon(
                          _obscureText
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye,
                          size: 16,
                          color: hintColor,
                        ),
                      ),
                    )
                  : null,
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              // Zero-height error style — suppresses Flutter's built-in
              // error space entirely. We render our own error text below.
              // (Cannot use error: widget + errorText simultaneously.)
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              contentPadding: EdgeInsets.symmetric(
                // prefixIcon slot (single-line): content starts right after icon, no extra left pad.
                // prefix widget (multi-line) or no icon: add 14px left pad from the container edge.
                horizontal: (widget.prefixIcon != null && widget.maxLines == 1) ? 0 : 14,
                vertical: 12,
              ),
              isDense: true,
            ),
          );
        }

        // ── Container per state ───────────────────────────────────────────
        Widget field;

        if (hasError) {
          field = Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.04)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.auroraRed, width: 1.5),
            ),
            child: buildTextField(),
          );
        } else if (isReadOnly) {
          final roFill = isDark
              ? AppColors.white.withValues(alpha: 0.02)
              : AppColors.auroraPurple.withValues(alpha: 0.02);
          final roBorder = isDark
              ? AppColors.white.withValues(alpha: 0.16)
              : AppColors.auroraPurple.withValues(alpha: 0.30);
          field = Opacity(
            opacity: 0.70,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: roFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: roBorder, width: 1.5),
              ),
              child: buildTextField(),
            ),
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
              child: buildTextField(),
            ),
          );
        } else {
          final borderAlpha =
              _hasText ? (isDark ? 0.32 : 0.50) : (isDark ? 0.12 : 0.28);
          final borderColor = isDark
              ? AppColors.white.withValues(alpha: borderAlpha)
              : AppColors.auroraPurple.withValues(alpha: borderAlpha);
          field = Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.04)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: buildTextField(),
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
                  style: AppTextStyles.dsFieldLabel.copyWith(color: labelAndIconColor),
                  children: widget.required
                      ? [
                          TextSpan(
                            text: ' *',
                            style: AppTextStyles.dsFieldLabel.copyWith(
                              color: AppColors.auroraPink,
                            ),
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
                errorMessage,
                style: AppTextStyles.captionSmall.copyWith(
                  color: AppColors.auroraRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ] else if (widget.helperText != null) ...[
              const SizedBox(height: 5),
              Text(
                widget.helperText!,
                style: AppTextStyles.captionSmall.copyWith(
                  color: isDark
                      ? AppColors.mutedOnDark
                      : AppColors.mutedOnLight,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
