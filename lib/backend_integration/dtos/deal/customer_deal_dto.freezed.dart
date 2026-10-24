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
@ServerUtcDateConverter() DateTime? get expiresAt; bool get isLive; List<ItemListItemDto> get items;
/// Create a copy of CustomerDealDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerDealDtoCopyWith<CustomerDealDto> get copyWith => _$CustomerDealDtoCopyWithImpl<CustomerDealDto>(this as CustomerDealDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerDealDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,startsAt,expiresAt,isLive,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'CustomerDealDto(id: $id, title: $title, description: $description, startsAt: $startsAt, expiresAt: $expiresAt, isLive: $isLive, items: $items)';
}


}

/// @nodoc
abstract mixin class $CustomerDealDtoCopyWith<$Res>  {
  factory $CustomerDealDtoCopyWith(CustomerDealDto value, $Res Function(CustomerDealDto) _then) = _$CustomerDealDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? description,@ServerUtcDateConverter() DateTime startsAt,@ServerUtcDateConverter() DateTime? expiresAt, bool isLive, List<ItemListItemDto> items
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? startsAt = null,Object? expiresAt = freezed,Object? isLive = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ItemListItemDto>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? description, @ServerUtcDateConverter()  DateTime startsAt, @ServerUtcDateConverter()  DateTime? expiresAt,  bool isLive,  List<ItemListItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerDealDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.startsAt,_that.expiresAt,_that.isLive,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? description, @ServerUtcDateConverter()  DateTime startsAt, @ServerUtcDateConverter()  DateTime? expiresAt,  bool isLive,  List<ItemListItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _CustomerDealDto():
return $default(_that.id,_that.title,_that.description,_that.startsAt,_that.expiresAt,_that.isLive,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? description, @ServerUtcDateConverter()  DateTime startsAt, @ServerUtcDateConverter()  DateTime? expiresAt,  bool isLive,  List<ItemListItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _CustomerDealDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.startsAt,_that.expiresAt,_that.isLive,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _CustomerDealDto implements CustomerDealDto {
  const _CustomerDealDto({required this.id, required this.title, this.description, @ServerUtcDateConverter() required this.startsAt, @ServerUtcDateConverter() this.expiresAt, required this.isLive, final  List<ItemListItemDto> items = const []}): _items = items;
  factory _CustomerDealDto.fromJson(Map<String, dynamic> json) => _$CustomerDealDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  String? description;
@override@ServerUtcDateConverter() final  DateTime startsAt;
// Null when the deal never ends.
@override@ServerUtcDateConverter() final  DateTime? expiresAt;
@override final  bool isLive;
 final  List<ItemListItemDto> _items;
@override@JsonKey() List<ItemListItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of CustomerDealDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerDealDtoCopyWith<_CustomerDealDto> get copyWith => __$CustomerDealDtoCopyWithImpl<_CustomerDealDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerDealDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,startsAt,expiresAt,isLive,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'CustomerDealDto(id: $id, title: $title, description: $description, startsAt: $startsAt, expiresAt: $expiresAt, isLive: $isLive, items: $items)';
}


}

/// @nodoc
abstract mixin class _$CustomerDealDtoCopyWith<$Res> implements $CustomerDealDtoCopyWith<$Res> {
  factory _$CustomerDealDtoCopyWith(_CustomerDealDto value, $Res Function(_CustomerDealDto) _then) = __$CustomerDealDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? description,@ServerUtcDateConverter() DateTime startsAt,@ServerUtcDateConverter() DateTime? expiresAt, bool isLive, List<ItemListItemDto> items
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? startsAt = null,Object? expiresAt = freezed,Object? isLive = null,Object? items = null,}) {
  return _then(_CustomerDealDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ItemListItemDto>,
  ));
}


}

// dart format on
