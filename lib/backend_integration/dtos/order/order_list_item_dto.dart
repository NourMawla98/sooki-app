import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/server_date.dart';

import 'order_item_dto.dart';

part 'order_list_item_dto.freezed.dart';
part 'order_list_item_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class OrderListItemDto with _$OrderListItemDto {
  const factory OrderListItemDto({
    required int id,
    required String trackingNumber,
    required int status,
    required double totalAmount,
    // Sent in UTC; shown in the device's time zone.
    @ServerUtcDateConverter() required DateTime createdAt,
    @Default([]) List<OrderItemDto> items,
    // Everything deals took off the order.
    @Default(0.0) double totalDealDiscount,
  }) = _OrderListItemDto;

  factory OrderListItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderListItemDtoFromJson(json);
}
