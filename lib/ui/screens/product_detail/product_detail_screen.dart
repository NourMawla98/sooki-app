import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../backend_integration/apis/items_api.dart';
import '../../../models/review.dart';
import '../../../services/viewed_items_service.dart';
import '../../../backend_integration/dtos/item/item_detail_dto.dart';
import '../../../backend_integration/dtos/item/item_tag_dto.dart';
import '../../../routes/route_constants.dart';
import '../../../services/theme_service.dart';
import '../../../services/toast_service.dart';
import '../../../services/wishlist_service.dart';
import '../../../themes/themes.dart';
import '../image_viewer/image_viewer_screen.dart';
import '../../../ui/reusable_components/skeleton/skeleton_shimmer.dart';
import '../../../ui/reusable_components/swatch/color_swatch_type.dart';
import 'widgets/color_selector.dart';
import 'widgets/image_gallery.dart';
import 'widgets/price_quantity_row.dart';
import 'widgets/product_info.dart';
import 'widgets/product_tabs.dart';
import 'widgets/size_guide_sheet.dart';
import 'widgets/size_selector.dart';
import 'widgets/sticky_bottom_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final int itemId;

  const ProductDetailScreen({super.key, required this.itemId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final WishlistService _wishlist = GetIt.instance<WishlistService>();
  final ItemsApi _itemsApi = GetIt.instance<ItemsApi>();
  final ViewedItemsService _viewedItems = GetIt.instance<ViewedItemsService>();
  final GlobalKey<ImageGalleryState> _galleryKey = GlobalKey();

  Timer? _dwellTimer;

  ItemDetailDto? _item;
  bool _loading = true;
  String? _error;

  ItemDetailColorDto? _selectedColor;
  ItemDetailSizeDto? _selectedSize;
  int _quantity = 1;

  List<String> _masterImages = [];
  Map<int, int> _colorFirstIndex = {};

  final ScrollController _reviewsScrollController = ScrollController();
  List<Review> _reviews = [];
  bool _reviewsLoadingMore = false;
  bool _reviewsIsLastPage = false;
  int _reviewsTotalCount = 0;
  static const int _reviewsTake = 10;

  @override
  void initState() {
    super.initState();
    _fetchItem();
    _dwellTimer = Timer(
      const Duration(seconds: 3),
      () => _viewedItems.record(widget.itemId),
    );
    _reviewsScrollController.addListener(_onReviewsScroll);
  }

  @override
  void dispose() {
    _dwellTimer?.cancel();
    _reviewsScrollController.dispose();
    super.dispose();
  }

  void _onReviewsScroll() {
    final pos = _reviewsScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300 &&
        !_reviewsLoadingMore &&
        !_reviewsIsLastPage) {
      _fetchMoreReviews();
    }
  }

  Future<void> _fetchReviews() async {
    final result = await _itemsApi.getReviews(widget.itemId, skip: 0, take: _reviewsTake);
    if (!mounted) return;
    result.fold(
      (_) {},
      (page) => setState(() {
        _reviews = page.reviews;
        _reviewsIsLastPage = page.isLastPage;
        _reviewsTotalCount = page.totalCount;
      }),
    );
  }

  Future<void> _fetchMoreReviews() async {
    if (_reviewsLoadingMore || _reviewsIsLastPage) return;
    setState(() => _reviewsLoadingMore = true);
    final result = await _itemsApi.getReviews(
      widget.itemId,
      skip: _reviews.length,
      take: _reviewsTake,
    );
    if (!mounted) return;
    result.fold(
      (_) {},
      (page) => setState(() {
        _reviews = [..._reviews, ...page.reviews];
        _reviewsIsLastPage = page.isLastPage;
      }),
    );
    setState(() => _reviewsLoadingMore = false);
  }

  Future<void> _fetchItem() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await _itemsApi.getItemById(widget.itemId);
    if (!mounted) return;
    result.fold(
      (err) => setState(() {
        _loading = false;
        _error = err.message;
      }),
      (item) {
        _item = item;
        _buildMasterImages(item);
        final firstAvailable = item.colors
            .where((c) => c.sizes.isEmpty || c.sizes.any((s) => s.stock > 0))
            .firstOrNull;
        _selectedColor = firstAvailable ?? item.colors.firstOrNull;
        setState(() => _loading = false);
        _fetchReviews();
      },
    );
  }

  void _buildMasterImages(ItemDetailDto item) {
    final images = <String>[];
    final colorIndex = <int, int>{};
    for (final color in item.colors) {
      final urls = color.media.map((m) => m.url).toList();
      if (urls.isNotEmpty) {
        colorIndex[color.id] = images.length;
        images.addAll(urls);
      }
    }
    _masterImages = images;
    _colorFirstIndex = colorIndex;
  }

  String? get _mainImageUrl {
    if (_selectedColor == null) return null;
    final main = _selectedColor!.media.where((m) => m.isMain).firstOrNull;
    return main?.url ?? _selectedColor!.media.firstOrNull?.url;
  }

  double get _effectivePrice {
    final base = _item?.discountedPrice ?? _item?.originalPrice ?? 0.0;
    final extra = _selectedSize?.additionalPrice ?? 0.0;
    return base + extra;
  }

  int get _currentStock {
    if (_selectedSize != null) return _selectedSize!.stock;
    return _item?.stock ?? 999;
  }

  List<ItemDetailSizeDto> get _currentSizes =>
      _selectedColor?.sizes ?? [];

  bool get _hasSizes => _currentSizes.isNotEmpty;

  ItemDetailColorDto? _colorForImageIndex(int index) {
    final item = _item;
    if (item == null) return null;
    ItemDetailColorDto? owner;
    var bestStart = -1;
    for (final color in item.colors) {
      final start = _colorFirstIndex[color.id];
      if (start == null) continue;
      if (start <= index && start > bestStart) {
        bestStart = start;
        owner = color;
      }
    }
    return owner;
  }

  void _onColorSelected(ItemDetailColorDto color) {
    final newStock = _item?.stock ?? 999;
    setState(() {
      _selectedColor = color;
      _selectedSize = null;
      if (newStock > 0 && _quantity > newStock) _quantity = newStock;
    });
    final target = _colorFirstIndex[color.id];
    if (target != null) {
      _galleryKey.currentState?.jumpToIndex(target);
    }
  }

  void _onGalleryIndexChanged(int index) {
    final owner = _colorForImageIndex(index);
    if (owner == null || owner == _selectedColor) return;
    final available = owner.sizes.isEmpty || owner.sizes.any((s) => s.stock > 0);
    if (!available) return;
    setState(() {
      _selectedColor = owner;
      _selectedSize = null;
    });
  }

  void _showSizeGuide() {
    SizeGuideSheet.show(
      context,
      sizeStandardId: _selectedColor?.sizes.firstOrNull?.sizeStandardId,
      selectedLabel: _selectedSize?.displayValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService.instance, _wishlist]),
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final bgColor =
            isDark ? AppColors.auroraDeepBase : AppColors.auroraLightBase;
        final isWishlisted =
            _wishlist.isWishlisted(widget.itemId.toString());

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _HeaderIcon(
                        icon: isRtl
                            ? FontAwesomeIcons.arrowRight
                            : FontAwesomeIcons.arrowLeft,
                        isDark: isDark,
                        onTap: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          _HeaderIcon(
                            icon: FontAwesomeIcons.shareNodes,
                            isDark: isDark,
                            onTap: () {},
                          ),
                          _HeaderIcon(
                            icon: isWishlisted
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            isDark: isDark,
                            activeColor: AppColors.auroraRed,
                            onTap: () async {
                              final msg = await _wishlist.toggle(
                                  widget.itemId.toString());
                              if (msg != null && msg.isNotEmpty) {
                                ToastService.instance.showSuccess(msg);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildBody(isDark)),
                if (!_loading && _error == null && _item != null)
                  StickyBottomBar(
                    itemId: widget.itemId,
                    itemTitle: _item!.title,
                    mainImageUrl: _mainImageUrl,
                    selectedColorName: _selectedColor != null ? colorDisplayName(_selectedColor!) : null,
                    selectedSizeValueId: _selectedSize?.sizeValueId,
                    selectedSizeName: _selectedSize?.displayValue,
                    unitPrice: _effectivePrice,
                    quantity: _quantity,
                    hasSizes: _hasSizes,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(bool isDark) {
    if (_loading) return const _LoadingView();
    if (_error != null) {
      return _ErrorView(message: _error!, onRetry: _fetchItem);
    }
    final item = _item!;
    final isVerified = false; // no isVerified in ItemDetailDto yet

    return RefreshIndicator(
      onRefresh: _fetchItem,
      color: AppColors.auroraPink,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageGallery(
              key: _galleryKey,
              imageUrls: _masterImages,
              isVerified: isVerified,
              discountPercentage: item.discountPercentage > 0
                  ? item.discountPercentage
                  : null,
              onIndexChanged: _onGalleryIndexChanged,
              onHeroTap: (index) => Navigator.pushNamed(
                context,
                imageViewerScreenRoute,
                arguments: ImageViewerArgs(
                  imageUrls: _masterImages,
                  initialIndex: index,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProductInfo(
                categoryName: item.categoryName,
                title: item.title,
                subtitle: item.subtitle,
                stock: _currentStock,
                brand: item.brand,
                description: item.description,
              ),
            ),
            if (item.tags.isNotEmpty) ...[
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _TagsRow(tags: item.tags),
              ),
            ],
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PriceQuantityRow(
                unitPrice: _effectivePrice,
                originalUnitPrice: item.discountedPrice != null
                    ? item.originalPrice + (_selectedSize?.additionalPrice ?? 0.0)
                    : null,
                quantity: _quantity,
                maxQuantity: _currentStock > 0 ? _currentStock : 1,
                onQuantityChanged: (q) => setState(() => _quantity = q),
              ),
            ),
            const SizedBox(height: 18),
            if (item.colors.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ColorSelector(
                  colors: item.colors,
                  selected: _selectedColor,
                  onSelected: _onColorSelected,
                ),
              ),
            if (item.colors.isNotEmpty) const SizedBox(height: 18),
            if (_currentSizes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizeSelector(
                  sizes: _currentSizes,
                  selected: _selectedSize,
                  sizeStandardId:
                      _selectedColor?.sizes.firstOrNull?.sizeStandardId,
                  onSelected: (size) => setState(() {
                    _selectedSize = size;
                    if (size.stock > 0 && _quantity > size.stock) {
                      _quantity = size.stock;
                    }
                  }),
                  onSizeGuide: _showSizeGuide,
                ),
              ),
            if (_currentSizes.isNotEmpty) const SizedBox(height: 18),
            ProductTabs(
              labels: item.labels,
              attributes: item.attributes,
              sizeMeasurements: item.sizeMeasurements,
              selectedSizeValueId: _selectedSize?.sizeValueId,
              reviews: _reviews,
              averageRating: item.averageRating,
              totalReviewCount: _reviewsTotalCount,
              isLoadingMoreReviews: _reviewsLoadingMore,
              reviewsController: _reviewsScrollController,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Header icon ──────────────────────────────────────────────────────────────

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.isDark,
    this.onTap,
    this.activeColor,
  });

  final FaIconData icon;
  final bool isDark;
  final VoidCallback? onTap;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final glyph = activeColor ??
        (isDark ? AppColors.white : AppColors.auroraPurple);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: FaIcon(icon, size: 20, color: glyph),
        ),
      ),
    );
  }
}

// ─── Tags row ─────────────────────────────────────────────────────────────────

class _TagsRow extends StatelessWidget {
  const _TagsRow({required this.tags});
  final List<ItemTagDto> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags.map((t) => _TagPill(tag: t)).toList(),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.tag});
  final ItemTagDto tag;

  Color _color() {
    final n = tag.name.toUpperCase();
    if (n.contains('VERIF')) return AppColors.verifiedGreen;
    if (n.contains('BRAND')) return AppColors.auroraElectricBlue;
    if (n.contains('EDIT')) return AppColors.auroraGold;
    if (n.contains('EXCL')) return AppColors.auroraPink;
    if (n.contains('QUAL')) return AppColors.auroraTeal;
    return switch (tag.id) {
      1 => AppColors.verifiedGreen,
      2 => AppColors.auroraElectricBlue,
      3 => AppColors.auroraGold,
      4 => AppColors.auroraPink,
      5 => AppColors.auroraTeal,
      _ => AppColors.auroraPurple,
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        border: Border.all(color: c.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        tag.name,
        style: AppFonts.primary(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: c,
          height: 1.1,
        ),
      ),
    );
  }
}

// ─── Loading & error states ───────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image gallery placeholder
          const SizedBox(
            height: 380,
            width: double.infinity,
            child: SkeletonShimmer(),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category chip + stock pill row
                Row(
                  children: [
                    SizedBox(
                      width: 110, height: 22,
                      child: SkeletonShimmer(borderRadius: BorderRadius.circular(999)),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 70, height: 16,
                      child: SkeletonShimmer(borderRadius: BorderRadius.circular(999)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Title — two lines
                SizedBox(
                  width: double.infinity, height: 26,
                  child: SkeletonShimmer(borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200, height: 26,
                  child: SkeletonShimmer(borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(height: 10),
                // Subtitle
                SizedBox(
                  width: 160, height: 16,
                  child: SkeletonShimmer(borderRadius: BorderRadius.circular(6)),
                ),
                const SizedBox(height: 20),
                // About glass box
                SizedBox(
                  width: double.infinity, height: 90,
                  child: SkeletonShimmer(borderRadius: BorderRadius.circular(14)),
                ),
                const SizedBox(height: 20),
                // Price + quantity row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100, height: 28,
                      child: SkeletonShimmer(borderRadius: BorderRadius.circular(8)),
                    ),
                    SizedBox(
                      width: 90, height: 36,
                      child: SkeletonShimmer(borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Color swatches
                Row(
                  children: List.generate(4, (i) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10),
                    child: SizedBox(
                      width: 36, height: 36,
                      child: SkeletonShimmer(borderRadius: BorderRadius.circular(999)),
                    ),
                  )),
                ),
                const SizedBox(height: 20),
                // Size chips
                Row(
                  children: List.generate(5, (i) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: SizedBox(
                      width: 48, height: 40,
                      child: SkeletonShimmer(borderRadius: BorderRadius.circular(10)),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final isDark = ThemeService.instance.isDarkMode;
        final textColor = isDark ? AppColors.white : AppColors.primaryPurple;
        final mutedColor = textColor.withValues(alpha: 0.60);

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(FontAwesomeIcons.circleExclamation,
                    size: 36, color: AppColors.auroraPink),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppFonts.primary(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: mutedColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onRetry,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.auroraPink,
                          AppColors.auroraElectricBlue
                        ],
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'product_detail_screen.try_again'.tr(),
                      style: AppFonts.primary(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                        letterSpacing: 0.4,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
