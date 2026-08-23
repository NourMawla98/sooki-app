import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../themes/app_colors.dart';

/// A product image with the app's single "no image" treatment.
///
/// A missing image looks the same everywhere it can happen: the cart, the
/// checkout list and the order detail. It reads as an absence, a muted glass
/// tile with an image icon, rather than as a coloured block a shopper could
/// mistake for the product.
///
/// The placeholder covers both a null or empty [url] and an image that fails
/// to load, since the shopper cannot tell those apart and should not have to.
class ProductThumb extends StatelessWidget {
  /// Image to show. Null or empty renders the placeholder.
  final String? url;

  /// Width and height. The thumb is always square.
  final double size;

  final double borderRadius;

  /// Placeholder icon size. Defaults to a quarter of [size], which keeps the
  /// icon in proportion across the sizes the app uses.
  final double? iconSize;

  final bool isDark;

  const ProductThumb({
    super.key,
    required this.url,
    required this.size,
    required this.isDark,
    this.borderRadius = 8,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final fill = isDark
        ? AppColors.white.withValues(alpha: 0.06)
        : AppColors.auroraPurple.withValues(alpha: 0.06);
    final border = isDark
        ? AppColors.white.withValues(alpha: 0.10)
        : AppColors.auroraPurple.withValues(alpha: 0.16);
    final icon = isDark
        ? AppColors.white.withValues(alpha: 0.20)
        : AppColors.auroraPurple.withValues(alpha: 0.30);

    final placeholder = Center(
      child: FaIcon(
        FontAwesomeIcons.image,
        size: iconSize ?? size / 4,
        color: icon,
      ),
    );

    final hasUrl = url != null && url!.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.hardEdge,
      child: hasUrl
          ? Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => placeholder,
            )
          : placeholder,
    );
  }
}
