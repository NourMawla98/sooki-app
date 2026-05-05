import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../enums/app_language.dart';
import '../../../services/language_service.dart';
import '../../../services/theme_service.dart';
import '../../../themes/themes.dart';

class LanguageSelector extends StatefulWidget {
  final ValueChanged<String>? onLanguageChanged;

  const LanguageSelector({super.key, this.onLanguageChanged});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector>
    with SingleTickerProviderStateMixin {
  late final LanguageService _languageService =
      serviceLocator<LanguageService>();
  late AppLanguage _selected = _languageService.currentLanguage;

  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const _radius = 10.0;

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

  void _toggleDropdown() => _isOpen ? _closeDropdown() : _openDropdown();

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

  Future<void> _applyLanguage(AppLanguage language) async {
    if (language == _selected) return;
    await _languageService.setLanguage(language, context: context);
    if (!mounted) return;
    setState(() => _selected = language);
    widget.onLanguageChanged?.call(language.displayName);
  }

  OverlayEntry _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final isDark = ThemeService.instance.isDarkMode;
    final bg = isDark ? AppColors.auroraDeepBase : AppColors.white;
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.22)
        : AppColors.auroraPurple.withValues(alpha: 0.20);
    final itemTextColor = isDark ? AppColors.white : AppColors.auroraDeepBase;

    return OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height - 2),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(height: 3, color: bg),
                            ...AppLanguage.values.map((lang) {
                            final isSelected = lang == _selected;
                            return GestureDetector(
                              onTap: () async {
                                _closeDropdown();
                                await _applyLanguage(lang);
                              },
                              child: Container(
                                width: double.infinity,
                                color: bg,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                child: Text(
                                  lang.displayName,
                                  style: AppTextStyles.dsBody.copyWith(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.auroraPink
                                        : itemTextColor,
                                  ),
                                ),
                              ),
                            );
                          }),
                          ],
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
        final bg = isDark ? AppColors.auroraDeepBase : AppColors.white;
        final border = isDark
            ? AppColors.white.withValues(alpha: 0.22)
            : AppColors.auroraPurple.withValues(alpha: 0.20);
        final textColor = isDark ? AppColors.white : AppColors.auroraPurple;

        final decoration = _isOpen
            ? BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(_radius),
                ),
                border: Border(
                  top: BorderSide(color: border, width: 1.5),
                  left: BorderSide(color: border, width: 1.5),
                  right: BorderSide(color: border, width: 1.5),
                ),
              )
            : BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(_radius),
                border: Border.all(color: border, width: 1.5),
              );

        return CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: decoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selected.displayName,
                    style: AppTextStyles.dsBody.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: FaIcon(
                      FontAwesomeIcons.chevronDown,
                      color: textColor,
                      size: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
