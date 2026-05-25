// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'size_value_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SizeValueDto {

 int get id; String get displayValue;
/// Create a copy of SizeValueDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeValueDtoCopyWith<SizeValueDto> get copyWith => _$SizeValueDtoCopyWithImpl<SizeValueDto>(this as SizeValueDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeValueDto&&(identical(other.id, id) || other.id == id)&&(identical(other.displayValue, displayValue) || other.displayValue == displayValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayValue);

@override
String toString() {
  return 'SizeValueDto(id: $id, displayValue: $displayValue)';
}


}

/// @nodoc
abstract mixin class $SizeValueDtoCopyWith<$Res>  {
  factory $SizeValueDtoCopyWith(SizeValueDto value, $Res Function(SizeValueDto) _then) = _$SizeValueDtoCopyWithImpl;
@useResult
$Res call({
 int id, String displayValue
});




}
/// @nodoc
class _$SizeValueDtoCopyWithImpl<$Res>
    implements $SizeValueDtoCopyWith<$Res> {
  _$SizeValueDtoCopyWithImpl(this._self, this._then);

  final SizeValueDto _self;
  final $Res Function(SizeValueDto) _then;

/// Create a copy of SizeValueDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayValue = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,displayValue: null == displayValue ? _self.displayValue : displayValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SizeValueDto].
extension SizeValueDtoPatterns on SizeValueDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SizeValueDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SizeValueDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SizeValueDto value)  $default,){
final _that = this;
switch (_that) {
case _SizeValueDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SizeValueDto value)?  $default,){
final _that = this;
switch (_that) {
case _SizeValueDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String displayValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SizeValueDto() when $default != null:
return $default(_that.id,_that.displayValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String displayValue)  $default,) {final _that = this;
switch (_that) {
case _SizeValueDto():
return $default(_that.id,_that.displayValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String displayValue)?  $default,) {final _that = this;
switch (_that) {
case _SizeValueDto() when $default != null:
return $default(_that.id,_that.displayValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _SizeValueDto implements SizeValueDto {
  const _SizeValueDto({required this.id, required this.displayValue});
  factory _SizeValueDto.fromJson(Map<String, dynamic> json) => _$SizeValueDtoFromJson(json);

@override final  int id;
@override final  String displayValue;

/// Create a copy of SizeValueDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SizeValueDtoCopyWith<_SizeValueDto> get copyWith => __$SizeValueDtoCopyWithImpl<_SizeValueDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SizeValueDto&&(identical(other.id, id) || other.id == id)&&(identical(other.displayValue, displayValue) || other.displayValue == displayValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayValue);

@override
String toString() {
  return 'SizeValueDto(id: $id, displayValue: $displayValue)';
}


}

/// @nodoc
abstract mixin class _$SizeValueDtoCopyWith<$Res> implements $SizeValueDtoCopyWith<$Res> {
  factory _$SizeValueDtoCopyWith(_SizeValueDto value, $Res Function(_SizeValueDto) _then) = __$SizeValueDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String displayValue
});




}
/// @nodoc
class __$SizeValueDtoCopyWithImpl<$Res>
    implements _$SizeValueDtoCopyWith<$Res> {
  __$SizeValueDtoCopyWithImpl(this._self, this._then);

  final _SizeValueDto _self;
  final $Res Function(_SizeValueDto) _then;

/// Create a copy of SizeValueDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayValue = null,}) {
  return _then(_SizeValueDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,displayValue: null == displayValue ? _self.displayValue : displayValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
