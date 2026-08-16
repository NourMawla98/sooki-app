// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_detail_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderDetailDto {

 int get id; String get trackingNumber; int get status; String get customerName; String? get addressLabel; String get city; String? get area; String? get street; String? get building; String? get floor; String? get customerNote; double get subtotal; double get discountAmount; double get deliveryFee; double get totalAmount; DateTime get createdAt; int? get paymentMethod; int? get paymentStatus; List<OrderItemDto> get items;
/// Create a copy of OrderDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDetailDtoCopyWith<OrderDetailDto> get copyWith => _$OrderDetailDtoCopyWithImpl<OrderDetailDto>(this as OrderDetailDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.addressLabel, addressLabel) || other.addressLabel == addressLabel)&&(identical(other.city, city) || other.city == city)&&(identical(other.area, area) || other.area == area)&&(identical(other.street, street) || other.street == street)&&(identical(other.building, building) || other.building == building)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.customerNote, customerNote) || other.customerNote == customerNote)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,trackingNumber,status,customerName,addressLabel,city,area,street,building,floor,customerNote,subtotal,discountAmount,deliveryFee,totalAmount,createdAt,paymentMethod,paymentStatus,const DeepCollectionEquality().hash(items)]);

@override
String toString() {
  return 'OrderDetailDto(id: $id, trackingNumber: $trackingNumber, status: $status, customerName: $customerName, addressLabel: $addressLabel, city: $city, area: $area, street: $street, building: $building, floor: $floor, customerNote: $customerNote, subtotal: $subtotal, discountAmount: $discountAmount, deliveryFee: $deliveryFee, totalAmount: $totalAmount, createdAt: $createdAt, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, items: $items)';
}


}

/// @nodoc
abstract mixin class $OrderDetailDtoCopyWith<$Res>  {
  factory $OrderDetailDtoCopyWith(OrderDetailDto value, $Res Function(OrderDetailDto) _then) = _$OrderDetailDtoCopyWithImpl;
@useResult
$Res call({
 int id, String trackingNumber, int status, String customerName, String? addressLabel, String city, String? area, String? street, String? building, String? floor, String? customerNote, double subtotal, double discountAmount, double deliveryFee, double totalAmount, DateTime createdAt, int? paymentMethod, int? paymentStatus, List<OrderItemDto> items
});




}
/// @nodoc
class _$OrderDetailDtoCopyWithImpl<$Res>
    implements $OrderDetailDtoCopyWith<$Res> {
  _$OrderDetailDtoCopyWithImpl(this._self, this._then);

  final OrderDetailDto _self;
  final $Res Function(OrderDetailDto) _then;

/// Create a copy of OrderDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? trackingNumber = null,Object? status = null,Object? customerName = null,Object? addressLabel = freezed,Object? city = null,Object? area = freezed,Object? street = freezed,Object? building = freezed,Object? floor = freezed,Object? customerNote = freezed,Object? subtotal = null,Object? discountAmount = null,Object? deliveryFee = null,Object? totalAmount = null,Object? createdAt = null,Object? paymentMethod = freezed,Object? paymentStatus = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,trackingNumber: null == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,addressLabel: freezed == addressLabel ? _self.addressLabel : addressLabel // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,street: freezed == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String?,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,customerNote: freezed == customerNote ? _self.customerNote : customerNote // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as int?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as int?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderDetailDto].
extension OrderDetailDtoPatterns on OrderDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _OrderDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String trackingNumber,  int status,  String customerName,  String? addressLabel,  String city,  String? area,  String? street,  String? building,  String? floor,  String? customerNote,  double subtotal,  double discountAmount,  double deliveryFee,  double totalAmount,  DateTime createdAt,  int? paymentMethod,  int? paymentStatus,  List<OrderItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDetailDto() when $default != null:
return $default(_that.id,_that.trackingNumber,_that.status,_that.customerName,_that.addressLabel,_that.city,_that.area,_that.street,_that.building,_that.floor,_that.customerNote,_that.subtotal,_that.discountAmount,_that.deliveryFee,_that.totalAmount,_that.createdAt,_that.paymentMethod,_that.paymentStatus,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String trackingNumber,  int status,  String customerName,  String? addressLabel,  String city,  String? area,  String? street,  String? building,  String? floor,  String? customerNote,  double subtotal,  double discountAmount,  double deliveryFee,  double totalAmount,  DateTime createdAt,  int? paymentMethod,  int? paymentStatus,  List<OrderItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _OrderDetailDto():
return $default(_that.id,_that.trackingNumber,_that.status,_that.customerName,_that.addressLabel,_that.city,_that.area,_that.street,_that.building,_that.floor,_that.customerNote,_that.subtotal,_that.discountAmount,_that.deliveryFee,_that.totalAmount,_that.createdAt,_that.paymentMethod,_that.paymentStatus,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String trackingNumber,  int status,  String customerName,  String? addressLabel,  String city,  String? area,  String? street,  String? building,  String? floor,  String? customerNote,  double subtotal,  double discountAmount,  double deliveryFee,  double totalAmount,  DateTime createdAt,  int? paymentMethod,  int? paymentStatus,  List<OrderItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _OrderDetailDto() when $default != null:
return $default(_that.id,_that.trackingNumber,_that.status,_that.customerName,_that.addressLabel,_that.city,_that.area,_that.street,_that.building,_that.floor,_that.customerNote,_that.subtotal,_that.discountAmount,_that.deliveryFee,_that.totalAmount,_that.createdAt,_that.paymentMethod,_that.paymentStatus,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _OrderDetailDto implements OrderDetailDto {
  const _OrderDetailDto({required this.id, required this.trackingNumber, required this.status, required this.customerName, this.addressLabel, required this.city, this.area, this.street, this.building, this.floor, this.customerNote, required this.subtotal, required this.discountAmount, required this.deliveryFee, required this.totalAmount, required this.createdAt, this.paymentMethod, this.paymentStatus, final  List<OrderItemDto> items = const []}): _items = items;
  factory _OrderDetailDto.fromJson(Map<String, dynamic> json) => _$OrderDetailDtoFromJson(json);

@override final  int id;
@override final  String trackingNumber;
@override final  int status;
@override final  String customerName;
@override final  String? addressLabel;
@override final  String city;
@override final  String? area;
@override final  String? street;
@override final  String? building;
@override final  String? floor;
@override final  String? customerNote;
@override final  double subtotal;
@override final  double discountAmount;
@override final  double deliveryFee;
@override final  double totalAmount;
@override final  DateTime createdAt;
@override final  int? paymentMethod;
@override final  int? paymentStatus;
 final  List<OrderItemDto> _items;
@override@JsonKey() List<OrderItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of OrderDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDetailDtoCopyWith<_OrderDetailDto> get copyWith => __$OrderDetailDtoCopyWithImpl<_OrderDetailDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.addressLabel, addressLabel) || other.addressLabel == addressLabel)&&(identical(other.city, city) || other.city == city)&&(identical(other.area, area) || other.area == area)&&(identical(other.street, street) || other.street == street)&&(identical(other.building, building) || other.building == building)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.customerNote, customerNote) || other.customerNote == customerNote)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,trackingNumber,status,customerName,addressLabel,city,area,street,building,floor,customerNote,subtotal,discountAmount,deliveryFee,totalAmount,createdAt,paymentMethod,paymentStatus,const DeepCollectionEquality().hash(_items)]);

@override
String toString() {
  return 'OrderDetailDto(id: $id, trackingNumber: $trackingNumber, status: $status, customerName: $customerName, addressLabel: $addressLabel, city: $city, area: $area, street: $street, building: $building, floor: $floor, customerNote: $customerNote, subtotal: $subtotal, discountAmount: $discountAmount, deliveryFee: $deliveryFee, totalAmount: $totalAmount, createdAt: $createdAt, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, items: $items)';
}


}

/// @nodoc
abstract mixin class _$OrderDetailDtoCopyWith<$Res> implements $OrderDetailDtoCopyWith<$Res> {
  factory _$OrderDetailDtoCopyWith(_OrderDetailDto value, $Res Function(_OrderDetailDto) _then) = __$OrderDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String trackingNumber, int status, String customerName, String? addressLabel, String city, String? area, String? street, String? building, String? floor, String? customerNote, double subtotal, double discountAmount, double deliveryFee, double totalAmount, DateTime createdAt, int? paymentMethod, int? paymentStatus, List<OrderItemDto> items
});




}
/// @nodoc
class __$OrderDetailDtoCopyWithImpl<$Res>
    implements _$OrderDetailDtoCopyWith<$Res> {
  __$OrderDetailDtoCopyWithImpl(this._self, this._then);

  final _OrderDetailDto _self;
  final $Res Function(_OrderDetailDto) _then;

/// Create a copy of OrderDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trackingNumber = null,Object? status = null,Object? customerName = null,Object? addressLabel = freezed,Object? city = null,Object? area = freezed,Object? street = freezed,Object? building = freezed,Object? floor = freezed,Object? customerNote = freezed,Object? subtotal = null,Object? discountAmount = null,Object? deliveryFee = null,Object? totalAmount = null,Object? createdAt = null,Object? paymentMethod = freezed,Object? paymentStatus = freezed,Object? items = null,}) {
  return _then(_OrderDetailDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,trackingNumber: null == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,addressLabel: freezed == addressLabel ? _self.addressLabel : addressLabel // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,street: freezed == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String?,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,customerNote: freezed == customerNote ? _self.customerNote : customerNote // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as int?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as int?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemDto>,
  ));
}


}

// dart format on
