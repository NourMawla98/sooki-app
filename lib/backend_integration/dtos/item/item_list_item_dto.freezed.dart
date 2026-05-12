// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_list_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemListItemDto {

 int get id; String get title; double get originalPrice; double? get discountedPrice; String get storeName; String get categoryName; List<String> get colorImages;
/// Create a copy of ItemListItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemListItemDtoCopyWith<ItemListItemDto> get copyWith => _$ItemListItemDtoCopyWithImpl<ItemListItemDto>(this as ItemListItemDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemListItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&const DeepCollectionEquality().equals(other.colorImages, colorImages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,originalPrice,discountedPrice,storeName,categoryName,const DeepCollectionEquality().hash(colorImages));

@override
String toString() {
  return 'ItemListItemDto(id: $id, title: $title, originalPrice: $originalPrice, discountedPrice: $discountedPrice, storeName: $storeName, categoryName: $categoryName, colorImages: $colorImages)';
}


}

/// @nodoc
abstract mixin class $ItemListItemDtoCopyWith<$Res>  {
  factory $ItemListItemDtoCopyWith(ItemListItemDto value, $Res Function(ItemListItemDto) _then) = _$ItemListItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, double originalPrice, double? discountedPrice, String storeName, String categoryName, List<String> colorImages
});




}
/// @nodoc
class _$ItemListItemDtoCopyWithImpl<$Res>
    implements $ItemListItemDtoCopyWith<$Res> {
  _$ItemListItemDtoCopyWithImpl(this._self, this._then);

  final ItemListItemDto _self;
  final $Res Function(ItemListItemDto) _then;

/// Create a copy of ItemListItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? originalPrice = null,Object? discountedPrice = freezed,Object? storeName = null,Object? categoryName = null,Object? colorImages = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,colorImages: null == colorImages ? _self.colorImages : colorImages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemListItemDto].
extension ItemListItemDtoPatterns on ItemListItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemListItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemListItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemListItemDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemListItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemListItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemListItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  double originalPrice,  double? discountedPrice,  String storeName,  String categoryName,  List<String> colorImages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemListItemDto() when $default != null:
return $default(_that.id,_that.title,_that.originalPrice,_that.discountedPrice,_that.storeName,_that.categoryName,_that.colorImages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  double originalPrice,  double? discountedPrice,  String storeName,  String categoryName,  List<String> colorImages)  $default,) {final _that = this;
switch (_that) {
case _ItemListItemDto():
return $default(_that.id,_that.title,_that.originalPrice,_that.discountedPrice,_that.storeName,_that.categoryName,_that.colorImages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  double originalPrice,  double? discountedPrice,  String storeName,  String categoryName,  List<String> colorImages)?  $default,) {final _that = this;
switch (_that) {
case _ItemListItemDto() when $default != null:
return $default(_that.id,_that.title,_that.originalPrice,_that.discountedPrice,_that.storeName,_that.categoryName,_that.colorImages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemListItemDto implements ItemListItemDto {
  const _ItemListItemDto({required this.id, required this.title, required this.originalPrice, this.discountedPrice, required this.storeName, required this.categoryName, final  List<String> colorImages = const []}): _colorImages = colorImages;
  factory _ItemListItemDto.fromJson(Map<String, dynamic> json) => _$ItemListItemDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  double originalPrice;
@override final  double? discountedPrice;
@override final  String storeName;
@override final  String categoryName;
 final  List<String> _colorImages;
@override@JsonKey() List<String> get colorImages {
  if (_colorImages is EqualUnmodifiableListView) return _colorImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_colorImages);
}


/// Create a copy of ItemListItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemListItemDtoCopyWith<_ItemListItemDto> get copyWith => __$ItemListItemDtoCopyWithImpl<_ItemListItemDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemListItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&const DeepCollectionEquality().equals(other._colorImages, _colorImages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,originalPrice,discountedPrice,storeName,categoryName,const DeepCollectionEquality().hash(_colorImages));

@override
String toString() {
  return 'ItemListItemDto(id: $id, title: $title, originalPrice: $originalPrice, discountedPrice: $discountedPrice, storeName: $storeName, categoryName: $categoryName, colorImages: $colorImages)';
}


}

/// @nodoc
abstract mixin class _$ItemListItemDtoCopyWith<$Res> implements $ItemListItemDtoCopyWith<$Res> {
  factory _$ItemListItemDtoCopyWith(_ItemListItemDto value, $Res Function(_ItemListItemDto) _then) = __$ItemListItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, double originalPrice, double? discountedPrice, String storeName, String categoryName, List<String> colorImages
});




}
/// @nodoc
class __$ItemListItemDtoCopyWithImpl<$Res>
    implements _$ItemListItemDtoCopyWith<$Res> {
  __$ItemListItemDtoCopyWithImpl(this._self, this._then);

  final _ItemListItemDto _self;
  final $Res Function(_ItemListItemDto) _then;

/// Create a copy of ItemListItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? originalPrice = null,Object? discountedPrice = freezed,Object? storeName = null,Object? categoryName = null,Object? colorImages = null,}) {
  return _then(_ItemListItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,colorImages: null == colorImages ? _self._colorImages : colorImages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
