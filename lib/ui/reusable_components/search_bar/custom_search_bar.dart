import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_fonts.dart';
import '../../../themes/app_text_styles.dart';

/// Aurora search pill. Full capsule, no border.
/// Idle: subtle tint fill. Focused: soft, wide aurora halo bloom.
class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final focused = _focusNode.hasFocus;

        // Light fill must be the vivid aurora purple — the muted
        // primaryPurple renders as near-gray at low alpha.
        final fill = isDark
            ? AppColors.white.withValues(alpha: 0.10)
            : AppColors.auroraPurple.withValues(alpha: 0.10);

        final placeholder = isDark
            ? AppColors.white.withValues(alpha: 0.45)
            : AppColors.primaryPurple.withValues(alpha: 0.40);

        final textColor = isDark ? AppColors.white : AppColors.primaryPurple;

        final iconColor = focused
            ? AppColors.auroraElectricBlue
            : (isDark
                ? AppColors.white.withValues(alpha: 0.50)
                : AppColors.primaryPurple.withValues(alpha: 0.45));

        // Tight, tasteful aurora halo — a hint of color right at the pill
        // edge. No second layer; a wide echo bleeds into surrounding UI.
        final glow = focused
            ? [
                BoxShadow(
                  color: isDark
                      ? AppColors.auroraElectricBlue.withValues(alpha: 0.25)
                      : AppColors.auroraPurple.withValues(alpha: 0.20),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ]
            : <BoxShadow>[];

        return Container(
          height: 44,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(22),
            boxShadow: glow,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                size: 14,
                color: iconColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  cursorColor: AppColors.auroraElectricBlue,
                  style: AppFonts.primary(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    // Override the global InputDecorationTheme's filled:true.
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Search for products...',
                    hintStyle: AppTextStyles.inputHint.copyWith(
                      color: placeholder,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
