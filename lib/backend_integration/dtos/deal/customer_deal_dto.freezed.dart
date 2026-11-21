// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_deal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerDealDto {

 int get id; String get title; String? get description;@ServerUtcDateConverter() DateTime get startsAt;// Null when the deal never ends.
@ServerUtcDateConverter() DateTime? get expiresAt; bool get isLive;// Every item in the deal, the free one included.
 List<ItemListItemDto> get items; int get type;// Multi-buy and spend deals.
 double? get discountPercent;// Multi-buy deals: the fewest units that unlock the discount.
 int? get minQuantity;// Bundle deals: what one full set costs.
 double? get bundlePrice;// Bundle and free gift deals: one full set at normal prices, the free
// line included.
 double? get originalTotal;// Spend deals: the cart subtotal that unlocks the discount.
 double? get spendThreshold; List<DealLineDto> get lines;
/// Create a copy of CustomerDealDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerDealDtoCopyWith<CustomerDealDto> get copyWith => _$CustomerDealDtoCopyWithImpl<CustomerDealDto>(this as CustomerDealDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerDealDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.type, type) || other.type == type)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.bundlePrice, bundlePrice) || other.bundlePrice == bundlePrice)&&(identical(other.originalTotal, originalTotal) || other.originalTotal == originalTotal)&&(identical(other.spendThreshold, spendThreshold) || other.spendThreshold == spendThreshold)&&const DeepCollectionEquality().equals(other.lines, lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,startsAt,expiresAt,isLive,const DeepCollectionEquality().hash(items),type,discountPercent,minQuantity,bundlePrice,originalTotal,spendThreshold,const DeepCollectionEquality().hash(lines));

@override
String toString() {
  return 'CustomerDealDto(id: $id, title: $title, description: $description, startsAt: $startsAt, expiresAt: $expiresAt, isLive: $isLive, items: $items, type: $type, discountPercent: $discountPercent, minQuantity: $minQuantity, bundlePrice: $bundlePrice, originalTotal: $originalTotal, spendThreshold: $spendThreshold, lines: $lines)';
}


}

/// @nodoc
abstract mixin class $CustomerDealDtoCopyWith<$Res>  {
  factory $CustomerDealDtoCopyWith(CustomerDealDto value, $Res Function(CustomerDealDto) _then) = _$CustomerDealDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? description,@ServerUtcDateConverter() DateTime startsAt,@ServerUtcDateConverter() DateTime? expiresAt, bool isLive, List<ItemListItemDto> items, int type, double? discountPercent, int? minQuantity, double? bundlePrice, double? originalTotal, double? spendThreshold, List<DealLineDto> lines
});




}
/// @nodoc
class _$CustomerDealDtoCopyWithImpl<$Res>
    implements $CustomerDealDtoCopyWith<$Res> {
  _$CustomerDealDtoCopyWithImpl(this._self, this._then);

  final CustomerDealDto _self;
  final $Res Function(CustomerDealDto) _then;

/// Create a copy of CustomerDealDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? startsAt = null,Object? expiresAt = freezed,Object? isLive = null,Object? items = null,Object? type = null,Object? discountPercent = freezed,Object? minQuantity = freezed,Object? bundlePrice = freezed,Object? originalTotal = freezed,Object? spendThreshold = freezed,Object? lines = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ItemListItemDto>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double?,minQuantity: freezed == minQuantity ? _self.minQuantity : minQuantity // ignore: cast_nullable_to_non_nullable
as int?,bundlePrice: freezed == bundlePrice ? _self.bundlePrice : bundlePrice // ignore: cast_nullable_to_non_nullable
as double?,originalTotal: freezed == originalTotal ? _self.originalTotal : originalTotal // ignore: cast_nullable_to_non_nullable
as double?,spendThreshold: freezed == spendThreshold ? _self.spendThreshold : spendThreshold // ignore: cast_nullable_to_non_nullable
as double?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<DealLineDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerDealDto].
extension CustomerDealDtoPatterns on CustomerDealDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerDealDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerDealDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerDealDto value)  $default,){
final _that = this;
switch (_that) {
case _CustomerDealDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerDealDto value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerDealDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? description, @ServerUtcDateConverter()  DateTime startsAt, @ServerUtcDateConverter()  DateTime? expiresAt,  bool isLive,  List<ItemListItemDto> items,  int type,  double? discountPercent,  int? minQuantity,  double? bundlePrice,  double? originalTotal,  double? spendThreshold,  List<DealLineDto> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerDealDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.startsAt,_that.expiresAt,_that.isLive,_that.items,_that.type,_that.discountPercent,_that.minQuantity,_that.bundlePrice,_that.originalTotal,_that.spendThreshold,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? description, @ServerUtcDateConverter()  DateTime startsAt, @ServerUtcDateConverter()  DateTime? expiresAt,  bool isLive,  List<ItemListItemDto> items,  int type,  double? discountPercent,  int? minQuantity,  double? bundlePrice,  double? originalTotal,  double? spendThreshold,  List<DealLineDto> lines)  $default,) {final _that = this;
switch (_that) {
case _CustomerDealDto():
return $default(_that.id,_that.title,_that.description,_that.startsAt,_that.expiresAt,_that.isLive,_that.items,_that.type,_that.discountPercent,_that.minQuantity,_that.bundlePrice,_that.originalTotal,_that.spendThreshold,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? description, @ServerUtcDateConverter()  DateTime startsAt, @ServerUtcDateConverter()  DateTime? expiresAt,  bool isLive,  List<ItemListItemDto> items,  int type,  double? discountPercent,  int? minQuantity,  double? bundlePrice,  double? originalTotal,  double? spendThreshold,  List<DealLineDto> lines)?  $default,) {final _that = this;
switch (_that) {
case _CustomerDealDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.startsAt,_that.expiresAt,_that.isLive,_that.items,_that.type,_that.discountPercent,_that.minQuantity,_that.bundlePrice,_that.originalTotal,_that.spendThreshold,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _CustomerDealDto extends CustomerDealDto {
  const _CustomerDealDto({required this.id, required this.title, this.description, @ServerUtcDateConverter() required this.startsAt, @ServerUtcDateConverter() this.expiresAt, required this.isLive, final  List<ItemListItemDto> items = const [], this.type = 1, this.discountPercent, this.minQuantity, this.bundlePrice, this.originalTotal, this.spendThreshold, final  List<DealLineDto> lines = const []}): _items = items,_lines = lines,super._();
  factory _CustomerDealDto.fromJson(Map<String, dynamic> json) => _$CustomerDealDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  String? description;
@override@ServerUtcDateConverter() final  DateTime startsAt;
// Null when the deal never ends.
@override@ServerUtcDateConverter() final  DateTime? expiresAt;
@override final  bool isLive;
// Every item in the deal, the free one included.
 final  List<ItemListItemDto> _items;
// Every item in the deal, the free one included.
@override@JsonKey() List<ItemListItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int type;
// Multi-buy and spend deals.
@override final  double? discountPercent;
// Multi-buy deals: the fewest units that unlock the discount.
@override final  int? minQuantity;
// Bundle deals: what one full set costs.
@override final  double? bundlePrice;
// Bundle and free gift deals: one full set at normal prices, the free
// line included.
@override final  double? originalTotal;
// Spend deals: the cart subtotal that unlocks the discount.
@override final  double? spendThreshold;
 final  List<DealLineDto> _lines;
@override@JsonKey() List<DealLineDto> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of CustomerDealDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerDealDtoCopyWith<_CustomerDealDto> get copyWith => __$CustomerDealDtoCopyWithImpl<_CustomerDealDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerDealDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.type, type) || other.type == type)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.bundlePrice, bundlePrice) || other.bundlePrice == bundlePrice)&&(identical(other.originalTotal, originalTotal) || other.originalTotal == originalTotal)&&(identical(other.spendThreshold, spendThreshold) || other.spendThreshold == spendThreshold)&&const DeepCollectionEquality().equals(other._lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,startsAt,expiresAt,isLive,const DeepCollectionEquality().hash(_items),type,discountPercent,minQuantity,bundlePrice,originalTotal,spendThreshold,const DeepCollectionEquality().hash(_lines));

@override
String toString() {
  return 'CustomerDealDto(id: $id, title: $title, description: $description, startsAt: $startsAt, expiresAt: $expiresAt, isLive: $isLive, items: $items, type: $type, discountPercent: $discountPercent, minQuantity: $minQuantity, bundlePrice: $bundlePrice, originalTotal: $originalTotal, spendThreshold: $spendThreshold, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$CustomerDealDtoCopyWith<$Res> implements $CustomerDealDtoCopyWith<$Res> {
  factory _$CustomerDealDtoCopyWith(_CustomerDealDto value, $Res Function(_CustomerDealDto) _then) = __$CustomerDealDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? description,@ServerUtcDateConverter() DateTime startsAt,@ServerUtcDateConverter() DateTime? expiresAt, bool isLive, List<ItemListItemDto> items, int type, double? discountPercent, int? minQuantity, double? bundlePrice, double? originalTotal, double? spendThreshold, List<DealLineDto> lines
});




}
/// @nodoc
class __$CustomerDealDtoCopyWithImpl<$Res>
    implements _$CustomerDealDtoCopyWith<$Res> {
  __$CustomerDealDtoCopyWithImpl(this._self, this._then);

  final _CustomerDealDto _self;
  final $Res Function(_CustomerDealDto) _then;

/// Create a copy of CustomerDealDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? startsAt = null,Object? expiresAt = freezed,Object? isLive = null,Object? items = null,Object? type = null,Object? discountPercent = freezed,Object? minQuantity = freezed,Object? bundlePrice = freezed,Object? originalTotal = freezed,Object? spendThreshold = freezed,Object? lines = null,}) {
  return _then(_CustomerDealDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ItemListItemDto>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double?,minQuantity: freezed == minQuantity ? _self.minQuantity : minQuantity // ignore: cast_nullable_to_non_nullable
as int?,bundlePrice: freezed == bundlePrice ? _self.bundlePrice : bundlePrice // ignore: cast_nullable_to_non_nullable
as double?,originalTotal: freezed == originalTotal ? _self.originalTotal : originalTotal // ignore: cast_nullable_to_non_nullable
as double?,spendThreshold: freezed == spendThreshold ? _self.spendThreshold : spendThreshold // ignore: cast_nullable_to_non_nullable
as double?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<DealLineDto>,
  ));
}


}


/// @nodoc
mixin _$DealLineDto {

 int get itemId; int get quantity; int get role;
/// Create a copy of DealLineDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealLineDtoCopyWith<DealLineDto> get copyWith => _$DealLineDtoCopyWithImpl<DealLineDto>(this as DealLineDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealLineDto&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,quantity,role);

@override
String toString() {
  return 'DealLineDto(itemId: $itemId, quantity: $quantity, role: $role)';
}


}

/// @nodoc
abstract mixin class $DealLineDtoCopyWith<$Res>  {
  factory $DealLineDtoCopyWith(DealLineDto value, $Res Function(DealLineDto) _then) = _$DealLineDtoCopyWithImpl;
@useResult
$Res call({
 int itemId, int quantity, int role
});




}
/// @nodoc
class _$DealLineDtoCopyWithImpl<$Res>
    implements $DealLineDtoCopyWith<$Res> {
  _$DealLineDtoCopyWithImpl(this._self, this._then);

  final DealLineDto _self;
  final $Res Function(DealLineDto) _then;

/// Create a copy of DealLineDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? quantity = null,Object? role = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DealLineDto].
extension DealLineDtoPatterns on DealLineDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealLineDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealLineDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealLineDto value)  $default,){
final _that = this;
switch (_that) {
case _DealLineDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealLineDto value)?  $default,){
final _that = this;
switch (_that) {
case _DealLineDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int itemId,  int quantity,  int role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DealLineDto() when $default != null:
return $default(_that.itemId,_that.quantity,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int itemId,  int quantity,  int role)  $default,) {final _that = this;
switch (_that) {
case _DealLineDto():
return $default(_that.itemId,_that.quantity,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int itemId,  int quantity,  int role)?  $default,) {final _that = this;
switch (_that) {
case _DealLineDto() when $default != null:
return $default(_that.itemId,_that.quantity,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _DealLineDto extends DealLineDto {
  const _DealLineDto({required this.itemId, this.quantity = 1, this.role = 1}): super._();
  factory _DealLineDto.fromJson(Map<String, dynamic> json) => _$DealLineDtoFromJson(json);

@override final  int itemId;
@override@JsonKey() final  int quantity;
@override@JsonKey() final  int role;

/// Create a copy of DealLineDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealLineDtoCopyWith<_DealLineDto> get copyWith => __$DealLineDtoCopyWithImpl<_DealLineDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealLineDto&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,quantity,role);

@override
String toString() {
  return 'DealLineDto(itemId: $itemId, quantity: $quantity, role: $role)';
}


}

/// @nodoc
abstract mixin class _$DealLineDtoCopyWith<$Res> implements $DealLineDtoCopyWith<$Res> {
  factory _$DealLineDtoCopyWith(_DealLineDto value, $Res Function(_DealLineDto) _then) = __$DealLineDtoCopyWithImpl;
@override @useResult
$Res call({
 int itemId, int quantity, int role
});




}
/// @nodoc
class __$DealLineDtoCopyWithImpl<$Res>
    implements _$DealLineDtoCopyWith<$Res> {
  __$DealLineDtoCopyWithImpl(this._self, this._then);

  final _DealLineDto _self;
  final $Res Function(_DealLineDto) _then;

/// Create a copy of DealLineDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? quantity = null,Object? role = null,}) {
  return _then(_DealLineDto(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
