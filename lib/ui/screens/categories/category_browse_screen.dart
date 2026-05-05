import 'dart:math';

import 'package:flutter/material.dart';

import '../../../data/mock_browse_categories.dart';
import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/category_pill/aurora_subcategory_tile.dart';
import '../splash/widgets/aurora_glow_blob.dart';
import 'category_detail_args.dart';

class CategoryBrowseScreen extends StatefulWidget {
  const CategoryBrowseScreen({super.key});

  @override
  State<CategoryBrowseScreen> createState() => _CategoryBrowseScreenState();
}

class _CategoryBrowseScreenState extends State<CategoryBrowseScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? Colors.transparent : Colors.white,
          body: Stack(
            children: [
              AuroraGlowBlob(
                top: -60,
                right: -60,
                size: 280,
                color: AppColors.auroraPurple,
                intensity: isDark ? 0.18 : 0.09,
              ),
              AuroraGlowBlob(
                bottom: 60,
                left: -60,
                size: 280,
                color: AppColors.auroraElectricBlue,
                intensity: isDark ? 0.16 : 0.08,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Sidebar(
                    isDark: isDark,
                    selectedIndex: _selectedIndex,
                    onSelect: (i) => setState(() => _selectedIndex = i),
                  ),
                  Expanded(
                    child: _ContentPanel(
                      isDark: isDark,
                      category: mockBrowseCategories[_selectedIndex],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Left sidebar ─────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final bool isDark;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _Sidebar({
    required this.isDark,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final divider = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.10);

    return Container(
      width: 84,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: divider),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: mockBrowseCategories.length,
        itemBuilder: (_, i) {
          final cat = mockBrowseCategories[i];
          final isActive = i == selectedIndex;
          return _SidebarItem(
            isDark: isDark,
            imageAsset: cat.imageAsset,
            name: cat.name,
            isActive: isActive,
            onTap: () => onSelect(i),
          );
        },
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final bool isDark;
  final String imageAsset;
  final String name;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.isDark,
    required this.imageAsset,
    required this.name,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.isActive) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(_SidebarItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _ctrl.repeat();
    } else if (!widget.isActive && old.isActive) {
      _ctrl.stop();
      _ctrl.reset();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mutedText = widget.isDark
        ? AppColors.white.withValues(alpha: 0.38)
        : AppColors.auroraPurple.withValues(alpha: 0.45);

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image circle
            if (widget.isActive)
              // Rotating gradient ring with static image inside
              SizedBox(
                width: 54,
                height: 54,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Spinning sweep gradient ring
                    AnimatedBuilder(
                      animation: _ctrl,
                      builder: (_, _) => Transform.rotate(
                        angle: _ctrl.value * 2 * pi,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                AppColors.auroraPink,
                                AppColors.auroraPurple,
                                AppColors.auroraElectricBlue,
                                AppColors.auroraPink,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Static image circle
                    ClipOval(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.asset(
                          widget.imageAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              // Inactive: plain circle with faint border
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isDark
                        ? AppColors.white.withValues(alpha: 0.12)
                        : AppColors.auroraPurple.withValues(alpha: 0.18),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    widget.imageAsset,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 5),
            // Label
            widget.isActive
                ? ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.auroraPink, AppColors.auroraPurple],
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.captionSmall.copyWith(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                  )
                : Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.captionSmall.copyWith(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: mutedText,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ─── Right content panel ──────────────────────────────────────────────────────

class _ContentPanel extends StatelessWidget {
  final bool isDark;
  final BrowseMainCategory category;

  const _ContentPanel({required this.isDark, required this.category});

  @override
  Widget build(BuildContext context) {
    final nameColor = isDark ? AppColors.white : AppColors.auroraPurple;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: category name + Browse All link
          Row(
            children: [
              Text(
                category.name,
                style: AppTextStyles.heading3.copyWith(
                  color: nameColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  categoryDetailScreenRoute,
                  arguments: CategoryDetailArgs(mainCategory: category.name),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: AppColors.auroraGradient,
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'Browse All →',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Subcategory circle grid (3 col)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 12,
              mainAxisExtent: 133,
            ),
            itemCount: category.subcategories.length,
            itemBuilder: (_, i) {
              final sub = category.subcategories[i];
              return AuroraSubcategoryTile(
                imageAsset: sub.imageAsset,
                label: sub.label,
                onTap: () => Navigator.pushNamed(
                  context,
                  categoryDetailScreenRoute,
                  arguments: CategoryDetailArgs(
                    mainCategory: category.name,
                    subCategory: sub.label,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
