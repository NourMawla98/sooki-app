// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemDetailDto _$ItemDetailDtoFromJson(
  Map<String, dynamic> json,
) => _ItemDetailDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  subtitle: json['subtitle'] as String?,
  description: json['description'] as String?,
  originalPrice: (json['originalPrice'] as num).toDouble(),
  discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
  discountPercentage: (json['discountPercentage'] as num).toInt(),
  stock: (json['stock'] as num?)?.toInt(),
  brand: json['brand'] as String?,
  categoryName: json['categoryName'] as String,
  subCategoryName: json['subCategoryName'] as String?,
  detailCategoryName: json['detailCategoryName'] as String?,
  averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  colors:
      (json['colors'] as List<dynamic>?)
          ?.map((e) => ItemDetailColorDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map((e) => ItemTagDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  labels:
      (json['labels'] as List<dynamic>?)
          ?.map((e) => ItemDetailLabelDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  attributes:
      (json['attributes'] as List<dynamic>?)
          ?.map(
            (e) => ItemDetailAttributeDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  sizeMeasurements:
      (json['sizeMeasurements'] as List<dynamic>?)
          ?.map(
            (e) => ItemDetailSizeMeasurementGroupDto.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
);

_ItemDetailColorDto _$ItemDetailColorDtoFromJson(
  Map<String, dynamic> json,
) => _ItemDetailColorDto(
  id: (json['id'] as num).toInt(),
  colorType: json['colorType'] as String,
  sortOrder: (json['sortOrder'] as num).toInt(),
  patternImageUrl: json['patternImageUrl'] as String?,
  color1: ItemDetailColorValueDto.fromJson(
    json['color1'] as Map<String, dynamic>,
  ),
  color2: json['color2'] == null
      ? null
      : ItemDetailColorValueDto.fromJson(
          json['color2'] as Map<String, dynamic>,
        ),
  color3: json['color3'] == null
      ? null
      : ItemDetailColorValueDto.fromJson(
          json['color3'] as Map<String, dynamic>,
        ),
  media:
      (json['media'] as List<dynamic>?)
          ?.map((e) => ItemDetailMediaDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  sizes:
      (json['sizes'] as List<dynamic>?)
          ?.map((e) => ItemDetailSizeDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

_ItemDetailColorValueDto _$ItemDetailColorValueDtoFromJson(
  Map<String, dynamic> json,
) => _ItemDetailColorValueDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  hexCode: json['hexCode'] as String,
);

_ItemDetailMediaDto _$ItemDetailMediaDtoFromJson(Map<String, dynamic> json) =>
    _ItemDetailMediaDto(
      id: (json['id'] as num).toInt(),
      url: json['url'] as String,
      mediaType: json['mediaType'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      isMain: json['isMain'] as bool,
    );

_ItemDetailSizeDto _$ItemDetailSizeDtoFromJson(Map<String, dynamic> json) =>
    _ItemDetailSizeDto(
      sizeValueId: (json['sizeValueId'] as num).toInt(),
      displayValue: json['displayValue'] as String,
      standardName: json['standardName'] as String,
      sizeStandardId: (json['sizeStandardId'] as num?)?.toInt(),
      stock: (json['stock'] as num).toInt(),
      additionalPrice: (json['additionalPrice'] as num?)?.toDouble(),
    );

_ItemDetailSizeMeasurementGroupDto _$ItemDetailSizeMeasurementGroupDtoFromJson(
  Map<String, dynamic> json,
) => _ItemDetailSizeMeasurementGroupDto(
  sizeValueId: (json['sizeValueId'] as num).toInt(),
  displayValue: json['displayValue'] as String,
  measurements:
      (json['measurements'] as List<dynamic>?)
          ?.map(
            (e) => ItemDetailMeasurementDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

_ItemDetailMeasurementDto _$ItemDetailMeasurementDtoFromJson(
  Map<String, dynamic> json,
) => _ItemDetailMeasurementDto(
  measurementType: json['measurementType'] as String,
  value: (json['value'] as num).toDouble(),
);

_ItemDetailLabelDto _$ItemDetailLabelDtoFromJson(Map<String, dynamic> json) =>
    _ItemDetailLabelDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

_ItemDetailAttributeDto _$ItemDetailAttributeDtoFromJson(
  Map<String, dynamic> json,
) => _ItemDetailAttributeDto(
  attributeName: json['attributeName'] as String,
  value: json['value'] as String,
);
