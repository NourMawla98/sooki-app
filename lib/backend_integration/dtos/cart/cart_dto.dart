import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_dto.freezed.dart';
part 'cart_dto.g.dart';

// ─── Server DTOs (from GET /customer/cart) ────────────────────────────────────

@Freezed(toJson: false, fromJson: true)
abstract class CartResponseDto with _$CartResponseDto {
  const factory CartResponseDto({
    required int itemCount,
    required double subtotal,
    @Default([]) List<CartItemDto> items,
  }) = _CartResponseDto;

  factory CartResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartResponseDtoFromJson(json);
}

@Freezed(toJson: false, fromJson: true)
abstract class CartItemDto with _$CartItemDto {
  const factory CartItemDto({
    required int id,
    required int itemId,
    required String itemTitle,
    required int itemColorId,
    required String colorName,
    String? mainImageUrl,
    required int itemSizeId,
    required String sizeName,
    required double unitPrice,
    required int quantity,
    required double lineTotal,
    required int stock,
    required bool isAvailable,
  }) = _CartItemDto;

  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);
}

// ─── Unified display model (used by CartItemCard and CartScreen) ───────────────

class CartLineItem {
  final String id;
  final int itemSizeId;
  final int itemId;
  final String title;
  final String? imageUrl;
  final String colorName;
  final String sizeName;
  final double unitPrice;
  final int quantity;
  final int stock;
  final bool isAvailable;

  const CartLineItem({
    required this.id,
    required this.itemSizeId,
    required this.itemId,
    required this.title,
    required this.imageUrl,
    required this.colorName,
    required this.sizeName,
    required this.unitPrice,
    required this.quantity,
    required this.stock,
    required this.isAvailable,
  });

  double get lineTotal => unitPrice * quantity;

  static CartLineItem fromServer(CartItemDto dto) => CartLineItem(
    id: dto.id.toString(),
    itemSizeId: dto.itemSizeId,
    itemId: dto.itemId,
    title: dto.itemTitle,
    imageUrl: dto.mainImageUrl,
    colorName: dto.colorName,
    sizeName: dto.sizeName,
    unitPrice: dto.unitPrice,
    quantity: dto.quantity,
    stock: dto.stock,
    isAvailable: dto.isAvailable,
  );
}
