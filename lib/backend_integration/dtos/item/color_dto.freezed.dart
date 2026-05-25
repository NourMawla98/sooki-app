// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ColorDto {

 int get id; String get name; String get hexCode;
/// Create a copy of ColorDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColorDtoCopyWith<ColorDto> get copyWith => _$ColorDtoCopyWithImpl<ColorDto>(this as ColorDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ColorDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hexCode, hexCode) || other.hexCode == hexCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hexCode);

@override
String toString() {
  return 'ColorDto(id: $id, name: $name, hexCode: $hexCode)';
}


}

/// @nodoc
abstract mixin class $ColorDtoCopyWith<$Res>  {
  factory $ColorDtoCopyWith(ColorDto value, $Res Function(ColorDto) _then) = _$ColorDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String hexCode
});




}
/// @nodoc
class _$ColorDtoCopyWithImpl<$Res>
    implements $ColorDtoCopyWith<$Res> {
  _$ColorDtoCopyWithImpl(this._self, this._then);

  final ColorDto _self;
  final $Res Function(ColorDto) _then;

/// Create a copy of ColorDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? hexCode = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hexCode: null == hexCode ? _self.hexCode : hexCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ColorDto].
extension ColorDtoPatterns on ColorDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ColorDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ColorDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ColorDto value)  $default,){
final _that = this;
switch (_that) {
case _ColorDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ColorDto value)?  $default,){
final _that = this;
switch (_that) {
case _ColorDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String hexCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ColorDto() when $default != null:
return $default(_that.id,_that.name,_that.hexCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String hexCode)  $default,) {final _that = this;
switch (_that) {
case _ColorDto():
return $default(_that.id,_that.name,_that.hexCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String hexCode)?  $default,) {final _that = this;
switch (_that) {
case _ColorDto() when $default != null:
return $default(_that.id,_that.name,_that.hexCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ColorDto implements ColorDto {
  const _ColorDto({required this.id, required this.name, required this.hexCode});
  factory _ColorDto.fromJson(Map<String, dynamic> json) => _$ColorDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String hexCode;

/// Create a copy of ColorDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColorDtoCopyWith<_ColorDto> get copyWith => __$ColorDtoCopyWithImpl<_ColorDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColorDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hexCode, hexCode) || other.hexCode == hexCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hexCode);

@override
String toString() {
  return 'ColorDto(id: $id, name: $name, hexCode: $hexCode)';
}


}

/// @nodoc
abstract mixin class _$ColorDtoCopyWith<$Res> implements $ColorDtoCopyWith<$Res> {
  factory _$ColorDtoCopyWith(_ColorDto value, $Res Function(_ColorDto) _then) = __$ColorDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String hexCode
});




}
/// @nodoc
class __$ColorDtoCopyWithImpl<$Res>
    implements _$ColorDtoCopyWith<$Res> {
  __$ColorDtoCopyWithImpl(this._self, this._then);

  final _ColorDto _self;
  final $Res Function(_ColorDto) _then;

/// Create a copy of ColorDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? hexCode = null,}) {
  return _then(_ColorDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hexCode: null == hexCode ? _self.hexCode : hexCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
