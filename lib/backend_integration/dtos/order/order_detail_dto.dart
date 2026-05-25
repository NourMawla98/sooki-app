import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_item_dto.dart';

part 'order_detail_dto.freezed.dart';
part 'order_detail_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class OrderDetailDto with _$OrderDetailDto {
  const factory OrderDetailDto({
    required int id,
    required String trackingNumber,
    required int status,
    required String customerName,
    String? addressLabel,
    required String city,
    String? area,
    String? street,
    String? building,
    String? floor,
    String? customerNote,
    required double subtotal,
    required double discountAmount,
    required double deliveryFee,
    required double totalAmount,
    required DateTime createdAt,
    required int paymentMethod,
    required int paymentStatus,
    @Default([]) List<OrderItemDto> items,
  }) = _OrderDetailDto;

  factory OrderDetailDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailDtoFromJson(json);
}
