import 'package:freezed_annotation/freezed_annotation.dart';

part 'for_you_item_dto.freezed.dart';
part 'for_you_item_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class ForYouItemDto with _$ForYouItemDto {
  const factory ForYouItemDto({
    required int id,
    required String title,
    String? imageUrl,
    required double originalPrice,
    double? discountedPrice,
    required String reasonMessage,
  }) = _ForYouItemDto;

  factory ForYouItemDto.fromJson(Map<String, dynamic> json) =>
      _$ForYouItemDtoFromJson(json);
}
