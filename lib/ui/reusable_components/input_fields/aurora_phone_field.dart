import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class AuroraPhoneField extends StatefulWidget {
  final String? label;
  final bool required;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String defaultCountryCode;
  final void Function(String)? onChanged;
  final void Function(String dialCode)? onCountryChanged;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
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
    this.onCountryChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.errorText,
    this.onBlur,
  });

  @override
  State<AuroraPhoneField> createState() => _AuroraPhoneFieldState();
}

class _AuroraPhoneFieldState extends State<AuroraPhoneField>
    with SingleTickerProviderStateMixin {
  late Country _country;
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  bool _isFocused = false;
  bool _hasText = false;

  // Overlay picker
  bool _pickerOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  final TextEditingController _searchCtrl = TextEditingController();
  late final List<Country> _allCountries;
  List<Country> _filtered = [];

  @override
  void initState() {
    super.initState();
    _country = CountryParser.parseCountryCode(widget.defaultCountryCode);
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _hasText = widget.controller?.text.isNotEmpty ?? false;
    widget.controller?.addListener(_onTextChange);
    _animController = AnimationController(
      duration: const Duration(milliseconds: 140),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _allCountries = CountryService().getAll();
    _filtered = _allCountries;
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _closePicker(animate: false);
    _animController.dispose();
    _searchCtrl.dispose();
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

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase().trim();
    _filtered = q.isEmpty
        ? _allCountries
        : _allCountries
            .where((c) =>
                c.name.toLowerCase().contains(q) ||
                c.phoneCode.contains(q) ||
                c.countryCode.toLowerCase().contains(q))
            .toList();
    _overlayEntry?.markNeedsBuild();
  }

  void _togglePicker() => _pickerOpen ? _closePicker() : _openPicker();

  void _openPicker() {
    _searchCtrl.clear();
    _filtered = _allCountries;
    setState(() => _pickerOpen = true);
    _animController.forward();
    final box = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    _overlayEntry = _buildOverlay(box.size.height);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closePicker({bool animate = true}) {
    if (!_pickerOpen) return;
    if (animate) {
      _animController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        if (mounted) setState(() => _pickerOpen = false);
      });
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() => _pickerOpen = false);
    }
  }

  OverlayEntry _buildOverlay(double fieldHeight) {
    final isDark = ThemeService.instance.isDarkMode;
    final bg = isDark ? AppColors.auroraDeepBase : AppColors.white;
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.22)
        : AppColors.auroraPurple.withValues(alpha: 0.20);
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
    final hintColor = isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;
    final searchFill = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.05);
    final dividerColor = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.auroraPurple.withValues(alpha: 0.12);

    return OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closePicker,
        child: Stack(
          children: [
            Positioned(
              width: 260,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, fieldHeight + 4),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.auroraPurple
                                  .withValues(alpha: 0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: _searchCtrl,
                                  autofocus: true,
                                  style: AppTextStyles.dsBody.copyWith(
                                    fontSize: 13,
                                    color: textColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'aurora_phone_field.search_country'.tr(),
                                    hintStyle: AppTextStyles.dsBody.copyWith(
                                      fontSize: 13,
                                      color: hintColor,
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: FaIcon(
                                        FontAwesomeIcons.magnifyingGlass,
                                        size: 12,
                                        color: hintColor,
                                      ),
                                    ),
                                    prefixIconConstraints:
                                        const BoxConstraints(
                                            minWidth: 36, minHeight: 36),
                                    filled: true,
                                    fillColor: searchFill,
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: border),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: border),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: AppColors.auroraPurple
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              Container(height: 1, color: dividerColor),
                              Flexible(
                                child: ListView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  itemCount: _filtered.length,
                                  itemBuilder: (_, i) {
                                    final c = _filtered[i];
                                    final isSelected =
                                        c.countryCode == _country.countryCode;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _country = c;
                                          widget.controller?.clear();
                                          widget.onChanged?.call('');
                                        });
                                        widget.onCountryChanged?.call('+${c.phoneCode}');
                                        _closePicker();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 9),
                                        child: Row(
                                          children: [
                                            Text(
                                              c.flagEmoji,
                                              style: const TextStyle(
                                                  fontSize: 16, height: 1),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                c.name,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: AppTextStyles.dsBody
                                                    .copyWith(
                                                  fontSize: 13,
                                                  color: isSelected
                                                      ? AppColors.auroraPink
                                                      : textColor,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w700
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            // Dial code stays in Western digits:
                                            // it is a phone identifier, not a quantity.
                                            Text(
                                              '+${c.phoneCode}',
                                              style: AppTextStyles.dsBody
                                                  .copyWith(
                                                fontSize: 12,
                                                color: isSelected
                                                    ? AppColors.auroraPink
                                                    : (isDark
                                                        ? AppColors.white
                                                            .withValues(
                                                                alpha: 0.45)
                                                        : AppColors.auroraPurple
                                                            .withValues(
                                                                alpha: 0.6)),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
              onTap: _togglePicker,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _country.flagEmoji,
                      style: const TextStyle(fontSize: 18, height: 1),
                    ),
                    const SizedBox(width: 5),
                    // Dial code stays in Western digits: it is a phone
                    // identifier, not a quantity.
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
                    AnimatedRotation(
                      turns: _pickerOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        size: 9,
                        color: chevronColor,
                      ),
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
                onSubmitted: widget.onFieldSubmitted,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-()+]')),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          field = CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              key: _fieldKey,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: fieldFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.auroraRed, width: 1.5),
              ),
              child: phoneRow,
            ),
          );
        } else if (_isFocused) {
          final innerFill =
              isDark ? AppColors.auroraDeepBase : AppColors.white;
          field = CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              key: _fieldKey,
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
            ),
          );
        } else {
          final fieldFill = isDark
              ? AppColors.white.withValues(alpha: 0.04)
              : AppColors.white;
          field = CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              key: _fieldKey,
              decoration: BoxDecoration(
                color: fieldFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderNormal, width: 1.5),
              ),
              child: phoneRow,
            ),
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
                  style:
                      AppTextStyles.dsFieldLabel.copyWith(color: labelColor),
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
