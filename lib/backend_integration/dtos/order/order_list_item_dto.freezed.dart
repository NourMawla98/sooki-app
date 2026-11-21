// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_list_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderListItemDto {

 int get id; String get trackingNumber; int get status; double get totalAmount;// Sent in UTC; shown in the device's time zone.
@ServerUtcDateConverter() DateTime get createdAt; List<OrderItemDto> get items;// Everything deals took off the order.
 double get totalDealDiscount;
/// Create a copy of OrderListItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderListItemDtoCopyWith<OrderListItemDto> get copyWith => _$OrderListItemDtoCopyWithImpl<OrderListItemDto>(this as OrderListItemDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderListItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalDealDiscount, totalDealDiscount) || other.totalDealDiscount == totalDealDiscount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trackingNumber,status,totalAmount,createdAt,const DeepCollectionEquality().hash(items),totalDealDiscount);

@override
String toString() {
  return 'OrderListItemDto(id: $id, trackingNumber: $trackingNumber, status: $status, totalAmount: $totalAmount, createdAt: $createdAt, items: $items, totalDealDiscount: $totalDealDiscount)';
}


}

/// @nodoc
abstract mixin class $OrderListItemDtoCopyWith<$Res>  {
  factory $OrderListItemDtoCopyWith(OrderListItemDto value, $Res Function(OrderListItemDto) _then) = _$OrderListItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, String trackingNumber, int status, double totalAmount,@ServerUtcDateConverter() DateTime createdAt, List<OrderItemDto> items, double totalDealDiscount
});




}
/// @nodoc
class _$OrderListItemDtoCopyWithImpl<$Res>
    implements $OrderListItemDtoCopyWith<$Res> {
  _$OrderListItemDtoCopyWithImpl(this._self, this._then);

  final OrderListItemDto _self;
  final $Res Function(OrderListItemDto) _then;

/// Create a copy of OrderListItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? trackingNumber = null,Object? status = null,Object? totalAmount = null,Object? createdAt = null,Object? items = null,Object? totalDealDiscount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,trackingNumber: null == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemDto>,totalDealDiscount: null == totalDealDiscount ? _self.totalDealDiscount : totalDealDiscount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderListItemDto].
extension OrderListItemDtoPatterns on OrderListItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderListItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderListItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderListItemDto value)  $default,){
final _that = this;
switch (_that) {
case _OrderListItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderListItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _OrderListItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String trackingNumber,  int status,  double totalAmount, @ServerUtcDateConverter()  DateTime createdAt,  List<OrderItemDto> items,  double totalDealDiscount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderListItemDto() when $default != null:
return $default(_that.id,_that.trackingNumber,_that.status,_that.totalAmount,_that.createdAt,_that.items,_that.totalDealDiscount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String trackingNumber,  int status,  double totalAmount, @ServerUtcDateConverter()  DateTime createdAt,  List<OrderItemDto> items,  double totalDealDiscount)  $default,) {final _that = this;
switch (_that) {
case _OrderListItemDto():
return $default(_that.id,_that.trackingNumber,_that.status,_that.totalAmount,_that.createdAt,_that.items,_that.totalDealDiscount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String trackingNumber,  int status,  double totalAmount, @ServerUtcDateConverter()  DateTime createdAt,  List<OrderItemDto> items,  double totalDealDiscount)?  $default,) {final _that = this;
switch (_that) {
case _OrderListItemDto() when $default != null:
return $default(_that.id,_that.trackingNumber,_that.status,_that.totalAmount,_that.createdAt,_that.items,_that.totalDealDiscount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _OrderListItemDto implements OrderListItemDto {
  const _OrderListItemDto({required this.id, required this.trackingNumber, required this.status, required this.totalAmount, @ServerUtcDateConverter() required this.createdAt, final  List<OrderItemDto> items = const [], this.totalDealDiscount = 0.0}): _items = items;
  factory _OrderListItemDto.fromJson(Map<String, dynamic> json) => _$OrderListItemDtoFromJson(json);

@override final  int id;
@override final  String trackingNumber;
@override final  int status;
@override final  double totalAmount;
// Sent in UTC; shown in the device's time zone.
@override@ServerUtcDateConverter() final  DateTime createdAt;
 final  List<OrderItemDto> _items;
@override@JsonKey() List<OrderItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

// Everything deals took off the order.
@override@JsonKey() final  double totalDealDiscount;

/// Create a copy of OrderListItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderListItemDtoCopyWith<_OrderListItemDto> get copyWith => __$OrderListItemDtoCopyWithImpl<_OrderListItemDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderListItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalDealDiscount, totalDealDiscount) || other.totalDealDiscount == totalDealDiscount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trackingNumber,status,totalAmount,createdAt,const DeepCollectionEquality().hash(_items),totalDealDiscount);

@override
String toString() {
  return 'OrderListItemDto(id: $id, trackingNumber: $trackingNumber, status: $status, totalAmount: $totalAmount, createdAt: $createdAt, items: $items, totalDealDiscount: $totalDealDiscount)';
}


}

/// @nodoc
abstract mixin class _$OrderListItemDtoCopyWith<$Res> implements $OrderListItemDtoCopyWith<$Res> {
  factory _$OrderListItemDtoCopyWith(_OrderListItemDto value, $Res Function(_OrderListItemDto) _then) = __$OrderListItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String trackingNumber, int status, double totalAmount,@ServerUtcDateConverter() DateTime createdAt, List<OrderItemDto> items, double totalDealDiscount
});




}
/// @nodoc
class __$OrderListItemDtoCopyWithImpl<$Res>
    implements _$OrderListItemDtoCopyWith<$Res> {
  __$OrderListItemDtoCopyWithImpl(this._self, this._then);

  final _OrderListItemDto _self;
  final $Res Function(_OrderListItemDto) _then;

/// Create a copy of OrderListItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trackingNumber = null,Object? status = null,Object? totalAmount = null,Object? createdAt = null,Object? items = null,Object? totalDealDiscount = null,}) {
  return _then(_OrderListItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,trackingNumber: null == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemDto>,totalDealDiscount: null == totalDealDiscount ? _self.totalDealDiscount : totalDealDiscount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
