import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A Font Awesome icon that flips horizontally in a right-to-left locale.
///
/// Use it for glyphs that point somewhere, such as the logout arrow, where
/// Font Awesome ships only the left-to-right variant.
class MirroredFaIcon extends StatelessWidget {
  const MirroredFaIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
  });

  final FaIconData icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final glyph = FaIcon(icon, size: size, color: color);
    if (Directionality.of(context) != TextDirection.rtl) return glyph;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0),
      child: glyph,
    );
  }
}
