import 'package:freezed_annotation/freezed_annotation.dart';

import 'item_tag_dto.dart';

part 'item_detail_dto.freezed.dart';
part 'item_detail_dto.g.dart';

// ─── Root ─────────────────────────────────────────────────────────────────────

@Freezed(toJson: false, fromJson: true)
abstract class ItemDetailDto with _$ItemDetailDto {
  const factory ItemDetailDto({
    required int id,
    required String title,
    String? subtitle,
    String? description,
    required double originalPrice,
    double? discountedPrice,
    required int discountPercentage,
    int? stock,
    String? brand,
    required String categoryName,
    String? subCategoryName,
    String? detailCategoryName,
    @Default(0.0) double averageRating,
    @Default(0) int reviewCount,
    @Default([]) List<ItemDetailColorDto> colors,
    @Default([]) List<ItemTagDto> tags,
    @Default([]) List<ItemDetailLabelDto> labels,
    @Default([]) List<ItemDetailAttributeDto> attributes,
    @Default([]) List<ItemDetailSizeMeasurementGroupDto> sizeMeasurements,
  }) = _ItemDetailDto;

  factory ItemDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailDtoFromJson(json);
}

// ─── Color ────────────────────────────────────────────────────────────────────

@Freezed(toJson: false, fromJson: true)
abstract class ItemDetailColorDto with _$ItemDetailColorDto {
  const factory ItemDetailColorDto({
    required int id,
    required String colorType,
    required int sortOrder,
    String? patternImageUrl,
    required ItemDetailColorValueDto color1,
    ItemDetailColorValueDto? color2,
    ItemDetailColorValueDto? color3,
    @Default([]) List<ItemDetailMediaDto> media,
    @Default([]) List<ItemDetailSizeDto> sizes,
  }) = _ItemDetailColorDto;

  factory ItemDetailColorDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailColorDtoFromJson(json);
}

@Freezed(toJson: false, fromJson: true)
abstract class ItemDetailColorValueDto with _$ItemDetailColorValueDto {
  const factory ItemDetailColorValueDto({
    required int id,
    required String name,
    required String hexCode,
  }) = _ItemDetailColorValueDto;

  factory ItemDetailColorValueDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailColorValueDtoFromJson(json);
}

// ─── Media ────────────────────────────────────────────────────────────────────

@Freezed(toJson: false, fromJson: true)
abstract class ItemDetailMediaDto with _$ItemDetailMediaDto {
  const factory ItemDetailMediaDto({
    required int id,
    required String url,
    required String mediaType,
    required int sortOrder,
    required bool isMain,
  }) = _ItemDetailMediaDto;

  factory ItemDetailMediaDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailMediaDtoFromJson(json);
}

// ─── Size ─────────────────────────────────────────────────────────────────────

@Freezed(toJson: false, fromJson: true)
abstract class ItemDetailSizeDto with _$ItemDetailSizeDto {
  const factory ItemDetailSizeDto({
    required int itemSizeId,
    required int sizeValueId,
    @Default('') String code,
    required String displayValue,
    required String standardName,
    int? sizeStandardId,
    required int stock,
    double? additionalPrice,
  }) = _ItemDetailSizeDto;

  factory ItemDetailSizeDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailSizeDtoFromJson(json);
}

// ─── Size measurements ────────────────────────────────────────────────────────

@Freezed(toJson: false, fromJson: true)
abstract class ItemDetailSizeMeasurementGroupDto
    with _$ItemDetailSizeMeasurementGroupDto {
  const factory ItemDetailSizeMeasurementGroupDto({
    required int sizeValueId,
    required String displayValue,
    @Default([]) List<ItemDetailMeasurementDto> measurements,
  }) = _ItemDetailSizeMeasurementGroupDto;

  factory ItemDetailSizeMeasurementGroupDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ItemDetailSizeMeasurementGroupDtoFromJson(json);
}

@Freezed(toJson: false, fromJson: true)
abstract class ItemDetailMeasurementDto with _$ItemDetailMeasurementDto {
  const factory ItemDetailMeasurementDto({
    required String measurementType,
    required double value,
  }) = _ItemDetailMeasurementDto;

  factory ItemDetailMeasurementDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailMeasurementDtoFromJson(json);
}

// ─── Labels & Attributes ──────────────────────────────────────────────────────

@Freezed(toJson: false, fromJson: true)
abstract class ItemDetailLabelDto with _$ItemDetailLabelDto {
  const factory ItemDetailLabelDto({required int id, required String name}) =
      _ItemDetailLabelDto;

  factory ItemDetailLabelDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailLabelDtoFromJson(json);
}

@Freezed(toJson: false, fromJson: true)
abstract class ItemDetailAttributeDto with _$ItemDetailAttributeDto {
  const factory ItemDetailAttributeDto({
    required String attributeName,
    required String value,
  }) = _ItemDetailAttributeDto;

  factory ItemDetailAttributeDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailAttributeDtoFromJson(json);
}
