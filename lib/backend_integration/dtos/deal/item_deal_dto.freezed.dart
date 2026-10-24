// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_deal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemDealDto {

 int get dealId; double get dealPrice;// Null when the deal never ends, so no countdown is shown.
@ServerUtcDateConverter() DateTime? get expiresAt;
/// Create a copy of ItemDealDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDealDtoCopyWith<ItemDealDto> get copyWith => _$ItemDealDtoCopyWithImpl<ItemDealDto>(this as ItemDealDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDealDto&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.dealPrice, dealPrice) || other.dealPrice == dealPrice)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dealId,dealPrice,expiresAt);

@override
String toString() {
  return 'ItemDealDto(dealId: $dealId, dealPrice: $dealPrice, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $ItemDealDtoCopyWith<$Res>  {
  factory $ItemDealDtoCopyWith(ItemDealDto value, $Res Function(ItemDealDto) _then) = _$ItemDealDtoCopyWithImpl;
@useResult
$Res call({
 int dealId, double dealPrice,@ServerUtcDateConverter() DateTime? expiresAt
});




}
/// @nodoc
class _$ItemDealDtoCopyWithImpl<$Res>
    implements $ItemDealDtoCopyWith<$Res> {
  _$ItemDealDtoCopyWithImpl(this._self, this._then);

  final ItemDealDto _self;
  final $Res Function(ItemDealDto) _then;

/// Create a copy of ItemDealDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dealId = null,Object? dealPrice = null,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,dealPrice: null == dealPrice ? _self.dealPrice : dealPrice // ignore: cast_nullable_to_non_nullable
as double,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDealDto].
extension ItemDealDtoPatterns on ItemDealDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDealDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDealDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDealDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDealDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDealDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDealDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dealId,  double dealPrice, @ServerUtcDateConverter()  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDealDto() when $default != null:
return $default(_that.dealId,_that.dealPrice,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dealId,  double dealPrice, @ServerUtcDateConverter()  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _ItemDealDto():
return $default(_that.dealId,_that.dealPrice,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dealId,  double dealPrice, @ServerUtcDateConverter()  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _ItemDealDto() when $default != null:
return $default(_that.dealId,_that.dealPrice,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemDealDto extends ItemDealDto {
  const _ItemDealDto({required this.dealId, required this.dealPrice, @ServerUtcDateConverter() this.expiresAt}): super._();
  factory _ItemDealDto.fromJson(Map<String, dynamic> json) => _$ItemDealDtoFromJson(json);

@override final  int dealId;
@override final  double dealPrice;
// Null when the deal never ends, so no countdown is shown.
@override@ServerUtcDateConverter() final  DateTime? expiresAt;

/// Create a copy of ItemDealDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDealDtoCopyWith<_ItemDealDto> get copyWith => __$ItemDealDtoCopyWithImpl<_ItemDealDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDealDto&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.dealPrice, dealPrice) || other.dealPrice == dealPrice)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dealId,dealPrice,expiresAt);

@override
String toString() {
  return 'ItemDealDto(dealId: $dealId, dealPrice: $dealPrice, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ItemDealDtoCopyWith<$Res> implements $ItemDealDtoCopyWith<$Res> {
  factory _$ItemDealDtoCopyWith(_ItemDealDto value, $Res Function(_ItemDealDto) _then) = __$ItemDealDtoCopyWithImpl;
@override @useResult
$Res call({
 int dealId, double dealPrice,@ServerUtcDateConverter() DateTime? expiresAt
});




}
/// @nodoc
class __$ItemDealDtoCopyWithImpl<$Res>
    implements _$ItemDealDtoCopyWith<$Res> {
  __$ItemDealDtoCopyWithImpl(this._self, this._then);

  final _ItemDealDto _self;
  final $Res Function(_ItemDealDto) _then;

/// Create a copy of ItemDealDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dealId = null,Object? dealPrice = null,Object? expiresAt = freezed,}) {
  return _then(_ItemDealDto(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,dealPrice: null == dealPrice ? _self.dealPrice : dealPrice // ignore: cast_nullable_to_non_nullable
as double,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
