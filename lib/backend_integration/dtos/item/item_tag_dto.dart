import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_tag_dto.freezed.dart';
part 'item_tag_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class ItemTagDto with _$ItemTagDto {
  const factory ItemTagDto({
    required int id,
    required String name,
  }) = _ItemTagDto;

  factory ItemTagDto.fromJson(Map<String, dynamic> json) =>
      _$ItemTagDtoFromJson(json);
}
