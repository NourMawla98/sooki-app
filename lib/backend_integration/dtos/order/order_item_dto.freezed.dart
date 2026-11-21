// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderItemDto {

 int get id; int get itemId; int get status; int get quantity; double get unitPrice; double get totalPrice; String get itemTitle; String get colorName; String get sizeName; String? get imageUrl;// storeName intentionally omitted, never parsed or rendered
// The deal that priced this line, when one did.
 int? get dealId; int? get dealType; double? get snapshotDealPrice;// What a bundle, multi-buy or free gift deal took off this line.
 double get dealDiscount;// A fixed price deal on only some of the units, taken off the line.
 double get singleDealDiscount;// What the fixed price deal saved on this line, whole or part.
 double? get singleItemSaving;// Everything deals took off this line: [totalPrice] plus this is the
// line at its normal price.
 double? get totalLineDiscount;// The spend deal over the whole cart, and this line's share of it.
 int? get cartDealId; double get cartDealDiscount;
/// Create a copy of OrderItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemDtoCopyWith<OrderItemDto> get copyWith => _$OrderItemDtoCopyWithImpl<OrderItemDto>(this as OrderItemDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.status, status) || other.status == status)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.itemTitle, itemTitle) || other.itemTitle == itemTitle)&&(identical(other.colorName, colorName) || other.colorName == colorName)&&(identical(other.sizeName, sizeName) || other.sizeName == sizeName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.dealType, dealType) || other.dealType == dealType)&&(identical(other.snapshotDealPrice, snapshotDealPrice) || other.snapshotDealPrice == snapshotDealPrice)&&(identical(other.dealDiscount, dealDiscount) || other.dealDiscount == dealDiscount)&&(identical(other.singleDealDiscount, singleDealDiscount) || other.singleDealDiscount == singleDealDiscount)&&(identical(other.singleItemSaving, singleItemSaving) || other.singleItemSaving == singleItemSaving)&&(identical(other.totalLineDiscount, totalLineDiscount) || other.totalLineDiscount == totalLineDiscount)&&(identical(other.cartDealId, cartDealId) || other.cartDealId == cartDealId)&&(identical(other.cartDealDiscount, cartDealDiscount) || other.cartDealDiscount == cartDealDiscount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,itemId,status,quantity,unitPrice,totalPrice,itemTitle,colorName,sizeName,imageUrl,dealId,dealType,snapshotDealPrice,dealDiscount,singleDealDiscount,singleItemSaving,totalLineDiscount,cartDealId,cartDealDiscount]);

@override
String toString() {
  return 'OrderItemDto(id: $id, itemId: $itemId, status: $status, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, itemTitle: $itemTitle, colorName: $colorName, sizeName: $sizeName, imageUrl: $imageUrl, dealId: $dealId, dealType: $dealType, snapshotDealPrice: $snapshotDealPrice, dealDiscount: $dealDiscount, singleDealDiscount: $singleDealDiscount, singleItemSaving: $singleItemSaving, totalLineDiscount: $totalLineDiscount, cartDealId: $cartDealId, cartDealDiscount: $cartDealDiscount)';
}


}

/// @nodoc
abstract mixin class $OrderItemDtoCopyWith<$Res>  {
  factory $OrderItemDtoCopyWith(OrderItemDto value, $Res Function(OrderItemDto) _then) = _$OrderItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, int itemId, int status, int quantity, double unitPrice, double totalPrice, String itemTitle, String colorName, String sizeName, String? imageUrl, int? dealId, int? dealType, double? snapshotDealPrice, double dealDiscount, double singleDealDiscount, double? singleItemSaving, double? totalLineDiscount, int? cartDealId, double cartDealDiscount
});




}
/// @nodoc
class _$OrderItemDtoCopyWithImpl<$Res>
    implements $OrderItemDtoCopyWith<$Res> {
  _$OrderItemDtoCopyWithImpl(this._self, this._then);

  final OrderItemDto _self;
  final $Res Function(OrderItemDto) _then;

/// Create a copy of OrderItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? status = null,Object? quantity = null,Object? unitPrice = null,Object? totalPrice = null,Object? itemTitle = null,Object? colorName = null,Object? sizeName = null,Object? imageUrl = freezed,Object? dealId = freezed,Object? dealType = freezed,Object? snapshotDealPrice = freezed,Object? dealDiscount = null,Object? singleDealDiscount = null,Object? singleItemSaving = freezed,Object? totalLineDiscount = freezed,Object? cartDealId = freezed,Object? cartDealDiscount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,itemTitle: null == itemTitle ? _self.itemTitle : itemTitle // ignore: cast_nullable_to_non_nullable
as String,colorName: null == colorName ? _self.colorName : colorName // ignore: cast_nullable_to_non_nullable
as String,sizeName: null == sizeName ? _self.sizeName : sizeName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,dealId: freezed == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int?,dealType: freezed == dealType ? _self.dealType : dealType // ignore: cast_nullable_to_non_nullable
as int?,snapshotDealPrice: freezed == snapshotDealPrice ? _self.snapshotDealPrice : snapshotDealPrice // ignore: cast_nullable_to_non_nullable
as double?,dealDiscount: null == dealDiscount ? _self.dealDiscount : dealDiscount // ignore: cast_nullable_to_non_nullable
as double,singleDealDiscount: null == singleDealDiscount ? _self.singleDealDiscount : singleDealDiscount // ignore: cast_nullable_to_non_nullable
as double,singleItemSaving: freezed == singleItemSaving ? _self.singleItemSaving : singleItemSaving // ignore: cast_nullable_to_non_nullable
as double?,totalLineDiscount: freezed == totalLineDiscount ? _self.totalLineDiscount : totalLineDiscount // ignore: cast_nullable_to_non_nullable
as double?,cartDealId: freezed == cartDealId ? _self.cartDealId : cartDealId // ignore: cast_nullable_to_non_nullable
as int?,cartDealDiscount: null == cartDealDiscount ? _self.cartDealDiscount : cartDealDiscount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItemDto].
extension OrderItemDtoPatterns on OrderItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItemDto value)  $default,){
final _that = this;
switch (_that) {
case _OrderItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int itemId,  int status,  int quantity,  double unitPrice,  double totalPrice,  String itemTitle,  String colorName,  String sizeName,  String? imageUrl,  int? dealId,  int? dealType,  double? snapshotDealPrice,  double dealDiscount,  double singleDealDiscount,  double? singleItemSaving,  double? totalLineDiscount,  int? cartDealId,  double cartDealDiscount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItemDto() when $default != null:
return $default(_that.id,_that.itemId,_that.status,_that.quantity,_that.unitPrice,_that.totalPrice,_that.itemTitle,_that.colorName,_that.sizeName,_that.imageUrl,_that.dealId,_that.dealType,_that.snapshotDealPrice,_that.dealDiscount,_that.singleDealDiscount,_that.singleItemSaving,_that.totalLineDiscount,_that.cartDealId,_that.cartDealDiscount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int itemId,  int status,  int quantity,  double unitPrice,  double totalPrice,  String itemTitle,  String colorName,  String sizeName,  String? imageUrl,  int? dealId,  int? dealType,  double? snapshotDealPrice,  double dealDiscount,  double singleDealDiscount,  double? singleItemSaving,  double? totalLineDiscount,  int? cartDealId,  double cartDealDiscount)  $default,) {final _that = this;
switch (_that) {
case _OrderItemDto():
return $default(_that.id,_that.itemId,_that.status,_that.quantity,_that.unitPrice,_that.totalPrice,_that.itemTitle,_that.colorName,_that.sizeName,_that.imageUrl,_that.dealId,_that.dealType,_that.snapshotDealPrice,_that.dealDiscount,_that.singleDealDiscount,_that.singleItemSaving,_that.totalLineDiscount,_that.cartDealId,_that.cartDealDiscount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int itemId,  int status,  int quantity,  double unitPrice,  double totalPrice,  String itemTitle,  String colorName,  String sizeName,  String? imageUrl,  int? dealId,  int? dealType,  double? snapshotDealPrice,  double dealDiscount,  double singleDealDiscount,  double? singleItemSaving,  double? totalLineDiscount,  int? cartDealId,  double cartDealDiscount)?  $default,) {final _that = this;
switch (_that) {
case _OrderItemDto() when $default != null:
return $default(_that.id,_that.itemId,_that.status,_that.quantity,_that.unitPrice,_that.totalPrice,_that.itemTitle,_that.colorName,_that.sizeName,_that.imageUrl,_that.dealId,_that.dealType,_that.snapshotDealPrice,_that.dealDiscount,_that.singleDealDiscount,_that.singleItemSaving,_that.totalLineDiscount,_that.cartDealId,_that.cartDealDiscount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _OrderItemDto extends OrderItemDto {
  const _OrderItemDto({required this.id, this.itemId = 0, required this.status, required this.quantity, required this.unitPrice, required this.totalPrice, required this.itemTitle, required this.colorName, required this.sizeName, this.imageUrl, this.dealId, this.dealType, this.snapshotDealPrice, this.dealDiscount = 0.0, this.singleDealDiscount = 0.0, this.singleItemSaving, this.totalLineDiscount, this.cartDealId, this.cartDealDiscount = 0.0}): super._();
  factory _OrderItemDto.fromJson(Map<String, dynamic> json) => _$OrderItemDtoFromJson(json);

@override final  int id;
@override@JsonKey() final  int itemId;
@override final  int status;
@override final  int quantity;
@override final  double unitPrice;
@override final  double totalPrice;
@override final  String itemTitle;
@override final  String colorName;
@override final  String sizeName;
@override final  String? imageUrl;
// storeName intentionally omitted, never parsed or rendered
// The deal that priced this line, when one did.
@override final  int? dealId;
@override final  int? dealType;
@override final  double? snapshotDealPrice;
// What a bundle, multi-buy or free gift deal took off this line.
@override@JsonKey() final  double dealDiscount;
// A fixed price deal on only some of the units, taken off the line.
@override@JsonKey() final  double singleDealDiscount;
// What the fixed price deal saved on this line, whole or part.
@override final  double? singleItemSaving;
// Everything deals took off this line: [totalPrice] plus this is the
// line at its normal price.
@override final  double? totalLineDiscount;
// The spend deal over the whole cart, and this line's share of it.
@override final  int? cartDealId;
@override@JsonKey() final  double cartDealDiscount;

/// Create a copy of OrderItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemDtoCopyWith<_OrderItemDto> get copyWith => __$OrderItemDtoCopyWithImpl<_OrderItemDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.status, status) || other.status == status)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.itemTitle, itemTitle) || other.itemTitle == itemTitle)&&(identical(other.colorName, colorName) || other.colorName == colorName)&&(identical(other.sizeName, sizeName) || other.sizeName == sizeName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.dealType, dealType) || other.dealType == dealType)&&(identical(other.snapshotDealPrice, snapshotDealPrice) || other.snapshotDealPrice == snapshotDealPrice)&&(identical(other.dealDiscount, dealDiscount) || other.dealDiscount == dealDiscount)&&(identical(other.singleDealDiscount, singleDealDiscount) || other.singleDealDiscount == singleDealDiscount)&&(identical(other.singleItemSaving, singleItemSaving) || other.singleItemSaving == singleItemSaving)&&(identical(other.totalLineDiscount, totalLineDiscount) || other.totalLineDiscount == totalLineDiscount)&&(identical(other.cartDealId, cartDealId) || other.cartDealId == cartDealId)&&(identical(other.cartDealDiscount, cartDealDiscount) || other.cartDealDiscount == cartDealDiscount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,itemId,status,quantity,unitPrice,totalPrice,itemTitle,colorName,sizeName,imageUrl,dealId,dealType,snapshotDealPrice,dealDiscount,singleDealDiscount,singleItemSaving,totalLineDiscount,cartDealId,cartDealDiscount]);

@override
String toString() {
  return 'OrderItemDto(id: $id, itemId: $itemId, status: $status, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, itemTitle: $itemTitle, colorName: $colorName, sizeName: $sizeName, imageUrl: $imageUrl, dealId: $dealId, dealType: $dealType, snapshotDealPrice: $snapshotDealPrice, dealDiscount: $dealDiscount, singleDealDiscount: $singleDealDiscount, singleItemSaving: $singleItemSaving, totalLineDiscount: $totalLineDiscount, cartDealId: $cartDealId, cartDealDiscount: $cartDealDiscount)';
}


}

/// @nodoc
abstract mixin class _$OrderItemDtoCopyWith<$Res> implements $OrderItemDtoCopyWith<$Res> {
  factory _$OrderItemDtoCopyWith(_OrderItemDto value, $Res Function(_OrderItemDto) _then) = __$OrderItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int itemId, int status, int quantity, double unitPrice, double totalPrice, String itemTitle, String colorName, String sizeName, String? imageUrl, int? dealId, int? dealType, double? snapshotDealPrice, double dealDiscount, double singleDealDiscount, double? singleItemSaving, double? totalLineDiscount, int? cartDealId, double cartDealDiscount
});




}
/// @nodoc
class __$OrderItemDtoCopyWithImpl<$Res>
    implements _$OrderItemDtoCopyWith<$Res> {
  __$OrderItemDtoCopyWithImpl(this._self, this._then);

  final _OrderItemDto _self;
  final $Res Function(_OrderItemDto) _then;

/// Create a copy of OrderItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? status = null,Object? quantity = null,Object? unitPrice = null,Object? totalPrice = null,Object? itemTitle = null,Object? colorName = null,Object? sizeName = null,Object? imageUrl = freezed,Object? dealId = freezed,Object? dealType = freezed,Object? snapshotDealPrice = freezed,Object? dealDiscount = null,Object? singleDealDiscount = null,Object? singleItemSaving = freezed,Object? totalLineDiscount = freezed,Object? cartDealId = freezed,Object? cartDealDiscount = null,}) {
  return _then(_OrderItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,itemTitle: null == itemTitle ? _self.itemTitle : itemTitle // ignore: cast_nullable_to_non_nullable
as String,colorName: null == colorName ? _self.colorName : colorName // ignore: cast_nullable_to_non_nullable
as String,sizeName: null == sizeName ? _self.sizeName : sizeName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,dealId: freezed == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int?,dealType: freezed == dealType ? _self.dealType : dealType // ignore: cast_nullable_to_non_nullable
as int?,snapshotDealPrice: freezed == snapshotDealPrice ? _self.snapshotDealPrice : snapshotDealPrice // ignore: cast_nullable_to_non_nullable
as double?,dealDiscount: null == dealDiscount ? _self.dealDiscount : dealDiscount // ignore: cast_nullable_to_non_nullable
as double,singleDealDiscount: null == singleDealDiscount ? _self.singleDealDiscount : singleDealDiscount // ignore: cast_nullable_to_non_nullable
as double,singleItemSaving: freezed == singleItemSaving ? _self.singleItemSaving : singleItemSaving // ignore: cast_nullable_to_non_nullable
as double?,totalLineDiscount: freezed == totalLineDiscount ? _self.totalLineDiscount : totalLineDiscount // ignore: cast_nullable_to_non_nullable
as double?,cartDealId: freezed == cartDealId ? _self.cartDealId : cartDealId // ignore: cast_nullable_to_non_nullable
as int?,cartDealDiscount: null == cartDealDiscount ? _self.cartDealDiscount : cartDealDiscount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
