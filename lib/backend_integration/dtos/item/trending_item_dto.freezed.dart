// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trending_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrendingItemDto {

 int get id; String get title; String get imageUrl;// Current price before any deal.
 double get price; ItemDealDto? get deal;
/// Create a copy of TrendingItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendingItemDtoCopyWith<TrendingItemDto> get copyWith => _$TrendingItemDtoCopyWithImpl<TrendingItemDto>(this as TrendingItemDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendingItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price)&&(identical(other.deal, deal) || other.deal == deal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,imageUrl,price,deal);

@override
String toString() {
  return 'TrendingItemDto(id: $id, title: $title, imageUrl: $imageUrl, price: $price, deal: $deal)';
}


}

/// @nodoc
abstract mixin class $TrendingItemDtoCopyWith<$Res>  {
  factory $TrendingItemDtoCopyWith(TrendingItemDto value, $Res Function(TrendingItemDto) _then) = _$TrendingItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String imageUrl, double price, ItemDealDto? deal
});


$ItemDealDtoCopyWith<$Res>? get deal;

}
/// @nodoc
class _$TrendingItemDtoCopyWithImpl<$Res>
    implements $TrendingItemDtoCopyWith<$Res> {
  _$TrendingItemDtoCopyWithImpl(this._self, this._then);

  final TrendingItemDto _self;
  final $Res Function(TrendingItemDto) _then;

/// Create a copy of TrendingItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? imageUrl = null,Object? price = null,Object? deal = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,deal: freezed == deal ? _self.deal : deal // ignore: cast_nullable_to_non_nullable
as ItemDealDto?,
  ));
}
/// Create a copy of TrendingItemDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemDealDtoCopyWith<$Res>? get deal {
    if (_self.deal == null) {
    return null;
  }

  return $ItemDealDtoCopyWith<$Res>(_self.deal!, (value) {
    return _then(_self.copyWith(deal: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrendingItemDto].
extension TrendingItemDtoPatterns on TrendingItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendingItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendingItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendingItemDto value)  $default,){
final _that = this;
switch (_that) {
case _TrendingItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendingItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _TrendingItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String imageUrl,  double price,  ItemDealDto? deal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendingItemDto() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.price,_that.deal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String imageUrl,  double price,  ItemDealDto? deal)  $default,) {final _that = this;
switch (_that) {
case _TrendingItemDto():
return $default(_that.id,_that.title,_that.imageUrl,_that.price,_that.deal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String imageUrl,  double price,  ItemDealDto? deal)?  $default,) {final _that = this;
switch (_that) {
case _TrendingItemDto() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.price,_that.deal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _TrendingItemDto implements TrendingItemDto {
  const _TrendingItemDto({required this.id, required this.title, required this.imageUrl, required this.price, this.deal});
  factory _TrendingItemDto.fromJson(Map<String, dynamic> json) => _$TrendingItemDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  String imageUrl;
// Current price before any deal.
@override final  double price;
@override final  ItemDealDto? deal;

/// Create a copy of TrendingItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendingItemDtoCopyWith<_TrendingItemDto> get copyWith => __$TrendingItemDtoCopyWithImpl<_TrendingItemDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendingItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.price, price) || other.price == price)&&(identical(other.deal, deal) || other.deal == deal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,imageUrl,price,deal);

@override
String toString() {
  return 'TrendingItemDto(id: $id, title: $title, imageUrl: $imageUrl, price: $price, deal: $deal)';
}


}

/// @nodoc
abstract mixin class _$TrendingItemDtoCopyWith<$Res> implements $TrendingItemDtoCopyWith<$Res> {
  factory _$TrendingItemDtoCopyWith(_TrendingItemDto value, $Res Function(_TrendingItemDto) _then) = __$TrendingItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String imageUrl, double price, ItemDealDto? deal
});


@override $ItemDealDtoCopyWith<$Res>? get deal;

}
/// @nodoc
class __$TrendingItemDtoCopyWithImpl<$Res>
    implements _$TrendingItemDtoCopyWith<$Res> {
  __$TrendingItemDtoCopyWithImpl(this._self, this._then);

  final _TrendingItemDto _self;
  final $Res Function(_TrendingItemDto) _then;

/// Create a copy of TrendingItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? imageUrl = null,Object? price = null,Object? deal = freezed,}) {
  return _then(_TrendingItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,deal: freezed == deal ? _self.deal : deal // ignore: cast_nullable_to_non_nullable
as ItemDealDto?,
  ));
}

/// Create a copy of TrendingItemDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemDealDtoCopyWith<$Res>? get deal {
    if (_self.deal == null) {
    return null;
  }

  return $ItemDealDtoCopyWith<$Res>(_self.deal!, (value) {
    return _then(_self.copyWith(deal: value));
  });
}
}

// dart format on
