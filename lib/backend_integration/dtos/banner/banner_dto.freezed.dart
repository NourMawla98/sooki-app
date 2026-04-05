// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BannerDto {

 int get id; int get type; String get title; String? get subtitle; String? get description; String? get redirectionRoute; List<String> get imageUrls;
/// Create a copy of BannerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerDtoCopyWith<BannerDto> get copyWith => _$BannerDtoCopyWithImpl<BannerDto>(this as BannerDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.redirectionRoute, redirectionRoute) || other.redirectionRoute == redirectionRoute)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,subtitle,description,redirectionRoute,const DeepCollectionEquality().hash(imageUrls));

@override
String toString() {
  return 'BannerDto(id: $id, type: $type, title: $title, subtitle: $subtitle, description: $description, redirectionRoute: $redirectionRoute, imageUrls: $imageUrls)';
}


}

/// @nodoc
abstract mixin class $BannerDtoCopyWith<$Res>  {
  factory $BannerDtoCopyWith(BannerDto value, $Res Function(BannerDto) _then) = _$BannerDtoCopyWithImpl;
@useResult
$Res call({
 int id, int type, String title, String? subtitle, String? description, String? redirectionRoute, List<String> imageUrls
});




}
/// @nodoc
class _$BannerDtoCopyWithImpl<$Res>
    implements $BannerDtoCopyWith<$Res> {
  _$BannerDtoCopyWithImpl(this._self, this._then);

  final BannerDto _self;
  final $Res Function(BannerDto) _then;

/// Create a copy of BannerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? subtitle = freezed,Object? description = freezed,Object? redirectionRoute = freezed,Object? imageUrls = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,redirectionRoute: freezed == redirectionRoute ? _self.redirectionRoute : redirectionRoute // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerDto].
extension BannerDtoPatterns on BannerDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerDto value)  $default,){
final _that = this;
switch (_that) {
case _BannerDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerDto value)?  $default,){
final _that = this;
switch (_that) {
case _BannerDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int type,  String title,  String? subtitle,  String? description,  String? redirectionRoute,  List<String> imageUrls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerDto() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.subtitle,_that.description,_that.redirectionRoute,_that.imageUrls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int type,  String title,  String? subtitle,  String? description,  String? redirectionRoute,  List<String> imageUrls)  $default,) {final _that = this;
switch (_that) {
case _BannerDto():
return $default(_that.id,_that.type,_that.title,_that.subtitle,_that.description,_that.redirectionRoute,_that.imageUrls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int type,  String title,  String? subtitle,  String? description,  String? redirectionRoute,  List<String> imageUrls)?  $default,) {final _that = this;
switch (_that) {
case _BannerDto() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.subtitle,_that.description,_that.redirectionRoute,_that.imageUrls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _BannerDto implements BannerDto {
  const _BannerDto({required this.id, required this.type, required this.title, this.subtitle, this.description, this.redirectionRoute, final  List<String> imageUrls = const []}): _imageUrls = imageUrls;
  factory _BannerDto.fromJson(Map<String, dynamic> json) => _$BannerDtoFromJson(json);

@override final  int id;
@override final  int type;
@override final  String title;
@override final  String? subtitle;
@override final  String? description;
@override final  String? redirectionRoute;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}


/// Create a copy of BannerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerDtoCopyWith<_BannerDto> get copyWith => __$BannerDtoCopyWithImpl<_BannerDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.redirectionRoute, redirectionRoute) || other.redirectionRoute == redirectionRoute)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,subtitle,description,redirectionRoute,const DeepCollectionEquality().hash(_imageUrls));

@override
String toString() {
  return 'BannerDto(id: $id, type: $type, title: $title, subtitle: $subtitle, description: $description, redirectionRoute: $redirectionRoute, imageUrls: $imageUrls)';
}


}

/// @nodoc
abstract mixin class _$BannerDtoCopyWith<$Res> implements $BannerDtoCopyWith<$Res> {
  factory _$BannerDtoCopyWith(_BannerDto value, $Res Function(_BannerDto) _then) = __$BannerDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int type, String title, String? subtitle, String? description, String? redirectionRoute, List<String> imageUrls
});




}
/// @nodoc
class __$BannerDtoCopyWithImpl<$Res>
    implements _$BannerDtoCopyWith<$Res> {
  __$BannerDtoCopyWithImpl(this._self, this._then);

  final _BannerDto _self;
  final $Res Function(_BannerDto) _then;

/// Create a copy of BannerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? subtitle = freezed,Object? description = freezed,Object? redirectionRoute = freezed,Object? imageUrls = null,}) {
  return _then(_BannerDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,redirectionRoute: freezed == redirectionRoute ? _self.redirectionRoute : redirectionRoute // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
