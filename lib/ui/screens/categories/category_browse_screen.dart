import 'dart:math';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../backend_integration/apis/categories_api.dart';
import '../../../backend_integration/dependency_injection/dependency_injection.dart';
import '../../../backend_integration/dtos/category/category_dto.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';
import '../../reusable_components/category_pill/aurora_subcategory_tile.dart';
import '../../reusable_components/skeleton/skeleton_shimmer.dart';
import '../splash/widgets/aurora_glow_blob.dart';
import 'category_detail_args.dart';

class CategoryBrowseScreen extends StatefulWidget {
  const CategoryBrowseScreen({super.key});

  @override
  State<CategoryBrowseScreen> createState() => _CategoryBrowseScreenState();
}

class _CategoryBrowseScreenState extends State<CategoryBrowseScreen> {
  List<CategoryDto> _categories = [];
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    final result = await serviceLocator<CategoriesApi>().getCategories();
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _isLoading = false;
        _hasError = true;
      }),
      (categories) => setState(() {
        _categories = categories;
        _selectedIndex = 0;
        _isLoading = false;
      }),
    );
  }

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
              if (_isLoading)
                _SkeletonBody(isDark: isDark)
              else if (_hasError)
                _ErrorBody(isDark: isDark, onRetry: _fetchCategories)
              else if (_categories.isEmpty)
                const SizedBox.shrink()
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Sidebar(
                      isDark: isDark,
                      categories: _categories,
                      selectedIndex: _selectedIndex,
                      onSelect: (i) => setState(() => _selectedIndex = i),
                    ),
                    Expanded(
                      child: _ContentPanel(
                        isDark: isDark,
                        category: _categories[_selectedIndex],
                        onRefresh: _fetchCategories,
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

// ─── Skeleton ─────────────────────────────────────────────────────────────────

class _SkeletonBody extends StatelessWidget {
  final bool isDark;
  const _SkeletonBody({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final divider = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.10);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sidebar skeleton
        Container(
          width: 84,
          decoration: BoxDecoration(
            border: BorderDirectional(end: BorderSide(color: divider)),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: 6,
            itemBuilder: (_, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: SkeletonShimmer(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(
                    width: 48,
                    height: 9,
                    child: SkeletonShimmer(),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Content skeleton
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 14, 12, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      height: 17,
                      child: SkeletonShimmer(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 72,
                      height: 12,
                      child: SkeletonShimmer(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 133,
                  ),
                  itemCount: 6,
                  itemBuilder: (_, _) => SkeletonShimmer(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Error ────────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  final bool isDark;
  final VoidCallback onRetry;
  const _ErrorBody({required this.isDark, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final mutedText = isDark
        ? AppColors.white.withValues(alpha: 0.55)
        : AppColors.primaryPurple.withValues(alpha: 0.65);

    return Center(
      child: GestureDetector(
        onTap: onRetry,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded, color: mutedText, size: 36),
            const SizedBox(height: 8),
            Text(
              'category_browse_screen.tap_to_retry'.tr(),
              style: AppTextStyles.caption.copyWith(color: mutedText),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Left sidebar ─────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final bool isDark;
  final List<CategoryDto> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _Sidebar({
    required this.isDark,
    required this.categories,
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
        border: BorderDirectional(end: BorderSide(color: divider)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categories.length,
        itemBuilder: (_, i) => _SidebarItem(
          isDark: isDark,
          imageUrl: categories[i].imageUrl,
          name: categories[i].name,
          isActive: i == selectedIndex,
          onTap: () => onSelect(i),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final bool isDark;
  final String? imageUrl;
  final String name;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.isDark,
    required this.imageUrl,
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
            if (widget.isActive)
              SizedBox(
                width: 54,
                height: 54,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
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
                    ClipOval(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: _CategoryImage(imageUrl: widget.imageUrl),
                      ),
                    ),
                  ],
                ),
              )
            else
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
                  child: _CategoryImage(imageUrl: widget.imageUrl),
                ),
              ),
            const SizedBox(height: 5),
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

class _CategoryImage extends StatelessWidget {
  final String? imageUrl;
  const _CategoryImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(color: AppColors.skeletonBase);
    if (imageUrl == null || imageUrl!.isEmpty) return placeholder;
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : placeholder,
    );
  }
}

// ─── Right content panel ──────────────────────────────────────────────────────

class _ContentPanel extends StatelessWidget {
  final bool isDark;
  final CategoryDto category;
  final Future<void> Function() onRefresh;

  const _ContentPanel({
    required this.isDark,
    required this.category,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final nameColor = isDark ? AppColors.white : AppColors.auroraPurple;
    final subcategories = category.subCategories;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.auroraPink,
      child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(12, 14, 12, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  arguments: CategoryDetailArgs(mainCategory: category),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: AppColors.auroraGradient,
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'category_browse_screen.browse_all'.tr(),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      FaIcon(
                        isRtl
                            ? FontAwesomeIcons.chevronLeft
                            : FontAwesomeIcons.chevronRight,
                        size: 10,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (subcategories.isEmpty) ...[
            const SizedBox(height: 32),
            Center(
              child: Text(
                'category_browse_screen.no_subcategories_yet'.tr(),
                style: AppTextStyles.caption.copyWith(
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.35)
                      : AppColors.auroraPurple.withValues(alpha: 0.45),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 12,
                mainAxisExtent: 133,
              ),
              itemCount: subcategories.length,
              itemBuilder: (_, i) {
                final sub = subcategories[i];
                return AuroraSubcategoryTile(
                  imageUrl: sub.imageUrl,
                  label: sub.name,
                  onTap: () => Navigator.pushNamed(
                    context,
                    categoryDetailScreenRoute,
                    arguments: CategoryDetailArgs(
                      mainCategory: category,
                      subCategory: sub,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    ),
    );
  }
}
