// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_category_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubCategoryDto {

 int get id; String get name; String? get imageUrl; List<DetailCategoryDto> get detailCategories;
/// Create a copy of SubCategoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubCategoryDtoCopyWith<SubCategoryDto> get copyWith => _$SubCategoryDtoCopyWithImpl<SubCategoryDto>(this as SubCategoryDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubCategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.detailCategories, detailCategories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,const DeepCollectionEquality().hash(detailCategories));

@override
String toString() {
  return 'SubCategoryDto(id: $id, name: $name, imageUrl: $imageUrl, detailCategories: $detailCategories)';
}


}

/// @nodoc
abstract mixin class $SubCategoryDtoCopyWith<$Res>  {
  factory $SubCategoryDtoCopyWith(SubCategoryDto value, $Res Function(SubCategoryDto) _then) = _$SubCategoryDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? imageUrl, List<DetailCategoryDto> detailCategories
});




}
/// @nodoc
class _$SubCategoryDtoCopyWithImpl<$Res>
    implements $SubCategoryDtoCopyWith<$Res> {
  _$SubCategoryDtoCopyWithImpl(this._self, this._then);

  final SubCategoryDto _self;
  final $Res Function(SubCategoryDto) _then;

/// Create a copy of SubCategoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? detailCategories = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,detailCategories: null == detailCategories ? _self.detailCategories : detailCategories // ignore: cast_nullable_to_non_nullable
as List<DetailCategoryDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SubCategoryDto].
extension SubCategoryDtoPatterns on SubCategoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubCategoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubCategoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubCategoryDto value)  $default,){
final _that = this;
switch (_that) {
case _SubCategoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubCategoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _SubCategoryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? imageUrl,  List<DetailCategoryDto> detailCategories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubCategoryDto() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.detailCategories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? imageUrl,  List<DetailCategoryDto> detailCategories)  $default,) {final _that = this;
switch (_that) {
case _SubCategoryDto():
return $default(_that.id,_that.name,_that.imageUrl,_that.detailCategories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? imageUrl,  List<DetailCategoryDto> detailCategories)?  $default,) {final _that = this;
switch (_that) {
case _SubCategoryDto() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.detailCategories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _SubCategoryDto implements SubCategoryDto {
  const _SubCategoryDto({required this.id, required this.name, this.imageUrl, final  List<DetailCategoryDto> detailCategories = const []}): _detailCategories = detailCategories;
  factory _SubCategoryDto.fromJson(Map<String, dynamic> json) => _$SubCategoryDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? imageUrl;
 final  List<DetailCategoryDto> _detailCategories;
@override@JsonKey() List<DetailCategoryDto> get detailCategories {
  if (_detailCategories is EqualUnmodifiableListView) return _detailCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_detailCategories);
}


/// Create a copy of SubCategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubCategoryDtoCopyWith<_SubCategoryDto> get copyWith => __$SubCategoryDtoCopyWithImpl<_SubCategoryDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubCategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._detailCategories, _detailCategories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,const DeepCollectionEquality().hash(_detailCategories));

@override
String toString() {
  return 'SubCategoryDto(id: $id, name: $name, imageUrl: $imageUrl, detailCategories: $detailCategories)';
}


}

/// @nodoc
abstract mixin class _$SubCategoryDtoCopyWith<$Res> implements $SubCategoryDtoCopyWith<$Res> {
  factory _$SubCategoryDtoCopyWith(_SubCategoryDto value, $Res Function(_SubCategoryDto) _then) = __$SubCategoryDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? imageUrl, List<DetailCategoryDto> detailCategories
});




}
/// @nodoc
class __$SubCategoryDtoCopyWithImpl<$Res>
    implements _$SubCategoryDtoCopyWith<$Res> {
  __$SubCategoryDtoCopyWithImpl(this._self, this._then);

  final _SubCategoryDto _self;
  final $Res Function(_SubCategoryDto) _then;

/// Create a copy of SubCategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? detailCategories = null,}) {
  return _then(_SubCategoryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,detailCategories: null == detailCategories ? _self._detailCategories : detailCategories // ignore: cast_nullable_to_non_nullable
as List<DetailCategoryDto>,
  ));
}


}

// dart format on
