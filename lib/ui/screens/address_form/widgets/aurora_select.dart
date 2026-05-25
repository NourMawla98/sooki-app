import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

/// Aurora-styled select field that opens an inline overlay dropdown below
/// the trigger, matching the LanguageSelector pattern.
class AuroraSelect extends StatefulWidget {
  final String? value;
  final String hint;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final FaIconData? prefixIcon;
  final bool enabled;
  // sheetTitle kept for API compatibility but unused in overlay mode
  final String sheetTitle;

  const AuroraSelect({
    super.key,
    required this.value,
    required this.hint,
    required this.options,
    required this.onChanged,
    required this.sheetTitle,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  State<AuroraSelect> createState() => _AuroraSelectState();
}

class _AuroraSelectState extends State<AuroraSelect>
    with SingleTickerProviderStateMixin {
  static const _radius = 12.0;
  static const _maxDropdownHeight = 240.0;

  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 140),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _closeDropdown(animate: false);
    _animController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.enabled || widget.options.isEmpty) return;
    _isOpen ? _closeDropdown() : _openDropdown();
  }

  void _openDropdown() {
    setState(() => _isOpen = true);
    _animController.forward();
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown({bool animate = true}) {
    if (!_isOpen) return;
    if (animate) {
      _animController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        if (mounted) setState(() => _isOpen = false);
      });
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() => _isOpen = false);
    }
  }

  void _pick(String value) {
    _closeDropdown();
    widget.onChanged(value);
  }

  OverlayEntry _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final triggerWidth = renderBox.size.width;
    final triggerHeight = renderBox.size.height;
    final isDark = ThemeService.instance.isDarkMode;

    final bg = isDark ? AppColors.auroraDeepBase : AppColors.white;
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.22)
        : AppColors.auroraPurple.withValues(alpha: 0.20);
    final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;

    return OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            Positioned(
              width: triggerWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, triggerHeight - 2),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: _maxDropdownHeight),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(_radius),
                        ),
                        border: Border(
                          left: BorderSide(color: border, width: 1.5),
                          right: BorderSide(color: border, width: 1.5),
                          bottom: BorderSide(color: border, width: 1.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.auroraPurple.withValues(alpha: 0.10),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(_radius),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 4, bottom: 6),
                          shrinkWrap: true,
                          itemCount: widget.options.length,
                          itemBuilder: (_, i) {
                            final opt = widget.options[i];
                            final isSelected = opt == widget.value;
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _pick(opt),
                              child: Container(
                                width: double.infinity,
                                color: bg,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 11,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        opt,
                                        style: AppTextStyles.dsBody.copyWith(
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? AppColors.auroraPurple
                                              : textColor,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      FaIcon(
                                        FontAwesomeIcons.check,
                                        size: 11,
                                        color: AppColors.auroraPurple,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
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
        final hasValue = widget.value != null && widget.value!.isNotEmpty;

        final fill = isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.white;
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.22)
            : AppColors.auroraPurple.withValues(alpha: 0.28);
        final openBorder = isDark
            ? AppColors.white.withValues(alpha: 0.22)
            : AppColors.auroraPurple.withValues(alpha: 0.28);
        final iconColor = isDark ? AppColors.white : AppColors.auroraPurple;
        final textColor = isDark ? AppColors.white : AppColors.auroraDeepBase;
        final hintColor = isDark ? AppColors.mutedOnDark : AppColors.mutedOnLight;
        final chevronColor = isDark
            ? AppColors.white.withValues(alpha: 0.35)
            : AppColors.auroraDeepBase.withValues(alpha: 0.45);

        final decoration = _isOpen
            ? BoxDecoration(
                color: fill,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(_radius),
                ),
                border: Border(
                  top: BorderSide(color: openBorder, width: 1.5),
                  left: BorderSide(color: openBorder, width: 1.5),
                  right: BorderSide(color: openBorder, width: 1.5),
                ),
              )
            : BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(_radius),
                border: Border.all(color: border, width: 1.5),
              );

        return CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggleDropdown,
            child: Opacity(
              opacity: widget.enabled ? 1.0 : 0.5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: decoration,
                child: Row(
                  children: [
                    if (widget.prefixIcon != null) ...[
                      FaIcon(widget.prefixIcon!, size: 16, color: iconColor),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        hasValue ? widget.value! : widget.hint,
                        style: AppTextStyles.dsBody.copyWith(
                          fontSize: 14,
                          fontWeight:
                              hasValue ? FontWeight.w600 : FontWeight.normal,
                          color: hasValue ? textColor : hintColor,
                          height: 1.0,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        size: 12,
                        color: chevronColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
