// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_offer_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemOfferDto {

 int get dealId; int get type; String get title;// Multi-buy: the percent off once [minQuantity] units are in the cart.
 double? get discountPercent; int? get minQuantity;// Bundle: one full set for [bundlePrice] instead of [originalTotal].
 double? get bundlePrice; double? get originalTotal;// Whether this item is bought or handed out free in the deal.
 int get role;// Null when the deal never ends.
@ServerUtcDateConverter() DateTime? get expiresAt;
/// Create a copy of ItemOfferDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemOfferDtoCopyWith<ItemOfferDto> get copyWith => _$ItemOfferDtoCopyWithImpl<ItemOfferDto>(this as ItemOfferDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemOfferDto&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.bundlePrice, bundlePrice) || other.bundlePrice == bundlePrice)&&(identical(other.originalTotal, originalTotal) || other.originalTotal == originalTotal)&&(identical(other.role, role) || other.role == role)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dealId,type,title,discountPercent,minQuantity,bundlePrice,originalTotal,role,expiresAt);

@override
String toString() {
  return 'ItemOfferDto(dealId: $dealId, type: $type, title: $title, discountPercent: $discountPercent, minQuantity: $minQuantity, bundlePrice: $bundlePrice, originalTotal: $originalTotal, role: $role, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $ItemOfferDtoCopyWith<$Res>  {
  factory $ItemOfferDtoCopyWith(ItemOfferDto value, $Res Function(ItemOfferDto) _then) = _$ItemOfferDtoCopyWithImpl;
@useResult
$Res call({
 int dealId, int type, String title, double? discountPercent, int? minQuantity, double? bundlePrice, double? originalTotal, int role,@ServerUtcDateConverter() DateTime? expiresAt
});




}
/// @nodoc
class _$ItemOfferDtoCopyWithImpl<$Res>
    implements $ItemOfferDtoCopyWith<$Res> {
  _$ItemOfferDtoCopyWithImpl(this._self, this._then);

  final ItemOfferDto _self;
  final $Res Function(ItemOfferDto) _then;

/// Create a copy of ItemOfferDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dealId = null,Object? type = null,Object? title = null,Object? discountPercent = freezed,Object? minQuantity = freezed,Object? bundlePrice = freezed,Object? originalTotal = freezed,Object? role = null,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double?,minQuantity: freezed == minQuantity ? _self.minQuantity : minQuantity // ignore: cast_nullable_to_non_nullable
as int?,bundlePrice: freezed == bundlePrice ? _self.bundlePrice : bundlePrice // ignore: cast_nullable_to_non_nullable
as double?,originalTotal: freezed == originalTotal ? _self.originalTotal : originalTotal // ignore: cast_nullable_to_non_nullable
as double?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as int,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemOfferDto].
extension ItemOfferDtoPatterns on ItemOfferDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemOfferDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemOfferDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemOfferDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemOfferDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemOfferDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemOfferDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dealId,  int type,  String title,  double? discountPercent,  int? minQuantity,  double? bundlePrice,  double? originalTotal,  int role, @ServerUtcDateConverter()  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemOfferDto() when $default != null:
return $default(_that.dealId,_that.type,_that.title,_that.discountPercent,_that.minQuantity,_that.bundlePrice,_that.originalTotal,_that.role,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dealId,  int type,  String title,  double? discountPercent,  int? minQuantity,  double? bundlePrice,  double? originalTotal,  int role, @ServerUtcDateConverter()  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _ItemOfferDto():
return $default(_that.dealId,_that.type,_that.title,_that.discountPercent,_that.minQuantity,_that.bundlePrice,_that.originalTotal,_that.role,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dealId,  int type,  String title,  double? discountPercent,  int? minQuantity,  double? bundlePrice,  double? originalTotal,  int role, @ServerUtcDateConverter()  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _ItemOfferDto() when $default != null:
return $default(_that.dealId,_that.type,_that.title,_that.discountPercent,_that.minQuantity,_that.bundlePrice,_that.originalTotal,_that.role,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemOfferDto extends ItemOfferDto {
  const _ItemOfferDto({required this.dealId, this.type = 1, this.title = '', this.discountPercent, this.minQuantity, this.bundlePrice, this.originalTotal, this.role = 1, @ServerUtcDateConverter() this.expiresAt}): super._();
  factory _ItemOfferDto.fromJson(Map<String, dynamic> json) => _$ItemOfferDtoFromJson(json);

@override final  int dealId;
@override@JsonKey() final  int type;
@override@JsonKey() final  String title;
// Multi-buy: the percent off once [minQuantity] units are in the cart.
@override final  double? discountPercent;
@override final  int? minQuantity;
// Bundle: one full set for [bundlePrice] instead of [originalTotal].
@override final  double? bundlePrice;
@override final  double? originalTotal;
// Whether this item is bought or handed out free in the deal.
@override@JsonKey() final  int role;
// Null when the deal never ends.
@override@ServerUtcDateConverter() final  DateTime? expiresAt;

/// Create a copy of ItemOfferDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemOfferDtoCopyWith<_ItemOfferDto> get copyWith => __$ItemOfferDtoCopyWithImpl<_ItemOfferDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemOfferDto&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.bundlePrice, bundlePrice) || other.bundlePrice == bundlePrice)&&(identical(other.originalTotal, originalTotal) || other.originalTotal == originalTotal)&&(identical(other.role, role) || other.role == role)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dealId,type,title,discountPercent,minQuantity,bundlePrice,originalTotal,role,expiresAt);

@override
String toString() {
  return 'ItemOfferDto(dealId: $dealId, type: $type, title: $title, discountPercent: $discountPercent, minQuantity: $minQuantity, bundlePrice: $bundlePrice, originalTotal: $originalTotal, role: $role, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ItemOfferDtoCopyWith<$Res> implements $ItemOfferDtoCopyWith<$Res> {
  factory _$ItemOfferDtoCopyWith(_ItemOfferDto value, $Res Function(_ItemOfferDto) _then) = __$ItemOfferDtoCopyWithImpl;
@override @useResult
$Res call({
 int dealId, int type, String title, double? discountPercent, int? minQuantity, double? bundlePrice, double? originalTotal, int role,@ServerUtcDateConverter() DateTime? expiresAt
});




}
/// @nodoc
class __$ItemOfferDtoCopyWithImpl<$Res>
    implements _$ItemOfferDtoCopyWith<$Res> {
  __$ItemOfferDtoCopyWithImpl(this._self, this._then);

  final _ItemOfferDto _self;
  final $Res Function(_ItemOfferDto) _then;

/// Create a copy of ItemOfferDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dealId = null,Object? type = null,Object? title = null,Object? discountPercent = freezed,Object? minQuantity = freezed,Object? bundlePrice = freezed,Object? originalTotal = freezed,Object? role = null,Object? expiresAt = freezed,}) {
  return _then(_ItemOfferDto(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double?,minQuantity: freezed == minQuantity ? _self.minQuantity : minQuantity // ignore: cast_nullable_to_non_nullable
as int?,bundlePrice: freezed == bundlePrice ? _self.bundlePrice : bundlePrice // ignore: cast_nullable_to_non_nullable
as double?,originalTotal: freezed == originalTotal ? _self.originalTotal : originalTotal // ignore: cast_nullable_to_non_nullable
as double?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as int,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
