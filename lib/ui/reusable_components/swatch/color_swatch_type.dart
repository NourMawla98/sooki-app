import '../../../models/product.dart';

enum ColorSwatchType {
  solid,
  twoColor,
  threeColor,
  multicolor,
  pattern,
}

ColorSwatchType inferSwatchType(ColorVariant variant) {
  if (variant.swatchAssetPath != null) return ColorSwatchType.pattern;

  final lowered = variant.name.toLowerCase();
  if (lowered.contains('multi') || lowered.contains('rainbow')) {
    return ColorSwatchType.multicolor;
  }

  final hexes = variant.hexCodes;
  if (hexes == null || hexes.length <= 1) return ColorSwatchType.solid;
  if (hexes.length == 2) return ColorSwatchType.twoColor;
  if (hexes.length == 3) return ColorSwatchType.threeColor;
  return ColorSwatchType.multicolor;
}
