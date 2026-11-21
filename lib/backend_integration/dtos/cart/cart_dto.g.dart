// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartResponseDto _$CartResponseDtoFromJson(Map<String, dynamic> json) =>
    _CartResponseDto(
      itemCount: (json['itemCount'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dealDiscount: (json['dealDiscount'] as num?)?.toDouble() ?? 0.0,
      singleItemDiscount:
          (json['singleItemDiscount'] as num?)?.toDouble() ?? 0.0,
      appliedDeals:
          (json['appliedDeals'] as List<dynamic>?)
              ?.map((e) => AppliedDealDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      spendDeal: json['spendDeal'] == null
          ? null
          : SpendDealDto.fromJson(json['spendDeal'] as Map<String, dynamic>),
    );

_AppliedDealDto _$AppliedDealDtoFromJson(Map<String, dynamic> json) =>
    _AppliedDealDto(
      dealId: (json['dealId'] as num).toInt(),
      type: (json['type'] as num?)?.toInt() ?? 1,
      title: json['title'] as String? ?? '',
      saving: (json['saving'] as num?)?.toDouble() ?? 0.0,
    );

_SpendDealDto _$SpendDealDtoFromJson(Map<String, dynamic> json) =>
    _SpendDealDto(
      dealId: (json['dealId'] as num).toInt(),
      title: json['title'] as String? ?? '',
      spendThreshold: (json['spendThreshold'] as num).toDouble(),
      discountPercent: (json['discountPercent'] as num).toDouble(),
      eligibleSubtotal: (json['eligibleSubtotal'] as num?)?.toDouble() ?? 0.0,
      remaining: (json['remaining'] as num?)?.toDouble() ?? 0.0,
      unlocked: json['unlocked'] as bool? ?? false,
    );

_CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => _CartItemDto(
  id: (json['id'] as num).toInt(),
  itemId: (json['itemId'] as num).toInt(),
  itemTitle: json['itemTitle'] as String,
  itemColorId: (json['itemColorId'] as num).toInt(),
  colorName: json['colorName'] as String,
  mainImageUrl: json['mainImageUrl'] as String?,
  itemSizeId: (json['itemSizeId'] as num).toInt(),
  sizeName: json['sizeName'] as String,
  unitPrice: (json['unitPrice'] as num).toDouble(),
  dealId: (json['dealId'] as num?)?.toInt(),
  unitPriceBeforeDeal: (json['unitPriceBeforeDeal'] as num?)?.toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  lineTotal: (json['lineTotal'] as num).toDouble(),
  stock: (json['stock'] as num).toInt(),
  isAvailable: json['isAvailable'] as bool,
  dealSaving: (json['dealSaving'] as num?)?.toDouble() ?? 0.0,
  appliedDealId: (json['appliedDealId'] as num?)?.toInt(),
  singleDealDiscount: (json['singleDealDiscount'] as num?)?.toDouble() ?? 0.0,
);
