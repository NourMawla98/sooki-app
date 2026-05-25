import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_item_dto.freezed.dart';
part 'location_item_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class LocationItemDto with _$LocationItemDto {
  const factory LocationItemDto({
    required int id,
    required String name,
  }) = _LocationItemDto;

  factory LocationItemDto.fromJson(Map<String, dynamic> json) =>
      _$LocationItemDtoFromJson(json);
}
