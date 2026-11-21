// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartResponseDto {

 int get itemCount;// Before any deal, fixed price deals included.
 double get subtotal;// After every deal; null from a backend that predates it.
 double? get total; List<CartItemDto> get items;// Everything deals take off the cart, fixed price deals included.
 double get dealDiscount;// The part of [dealDiscount] that fixed price deals save.
 double get singleItemDiscount; List<AppliedDealDto> get appliedDeals;// The best live spend deal, null when none is live.
 SpendDealDto? get spendDeal;
/// Create a copy of CartResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartResponseDtoCopyWith<CartResponseDto> get copyWith => _$CartResponseDtoCopyWithImpl<CartResponseDto>(this as CartResponseDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartResponseDto&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.dealDiscount, dealDiscount) || other.dealDiscount == dealDiscount)&&(identical(other.singleItemDiscount, singleItemDiscount) || other.singleItemDiscount == singleItemDiscount)&&const DeepCollectionEquality().equals(other.appliedDeals, appliedDeals)&&(identical(other.spendDeal, spendDeal) || other.spendDeal == spendDeal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemCount,subtotal,total,const DeepCollectionEquality().hash(items),dealDiscount,singleItemDiscount,const DeepCollectionEquality().hash(appliedDeals),spendDeal);

@override
String toString() {
  return 'CartResponseDto(itemCount: $itemCount, subtotal: $subtotal, total: $total, items: $items, dealDiscount: $dealDiscount, singleItemDiscount: $singleItemDiscount, appliedDeals: $appliedDeals, spendDeal: $spendDeal)';
}


}

/// @nodoc
abstract mixin class $CartResponseDtoCopyWith<$Res>  {
  factory $CartResponseDtoCopyWith(CartResponseDto value, $Res Function(CartResponseDto) _then) = _$CartResponseDtoCopyWithImpl;
@useResult
$Res call({
 int itemCount, double subtotal, double? total, List<CartItemDto> items, double dealDiscount, double singleItemDiscount, List<AppliedDealDto> appliedDeals, SpendDealDto? spendDeal
});


$SpendDealDtoCopyWith<$Res>? get spendDeal;

}
/// @nodoc
class _$CartResponseDtoCopyWithImpl<$Res>
    implements $CartResponseDtoCopyWith<$Res> {
  _$CartResponseDtoCopyWithImpl(this._self, this._then);

  final CartResponseDto _self;
  final $Res Function(CartResponseDto) _then;

/// Create a copy of CartResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemCount = null,Object? subtotal = null,Object? total = freezed,Object? items = null,Object? dealDiscount = null,Object? singleItemDiscount = null,Object? appliedDeals = null,Object? spendDeal = freezed,}) {
  return _then(_self.copyWith(
itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemDto>,dealDiscount: null == dealDiscount ? _self.dealDiscount : dealDiscount // ignore: cast_nullable_to_non_nullable
as double,singleItemDiscount: null == singleItemDiscount ? _self.singleItemDiscount : singleItemDiscount // ignore: cast_nullable_to_non_nullable
as double,appliedDeals: null == appliedDeals ? _self.appliedDeals : appliedDeals // ignore: cast_nullable_to_non_nullable
as List<AppliedDealDto>,spendDeal: freezed == spendDeal ? _self.spendDeal : spendDeal // ignore: cast_nullable_to_non_nullable
as SpendDealDto?,
  ));
}
/// Create a copy of CartResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpendDealDtoCopyWith<$Res>? get spendDeal {
    if (_self.spendDeal == null) {
    return null;
  }

  return $SpendDealDtoCopyWith<$Res>(_self.spendDeal!, (value) {
    return _then(_self.copyWith(spendDeal: value));
  });
}
}


/// Adds pattern-matching-related methods to [CartResponseDto].
extension CartResponseDtoPatterns on CartResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _CartResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _CartResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int itemCount,  double subtotal,  double? total,  List<CartItemDto> items,  double dealDiscount,  double singleItemDiscount,  List<AppliedDealDto> appliedDeals,  SpendDealDto? spendDeal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartResponseDto() when $default != null:
return $default(_that.itemCount,_that.subtotal,_that.total,_that.items,_that.dealDiscount,_that.singleItemDiscount,_that.appliedDeals,_that.spendDeal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int itemCount,  double subtotal,  double? total,  List<CartItemDto> items,  double dealDiscount,  double singleItemDiscount,  List<AppliedDealDto> appliedDeals,  SpendDealDto? spendDeal)  $default,) {final _that = this;
switch (_that) {
case _CartResponseDto():
return $default(_that.itemCount,_that.subtotal,_that.total,_that.items,_that.dealDiscount,_that.singleItemDiscount,_that.appliedDeals,_that.spendDeal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int itemCount,  double subtotal,  double? total,  List<CartItemDto> items,  double dealDiscount,  double singleItemDiscount,  List<AppliedDealDto> appliedDeals,  SpendDealDto? spendDeal)?  $default,) {final _that = this;
switch (_that) {
case _CartResponseDto() when $default != null:
return $default(_that.itemCount,_that.subtotal,_that.total,_that.items,_that.dealDiscount,_that.singleItemDiscount,_that.appliedDeals,_that.spendDeal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _CartResponseDto implements CartResponseDto {
  const _CartResponseDto({required this.itemCount, required this.subtotal, this.total, final  List<CartItemDto> items = const [], this.dealDiscount = 0.0, this.singleItemDiscount = 0.0, final  List<AppliedDealDto> appliedDeals = const [], this.spendDeal}): _items = items,_appliedDeals = appliedDeals;
  factory _CartResponseDto.fromJson(Map<String, dynamic> json) => _$CartResponseDtoFromJson(json);

@override final  int itemCount;
// Before any deal, fixed price deals included.
@override final  double subtotal;
// After every deal; null from a backend that predates it.
@override final  double? total;
 final  List<CartItemDto> _items;
@override@JsonKey() List<CartItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

// Everything deals take off the cart, fixed price deals included.
@override@JsonKey() final  double dealDiscount;
// The part of [dealDiscount] that fixed price deals save.
@override@JsonKey() final  double singleItemDiscount;
 final  List<AppliedDealDto> _appliedDeals;
@override@JsonKey() List<AppliedDealDto> get appliedDeals {
  if (_appliedDeals is EqualUnmodifiableListView) return _appliedDeals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_appliedDeals);
}

// The best live spend deal, null when none is live.
@override final  SpendDealDto? spendDeal;

/// Create a copy of CartResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartResponseDtoCopyWith<_CartResponseDto> get copyWith => __$CartResponseDtoCopyWithImpl<_CartResponseDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartResponseDto&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.dealDiscount, dealDiscount) || other.dealDiscount == dealDiscount)&&(identical(other.singleItemDiscount, singleItemDiscount) || other.singleItemDiscount == singleItemDiscount)&&const DeepCollectionEquality().equals(other._appliedDeals, _appliedDeals)&&(identical(other.spendDeal, spendDeal) || other.spendDeal == spendDeal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemCount,subtotal,total,const DeepCollectionEquality().hash(_items),dealDiscount,singleItemDiscount,const DeepCollectionEquality().hash(_appliedDeals),spendDeal);

@override
String toString() {
  return 'CartResponseDto(itemCount: $itemCount, subtotal: $subtotal, total: $total, items: $items, dealDiscount: $dealDiscount, singleItemDiscount: $singleItemDiscount, appliedDeals: $appliedDeals, spendDeal: $spendDeal)';
}


}

/// @nodoc
abstract mixin class _$CartResponseDtoCopyWith<$Res> implements $CartResponseDtoCopyWith<$Res> {
  factory _$CartResponseDtoCopyWith(_CartResponseDto value, $Res Function(_CartResponseDto) _then) = __$CartResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int itemCount, double subtotal, double? total, List<CartItemDto> items, double dealDiscount, double singleItemDiscount, List<AppliedDealDto> appliedDeals, SpendDealDto? spendDeal
});


@override $SpendDealDtoCopyWith<$Res>? get spendDeal;

}
/// @nodoc
class __$CartResponseDtoCopyWithImpl<$Res>
    implements _$CartResponseDtoCopyWith<$Res> {
  __$CartResponseDtoCopyWithImpl(this._self, this._then);

  final _CartResponseDto _self;
  final $Res Function(_CartResponseDto) _then;

/// Create a copy of CartResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemCount = null,Object? subtotal = null,Object? total = freezed,Object? items = null,Object? dealDiscount = null,Object? singleItemDiscount = null,Object? appliedDeals = null,Object? spendDeal = freezed,}) {
  return _then(_CartResponseDto(
itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemDto>,dealDiscount: null == dealDiscount ? _self.dealDiscount : dealDiscount // ignore: cast_nullable_to_non_nullable
as double,singleItemDiscount: null == singleItemDiscount ? _self.singleItemDiscount : singleItemDiscount // ignore: cast_nullable_to_non_nullable
as double,appliedDeals: null == appliedDeals ? _self._appliedDeals : appliedDeals // ignore: cast_nullable_to_non_nullable
as List<AppliedDealDto>,spendDeal: freezed == spendDeal ? _self.spendDeal : spendDeal // ignore: cast_nullable_to_non_nullable
as SpendDealDto?,
  ));
}

/// Create a copy of CartResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpendDealDtoCopyWith<$Res>? get spendDeal {
    if (_self.spendDeal == null) {
    return null;
  }

  return $SpendDealDtoCopyWith<$Res>(_self.spendDeal!, (value) {
    return _then(_self.copyWith(spendDeal: value));
  });
}
}


/// @nodoc
mixin _$AppliedDealDto {

 int get dealId; int get type; String get title; double get saving;
/// Create a copy of AppliedDealDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppliedDealDtoCopyWith<AppliedDealDto> get copyWith => _$AppliedDealDtoCopyWithImpl<AppliedDealDto>(this as AppliedDealDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppliedDealDto&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.saving, saving) || other.saving == saving));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dealId,type,title,saving);

@override
String toString() {
  return 'AppliedDealDto(dealId: $dealId, type: $type, title: $title, saving: $saving)';
}


}

/// @nodoc
abstract mixin class $AppliedDealDtoCopyWith<$Res>  {
  factory $AppliedDealDtoCopyWith(AppliedDealDto value, $Res Function(AppliedDealDto) _then) = _$AppliedDealDtoCopyWithImpl;
@useResult
$Res call({
 int dealId, int type, String title, double saving
});




}
/// @nodoc
class _$AppliedDealDtoCopyWithImpl<$Res>
    implements $AppliedDealDtoCopyWith<$Res> {
  _$AppliedDealDtoCopyWithImpl(this._self, this._then);

  final AppliedDealDto _self;
  final $Res Function(AppliedDealDto) _then;

/// Create a copy of AppliedDealDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dealId = null,Object? type = null,Object? title = null,Object? saving = null,}) {
  return _then(_self.copyWith(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AppliedDealDto].
extension AppliedDealDtoPatterns on AppliedDealDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppliedDealDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppliedDealDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppliedDealDto value)  $default,){
final _that = this;
switch (_that) {
case _AppliedDealDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppliedDealDto value)?  $default,){
final _that = this;
switch (_that) {
case _AppliedDealDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dealId,  int type,  String title,  double saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppliedDealDto() when $default != null:
return $default(_that.dealId,_that.type,_that.title,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dealId,  int type,  String title,  double saving)  $default,) {final _that = this;
switch (_that) {
case _AppliedDealDto():
return $default(_that.dealId,_that.type,_that.title,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dealId,  int type,  String title,  double saving)?  $default,) {final _that = this;
switch (_that) {
case _AppliedDealDto() when $default != null:
return $default(_that.dealId,_that.type,_that.title,_that.saving);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _AppliedDealDto implements AppliedDealDto {
  const _AppliedDealDto({required this.dealId, this.type = 1, this.title = '', this.saving = 0.0});
  factory _AppliedDealDto.fromJson(Map<String, dynamic> json) => _$AppliedDealDtoFromJson(json);

@override final  int dealId;
@override@JsonKey() final  int type;
@override@JsonKey() final  String title;
@override@JsonKey() final  double saving;

/// Create a copy of AppliedDealDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppliedDealDtoCopyWith<_AppliedDealDto> get copyWith => __$AppliedDealDtoCopyWithImpl<_AppliedDealDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppliedDealDto&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.saving, saving) || other.saving == saving));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dealId,type,title,saving);

@override
String toString() {
  return 'AppliedDealDto(dealId: $dealId, type: $type, title: $title, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$AppliedDealDtoCopyWith<$Res> implements $AppliedDealDtoCopyWith<$Res> {
  factory _$AppliedDealDtoCopyWith(_AppliedDealDto value, $Res Function(_AppliedDealDto) _then) = __$AppliedDealDtoCopyWithImpl;
@override @useResult
$Res call({
 int dealId, int type, String title, double saving
});




}
/// @nodoc
class __$AppliedDealDtoCopyWithImpl<$Res>
    implements _$AppliedDealDtoCopyWith<$Res> {
  __$AppliedDealDtoCopyWithImpl(this._self, this._then);

  final _AppliedDealDto _self;
  final $Res Function(_AppliedDealDto) _then;

/// Create a copy of AppliedDealDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dealId = null,Object? type = null,Object? title = null,Object? saving = null,}) {
  return _then(_AppliedDealDto(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$SpendDealDto {

 int get dealId; String get title; double get spendThreshold; double get discountPercent;// The subtotal after the other deals, which is what counts to the threshold.
 double get eligibleSubtotal; double get remaining; bool get unlocked;
/// Create a copy of SpendDealDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpendDealDtoCopyWith<SpendDealDto> get copyWith => _$SpendDealDtoCopyWithImpl<SpendDealDto>(this as SpendDealDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpendDealDto&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.title, title) || other.title == title)&&(identical(other.spendThreshold, spendThreshold) || other.spendThreshold == spendThreshold)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.eligibleSubtotal, eligibleSubtotal) || other.eligibleSubtotal == eligibleSubtotal)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.unlocked, unlocked) || other.unlocked == unlocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dealId,title,spendThreshold,discountPercent,eligibleSubtotal,remaining,unlocked);

@override
String toString() {
  return 'SpendDealDto(dealId: $dealId, title: $title, spendThreshold: $spendThreshold, discountPercent: $discountPercent, eligibleSubtotal: $eligibleSubtotal, remaining: $remaining, unlocked: $unlocked)';
}


}

/// @nodoc
abstract mixin class $SpendDealDtoCopyWith<$Res>  {
  factory $SpendDealDtoCopyWith(SpendDealDto value, $Res Function(SpendDealDto) _then) = _$SpendDealDtoCopyWithImpl;
@useResult
$Res call({
 int dealId, String title, double spendThreshold, double discountPercent, double eligibleSubtotal, double remaining, bool unlocked
});




}
/// @nodoc
class _$SpendDealDtoCopyWithImpl<$Res>
    implements $SpendDealDtoCopyWith<$Res> {
  _$SpendDealDtoCopyWithImpl(this._self, this._then);

  final SpendDealDto _self;
  final $Res Function(SpendDealDto) _then;

/// Create a copy of SpendDealDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dealId = null,Object? title = null,Object? spendThreshold = null,Object? discountPercent = null,Object? eligibleSubtotal = null,Object? remaining = null,Object? unlocked = null,}) {
  return _then(_self.copyWith(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,spendThreshold: null == spendThreshold ? _self.spendThreshold : spendThreshold // ignore: cast_nullable_to_non_nullable
as double,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double,eligibleSubtotal: null == eligibleSubtotal ? _self.eligibleSubtotal : eligibleSubtotal // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,unlocked: null == unlocked ? _self.unlocked : unlocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SpendDealDto].
extension SpendDealDtoPatterns on SpendDealDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpendDealDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpendDealDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpendDealDto value)  $default,){
final _that = this;
switch (_that) {
case _SpendDealDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpendDealDto value)?  $default,){
final _that = this;
switch (_that) {
case _SpendDealDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dealId,  String title,  double spendThreshold,  double discountPercent,  double eligibleSubtotal,  double remaining,  bool unlocked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpendDealDto() when $default != null:
return $default(_that.dealId,_that.title,_that.spendThreshold,_that.discountPercent,_that.eligibleSubtotal,_that.remaining,_that.unlocked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dealId,  String title,  double spendThreshold,  double discountPercent,  double eligibleSubtotal,  double remaining,  bool unlocked)  $default,) {final _that = this;
switch (_that) {
case _SpendDealDto():
return $default(_that.dealId,_that.title,_that.spendThreshold,_that.discountPercent,_that.eligibleSubtotal,_that.remaining,_that.unlocked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dealId,  String title,  double spendThreshold,  double discountPercent,  double eligibleSubtotal,  double remaining,  bool unlocked)?  $default,) {final _that = this;
switch (_that) {
case _SpendDealDto() when $default != null:
return $default(_that.dealId,_that.title,_that.spendThreshold,_that.discountPercent,_that.eligibleSubtotal,_that.remaining,_that.unlocked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _SpendDealDto implements SpendDealDto {
  const _SpendDealDto({required this.dealId, this.title = '', required this.spendThreshold, required this.discountPercent, this.eligibleSubtotal = 0.0, this.remaining = 0.0, this.unlocked = false});
  factory _SpendDealDto.fromJson(Map<String, dynamic> json) => _$SpendDealDtoFromJson(json);

@override final  int dealId;
@override@JsonKey() final  String title;
@override final  double spendThreshold;
@override final  double discountPercent;
// The subtotal after the other deals, which is what counts to the threshold.
@override@JsonKey() final  double eligibleSubtotal;
@override@JsonKey() final  double remaining;
@override@JsonKey() final  bool unlocked;

/// Create a copy of SpendDealDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpendDealDtoCopyWith<_SpendDealDto> get copyWith => __$SpendDealDtoCopyWithImpl<_SpendDealDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpendDealDto&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.title, title) || other.title == title)&&(identical(other.spendThreshold, spendThreshold) || other.spendThreshold == spendThreshold)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.eligibleSubtotal, eligibleSubtotal) || other.eligibleSubtotal == eligibleSubtotal)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.unlocked, unlocked) || other.unlocked == unlocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dealId,title,spendThreshold,discountPercent,eligibleSubtotal,remaining,unlocked);

@override
String toString() {
  return 'SpendDealDto(dealId: $dealId, title: $title, spendThreshold: $spendThreshold, discountPercent: $discountPercent, eligibleSubtotal: $eligibleSubtotal, remaining: $remaining, unlocked: $unlocked)';
}


}

/// @nodoc
abstract mixin class _$SpendDealDtoCopyWith<$Res> implements $SpendDealDtoCopyWith<$Res> {
  factory _$SpendDealDtoCopyWith(_SpendDealDto value, $Res Function(_SpendDealDto) _then) = __$SpendDealDtoCopyWithImpl;
@override @useResult
$Res call({
 int dealId, String title, double spendThreshold, double discountPercent, double eligibleSubtotal, double remaining, bool unlocked
});




}
/// @nodoc
class __$SpendDealDtoCopyWithImpl<$Res>
    implements _$SpendDealDtoCopyWith<$Res> {
  __$SpendDealDtoCopyWithImpl(this._self, this._then);

  final _SpendDealDto _self;
  final $Res Function(_SpendDealDto) _then;

/// Create a copy of SpendDealDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dealId = null,Object? title = null,Object? spendThreshold = null,Object? discountPercent = null,Object? eligibleSubtotal = null,Object? remaining = null,Object? unlocked = null,}) {
  return _then(_SpendDealDto(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,spendThreshold: null == spendThreshold ? _self.spendThreshold : spendThreshold // ignore: cast_nullable_to_non_nullable
as double,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double,eligibleSubtotal: null == eligibleSubtotal ? _self.eligibleSubtotal : eligibleSubtotal // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,unlocked: null == unlocked ? _self.unlocked : unlocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CartItemDto {

 int get id; int get itemId; String get itemTitle; int get itemColorId; String get colorName; String? get mainImageUrl; int get itemSizeId; String get sizeName; double get unitPrice;// Set when a live deal lowered the unit price: the deal and the price before it.
 int? get dealId; double? get unitPriceBeforeDeal; int get quantity; double get lineTotal; int get stock; bool get isAvailable;// What a bundle, multi-buy or free gift deal saves on this line.
 double get dealSaving; int? get appliedDealId;// A fixed price deal on only some of the units: the line keeps its normal
// unit price and this comes off the line total.
 double get singleDealDiscount;
/// Create a copy of CartItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemDtoCopyWith<CartItemDto> get copyWith => _$CartItemDtoCopyWithImpl<CartItemDto>(this as CartItemDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemTitle, itemTitle) || other.itemTitle == itemTitle)&&(identical(other.itemColorId, itemColorId) || other.itemColorId == itemColorId)&&(identical(other.colorName, colorName) || other.colorName == colorName)&&(identical(other.mainImageUrl, mainImageUrl) || other.mainImageUrl == mainImageUrl)&&(identical(other.itemSizeId, itemSizeId) || other.itemSizeId == itemSizeId)&&(identical(other.sizeName, sizeName) || other.sizeName == sizeName)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.unitPriceBeforeDeal, unitPriceBeforeDeal) || other.unitPriceBeforeDeal == unitPriceBeforeDeal)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.dealSaving, dealSaving) || other.dealSaving == dealSaving)&&(identical(other.appliedDealId, appliedDealId) || other.appliedDealId == appliedDealId)&&(identical(other.singleDealDiscount, singleDealDiscount) || other.singleDealDiscount == singleDealDiscount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,itemTitle,itemColorId,colorName,mainImageUrl,itemSizeId,sizeName,unitPrice,dealId,unitPriceBeforeDeal,quantity,lineTotal,stock,isAvailable,dealSaving,appliedDealId,singleDealDiscount);

@override
String toString() {
  return 'CartItemDto(id: $id, itemId: $itemId, itemTitle: $itemTitle, itemColorId: $itemColorId, colorName: $colorName, mainImageUrl: $mainImageUrl, itemSizeId: $itemSizeId, sizeName: $sizeName, unitPrice: $unitPrice, dealId: $dealId, unitPriceBeforeDeal: $unitPriceBeforeDeal, quantity: $quantity, lineTotal: $lineTotal, stock: $stock, isAvailable: $isAvailable, dealSaving: $dealSaving, appliedDealId: $appliedDealId, singleDealDiscount: $singleDealDiscount)';
}


}

/// @nodoc
abstract mixin class $CartItemDtoCopyWith<$Res>  {
  factory $CartItemDtoCopyWith(CartItemDto value, $Res Function(CartItemDto) _then) = _$CartItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, int itemId, String itemTitle, int itemColorId, String colorName, String? mainImageUrl, int itemSizeId, String sizeName, double unitPrice, int? dealId, double? unitPriceBeforeDeal, int quantity, double lineTotal, int stock, bool isAvailable, double dealSaving, int? appliedDealId, double singleDealDiscount
});




}
/// @nodoc
class _$CartItemDtoCopyWithImpl<$Res>
    implements $CartItemDtoCopyWith<$Res> {
  _$CartItemDtoCopyWithImpl(this._self, this._then);

  final CartItemDto _self;
  final $Res Function(CartItemDto) _then;

/// Create a copy of CartItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? itemTitle = null,Object? itemColorId = null,Object? colorName = null,Object? mainImageUrl = freezed,Object? itemSizeId = null,Object? sizeName = null,Object? unitPrice = null,Object? dealId = freezed,Object? unitPriceBeforeDeal = freezed,Object? quantity = null,Object? lineTotal = null,Object? stock = null,Object? isAvailable = null,Object? dealSaving = null,Object? appliedDealId = freezed,Object? singleDealDiscount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,itemTitle: null == itemTitle ? _self.itemTitle : itemTitle // ignore: cast_nullable_to_non_nullable
as String,itemColorId: null == itemColorId ? _self.itemColorId : itemColorId // ignore: cast_nullable_to_non_nullable
as int,colorName: null == colorName ? _self.colorName : colorName // ignore: cast_nullable_to_non_nullable
as String,mainImageUrl: freezed == mainImageUrl ? _self.mainImageUrl : mainImageUrl // ignore: cast_nullable_to_non_nullable
as String?,itemSizeId: null == itemSizeId ? _self.itemSizeId : itemSizeId // ignore: cast_nullable_to_non_nullable
as int,sizeName: null == sizeName ? _self.sizeName : sizeName // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,dealId: freezed == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int?,unitPriceBeforeDeal: freezed == unitPriceBeforeDeal ? _self.unitPriceBeforeDeal : unitPriceBeforeDeal // ignore: cast_nullable_to_non_nullable
as double?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,dealSaving: null == dealSaving ? _self.dealSaving : dealSaving // ignore: cast_nullable_to_non_nullable
as double,appliedDealId: freezed == appliedDealId ? _self.appliedDealId : appliedDealId // ignore: cast_nullable_to_non_nullable
as int?,singleDealDiscount: null == singleDealDiscount ? _self.singleDealDiscount : singleDealDiscount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CartItemDto].
extension CartItemDtoPatterns on CartItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItemDto value)  $default,){
final _that = this;
switch (_that) {
case _CartItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _CartItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int itemId,  String itemTitle,  int itemColorId,  String colorName,  String? mainImageUrl,  int itemSizeId,  String sizeName,  double unitPrice,  int? dealId,  double? unitPriceBeforeDeal,  int quantity,  double lineTotal,  int stock,  bool isAvailable,  double dealSaving,  int? appliedDealId,  double singleDealDiscount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItemDto() when $default != null:
return $default(_that.id,_that.itemId,_that.itemTitle,_that.itemColorId,_that.colorName,_that.mainImageUrl,_that.itemSizeId,_that.sizeName,_that.unitPrice,_that.dealId,_that.unitPriceBeforeDeal,_that.quantity,_that.lineTotal,_that.stock,_that.isAvailable,_that.dealSaving,_that.appliedDealId,_that.singleDealDiscount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int itemId,  String itemTitle,  int itemColorId,  String colorName,  String? mainImageUrl,  int itemSizeId,  String sizeName,  double unitPrice,  int? dealId,  double? unitPriceBeforeDeal,  int quantity,  double lineTotal,  int stock,  bool isAvailable,  double dealSaving,  int? appliedDealId,  double singleDealDiscount)  $default,) {final _that = this;
switch (_that) {
case _CartItemDto():
return $default(_that.id,_that.itemId,_that.itemTitle,_that.itemColorId,_that.colorName,_that.mainImageUrl,_that.itemSizeId,_that.sizeName,_that.unitPrice,_that.dealId,_that.unitPriceBeforeDeal,_that.quantity,_that.lineTotal,_that.stock,_that.isAvailable,_that.dealSaving,_that.appliedDealId,_that.singleDealDiscount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int itemId,  String itemTitle,  int itemColorId,  String colorName,  String? mainImageUrl,  int itemSizeId,  String sizeName,  double unitPrice,  int? dealId,  double? unitPriceBeforeDeal,  int quantity,  double lineTotal,  int stock,  bool isAvailable,  double dealSaving,  int? appliedDealId,  double singleDealDiscount)?  $default,) {final _that = this;
switch (_that) {
case _CartItemDto() when $default != null:
return $default(_that.id,_that.itemId,_that.itemTitle,_that.itemColorId,_that.colorName,_that.mainImageUrl,_that.itemSizeId,_that.sizeName,_that.unitPrice,_that.dealId,_that.unitPriceBeforeDeal,_that.quantity,_that.lineTotal,_that.stock,_that.isAvailable,_that.dealSaving,_that.appliedDealId,_that.singleDealDiscount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _CartItemDto implements CartItemDto {
  const _CartItemDto({required this.id, required this.itemId, required this.itemTitle, required this.itemColorId, required this.colorName, this.mainImageUrl, required this.itemSizeId, required this.sizeName, required this.unitPrice, this.dealId, this.unitPriceBeforeDeal, required this.quantity, required this.lineTotal, required this.stock, required this.isAvailable, this.dealSaving = 0.0, this.appliedDealId, this.singleDealDiscount = 0.0});
  factory _CartItemDto.fromJson(Map<String, dynamic> json) => _$CartItemDtoFromJson(json);

@override final  int id;
@override final  int itemId;
@override final  String itemTitle;
@override final  int itemColorId;
@override final  String colorName;
@override final  String? mainImageUrl;
@override final  int itemSizeId;
@override final  String sizeName;
@override final  double unitPrice;
// Set when a live deal lowered the unit price: the deal and the price before it.
@override final  int? dealId;
@override final  double? unitPriceBeforeDeal;
@override final  int quantity;
@override final  double lineTotal;
@override final  int stock;
@override final  bool isAvailable;
// What a bundle, multi-buy or free gift deal saves on this line.
@override@JsonKey() final  double dealSaving;
@override final  int? appliedDealId;
// A fixed price deal on only some of the units: the line keeps its normal
// unit price and this comes off the line total.
@override@JsonKey() final  double singleDealDiscount;

/// Create a copy of CartItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemDtoCopyWith<_CartItemDto> get copyWith => __$CartItemDtoCopyWithImpl<_CartItemDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemTitle, itemTitle) || other.itemTitle == itemTitle)&&(identical(other.itemColorId, itemColorId) || other.itemColorId == itemColorId)&&(identical(other.colorName, colorName) || other.colorName == colorName)&&(identical(other.mainImageUrl, mainImageUrl) || other.mainImageUrl == mainImageUrl)&&(identical(other.itemSizeId, itemSizeId) || other.itemSizeId == itemSizeId)&&(identical(other.sizeName, sizeName) || other.sizeName == sizeName)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.unitPriceBeforeDeal, unitPriceBeforeDeal) || other.unitPriceBeforeDeal == unitPriceBeforeDeal)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.dealSaving, dealSaving) || other.dealSaving == dealSaving)&&(identical(other.appliedDealId, appliedDealId) || other.appliedDealId == appliedDealId)&&(identical(other.singleDealDiscount, singleDealDiscount) || other.singleDealDiscount == singleDealDiscount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,itemTitle,itemColorId,colorName,mainImageUrl,itemSizeId,sizeName,unitPrice,dealId,unitPriceBeforeDeal,quantity,lineTotal,stock,isAvailable,dealSaving,appliedDealId,singleDealDiscount);

@override
String toString() {
  return 'CartItemDto(id: $id, itemId: $itemId, itemTitle: $itemTitle, itemColorId: $itemColorId, colorName: $colorName, mainImageUrl: $mainImageUrl, itemSizeId: $itemSizeId, sizeName: $sizeName, unitPrice: $unitPrice, dealId: $dealId, unitPriceBeforeDeal: $unitPriceBeforeDeal, quantity: $quantity, lineTotal: $lineTotal, stock: $stock, isAvailable: $isAvailable, dealSaving: $dealSaving, appliedDealId: $appliedDealId, singleDealDiscount: $singleDealDiscount)';
}


}

/// @nodoc
abstract mixin class _$CartItemDtoCopyWith<$Res> implements $CartItemDtoCopyWith<$Res> {
  factory _$CartItemDtoCopyWith(_CartItemDto value, $Res Function(_CartItemDto) _then) = __$CartItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int itemId, String itemTitle, int itemColorId, String colorName, String? mainImageUrl, int itemSizeId, String sizeName, double unitPrice, int? dealId, double? unitPriceBeforeDeal, int quantity, double lineTotal, int stock, bool isAvailable, double dealSaving, int? appliedDealId, double singleDealDiscount
});




}
/// @nodoc
class __$CartItemDtoCopyWithImpl<$Res>
    implements _$CartItemDtoCopyWith<$Res> {
  __$CartItemDtoCopyWithImpl(this._self, this._then);

  final _CartItemDto _self;
  final $Res Function(_CartItemDto) _then;

/// Create a copy of CartItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? itemTitle = null,Object? itemColorId = null,Object? colorName = null,Object? mainImageUrl = freezed,Object? itemSizeId = null,Object? sizeName = null,Object? unitPrice = null,Object? dealId = freezed,Object? unitPriceBeforeDeal = freezed,Object? quantity = null,Object? lineTotal = null,Object? stock = null,Object? isAvailable = null,Object? dealSaving = null,Object? appliedDealId = freezed,Object? singleDealDiscount = null,}) {
  return _then(_CartItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,itemTitle: null == itemTitle ? _self.itemTitle : itemTitle // ignore: cast_nullable_to_non_nullable
as String,itemColorId: null == itemColorId ? _self.itemColorId : itemColorId // ignore: cast_nullable_to_non_nullable
as int,colorName: null == colorName ? _self.colorName : colorName // ignore: cast_nullable_to_non_nullable
as String,mainImageUrl: freezed == mainImageUrl ? _self.mainImageUrl : mainImageUrl // ignore: cast_nullable_to_non_nullable
as String?,itemSizeId: null == itemSizeId ? _self.itemSizeId : itemSizeId // ignore: cast_nullable_to_non_nullable
as int,sizeName: null == sizeName ? _self.sizeName : sizeName // ignore: cast_nullable_to_non_nullable
as String,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,dealId: freezed == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int?,unitPriceBeforeDeal: freezed == unitPriceBeforeDeal ? _self.unitPriceBeforeDeal : unitPriceBeforeDeal // ignore: cast_nullable_to_non_nullable
as double?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,dealSaving: null == dealSaving ? _self.dealSaving : dealSaving // ignore: cast_nullable_to_non_nullable
as double,appliedDealId: freezed == appliedDealId ? _self.appliedDealId : appliedDealId // ignore: cast_nullable_to_non_nullable
as int?,singleDealDiscount: null == singleDealDiscount ? _self.singleDealDiscount : singleDealDiscount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
