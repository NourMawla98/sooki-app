// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'for_you_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForYouItemDto {

 int get id; String get title; String? get imageUrl; double get originalPrice; double? get discountedPrice; String get reasonMessage;
/// Create a copy of ForYouItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForYouItemDtoCopyWith<ForYouItemDto> get copyWith => _$ForYouItemDtoCopyWithImpl<ForYouItemDto>(this as ForYouItemDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForYouItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.reasonMessage, reasonMessage) || other.reasonMessage == reasonMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,imageUrl,originalPrice,discountedPrice,reasonMessage);

@override
String toString() {
  return 'ForYouItemDto(id: $id, title: $title, imageUrl: $imageUrl, originalPrice: $originalPrice, discountedPrice: $discountedPrice, reasonMessage: $reasonMessage)';
}


}

/// @nodoc
abstract mixin class $ForYouItemDtoCopyWith<$Res>  {
  factory $ForYouItemDtoCopyWith(ForYouItemDto value, $Res Function(ForYouItemDto) _then) = _$ForYouItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? imageUrl, double originalPrice, double? discountedPrice, String reasonMessage
});




}
/// @nodoc
class _$ForYouItemDtoCopyWithImpl<$Res>
    implements $ForYouItemDtoCopyWith<$Res> {
  _$ForYouItemDtoCopyWithImpl(this._self, this._then);

  final ForYouItemDto _self;
  final $Res Function(ForYouItemDto) _then;

/// Create a copy of ForYouItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? imageUrl = freezed,Object? originalPrice = null,Object? discountedPrice = freezed,Object? reasonMessage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,reasonMessage: null == reasonMessage ? _self.reasonMessage : reasonMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ForYouItemDto].
extension ForYouItemDtoPatterns on ForYouItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForYouItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForYouItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForYouItemDto value)  $default,){
final _that = this;
switch (_that) {
case _ForYouItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForYouItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _ForYouItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? imageUrl,  double originalPrice,  double? discountedPrice,  String reasonMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForYouItemDto() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.originalPrice,_that.discountedPrice,_that.reasonMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? imageUrl,  double originalPrice,  double? discountedPrice,  String reasonMessage)  $default,) {final _that = this;
switch (_that) {
case _ForYouItemDto():
return $default(_that.id,_that.title,_that.imageUrl,_that.originalPrice,_that.discountedPrice,_that.reasonMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? imageUrl,  double originalPrice,  double? discountedPrice,  String reasonMessage)?  $default,) {final _that = this;
switch (_that) {
case _ForYouItemDto() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.originalPrice,_that.discountedPrice,_that.reasonMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ForYouItemDto implements ForYouItemDto {
  const _ForYouItemDto({required this.id, required this.title, this.imageUrl, required this.originalPrice, this.discountedPrice, required this.reasonMessage});
  factory _ForYouItemDto.fromJson(Map<String, dynamic> json) => _$ForYouItemDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  String? imageUrl;
@override final  double originalPrice;
@override final  double? discountedPrice;
@override final  String reasonMessage;

/// Create a copy of ForYouItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForYouItemDtoCopyWith<_ForYouItemDto> get copyWith => __$ForYouItemDtoCopyWithImpl<_ForYouItemDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForYouItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.reasonMessage, reasonMessage) || other.reasonMessage == reasonMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,imageUrl,originalPrice,discountedPrice,reasonMessage);

@override
String toString() {
  return 'ForYouItemDto(id: $id, title: $title, imageUrl: $imageUrl, originalPrice: $originalPrice, discountedPrice: $discountedPrice, reasonMessage: $reasonMessage)';
}


}

/// @nodoc
abstract mixin class _$ForYouItemDtoCopyWith<$Res> implements $ForYouItemDtoCopyWith<$Res> {
  factory _$ForYouItemDtoCopyWith(_ForYouItemDto value, $Res Function(_ForYouItemDto) _then) = __$ForYouItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? imageUrl, double originalPrice, double? discountedPrice, String reasonMessage
});




}
/// @nodoc
class __$ForYouItemDtoCopyWithImpl<$Res>
    implements _$ForYouItemDtoCopyWith<$Res> {
  __$ForYouItemDtoCopyWithImpl(this._self, this._then);

  final _ForYouItemDto _self;
  final $Res Function(_ForYouItemDto) _then;

/// Create a copy of ForYouItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? imageUrl = freezed,Object? originalPrice = null,Object? discountedPrice = freezed,Object? reasonMessage = null,}) {
  return _then(_ForYouItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,reasonMessage: null == reasonMessage ? _self.reasonMessage : reasonMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
