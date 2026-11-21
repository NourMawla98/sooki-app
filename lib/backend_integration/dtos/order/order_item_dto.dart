import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_dto.freezed.dart';
part 'order_item_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class OrderItemDto with _$OrderItemDto {
  const OrderItemDto._();

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
    // storeName intentionally omitted, never parsed or rendered
    // The deal that priced this line, when one did.
    int? dealId,
    int? dealType,
    double? snapshotDealPrice,
    // What a bundle, multi-buy or free gift deal took off this line.
    @Default(0.0) double dealDiscount,
    // A fixed price deal on only some of the units, taken off the line.
    @Default(0.0) double singleDealDiscount,
    // What the fixed price deal saved on this line, whole or part.
    double? singleItemSaving,
    // Everything deals took off this line: [totalPrice] plus this is the
    // line at its normal price.
    double? totalLineDiscount,
    // The spend deal over the whole cart, and this line's share of it.
    int? cartDealId,
    @Default(0.0) double cartDealDiscount,
  }) = _OrderItemDto;

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);

  /// Everything deals took off this line.
  /// The backend's [totalLineDiscount], or the parts added up for a backend
  /// that does not send it.
  double get totalDealSaving =>
      totalLineDiscount ?? singleDealDiscount + dealDiscount + cartDealDiscount;

  /// The fixed price deal's saving on this line: the backend's figure, or the
  /// partial discount for a backend that does not send it.
  double get fixedPriceSaving => singleItemSaving ?? singleDealDiscount;

  /// What the line would have cost without its deals, or null when none
  /// saved anything. [totalPrice] is after all of them.
  double? get totalBeforeDeals =>
      totalDealSaving > 0 ? totalPrice + totalDealSaving : null;

  /// Whether any deal touched this line, the fixed price kind included.
  bool get hasDeal => dealId != null || cartDealId != null || totalDealSaving > 0;

  /// The deal type to name on the line: its own deal first, else the spend
  /// deal it shared in.
  int? get labelDealType =>
      dealType ?? (cartDealId != null || cartDealDiscount > 0 ? 5 : null);
}
