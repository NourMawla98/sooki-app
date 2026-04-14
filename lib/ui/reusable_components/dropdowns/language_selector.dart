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
  late final LanguageService _languageService = serviceLocator<LanguageService>();
  late AppLanguage _selected = _languageService.currentLanguage;

  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _closeDropdown();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() => _isOpen = true);
    _animationController.forward();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    if (!_isOpen) return;
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() => _isOpen = false);
    });
  }

  Future<void> _applyLanguage(AppLanguage language) async {
    if (language == _selected) return;
    await _languageService.setLanguage(language, context: context);
    if (!mounted) return;
    setState(() => _selected = language);
    widget.onLanguageChanged?.call(language.displayName);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            Positioned(
              width: 140,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(-35, size.height + 5),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryPurple
                              .withValues(alpha: 0.15),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: AppLanguage.values
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final language = entry.value;
                            final isSelected = language == _selected;
                            final isLast =
                                index == AppLanguage.values.length - 1;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _DropdownItem(
                                  language: language.displayName,
                                  isSelected: isSelected,
                                  onTap: () async {
                                    _closeDropdown();
                                    await _applyLanguage(language);
                                  },
                                ),
                                if (!isLast)
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    indent: 12,
                                    endIndent: 12,
                                    color: AppColors.primaryPurple
                                        .withValues(alpha: 0.06),
                                  ),
                              ],
                            );
                          }).toList(),
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
        final fg = isDark ? AppColors.white : AppColors.primaryPurple;
        final bg = isDark
            ? AppColors.white.withValues(alpha: 0.2)
            : AppColors.primaryPurple.withValues(alpha: 0.08);
        final borderColor = isDark
            ? AppColors.white.withValues(alpha: 0.3)
            : AppColors.primaryPurple.withValues(alpha: 0.25);
        return CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: InkWell(
              onTap: _toggleDropdown,
              borderRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selected.displayName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: FaIcon(
                      FontAwesomeIcons.chevronDown,
                      color: fg,
                      size: 14,
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

class _DropdownItem extends StatefulWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const _DropdownItem({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          color: widget.isSelected
              ? AppColors.primaryPurple.withValues(alpha: 0.1)
              : _isHovered
              ? AppColors.primaryPurple.withValues(alpha: 0.04)
              : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.language,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: widget.isSelected
                      ? AppColors.primaryPurple
                      : AppColors.textPrimary,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
              if (widget.isSelected)
                FaIcon(
                  FontAwesomeIcons.check,
                  color: AppColors.primaryPurple,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
