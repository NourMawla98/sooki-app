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

 int get itemCount; double get subtotal; List<CartItemDto> get items;
/// Create a copy of CartResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartResponseDtoCopyWith<CartResponseDto> get copyWith => _$CartResponseDtoCopyWithImpl<CartResponseDto>(this as CartResponseDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartResponseDto&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemCount,subtotal,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'CartResponseDto(itemCount: $itemCount, subtotal: $subtotal, items: $items)';
}


}

/// @nodoc
abstract mixin class $CartResponseDtoCopyWith<$Res>  {
  factory $CartResponseDtoCopyWith(CartResponseDto value, $Res Function(CartResponseDto) _then) = _$CartResponseDtoCopyWithImpl;
@useResult
$Res call({
 int itemCount, double subtotal, List<CartItemDto> items
});




}
/// @nodoc
class _$CartResponseDtoCopyWithImpl<$Res>
    implements $CartResponseDtoCopyWith<$Res> {
  _$CartResponseDtoCopyWithImpl(this._self, this._then);

  final CartResponseDto _self;
  final $Res Function(CartResponseDto) _then;

/// Create a copy of CartResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemCount = null,Object? subtotal = null,Object? items = null,}) {
  return _then(_self.copyWith(
itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemDto>,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int itemCount,  double subtotal,  List<CartItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartResponseDto() when $default != null:
return $default(_that.itemCount,_that.subtotal,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int itemCount,  double subtotal,  List<CartItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _CartResponseDto():
return $default(_that.itemCount,_that.subtotal,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int itemCount,  double subtotal,  List<CartItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _CartResponseDto() when $default != null:
return $default(_that.itemCount,_that.subtotal,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _CartResponseDto implements CartResponseDto {
  const _CartResponseDto({required this.itemCount, required this.subtotal, final  List<CartItemDto> items = const []}): _items = items;
  factory _CartResponseDto.fromJson(Map<String, dynamic> json) => _$CartResponseDtoFromJson(json);

@override final  int itemCount;
@override final  double subtotal;
 final  List<CartItemDto> _items;
@override@JsonKey() List<CartItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of CartResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartResponseDtoCopyWith<_CartResponseDto> get copyWith => __$CartResponseDtoCopyWithImpl<_CartResponseDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartResponseDto&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemCount,subtotal,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'CartResponseDto(itemCount: $itemCount, subtotal: $subtotal, items: $items)';
}


}

/// @nodoc
abstract mixin class _$CartResponseDtoCopyWith<$Res> implements $CartResponseDtoCopyWith<$Res> {
  factory _$CartResponseDtoCopyWith(_CartResponseDto value, $Res Function(_CartResponseDto) _then) = __$CartResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int itemCount, double subtotal, List<CartItemDto> items
});




}
/// @nodoc
class __$CartResponseDtoCopyWithImpl<$Res>
    implements _$CartResponseDtoCopyWith<$Res> {
  __$CartResponseDtoCopyWithImpl(this._self, this._then);

  final _CartResponseDto _self;
  final $Res Function(_CartResponseDto) _then;

/// Create a copy of CartResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemCount = null,Object? subtotal = null,Object? items = null,}) {
  return _then(_CartResponseDto(
itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemDto>,
  ));
}


}


/// @nodoc
mixin _$CartItemDto {

 int get id; int get itemId; String get itemTitle; int get itemColorId; String get colorName; String? get mainImageUrl; int get itemSizeId; String get sizeName; double get unitPrice; int get quantity; double get lineTotal; int get stock; bool get isAvailable;
/// Create a copy of CartItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemDtoCopyWith<CartItemDto> get copyWith => _$CartItemDtoCopyWithImpl<CartItemDto>(this as CartItemDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemTitle, itemTitle) || other.itemTitle == itemTitle)&&(identical(other.itemColorId, itemColorId) || other.itemColorId == itemColorId)&&(identical(other.colorName, colorName) || other.colorName == colorName)&&(identical(other.mainImageUrl, mainImageUrl) || other.mainImageUrl == mainImageUrl)&&(identical(other.itemSizeId, itemSizeId) || other.itemSizeId == itemSizeId)&&(identical(other.sizeName, sizeName) || other.sizeName == sizeName)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,itemTitle,itemColorId,colorName,mainImageUrl,itemSizeId,sizeName,unitPrice,quantity,lineTotal,stock,isAvailable);

@override
String toString() {
  return 'CartItemDto(id: $id, itemId: $itemId, itemTitle: $itemTitle, itemColorId: $itemColorId, colorName: $colorName, mainImageUrl: $mainImageUrl, itemSizeId: $itemSizeId, sizeName: $sizeName, unitPrice: $unitPrice, quantity: $quantity, lineTotal: $lineTotal, stock: $stock, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $CartItemDtoCopyWith<$Res>  {
  factory $CartItemDtoCopyWith(CartItemDto value, $Res Function(CartItemDto) _then) = _$CartItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, int itemId, String itemTitle, int itemColorId, String colorName, String? mainImageUrl, int itemSizeId, String sizeName, double unitPrice, int quantity, double lineTotal, int stock, bool isAvailable
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? itemTitle = null,Object? itemColorId = null,Object? colorName = null,Object? mainImageUrl = freezed,Object? itemSizeId = null,Object? sizeName = null,Object? unitPrice = null,Object? quantity = null,Object? lineTotal = null,Object? stock = null,Object? isAvailable = null,}) {
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
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int itemId,  String itemTitle,  int itemColorId,  String colorName,  String? mainImageUrl,  int itemSizeId,  String sizeName,  double unitPrice,  int quantity,  double lineTotal,  int stock,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItemDto() when $default != null:
return $default(_that.id,_that.itemId,_that.itemTitle,_that.itemColorId,_that.colorName,_that.mainImageUrl,_that.itemSizeId,_that.sizeName,_that.unitPrice,_that.quantity,_that.lineTotal,_that.stock,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int itemId,  String itemTitle,  int itemColorId,  String colorName,  String? mainImageUrl,  int itemSizeId,  String sizeName,  double unitPrice,  int quantity,  double lineTotal,  int stock,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _CartItemDto():
return $default(_that.id,_that.itemId,_that.itemTitle,_that.itemColorId,_that.colorName,_that.mainImageUrl,_that.itemSizeId,_that.sizeName,_that.unitPrice,_that.quantity,_that.lineTotal,_that.stock,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int itemId,  String itemTitle,  int itemColorId,  String colorName,  String? mainImageUrl,  int itemSizeId,  String sizeName,  double unitPrice,  int quantity,  double lineTotal,  int stock,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _CartItemDto() when $default != null:
return $default(_that.id,_that.itemId,_that.itemTitle,_that.itemColorId,_that.colorName,_that.mainImageUrl,_that.itemSizeId,_that.sizeName,_that.unitPrice,_that.quantity,_that.lineTotal,_that.stock,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _CartItemDto implements CartItemDto {
  const _CartItemDto({required this.id, required this.itemId, required this.itemTitle, required this.itemColorId, required this.colorName, this.mainImageUrl, required this.itemSizeId, required this.sizeName, required this.unitPrice, required this.quantity, required this.lineTotal, required this.stock, required this.isAvailable});
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
@override final  int quantity;
@override final  double lineTotal;
@override final  int stock;
@override final  bool isAvailable;

/// Create a copy of CartItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemDtoCopyWith<_CartItemDto> get copyWith => __$CartItemDtoCopyWithImpl<_CartItemDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemTitle, itemTitle) || other.itemTitle == itemTitle)&&(identical(other.itemColorId, itemColorId) || other.itemColorId == itemColorId)&&(identical(other.colorName, colorName) || other.colorName == colorName)&&(identical(other.mainImageUrl, mainImageUrl) || other.mainImageUrl == mainImageUrl)&&(identical(other.itemSizeId, itemSizeId) || other.itemSizeId == itemSizeId)&&(identical(other.sizeName, sizeName) || other.sizeName == sizeName)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,itemTitle,itemColorId,colorName,mainImageUrl,itemSizeId,sizeName,unitPrice,quantity,lineTotal,stock,isAvailable);

@override
String toString() {
  return 'CartItemDto(id: $id, itemId: $itemId, itemTitle: $itemTitle, itemColorId: $itemColorId, colorName: $colorName, mainImageUrl: $mainImageUrl, itemSizeId: $itemSizeId, sizeName: $sizeName, unitPrice: $unitPrice, quantity: $quantity, lineTotal: $lineTotal, stock: $stock, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$CartItemDtoCopyWith<$Res> implements $CartItemDtoCopyWith<$Res> {
  factory _$CartItemDtoCopyWith(_CartItemDto value, $Res Function(_CartItemDto) _then) = __$CartItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int itemId, String itemTitle, int itemColorId, String colorName, String? mainImageUrl, int itemSizeId, String sizeName, double unitPrice, int quantity, double lineTotal, int stock, bool isAvailable
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? itemTitle = null,Object? itemColorId = null,Object? colorName = null,Object? mainImageUrl = freezed,Object? itemSizeId = null,Object? sizeName = null,Object? unitPrice = null,Object? quantity = null,Object? lineTotal = null,Object? stock = null,Object? isAvailable = null,}) {
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
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
