import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String brand,
    required String category,
    @Default('') String description,
    @Default([]) List<String> features,
    @Default({}) Map<String, String> specifications,
    required double price,
    double? originalPrice,
    int? discountPercentage,
    @Default([]) List<String> imageUrls,
    @Default('') String thumbnailUrl,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(0) int stockCount,
    @Default(false) bool isNew,
    @Default(false) bool isVerified,
    @Default([]) List<ColorVariant> colors,
    @Default([]) List<SizeVariant> sizes,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
abstract class ColorVariant with _$ColorVariant {
  const factory ColorVariant({
    required String name,
    required String hexCode,
    @Default(true) bool isAvailable,
  }) = _ColorVariant;

  factory ColorVariant.fromJson(Map<String, dynamic> json) =>
      _$ColorVariantFromJson(json);
}

@freezed
abstract class SizeVariant with _$SizeVariant {
  const factory SizeVariant({
    required String label,
    @Default(true) bool isAvailable,
  }) = _SizeVariant;

  factory SizeVariant.fromJson(Map<String, dynamic> json) =>
      _$SizeVariantFromJson(json);
}

@freezed
abstract class Review with _$Review {
  const factory Review({
    required String userName,
    required double rating,
    required String text,
    required String date,
    @Default(false) bool isVerifiedPurchase,
    @Default(0) int helpfulCount,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
