import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_dto.freezed.dart';
part 'cart_dto.g.dart';

// ─── Server DTOs (from GET /customer/cart) ────────────────────────────────────

@Freezed(toJson: false, fromJson: true)
abstract class CartResponseDto with _$CartResponseDto {
  const factory CartResponseDto({
    required int itemCount,
    // Before any deal, fixed price deals included.
    required double subtotal,
    // After every deal; null from a backend that predates it.
    double? total,
    @Default([]) List<CartItemDto> items,
    // Everything deals take off the cart, fixed price deals included.
    @Default(0.0) double dealDiscount,
    // The part of [dealDiscount] that fixed price deals save.
    @Default(0.0) double singleItemDiscount,
    @Default([]) List<AppliedDealDto> appliedDeals,
    // The best live spend deal, null when none is live.
    SpendDealDto? spendDeal,
  }) = _CartResponseDto;

  factory CartResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartResponseDtoFromJson(json);
}

/// A deal the cart qualifies for, and what it saves.
@Freezed(toJson: false, fromJson: true)
abstract class AppliedDealDto with _$AppliedDealDto {
  const factory AppliedDealDto({
    required int dealId,
    @Default(1) int type,
    @Default('') String title,
    @Default(0.0) double saving,
  }) = _AppliedDealDto;

  factory AppliedDealDto.fromJson(Map<String, dynamic> json) =>
      _$AppliedDealDtoFromJson(json);
}

/// How far the cart is from a spend deal's threshold.
@Freezed(toJson: false, fromJson: true)
abstract class SpendDealDto with _$SpendDealDto {
  const factory SpendDealDto({
    required int dealId,
    @Default('') String title,
    required double spendThreshold,
    required double discountPercent,
    // The subtotal after the other deals, which is what counts to the threshold.
    @Default(0.0) double eligibleSubtotal,
    @Default(0.0) double remaining,
    @Default(false) bool unlocked,
  }) = _SpendDealDto;

  factory SpendDealDto.fromJson(Map<String, dynamic> json) =>
      _$SpendDealDtoFromJson(json);
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
    // Set when a live deal lowered the unit price: the deal and the price before it.
    int? dealId,
    double? unitPriceBeforeDeal,
    required int quantity,
    required double lineTotal,
    required int stock,
    required bool isAvailable,
    // What a bundle, multi-buy or free gift deal saves on this line.
    @Default(0.0) double dealSaving,
    int? appliedDealId,
    // A fixed price deal on only some of the units: the line keeps its normal
    // unit price and this comes off the line total.
    @Default(0.0) double singleDealDiscount,
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
  final double? unitPriceBeforeDeal;
  final int quantity;
  final int stock;
  final bool isAvailable;
  final double dealSaving;
  final int? appliedDealId;
  final double singleDealDiscount;

  const CartLineItem({
    required this.id,
    required this.itemSizeId,
    required this.itemId,
    required this.title,
    required this.imageUrl,
    required this.colorName,
    required this.sizeName,
    required this.unitPrice,
    this.unitPriceBeforeDeal,
    required this.quantity,
    required this.stock,
    required this.isAvailable,
    this.dealSaving = 0.0,
    this.appliedDealId,
    this.singleDealDiscount = 0.0,
  });

  /// The line after any fixed price deal, before bundle, multi-buy and free
  /// gift deals.
  double get lineTotal {
    final total = unitPrice * quantity - singleDealDiscount;
    return total < 0 ? 0 : total;
  }

  /// The line with no deal at all.
  double get lineTotalNormal => (unitPriceBeforeDeal ?? unitPrice) * quantity;

  /// The line at the price before a deal, or null when no deal applies.
  double? get lineTotalBeforeDeal {
    final before = unitPriceBeforeDeal;
    return before == null ? null : before * quantity;
  }

  /// What the line costs once a bundle, multi-buy or free gift deal takes its
  /// share off. Never below zero.
  double get lineTotalAfterDeals {
    final after = lineTotal - dealSaving;
    return after < 0 ? 0 : after;
  }

  /// A free gift line: a deal takes its whole price off.
  bool get isFreeGift => dealSaving > 0 && lineTotalAfterDeals < 0.005;

  /// The price shown struck through beside the line: the line with no deal
  /// at all, or null when nothing was saved on it.
  double? get struckLineTotal {
    final normal = lineTotalNormal;
    return normal - lineTotalAfterDeals > 0.005 ? normal : null;
  }

  static CartLineItem fromServer(CartItemDto dto) => CartLineItem(
    id: dto.id.toString(),
    itemSizeId: dto.itemSizeId,
    itemId: dto.itemId,
    title: dto.itemTitle,
    imageUrl: dto.mainImageUrl,
    colorName: dto.colorName,
    sizeName: dto.sizeName,
    unitPrice: dto.unitPrice,
    unitPriceBeforeDeal: dto.unitPriceBeforeDeal,
    quantity: dto.quantity,
    stock: dto.stock,
    isAvailable: dto.isAvailable,
    dealSaving: dto.dealSaving,
    appliedDealId: dto.appliedDealId,
    singleDealDiscount: dto.singleDealDiscount,
  );
}
