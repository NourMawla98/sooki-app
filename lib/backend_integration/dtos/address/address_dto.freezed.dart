// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddressDto {

 int get id; String? get label; String get fullName; String get street;@JsonKey(name: 'buildingName') String? get building; String? get floor;@JsonKey(name: 'apartment') String? get apt; String? get instructions; LocationItemDto get city; LocationItemDto? get area; double? get latitude; double? get longitude; bool get isDefault;
/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressDtoCopyWith<AddressDto> get copyWith => _$AddressDtoCopyWithImpl<AddressDto>(this as AddressDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressDto&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.street, street) || other.street == street)&&(identical(other.building, building) || other.building == building)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.apt, apt) || other.apt == apt)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.city, city) || other.city == city)&&(identical(other.area, area) || other.area == area)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,fullName,street,building,floor,apt,instructions,city,area,latitude,longitude,isDefault);

@override
String toString() {
  return 'AddressDto(id: $id, label: $label, fullName: $fullName, street: $street, building: $building, floor: $floor, apt: $apt, instructions: $instructions, city: $city, area: $area, latitude: $latitude, longitude: $longitude, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $AddressDtoCopyWith<$Res>  {
  factory $AddressDtoCopyWith(AddressDto value, $Res Function(AddressDto) _then) = _$AddressDtoCopyWithImpl;
@useResult
$Res call({
 int id, String? label, String fullName, String street,@JsonKey(name: 'buildingName') String? building, String? floor,@JsonKey(name: 'apartment') String? apt, String? instructions, LocationItemDto city, LocationItemDto? area, double? latitude, double? longitude, bool isDefault
});


$LocationItemDtoCopyWith<$Res> get city;$LocationItemDtoCopyWith<$Res>? get area;

}
/// @nodoc
class _$AddressDtoCopyWithImpl<$Res>
    implements $AddressDtoCopyWith<$Res> {
  _$AddressDtoCopyWithImpl(this._self, this._then);

  final AddressDto _self;
  final $Res Function(AddressDto) _then;

/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = freezed,Object? fullName = null,Object? street = null,Object? building = freezed,Object? floor = freezed,Object? apt = freezed,Object? instructions = freezed,Object? city = null,Object? area = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? isDefault = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,apt: freezed == apt ? _self.apt : apt // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as LocationItemDto,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LocationItemDto?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationItemDtoCopyWith<$Res> get city {
  
  return $LocationItemDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationItemDtoCopyWith<$Res>? get area {
    if (_self.area == null) {
    return null;
  }

  return $LocationItemDtoCopyWith<$Res>(_self.area!, (value) {
    return _then(_self.copyWith(area: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddressDto].
extension AddressDtoPatterns on AddressDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressDto value)  $default,){
final _that = this;
switch (_that) {
case _AddressDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressDto value)?  $default,){
final _that = this;
switch (_that) {
case _AddressDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? label,  String fullName,  String street, @JsonKey(name: 'buildingName')  String? building,  String? floor, @JsonKey(name: 'apartment')  String? apt,  String? instructions,  LocationItemDto city,  LocationItemDto? area,  double? latitude,  double? longitude,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressDto() when $default != null:
return $default(_that.id,_that.label,_that.fullName,_that.street,_that.building,_that.floor,_that.apt,_that.instructions,_that.city,_that.area,_that.latitude,_that.longitude,_that.isDefault);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? label,  String fullName,  String street, @JsonKey(name: 'buildingName')  String? building,  String? floor, @JsonKey(name: 'apartment')  String? apt,  String? instructions,  LocationItemDto city,  LocationItemDto? area,  double? latitude,  double? longitude,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _AddressDto():
return $default(_that.id,_that.label,_that.fullName,_that.street,_that.building,_that.floor,_that.apt,_that.instructions,_that.city,_that.area,_that.latitude,_that.longitude,_that.isDefault);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? label,  String fullName,  String street, @JsonKey(name: 'buildingName')  String? building,  String? floor, @JsonKey(name: 'apartment')  String? apt,  String? instructions,  LocationItemDto city,  LocationItemDto? area,  double? latitude,  double? longitude,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _AddressDto() when $default != null:
return $default(_that.id,_that.label,_that.fullName,_that.street,_that.building,_that.floor,_that.apt,_that.instructions,_that.city,_that.area,_that.latitude,_that.longitude,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _AddressDto implements AddressDto {
  const _AddressDto({required this.id, this.label, required this.fullName, required this.street, @JsonKey(name: 'buildingName') this.building, this.floor, @JsonKey(name: 'apartment') this.apt, this.instructions, required this.city, this.area, this.latitude, this.longitude, this.isDefault = false});
  factory _AddressDto.fromJson(Map<String, dynamic> json) => _$AddressDtoFromJson(json);

@override final  int id;
@override final  String? label;
@override final  String fullName;
@override final  String street;
@override@JsonKey(name: 'buildingName') final  String? building;
@override final  String? floor;
@override@JsonKey(name: 'apartment') final  String? apt;
@override final  String? instructions;
@override final  LocationItemDto city;
@override final  LocationItemDto? area;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey() final  bool isDefault;

/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressDtoCopyWith<_AddressDto> get copyWith => __$AddressDtoCopyWithImpl<_AddressDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressDto&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.street, street) || other.street == street)&&(identical(other.building, building) || other.building == building)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.apt, apt) || other.apt == apt)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.city, city) || other.city == city)&&(identical(other.area, area) || other.area == area)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,fullName,street,building,floor,apt,instructions,city,area,latitude,longitude,isDefault);

@override
String toString() {
  return 'AddressDto(id: $id, label: $label, fullName: $fullName, street: $street, building: $building, floor: $floor, apt: $apt, instructions: $instructions, city: $city, area: $area, latitude: $latitude, longitude: $longitude, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$AddressDtoCopyWith<$Res> implements $AddressDtoCopyWith<$Res> {
  factory _$AddressDtoCopyWith(_AddressDto value, $Res Function(_AddressDto) _then) = __$AddressDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String? label, String fullName, String street,@JsonKey(name: 'buildingName') String? building, String? floor,@JsonKey(name: 'apartment') String? apt, String? instructions, LocationItemDto city, LocationItemDto? area, double? latitude, double? longitude, bool isDefault
});


@override $LocationItemDtoCopyWith<$Res> get city;@override $LocationItemDtoCopyWith<$Res>? get area;

}
/// @nodoc
class __$AddressDtoCopyWithImpl<$Res>
    implements _$AddressDtoCopyWith<$Res> {
  __$AddressDtoCopyWithImpl(this._self, this._then);

  final _AddressDto _self;
  final $Res Function(_AddressDto) _then;

/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = freezed,Object? fullName = null,Object? street = null,Object? building = freezed,Object? floor = freezed,Object? apt = freezed,Object? instructions = freezed,Object? city = null,Object? area = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? isDefault = null,}) {
  return _then(_AddressDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,apt: freezed == apt ? _self.apt : apt // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as LocationItemDto,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as LocationItemDto?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationItemDtoCopyWith<$Res> get city {
  
  return $LocationItemDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of AddressDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationItemDtoCopyWith<$Res>? get area {
    if (_self.area == null) {
    return null;
  }

  return $LocationItemDtoCopyWith<$Res>(_self.area!, (value) {
    return _then(_self.copyWith(area: value));
  });
}
}

// dart format on
