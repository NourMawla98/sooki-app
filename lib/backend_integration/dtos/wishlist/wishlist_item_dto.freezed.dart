// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WishlistItemDto {

 int get id; int get itemId; String get itemTitle; String? get mainImageUrl; double get originalPrice; double? get discountedPrice; bool get isAvailable;
/// Create a copy of WishlistItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishlistItemDtoCopyWith<WishlistItemDto> get copyWith => _$WishlistItemDtoCopyWithImpl<WishlistItemDto>(this as WishlistItemDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishlistItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemTitle, itemTitle) || other.itemTitle == itemTitle)&&(identical(other.mainImageUrl, mainImageUrl) || other.mainImageUrl == mainImageUrl)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,itemTitle,mainImageUrl,originalPrice,discountedPrice,isAvailable);

@override
String toString() {
  return 'WishlistItemDto(id: $id, itemId: $itemId, itemTitle: $itemTitle, mainImageUrl: $mainImageUrl, originalPrice: $originalPrice, discountedPrice: $discountedPrice, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $WishlistItemDtoCopyWith<$Res>  {
  factory $WishlistItemDtoCopyWith(WishlistItemDto value, $Res Function(WishlistItemDto) _then) = _$WishlistItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, int itemId, String itemTitle, String? mainImageUrl, double originalPrice, double? discountedPrice, bool isAvailable
});




}
/// @nodoc
class _$WishlistItemDtoCopyWithImpl<$Res>
    implements $WishlistItemDtoCopyWith<$Res> {
  _$WishlistItemDtoCopyWithImpl(this._self, this._then);

  final WishlistItemDto _self;
  final $Res Function(WishlistItemDto) _then;

/// Create a copy of WishlistItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? itemTitle = null,Object? mainImageUrl = freezed,Object? originalPrice = null,Object? discountedPrice = freezed,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,itemTitle: null == itemTitle ? _self.itemTitle : itemTitle // ignore: cast_nullable_to_non_nullable
as String,mainImageUrl: freezed == mainImageUrl ? _self.mainImageUrl : mainImageUrl // ignore: cast_nullable_to_non_nullable
as String?,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WishlistItemDto].
extension WishlistItemDtoPatterns on WishlistItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishlistItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishlistItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishlistItemDto value)  $default,){
final _that = this;
switch (_that) {
case _WishlistItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishlistItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _WishlistItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int itemId,  String itemTitle,  String? mainImageUrl,  double originalPrice,  double? discountedPrice,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishlistItemDto() when $default != null:
return $default(_that.id,_that.itemId,_that.itemTitle,_that.mainImageUrl,_that.originalPrice,_that.discountedPrice,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int itemId,  String itemTitle,  String? mainImageUrl,  double originalPrice,  double? discountedPrice,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _WishlistItemDto():
return $default(_that.id,_that.itemId,_that.itemTitle,_that.mainImageUrl,_that.originalPrice,_that.discountedPrice,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int itemId,  String itemTitle,  String? mainImageUrl,  double originalPrice,  double? discountedPrice,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _WishlistItemDto() when $default != null:
return $default(_that.id,_that.itemId,_that.itemTitle,_that.mainImageUrl,_that.originalPrice,_that.discountedPrice,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _WishlistItemDto implements WishlistItemDto {
  const _WishlistItemDto({required this.id, required this.itemId, required this.itemTitle, this.mainImageUrl, required this.originalPrice, this.discountedPrice, required this.isAvailable});
  factory _WishlistItemDto.fromJson(Map<String, dynamic> json) => _$WishlistItemDtoFromJson(json);

@override final  int id;
@override final  int itemId;
@override final  String itemTitle;
@override final  String? mainImageUrl;
@override final  double originalPrice;
@override final  double? discountedPrice;
@override final  bool isAvailable;

/// Create a copy of WishlistItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishlistItemDtoCopyWith<_WishlistItemDto> get copyWith => __$WishlistItemDtoCopyWithImpl<_WishlistItemDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishlistItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemTitle, itemTitle) || other.itemTitle == itemTitle)&&(identical(other.mainImageUrl, mainImageUrl) || other.mainImageUrl == mainImageUrl)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,itemTitle,mainImageUrl,originalPrice,discountedPrice,isAvailable);

@override
String toString() {
  return 'WishlistItemDto(id: $id, itemId: $itemId, itemTitle: $itemTitle, mainImageUrl: $mainImageUrl, originalPrice: $originalPrice, discountedPrice: $discountedPrice, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$WishlistItemDtoCopyWith<$Res> implements $WishlistItemDtoCopyWith<$Res> {
  factory _$WishlistItemDtoCopyWith(_WishlistItemDto value, $Res Function(_WishlistItemDto) _then) = __$WishlistItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int itemId, String itemTitle, String? mainImageUrl, double originalPrice, double? discountedPrice, bool isAvailable
});




}
/// @nodoc
class __$WishlistItemDtoCopyWithImpl<$Res>
    implements _$WishlistItemDtoCopyWith<$Res> {
  __$WishlistItemDtoCopyWithImpl(this._self, this._then);

  final _WishlistItemDto _self;
  final $Res Function(_WishlistItemDto) _then;

/// Create a copy of WishlistItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? itemTitle = null,Object? mainImageUrl = freezed,Object? originalPrice = null,Object? discountedPrice = freezed,Object? isAvailable = null,}) {
  return _then(_WishlistItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,itemTitle: null == itemTitle ? _self.itemTitle : itemTitle // ignore: cast_nullable_to_non_nullable
as String,mainImageUrl: freezed == mainImageUrl ? _self.mainImageUrl : mainImageUrl // ignore: cast_nullable_to_non_nullable
as String?,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
