// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'size_standard_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SizeStandardDto {

 int get id; String get name; List<SizeValueDto> get values;
/// Create a copy of SizeStandardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeStandardDtoCopyWith<SizeStandardDto> get copyWith => _$SizeStandardDtoCopyWithImpl<SizeStandardDto>(this as SizeStandardDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeStandardDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.values, values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(values));

@override
String toString() {
  return 'SizeStandardDto(id: $id, name: $name, values: $values)';
}


}

/// @nodoc
abstract mixin class $SizeStandardDtoCopyWith<$Res>  {
  factory $SizeStandardDtoCopyWith(SizeStandardDto value, $Res Function(SizeStandardDto) _then) = _$SizeStandardDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<SizeValueDto> values
});




}
/// @nodoc
class _$SizeStandardDtoCopyWithImpl<$Res>
    implements $SizeStandardDtoCopyWith<$Res> {
  _$SizeStandardDtoCopyWithImpl(this._self, this._then);

  final SizeStandardDto _self;
  final $Res Function(SizeStandardDto) _then;

/// Create a copy of SizeStandardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? values = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as List<SizeValueDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SizeStandardDto].
extension SizeStandardDtoPatterns on SizeStandardDto {
@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SizeStandardDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SizeStandardDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SizeStandardDto value)  $default,){
final _that = this;
switch (_that) {
case _SizeStandardDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SizeStandardDto value)?  $default,){
final _that = this;
switch (_that) {
case _SizeStandardDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<SizeValueDto> values)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SizeStandardDto() when $default != null:
return $default(_that.id,_that.name,_that.values);case _:
  return orElse();

}
}
@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<SizeValueDto> values)  $default,) {final _that = this;
switch (_that) {
case _SizeStandardDto():
return $default(_that.id,_that.name,_that.values);case _:
  throw StateError('Unexpected subclass');

}
}
@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<SizeValueDto> values)?  $default,) {final _that = this;
switch (_that) {
case _SizeStandardDto() when $default != null:
return $default(_that.id,_that.name,_that.values);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _SizeStandardDto implements SizeStandardDto {
  const _SizeStandardDto({required this.id, required this.name, final  List<SizeValueDto> values = const []}): _values = values;
  factory _SizeStandardDto.fromJson(Map<String, dynamic> json) => _$SizeStandardDtoFromJson(json);

@override final  int id;
@override final  String name;
 final  List<SizeValueDto> _values;
@override@JsonKey() List<SizeValueDto> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


/// Create a copy of SizeStandardDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SizeStandardDtoCopyWith<_SizeStandardDto> get copyWith => __$SizeStandardDtoCopyWithImpl<_SizeStandardDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SizeStandardDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._values, _values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'SizeStandardDto(id: $id, name: $name, values: $values)';
}


}

/// @nodoc
abstract mixin class _$SizeStandardDtoCopyWith<$Res> implements $SizeStandardDtoCopyWith<$Res> {
  factory _$SizeStandardDtoCopyWith(_SizeStandardDto value, $Res Function(_SizeStandardDto) _then) = __$SizeStandardDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<SizeValueDto> values
});




}
/// @nodoc
class __$SizeStandardDtoCopyWithImpl<$Res>
    implements _$SizeStandardDtoCopyWith<$Res> {
  __$SizeStandardDtoCopyWithImpl(this._self, this._then);

  final _SizeStandardDto _self;
  final $Res Function(_SizeStandardDto) _then;

/// Create a copy of SizeStandardDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? values = null,}) {
  return _then(_SizeStandardDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<SizeValueDto>,
  ));
}


}

// dart format on
