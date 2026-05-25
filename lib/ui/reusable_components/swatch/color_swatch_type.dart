import '../../../backend_integration/dtos/item/item_detail_dto.dart';

enum ColorSwatchType {
  solid,
  twoColor,
  threeColor,
  multicolor,
  pattern,
}

ColorSwatchType inferSwatchType(ItemDetailColorDto color) {
  if (color.patternImageUrl != null) return ColorSwatchType.pattern;
  if (color.color3 != null) return ColorSwatchType.threeColor;
  if (color.color2 != null) return ColorSwatchType.twoColor;
  final lowered = color.colorType.toLowerCase();
  if (lowered.contains('multi') || lowered.contains('rainbow')) {
    return ColorSwatchType.multicolor;
  }
  return ColorSwatchType.solid;
}

String colorDisplayName(ItemDetailColorDto color) {
  if (color.color3 != null) {
    return '${color.color1.name} / ${color.color2!.name} / ${color.color3!.name}';
  }
  if (color.color2 != null) return '${color.color1.name} / ${color.color2!.name}';
  return color.color1.name;
}
