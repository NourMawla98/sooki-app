import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_dto.freezed.dart';
part 'order_item_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class OrderItemDto with _$OrderItemDto {
  const factory OrderItemDto({
    required int id,
    @Default(0) int itemId,
    required int status,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    required String itemTitle,
    required String colorName,
    required String sizeName,
    String? imageUrl,
    // storeName intentionally omitted — never parsed or rendered
  }) = _OrderItemDto;

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);
}
