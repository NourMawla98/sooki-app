import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/server_date.dart';

import 'order_item_dto.dart';

part 'order_detail_dto.freezed.dart';
part 'order_detail_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class OrderDetailDto with _$OrderDetailDto {
  const OrderDetailDto._();

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
    // The items at their normal prices; null from a backend that predates it.
    double? subtotalBeforeDeals,
    required double discountAmount,
    required double deliveryFee,
    required double totalAmount,
    // Sent in UTC; shown in the device's time zone.
    @ServerUtcDateConverter() required DateTime createdAt,
    int? paymentMethod,
    int? paymentStatus,
    @Default([]) List<OrderItemDto> items,
    // Everything deals took off the order.
    @Default(0.0) double totalDealDiscount,
  }) = _OrderDetailDto;

  factory OrderDetailDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailDtoFromJson(json);

  /// The subtotal shown above the deal savings, so the summary adds up: the
  /// backend's figure, or the subtotal with the deal savings put back.
  double get displaySubtotal => subtotalBeforeDeals ?? subtotal + totalDealDiscount;
}
