/// Saved shipping address. Persisted locally via [AddressService].
///
/// `line` is a human-readable one-line rendering for the cart pill + picker.
/// The structured fields (city, area, street, building, floor, apt,
/// instructions) are the source of truth and can be used by checkout / APIs.
/// Older persisted records without structured fields remain usable via `line`.
class DeliveryAddress {
  final String id;
  final String label;
  final String phone;
  final String line;
  final String? city;
  final String? area;
  final String? street;
  final String? building;
  final String? floor;
  final String? apt;
  final String? instructions;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.phone,
    required this.line,
    this.city,
    this.area,
    this.street,
    this.building,
    this.floor,
    this.apt,
    this.instructions,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  /// Builds a pretty one-line rendering from the structured parts.
  static String composeLine({
    required String? building,
    required String? street,
    required String? area,
    required String? city,
  }) {
    final parts = <String>[];
    final streetLine = [
      if ((building ?? '').trim().isNotEmpty) 'Bldg ${building!.trim()}',
      if ((street ?? '').trim().isNotEmpty) street!.trim(),
    ].join(' · ');
    if (streetLine.isNotEmpty) parts.add(streetLine);
    if ((area ?? '').trim().isNotEmpty) parts.add(area!.trim());
    if ((city ?? '').trim().isNotEmpty) parts.add(city!.trim());
    return parts.join(', ');
  }

  DeliveryAddress copyWith({
    String? id,
    String? label,
    String? phone,
    String? line,
    String? city,
    String? area,
    String? street,
    String? building,
    String? floor,
    String? apt,
    String? instructions,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return DeliveryAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      phone: phone ?? this.phone,
      line: line ?? this.line,
      city: city ?? this.city,
      area: area ?? this.area,
      street: street ?? this.street,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      apt: apt ?? this.apt,
      instructions: instructions ?? this.instructions,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'phone': phone,
        'line': line,
        'city': city,
        'area': area,
        'street': street,
        'building': building,
        'floor': floor,
        'apt': apt,
        'instructions': instructions,
        'latitude': latitude,
        'longitude': longitude,
        'isDefault': isDefault,
      };

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        id: json['id'] as String,
        label: json['label'] as String,
        phone: json['phone'] as String,
        line: json['line'] as String,
        city: json['city'] as String?,
        area: json['area'] as String?,
        street: json['street'] as String?,
        building: json['building'] as String?,
        floor: json['floor'] as String?,
        apt: json['apt'] as String?,
        instructions: json['instructions'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        isDefault: json['isDefault'] as bool? ?? false,
      );
}
