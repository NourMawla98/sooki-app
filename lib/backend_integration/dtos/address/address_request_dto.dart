class AddressRequestDto {
  final String label;
  final String fullName;
  final String street;
  final String? building;
  final String? floor;
  final String? apt;
  final String? instructions;
  final int cityId;
  final int? areaId;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const AddressRequestDto({
    required this.label,
    required this.fullName,
    required this.street,
    this.building,
    this.floor,
    this.apt,
    this.instructions,
    required this.cityId,
    this.areaId,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'fullName': fullName,
        'street': street,
        if (building != null) 'buildingName': building,
        if (floor != null) 'floor': floor,
        if (apt != null) 'apartment': apt,
        if (instructions != null) 'instructions': instructions,
        'cityId': cityId,
        if (areaId != null) 'areaId': areaId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        'isDefault': isDefault,
      };
}
