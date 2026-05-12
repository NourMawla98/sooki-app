import 'package:freezed_annotation/freezed_annotation.dart';

part 'trending_item_dto.freezed.dart';
part 'trending_item_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class TrendingItemDto with _$TrendingItemDto {
  const factory TrendingItemDto({
    required int id,
    required String title,
    required String imageUrl,
    required double price,
  }) = _TrendingItemDto;

  factory TrendingItemDto.fromJson(Map<String, dynamic> json) =>
      _$TrendingItemDtoFromJson(json);
}
