import 'package:freezed_annotation/freezed_annotation.dart';

import '../location/location_item_dto.dart';

part 'address_dto.freezed.dart';
part 'address_dto.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class AddressDto with _$AddressDto {
  const factory AddressDto({
    required int id,
    String? label,
    required String fullName,
    required String street,
    @JsonKey(name: 'buildingName') String? building,
    String? floor,
    @JsonKey(name: 'apartment') String? apt,
    String? instructions,
    required LocationItemDto city,
    LocationItemDto? area,
    double? latitude,
    double? longitude,
    @Default(false) bool isDefault,
  }) = _AddressDto;

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);
}
