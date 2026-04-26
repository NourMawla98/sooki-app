// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  brand: json['brand'] as String,
  category: json['category'] as String,
  subCategory: json['subCategory'] as String?,
  detailedCategory: json['detailedCategory'] as String?,
  description: json['description'] as String? ?? '',
  features:
      (json['features'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  specifications:
      (json['specifications'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  price: (json['price'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  discountPercentage: (json['discountPercentage'] as num?)?.toInt(),
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  stockCount: (json['stockCount'] as num?)?.toInt() ?? 0,
  isNew: json['isNew'] as bool? ?? false,
  isVerified: json['isVerified'] as bool? ?? false,
  isBrand: json['isBrand'] as bool? ?? false,
  isEditorsPick: json['isEditorsPick'] as bool? ?? false,
  isPlatformExclusive: json['isPlatformExclusive'] as bool? ?? false,
  isQualityChecked: json['isQualityChecked'] as bool? ?? false,
  colors:
      (json['colors'] as List<dynamic>?)
          ?.map((e) => ColorVariant.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  sizes:
      (json['sizes'] as List<dynamic>?)
          ?.map((e) => SizeVariant.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'brand': instance.brand,
  'category': instance.category,
  'subCategory': instance.subCategory,
  'detailedCategory': instance.detailedCategory,
  'description': instance.description,
  'features': instance.features,
  'specifications': instance.specifications,
  'price': instance.price,
  'originalPrice': instance.originalPrice,
  'discountPercentage': instance.discountPercentage,
  'imageUrls': instance.imageUrls,
  'thumbnailUrl': instance.thumbnailUrl,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'stockCount': instance.stockCount,
  'isNew': instance.isNew,
  'isVerified': instance.isVerified,
  'isBrand': instance.isBrand,
  'isEditorsPick': instance.isEditorsPick,
  'isPlatformExclusive': instance.isPlatformExclusive,
  'isQualityChecked': instance.isQualityChecked,
  'colors': instance.colors,
  'sizes': instance.sizes,
};

_ColorVariant _$ColorVariantFromJson(Map<String, dynamic> json) =>
    _ColorVariant(
      name: json['name'] as String,
      hexCode: json['hexCode'] as String,
      hexCodes: (json['hexCodes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      swatchAssetPath: json['swatchAssetPath'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$ColorVariantToJson(_ColorVariant instance) =>
    <String, dynamic>{
      'name': instance.name,
      'hexCode': instance.hexCode,
      'hexCodes': instance.hexCodes,
      'swatchAssetPath': instance.swatchAssetPath,
      'imageUrls': instance.imageUrls,
      'isAvailable': instance.isAvailable,
    };

_SizeVariant _$SizeVariantFromJson(Map<String, dynamic> json) => _SizeVariant(
  label: json['label'] as String,
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$SizeVariantToJson(_SizeVariant instance) =>
    <String, dynamic>{
      'label': instance.label,
      'isAvailable': instance.isAvailable,
    };

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  userName: json['userName'] as String,
  rating: (json['rating'] as num).toDouble(),
  text: json['text'] as String,
  date: json['date'] as String,
  isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
  helpfulCount: (json['helpfulCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'userName': instance.userName,
  'rating': instance.rating,
  'text': instance.text,
  'date': instance.date,
  'isVerifiedPurchase': instance.isVerifiedPurchase,
  'helpfulCount': instance.helpfulCount,
};
