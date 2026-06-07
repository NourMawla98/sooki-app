// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_detail_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemDetailDto {

 int get id; String get title; String? get subtitle; String? get description; double get originalPrice; double? get discountedPrice; int get discountPercentage; int? get stock; String? get brand; String get categoryName; String? get subCategoryName; String? get detailCategoryName; double get averageRating; int get reviewCount; List<ItemDetailColorDto> get colors; List<ItemTagDto> get tags; List<ItemDetailLabelDto> get labels; List<ItemDetailAttributeDto> get attributes; List<ItemDetailSizeMeasurementGroupDto> get sizeMeasurements;
/// Create a copy of ItemDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDetailDtoCopyWith<ItemDetailDto> get copyWith => _$ItemDetailDtoCopyWithImpl<ItemDetailDto>(this as ItemDetailDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.subCategoryName, subCategoryName) || other.subCategoryName == subCategoryName)&&(identical(other.detailCategoryName, detailCategoryName) || other.detailCategoryName == detailCategoryName)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&const DeepCollectionEquality().equals(other.colors, colors)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.attributes, attributes)&&const DeepCollectionEquality().equals(other.sizeMeasurements, sizeMeasurements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,subtitle,description,originalPrice,discountedPrice,discountPercentage,stock,brand,categoryName,subCategoryName,detailCategoryName,averageRating,reviewCount,const DeepCollectionEquality().hash(colors),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(attributes),const DeepCollectionEquality().hash(sizeMeasurements)]);

@override
String toString() {
  return 'ItemDetailDto(id: $id, title: $title, subtitle: $subtitle, description: $description, originalPrice: $originalPrice, discountedPrice: $discountedPrice, discountPercentage: $discountPercentage, stock: $stock, brand: $brand, categoryName: $categoryName, subCategoryName: $subCategoryName, detailCategoryName: $detailCategoryName, averageRating: $averageRating, reviewCount: $reviewCount, colors: $colors, tags: $tags, labels: $labels, attributes: $attributes, sizeMeasurements: $sizeMeasurements)';
}


}

/// @nodoc
abstract mixin class $ItemDetailDtoCopyWith<$Res>  {
  factory $ItemDetailDtoCopyWith(ItemDetailDto value, $Res Function(ItemDetailDto) _then) = _$ItemDetailDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? subtitle, String? description, double originalPrice, double? discountedPrice, int discountPercentage, int? stock, String? brand, String categoryName, String? subCategoryName, String? detailCategoryName, double averageRating, int reviewCount, List<ItemDetailColorDto> colors, List<ItemTagDto> tags, List<ItemDetailLabelDto> labels, List<ItemDetailAttributeDto> attributes, List<ItemDetailSizeMeasurementGroupDto> sizeMeasurements
});




}
/// @nodoc
class _$ItemDetailDtoCopyWithImpl<$Res>
    implements $ItemDetailDtoCopyWith<$Res> {
  _$ItemDetailDtoCopyWithImpl(this._self, this._then);

  final ItemDetailDto _self;
  final $Res Function(ItemDetailDto) _then;

/// Create a copy of ItemDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = freezed,Object? description = freezed,Object? originalPrice = null,Object? discountedPrice = freezed,Object? discountPercentage = null,Object? stock = freezed,Object? brand = freezed,Object? categoryName = null,Object? subCategoryName = freezed,Object? detailCategoryName = freezed,Object? averageRating = null,Object? reviewCount = null,Object? colors = null,Object? tags = null,Object? labels = null,Object? attributes = null,Object? sizeMeasurements = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,discountPercentage: null == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as int,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,subCategoryName: freezed == subCategoryName ? _self.subCategoryName : subCategoryName // ignore: cast_nullable_to_non_nullable
as String?,detailCategoryName: freezed == detailCategoryName ? _self.detailCategoryName : detailCategoryName // ignore: cast_nullable_to_non_nullable
as String?,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,colors: null == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as List<ItemDetailColorDto>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<ItemTagDto>,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<ItemDetailLabelDto>,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as List<ItemDetailAttributeDto>,sizeMeasurements: null == sizeMeasurements ? _self.sizeMeasurements : sizeMeasurements // ignore: cast_nullable_to_non_nullable
as List<ItemDetailSizeMeasurementGroupDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDetailDto].
extension ItemDetailDtoPatterns on ItemDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? subtitle,  String? description,  double originalPrice,  double? discountedPrice,  int discountPercentage,  int? stock,  String? brand,  String categoryName,  String? subCategoryName,  String? detailCategoryName,  double averageRating,  int reviewCount,  List<ItemDetailColorDto> colors,  List<ItemTagDto> tags,  List<ItemDetailLabelDto> labels,  List<ItemDetailAttributeDto> attributes,  List<ItemDetailSizeMeasurementGroupDto> sizeMeasurements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDetailDto() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.description,_that.originalPrice,_that.discountedPrice,_that.discountPercentage,_that.stock,_that.brand,_that.categoryName,_that.subCategoryName,_that.detailCategoryName,_that.averageRating,_that.reviewCount,_that.colors,_that.tags,_that.labels,_that.attributes,_that.sizeMeasurements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? subtitle,  String? description,  double originalPrice,  double? discountedPrice,  int discountPercentage,  int? stock,  String? brand,  String categoryName,  String? subCategoryName,  String? detailCategoryName,  double averageRating,  int reviewCount,  List<ItemDetailColorDto> colors,  List<ItemTagDto> tags,  List<ItemDetailLabelDto> labels,  List<ItemDetailAttributeDto> attributes,  List<ItemDetailSizeMeasurementGroupDto> sizeMeasurements)  $default,) {final _that = this;
switch (_that) {
case _ItemDetailDto():
return $default(_that.id,_that.title,_that.subtitle,_that.description,_that.originalPrice,_that.discountedPrice,_that.discountPercentage,_that.stock,_that.brand,_that.categoryName,_that.subCategoryName,_that.detailCategoryName,_that.averageRating,_that.reviewCount,_that.colors,_that.tags,_that.labels,_that.attributes,_that.sizeMeasurements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? subtitle,  String? description,  double originalPrice,  double? discountedPrice,  int discountPercentage,  int? stock,  String? brand,  String categoryName,  String? subCategoryName,  String? detailCategoryName,  double averageRating,  int reviewCount,  List<ItemDetailColorDto> colors,  List<ItemTagDto> tags,  List<ItemDetailLabelDto> labels,  List<ItemDetailAttributeDto> attributes,  List<ItemDetailSizeMeasurementGroupDto> sizeMeasurements)?  $default,) {final _that = this;
switch (_that) {
case _ItemDetailDto() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.description,_that.originalPrice,_that.discountedPrice,_that.discountPercentage,_that.stock,_that.brand,_that.categoryName,_that.subCategoryName,_that.detailCategoryName,_that.averageRating,_that.reviewCount,_that.colors,_that.tags,_that.labels,_that.attributes,_that.sizeMeasurements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemDetailDto implements ItemDetailDto {
  const _ItemDetailDto({required this.id, required this.title, this.subtitle, this.description, required this.originalPrice, this.discountedPrice, required this.discountPercentage, this.stock, this.brand, required this.categoryName, this.subCategoryName, this.detailCategoryName, this.averageRating = 0.0, this.reviewCount = 0, final  List<ItemDetailColorDto> colors = const [], final  List<ItemTagDto> tags = const [], final  List<ItemDetailLabelDto> labels = const [], final  List<ItemDetailAttributeDto> attributes = const [], final  List<ItemDetailSizeMeasurementGroupDto> sizeMeasurements = const []}): _colors = colors,_tags = tags,_labels = labels,_attributes = attributes,_sizeMeasurements = sizeMeasurements;
  factory _ItemDetailDto.fromJson(Map<String, dynamic> json) => _$ItemDetailDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  String? subtitle;
@override final  String? description;
@override final  double originalPrice;
@override final  double? discountedPrice;
@override final  int discountPercentage;
@override final  int? stock;
@override final  String? brand;
@override final  String categoryName;
@override final  String? subCategoryName;
@override final  String? detailCategoryName;
@override@JsonKey() final  double averageRating;
@override@JsonKey() final  int reviewCount;
 final  List<ItemDetailColorDto> _colors;
@override@JsonKey() List<ItemDetailColorDto> get colors {
  if (_colors is EqualUnmodifiableListView) return _colors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_colors);
}

 final  List<ItemTagDto> _tags;
@override@JsonKey() List<ItemTagDto> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<ItemDetailLabelDto> _labels;
@override@JsonKey() List<ItemDetailLabelDto> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

 final  List<ItemDetailAttributeDto> _attributes;
@override@JsonKey() List<ItemDetailAttributeDto> get attributes {
  if (_attributes is EqualUnmodifiableListView) return _attributes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attributes);
}

 final  List<ItemDetailSizeMeasurementGroupDto> _sizeMeasurements;
@override@JsonKey() List<ItemDetailSizeMeasurementGroupDto> get sizeMeasurements {
  if (_sizeMeasurements is EqualUnmodifiableListView) return _sizeMeasurements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizeMeasurements);
}


/// Create a copy of ItemDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDetailDtoCopyWith<_ItemDetailDto> get copyWith => __$ItemDetailDtoCopyWithImpl<_ItemDetailDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.subCategoryName, subCategoryName) || other.subCategoryName == subCategoryName)&&(identical(other.detailCategoryName, detailCategoryName) || other.detailCategoryName == detailCategoryName)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&const DeepCollectionEquality().equals(other._colors, _colors)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._labels, _labels)&&const DeepCollectionEquality().equals(other._attributes, _attributes)&&const DeepCollectionEquality().equals(other._sizeMeasurements, _sizeMeasurements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,subtitle,description,originalPrice,discountedPrice,discountPercentage,stock,brand,categoryName,subCategoryName,detailCategoryName,averageRating,reviewCount,const DeepCollectionEquality().hash(_colors),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_attributes),const DeepCollectionEquality().hash(_sizeMeasurements)]);

@override
String toString() {
  return 'ItemDetailDto(id: $id, title: $title, subtitle: $subtitle, description: $description, originalPrice: $originalPrice, discountedPrice: $discountedPrice, discountPercentage: $discountPercentage, stock: $stock, brand: $brand, categoryName: $categoryName, subCategoryName: $subCategoryName, detailCategoryName: $detailCategoryName, averageRating: $averageRating, reviewCount: $reviewCount, colors: $colors, tags: $tags, labels: $labels, attributes: $attributes, sizeMeasurements: $sizeMeasurements)';
}


}

/// @nodoc
abstract mixin class _$ItemDetailDtoCopyWith<$Res> implements $ItemDetailDtoCopyWith<$Res> {
  factory _$ItemDetailDtoCopyWith(_ItemDetailDto value, $Res Function(_ItemDetailDto) _then) = __$ItemDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? subtitle, String? description, double originalPrice, double? discountedPrice, int discountPercentage, int? stock, String? brand, String categoryName, String? subCategoryName, String? detailCategoryName, double averageRating, int reviewCount, List<ItemDetailColorDto> colors, List<ItemTagDto> tags, List<ItemDetailLabelDto> labels, List<ItemDetailAttributeDto> attributes, List<ItemDetailSizeMeasurementGroupDto> sizeMeasurements
});




}
/// @nodoc
class __$ItemDetailDtoCopyWithImpl<$Res>
    implements _$ItemDetailDtoCopyWith<$Res> {
  __$ItemDetailDtoCopyWithImpl(this._self, this._then);

  final _ItemDetailDto _self;
  final $Res Function(_ItemDetailDto) _then;

/// Create a copy of ItemDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = freezed,Object? description = freezed,Object? originalPrice = null,Object? discountedPrice = freezed,Object? discountPercentage = null,Object? stock = freezed,Object? brand = freezed,Object? categoryName = null,Object? subCategoryName = freezed,Object? detailCategoryName = freezed,Object? averageRating = null,Object? reviewCount = null,Object? colors = null,Object? tags = null,Object? labels = null,Object? attributes = null,Object? sizeMeasurements = null,}) {
  return _then(_ItemDetailDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,discountPercentage: null == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as int,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,subCategoryName: freezed == subCategoryName ? _self.subCategoryName : subCategoryName // ignore: cast_nullable_to_non_nullable
as String?,detailCategoryName: freezed == detailCategoryName ? _self.detailCategoryName : detailCategoryName // ignore: cast_nullable_to_non_nullable
as String?,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,colors: null == colors ? _self._colors : colors // ignore: cast_nullable_to_non_nullable
as List<ItemDetailColorDto>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<ItemTagDto>,labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<ItemDetailLabelDto>,attributes: null == attributes ? _self._attributes : attributes // ignore: cast_nullable_to_non_nullable
as List<ItemDetailAttributeDto>,sizeMeasurements: null == sizeMeasurements ? _self._sizeMeasurements : sizeMeasurements // ignore: cast_nullable_to_non_nullable
as List<ItemDetailSizeMeasurementGroupDto>,
  ));
}


}


/// @nodoc
mixin _$ItemDetailColorDto {

 int get id; String get colorType; int get sortOrder; String? get patternImageUrl; ItemDetailColorValueDto get color1; ItemDetailColorValueDto? get color2; ItemDetailColorValueDto? get color3; List<ItemDetailMediaDto> get media; List<ItemDetailSizeDto> get sizes;
/// Create a copy of ItemDetailColorDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDetailColorDtoCopyWith<ItemDetailColorDto> get copyWith => _$ItemDetailColorDtoCopyWithImpl<ItemDetailColorDto>(this as ItemDetailColorDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDetailColorDto&&(identical(other.id, id) || other.id == id)&&(identical(other.colorType, colorType) || other.colorType == colorType)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.patternImageUrl, patternImageUrl) || other.patternImageUrl == patternImageUrl)&&(identical(other.color1, color1) || other.color1 == color1)&&(identical(other.color2, color2) || other.color2 == color2)&&(identical(other.color3, color3) || other.color3 == color3)&&const DeepCollectionEquality().equals(other.media, media)&&const DeepCollectionEquality().equals(other.sizes, sizes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,colorType,sortOrder,patternImageUrl,color1,color2,color3,const DeepCollectionEquality().hash(media),const DeepCollectionEquality().hash(sizes));

@override
String toString() {
  return 'ItemDetailColorDto(id: $id, colorType: $colorType, sortOrder: $sortOrder, patternImageUrl: $patternImageUrl, color1: $color1, color2: $color2, color3: $color3, media: $media, sizes: $sizes)';
}


}

/// @nodoc
abstract mixin class $ItemDetailColorDtoCopyWith<$Res>  {
  factory $ItemDetailColorDtoCopyWith(ItemDetailColorDto value, $Res Function(ItemDetailColorDto) _then) = _$ItemDetailColorDtoCopyWithImpl;
@useResult
$Res call({
 int id, String colorType, int sortOrder, String? patternImageUrl, ItemDetailColorValueDto color1, ItemDetailColorValueDto? color2, ItemDetailColorValueDto? color3, List<ItemDetailMediaDto> media, List<ItemDetailSizeDto> sizes
});


$ItemDetailColorValueDtoCopyWith<$Res> get color1;$ItemDetailColorValueDtoCopyWith<$Res>? get color2;$ItemDetailColorValueDtoCopyWith<$Res>? get color3;

}
/// @nodoc
class _$ItemDetailColorDtoCopyWithImpl<$Res>
    implements $ItemDetailColorDtoCopyWith<$Res> {
  _$ItemDetailColorDtoCopyWithImpl(this._self, this._then);

  final ItemDetailColorDto _self;
  final $Res Function(ItemDetailColorDto) _then;

/// Create a copy of ItemDetailColorDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? colorType = null,Object? sortOrder = null,Object? patternImageUrl = freezed,Object? color1 = null,Object? color2 = freezed,Object? color3 = freezed,Object? media = null,Object? sizes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,colorType: null == colorType ? _self.colorType : colorType // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,patternImageUrl: freezed == patternImageUrl ? _self.patternImageUrl : patternImageUrl // ignore: cast_nullable_to_non_nullable
as String?,color1: null == color1 ? _self.color1 : color1 // ignore: cast_nullable_to_non_nullable
as ItemDetailColorValueDto,color2: freezed == color2 ? _self.color2 : color2 // ignore: cast_nullable_to_non_nullable
as ItemDetailColorValueDto?,color3: freezed == color3 ? _self.color3 : color3 // ignore: cast_nullable_to_non_nullable
as ItemDetailColorValueDto?,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<ItemDetailMediaDto>,sizes: null == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<ItemDetailSizeDto>,
  ));
}
/// Create a copy of ItemDetailColorDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemDetailColorValueDtoCopyWith<$Res> get color1 {
  
  return $ItemDetailColorValueDtoCopyWith<$Res>(_self.color1, (value) {
    return _then(_self.copyWith(color1: value));
  });
}/// Create a copy of ItemDetailColorDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemDetailColorValueDtoCopyWith<$Res>? get color2 {
    if (_self.color2 == null) {
    return null;
  }

  return $ItemDetailColorValueDtoCopyWith<$Res>(_self.color2!, (value) {
    return _then(_self.copyWith(color2: value));
  });
}/// Create a copy of ItemDetailColorDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemDetailColorValueDtoCopyWith<$Res>? get color3 {
    if (_self.color3 == null) {
    return null;
  }

  return $ItemDetailColorValueDtoCopyWith<$Res>(_self.color3!, (value) {
    return _then(_self.copyWith(color3: value));
  });
}
}


/// Adds pattern-matching-related methods to [ItemDetailColorDto].
extension ItemDetailColorDtoPatterns on ItemDetailColorDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDetailColorDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDetailColorDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDetailColorDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDetailColorDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDetailColorDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDetailColorDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String colorType,  int sortOrder,  String? patternImageUrl,  ItemDetailColorValueDto color1,  ItemDetailColorValueDto? color2,  ItemDetailColorValueDto? color3,  List<ItemDetailMediaDto> media,  List<ItemDetailSizeDto> sizes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDetailColorDto() when $default != null:
return $default(_that.id,_that.colorType,_that.sortOrder,_that.patternImageUrl,_that.color1,_that.color2,_that.color3,_that.media,_that.sizes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String colorType,  int sortOrder,  String? patternImageUrl,  ItemDetailColorValueDto color1,  ItemDetailColorValueDto? color2,  ItemDetailColorValueDto? color3,  List<ItemDetailMediaDto> media,  List<ItemDetailSizeDto> sizes)  $default,) {final _that = this;
switch (_that) {
case _ItemDetailColorDto():
return $default(_that.id,_that.colorType,_that.sortOrder,_that.patternImageUrl,_that.color1,_that.color2,_that.color3,_that.media,_that.sizes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String colorType,  int sortOrder,  String? patternImageUrl,  ItemDetailColorValueDto color1,  ItemDetailColorValueDto? color2,  ItemDetailColorValueDto? color3,  List<ItemDetailMediaDto> media,  List<ItemDetailSizeDto> sizes)?  $default,) {final _that = this;
switch (_that) {
case _ItemDetailColorDto() when $default != null:
return $default(_that.id,_that.colorType,_that.sortOrder,_that.patternImageUrl,_that.color1,_that.color2,_that.color3,_that.media,_that.sizes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemDetailColorDto implements ItemDetailColorDto {
  const _ItemDetailColorDto({required this.id, required this.colorType, required this.sortOrder, this.patternImageUrl, required this.color1, this.color2, this.color3, final  List<ItemDetailMediaDto> media = const [], final  List<ItemDetailSizeDto> sizes = const []}): _media = media,_sizes = sizes;
  factory _ItemDetailColorDto.fromJson(Map<String, dynamic> json) => _$ItemDetailColorDtoFromJson(json);

@override final  int id;
@override final  String colorType;
@override final  int sortOrder;
@override final  String? patternImageUrl;
@override final  ItemDetailColorValueDto color1;
@override final  ItemDetailColorValueDto? color2;
@override final  ItemDetailColorValueDto? color3;
 final  List<ItemDetailMediaDto> _media;
@override@JsonKey() List<ItemDetailMediaDto> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

 final  List<ItemDetailSizeDto> _sizes;
@override@JsonKey() List<ItemDetailSizeDto> get sizes {
  if (_sizes is EqualUnmodifiableListView) return _sizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizes);
}


/// Create a copy of ItemDetailColorDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDetailColorDtoCopyWith<_ItemDetailColorDto> get copyWith => __$ItemDetailColorDtoCopyWithImpl<_ItemDetailColorDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDetailColorDto&&(identical(other.id, id) || other.id == id)&&(identical(other.colorType, colorType) || other.colorType == colorType)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.patternImageUrl, patternImageUrl) || other.patternImageUrl == patternImageUrl)&&(identical(other.color1, color1) || other.color1 == color1)&&(identical(other.color2, color2) || other.color2 == color2)&&(identical(other.color3, color3) || other.color3 == color3)&&const DeepCollectionEquality().equals(other._media, _media)&&const DeepCollectionEquality().equals(other._sizes, _sizes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,colorType,sortOrder,patternImageUrl,color1,color2,color3,const DeepCollectionEquality().hash(_media),const DeepCollectionEquality().hash(_sizes));

@override
String toString() {
  return 'ItemDetailColorDto(id: $id, colorType: $colorType, sortOrder: $sortOrder, patternImageUrl: $patternImageUrl, color1: $color1, color2: $color2, color3: $color3, media: $media, sizes: $sizes)';
}


}

/// @nodoc
abstract mixin class _$ItemDetailColorDtoCopyWith<$Res> implements $ItemDetailColorDtoCopyWith<$Res> {
  factory _$ItemDetailColorDtoCopyWith(_ItemDetailColorDto value, $Res Function(_ItemDetailColorDto) _then) = __$ItemDetailColorDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String colorType, int sortOrder, String? patternImageUrl, ItemDetailColorValueDto color1, ItemDetailColorValueDto? color2, ItemDetailColorValueDto? color3, List<ItemDetailMediaDto> media, List<ItemDetailSizeDto> sizes
});


@override $ItemDetailColorValueDtoCopyWith<$Res> get color1;@override $ItemDetailColorValueDtoCopyWith<$Res>? get color2;@override $ItemDetailColorValueDtoCopyWith<$Res>? get color3;

}
/// @nodoc
class __$ItemDetailColorDtoCopyWithImpl<$Res>
    implements _$ItemDetailColorDtoCopyWith<$Res> {
  __$ItemDetailColorDtoCopyWithImpl(this._self, this._then);

  final _ItemDetailColorDto _self;
  final $Res Function(_ItemDetailColorDto) _then;

/// Create a copy of ItemDetailColorDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? colorType = null,Object? sortOrder = null,Object? patternImageUrl = freezed,Object? color1 = null,Object? color2 = freezed,Object? color3 = freezed,Object? media = null,Object? sizes = null,}) {
  return _then(_ItemDetailColorDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,colorType: null == colorType ? _self.colorType : colorType // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,patternImageUrl: freezed == patternImageUrl ? _self.patternImageUrl : patternImageUrl // ignore: cast_nullable_to_non_nullable
as String?,color1: null == color1 ? _self.color1 : color1 // ignore: cast_nullable_to_non_nullable
as ItemDetailColorValueDto,color2: freezed == color2 ? _self.color2 : color2 // ignore: cast_nullable_to_non_nullable
as ItemDetailColorValueDto?,color3: freezed == color3 ? _self.color3 : color3 // ignore: cast_nullable_to_non_nullable
as ItemDetailColorValueDto?,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<ItemDetailMediaDto>,sizes: null == sizes ? _self._sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<ItemDetailSizeDto>,
  ));
}

/// Create a copy of ItemDetailColorDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemDetailColorValueDtoCopyWith<$Res> get color1 {
  
  return $ItemDetailColorValueDtoCopyWith<$Res>(_self.color1, (value) {
    return _then(_self.copyWith(color1: value));
  });
}/// Create a copy of ItemDetailColorDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemDetailColorValueDtoCopyWith<$Res>? get color2 {
    if (_self.color2 == null) {
    return null;
  }

  return $ItemDetailColorValueDtoCopyWith<$Res>(_self.color2!, (value) {
    return _then(_self.copyWith(color2: value));
  });
}/// Create a copy of ItemDetailColorDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemDetailColorValueDtoCopyWith<$Res>? get color3 {
    if (_self.color3 == null) {
    return null;
  }

  return $ItemDetailColorValueDtoCopyWith<$Res>(_self.color3!, (value) {
    return _then(_self.copyWith(color3: value));
  });
}
}


/// @nodoc
mixin _$ItemDetailColorValueDto {

 int get id; String get name; String get hexCode;
/// Create a copy of ItemDetailColorValueDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDetailColorValueDtoCopyWith<ItemDetailColorValueDto> get copyWith => _$ItemDetailColorValueDtoCopyWithImpl<ItemDetailColorValueDto>(this as ItemDetailColorValueDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDetailColorValueDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hexCode, hexCode) || other.hexCode == hexCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hexCode);

@override
String toString() {
  return 'ItemDetailColorValueDto(id: $id, name: $name, hexCode: $hexCode)';
}


}

/// @nodoc
abstract mixin class $ItemDetailColorValueDtoCopyWith<$Res>  {
  factory $ItemDetailColorValueDtoCopyWith(ItemDetailColorValueDto value, $Res Function(ItemDetailColorValueDto) _then) = _$ItemDetailColorValueDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String hexCode
});




}
/// @nodoc
class _$ItemDetailColorValueDtoCopyWithImpl<$Res>
    implements $ItemDetailColorValueDtoCopyWith<$Res> {
  _$ItemDetailColorValueDtoCopyWithImpl(this._self, this._then);

  final ItemDetailColorValueDto _self;
  final $Res Function(ItemDetailColorValueDto) _then;

/// Create a copy of ItemDetailColorValueDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? hexCode = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hexCode: null == hexCode ? _self.hexCode : hexCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDetailColorValueDto].
extension ItemDetailColorValueDtoPatterns on ItemDetailColorValueDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDetailColorValueDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDetailColorValueDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDetailColorValueDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDetailColorValueDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDetailColorValueDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDetailColorValueDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String hexCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDetailColorValueDto() when $default != null:
return $default(_that.id,_that.name,_that.hexCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String hexCode)  $default,) {final _that = this;
switch (_that) {
case _ItemDetailColorValueDto():
return $default(_that.id,_that.name,_that.hexCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String hexCode)?  $default,) {final _that = this;
switch (_that) {
case _ItemDetailColorValueDto() when $default != null:
return $default(_that.id,_that.name,_that.hexCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemDetailColorValueDto implements ItemDetailColorValueDto {
  const _ItemDetailColorValueDto({required this.id, required this.name, required this.hexCode});
  factory _ItemDetailColorValueDto.fromJson(Map<String, dynamic> json) => _$ItemDetailColorValueDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String hexCode;

/// Create a copy of ItemDetailColorValueDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDetailColorValueDtoCopyWith<_ItemDetailColorValueDto> get copyWith => __$ItemDetailColorValueDtoCopyWithImpl<_ItemDetailColorValueDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDetailColorValueDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hexCode, hexCode) || other.hexCode == hexCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hexCode);

@override
String toString() {
  return 'ItemDetailColorValueDto(id: $id, name: $name, hexCode: $hexCode)';
}


}

/// @nodoc
abstract mixin class _$ItemDetailColorValueDtoCopyWith<$Res> implements $ItemDetailColorValueDtoCopyWith<$Res> {
  factory _$ItemDetailColorValueDtoCopyWith(_ItemDetailColorValueDto value, $Res Function(_ItemDetailColorValueDto) _then) = __$ItemDetailColorValueDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String hexCode
});




}
/// @nodoc
class __$ItemDetailColorValueDtoCopyWithImpl<$Res>
    implements _$ItemDetailColorValueDtoCopyWith<$Res> {
  __$ItemDetailColorValueDtoCopyWithImpl(this._self, this._then);

  final _ItemDetailColorValueDto _self;
  final $Res Function(_ItemDetailColorValueDto) _then;

/// Create a copy of ItemDetailColorValueDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? hexCode = null,}) {
  return _then(_ItemDetailColorValueDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hexCode: null == hexCode ? _self.hexCode : hexCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ItemDetailMediaDto {

 int get id; String get url; String get mediaType; int get sortOrder; bool get isMain;
/// Create a copy of ItemDetailMediaDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDetailMediaDtoCopyWith<ItemDetailMediaDto> get copyWith => _$ItemDetailMediaDtoCopyWithImpl<ItemDetailMediaDto>(this as ItemDetailMediaDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDetailMediaDto&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isMain, isMain) || other.isMain == isMain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,mediaType,sortOrder,isMain);

@override
String toString() {
  return 'ItemDetailMediaDto(id: $id, url: $url, mediaType: $mediaType, sortOrder: $sortOrder, isMain: $isMain)';
}


}

/// @nodoc
abstract mixin class $ItemDetailMediaDtoCopyWith<$Res>  {
  factory $ItemDetailMediaDtoCopyWith(ItemDetailMediaDto value, $Res Function(ItemDetailMediaDto) _then) = _$ItemDetailMediaDtoCopyWithImpl;
@useResult
$Res call({
 int id, String url, String mediaType, int sortOrder, bool isMain
});




}
/// @nodoc
class _$ItemDetailMediaDtoCopyWithImpl<$Res>
    implements $ItemDetailMediaDtoCopyWith<$Res> {
  _$ItemDetailMediaDtoCopyWithImpl(this._self, this._then);

  final ItemDetailMediaDto _self;
  final $Res Function(ItemDetailMediaDto) _then;

/// Create a copy of ItemDetailMediaDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? mediaType = null,Object? sortOrder = null,Object? isMain = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDetailMediaDto].
extension ItemDetailMediaDtoPatterns on ItemDetailMediaDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDetailMediaDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDetailMediaDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDetailMediaDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDetailMediaDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDetailMediaDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDetailMediaDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String url,  String mediaType,  int sortOrder,  bool isMain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDetailMediaDto() when $default != null:
return $default(_that.id,_that.url,_that.mediaType,_that.sortOrder,_that.isMain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String url,  String mediaType,  int sortOrder,  bool isMain)  $default,) {final _that = this;
switch (_that) {
case _ItemDetailMediaDto():
return $default(_that.id,_that.url,_that.mediaType,_that.sortOrder,_that.isMain);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String url,  String mediaType,  int sortOrder,  bool isMain)?  $default,) {final _that = this;
switch (_that) {
case _ItemDetailMediaDto() when $default != null:
return $default(_that.id,_that.url,_that.mediaType,_that.sortOrder,_that.isMain);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemDetailMediaDto implements ItemDetailMediaDto {
  const _ItemDetailMediaDto({required this.id, required this.url, required this.mediaType, required this.sortOrder, required this.isMain});
  factory _ItemDetailMediaDto.fromJson(Map<String, dynamic> json) => _$ItemDetailMediaDtoFromJson(json);

@override final  int id;
@override final  String url;
@override final  String mediaType;
@override final  int sortOrder;
@override final  bool isMain;

/// Create a copy of ItemDetailMediaDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDetailMediaDtoCopyWith<_ItemDetailMediaDto> get copyWith => __$ItemDetailMediaDtoCopyWithImpl<_ItemDetailMediaDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDetailMediaDto&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isMain, isMain) || other.isMain == isMain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,mediaType,sortOrder,isMain);

@override
String toString() {
  return 'ItemDetailMediaDto(id: $id, url: $url, mediaType: $mediaType, sortOrder: $sortOrder, isMain: $isMain)';
}


}

/// @nodoc
abstract mixin class _$ItemDetailMediaDtoCopyWith<$Res> implements $ItemDetailMediaDtoCopyWith<$Res> {
  factory _$ItemDetailMediaDtoCopyWith(_ItemDetailMediaDto value, $Res Function(_ItemDetailMediaDto) _then) = __$ItemDetailMediaDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String url, String mediaType, int sortOrder, bool isMain
});




}
/// @nodoc
class __$ItemDetailMediaDtoCopyWithImpl<$Res>
    implements _$ItemDetailMediaDtoCopyWith<$Res> {
  __$ItemDetailMediaDtoCopyWithImpl(this._self, this._then);

  final _ItemDetailMediaDto _self;
  final $Res Function(_ItemDetailMediaDto) _then;

/// Create a copy of ItemDetailMediaDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? mediaType = null,Object? sortOrder = null,Object? isMain = null,}) {
  return _then(_ItemDetailMediaDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ItemDetailSizeDto {

 int get sizeValueId; String get displayValue; String get standardName; int get stock; double? get additionalPrice;
/// Create a copy of ItemDetailSizeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDetailSizeDtoCopyWith<ItemDetailSizeDto> get copyWith => _$ItemDetailSizeDtoCopyWithImpl<ItemDetailSizeDto>(this as ItemDetailSizeDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDetailSizeDto&&(identical(other.sizeValueId, sizeValueId) || other.sizeValueId == sizeValueId)&&(identical(other.displayValue, displayValue) || other.displayValue == displayValue)&&(identical(other.standardName, standardName) || other.standardName == standardName)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.additionalPrice, additionalPrice) || other.additionalPrice == additionalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sizeValueId,displayValue,standardName,stock,additionalPrice);

@override
String toString() {
  return 'ItemDetailSizeDto(sizeValueId: $sizeValueId, displayValue: $displayValue, standardName: $standardName, stock: $stock, additionalPrice: $additionalPrice)';
}


}

/// @nodoc
abstract mixin class $ItemDetailSizeDtoCopyWith<$Res>  {
  factory $ItemDetailSizeDtoCopyWith(ItemDetailSizeDto value, $Res Function(ItemDetailSizeDto) _then) = _$ItemDetailSizeDtoCopyWithImpl;
@useResult
$Res call({
 int sizeValueId, String displayValue, String standardName, int stock, double? additionalPrice
});




}
/// @nodoc
class _$ItemDetailSizeDtoCopyWithImpl<$Res>
    implements $ItemDetailSizeDtoCopyWith<$Res> {
  _$ItemDetailSizeDtoCopyWithImpl(this._self, this._then);

  final ItemDetailSizeDto _self;
  final $Res Function(ItemDetailSizeDto) _then;

/// Create a copy of ItemDetailSizeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sizeValueId = null,Object? displayValue = null,Object? standardName = null,Object? stock = null,Object? additionalPrice = freezed,}) {
  return _then(_self.copyWith(
sizeValueId: null == sizeValueId ? _self.sizeValueId : sizeValueId // ignore: cast_nullable_to_non_nullable
as int,displayValue: null == displayValue ? _self.displayValue : displayValue // ignore: cast_nullable_to_non_nullable
as String,standardName: null == standardName ? _self.standardName : standardName // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,additionalPrice: freezed == additionalPrice ? _self.additionalPrice : additionalPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDetailSizeDto].
extension ItemDetailSizeDtoPatterns on ItemDetailSizeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDetailSizeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDetailSizeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDetailSizeDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDetailSizeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDetailSizeDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDetailSizeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sizeValueId,  String displayValue,  String standardName,  int stock,  double? additionalPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDetailSizeDto() when $default != null:
return $default(_that.sizeValueId,_that.displayValue,_that.standardName,_that.stock,_that.additionalPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sizeValueId,  String displayValue,  String standardName,  int stock,  double? additionalPrice)  $default,) {final _that = this;
switch (_that) {
case _ItemDetailSizeDto():
return $default(_that.sizeValueId,_that.displayValue,_that.standardName,_that.stock,_that.additionalPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sizeValueId,  String displayValue,  String standardName,  int stock,  double? additionalPrice)?  $default,) {final _that = this;
switch (_that) {
case _ItemDetailSizeDto() when $default != null:
return $default(_that.sizeValueId,_that.displayValue,_that.standardName,_that.stock,_that.additionalPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemDetailSizeDto implements ItemDetailSizeDto {
  const _ItemDetailSizeDto({required this.sizeValueId, required this.displayValue, required this.standardName, required this.stock, this.additionalPrice});
  factory _ItemDetailSizeDto.fromJson(Map<String, dynamic> json) => _$ItemDetailSizeDtoFromJson(json);

@override final  int sizeValueId;
@override final  String displayValue;
@override final  String standardName;
@override final  int stock;
@override final  double? additionalPrice;

/// Create a copy of ItemDetailSizeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDetailSizeDtoCopyWith<_ItemDetailSizeDto> get copyWith => __$ItemDetailSizeDtoCopyWithImpl<_ItemDetailSizeDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDetailSizeDto&&(identical(other.sizeValueId, sizeValueId) || other.sizeValueId == sizeValueId)&&(identical(other.displayValue, displayValue) || other.displayValue == displayValue)&&(identical(other.standardName, standardName) || other.standardName == standardName)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.additionalPrice, additionalPrice) || other.additionalPrice == additionalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sizeValueId,displayValue,standardName,stock,additionalPrice);

@override
String toString() {
  return 'ItemDetailSizeDto(sizeValueId: $sizeValueId, displayValue: $displayValue, standardName: $standardName, stock: $stock, additionalPrice: $additionalPrice)';
}


}

/// @nodoc
abstract mixin class _$ItemDetailSizeDtoCopyWith<$Res> implements $ItemDetailSizeDtoCopyWith<$Res> {
  factory _$ItemDetailSizeDtoCopyWith(_ItemDetailSizeDto value, $Res Function(_ItemDetailSizeDto) _then) = __$ItemDetailSizeDtoCopyWithImpl;
@override @useResult
$Res call({
 int sizeValueId, String displayValue, String standardName, int stock, double? additionalPrice
});




}
/// @nodoc
class __$ItemDetailSizeDtoCopyWithImpl<$Res>
    implements _$ItemDetailSizeDtoCopyWith<$Res> {
  __$ItemDetailSizeDtoCopyWithImpl(this._self, this._then);

  final _ItemDetailSizeDto _self;
  final $Res Function(_ItemDetailSizeDto) _then;

/// Create a copy of ItemDetailSizeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sizeValueId = null,Object? displayValue = null,Object? standardName = null,Object? stock = null,Object? additionalPrice = freezed,}) {
  return _then(_ItemDetailSizeDto(
sizeValueId: null == sizeValueId ? _self.sizeValueId : sizeValueId // ignore: cast_nullable_to_non_nullable
as int,displayValue: null == displayValue ? _self.displayValue : displayValue // ignore: cast_nullable_to_non_nullable
as String,standardName: null == standardName ? _self.standardName : standardName // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,additionalPrice: freezed == additionalPrice ? _self.additionalPrice : additionalPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$ItemDetailSizeMeasurementGroupDto {

 int get sizeValueId; String get displayValue; List<ItemDetailMeasurementDto> get measurements;
/// Create a copy of ItemDetailSizeMeasurementGroupDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDetailSizeMeasurementGroupDtoCopyWith<ItemDetailSizeMeasurementGroupDto> get copyWith => _$ItemDetailSizeMeasurementGroupDtoCopyWithImpl<ItemDetailSizeMeasurementGroupDto>(this as ItemDetailSizeMeasurementGroupDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDetailSizeMeasurementGroupDto&&(identical(other.sizeValueId, sizeValueId) || other.sizeValueId == sizeValueId)&&(identical(other.displayValue, displayValue) || other.displayValue == displayValue)&&const DeepCollectionEquality().equals(other.measurements, measurements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sizeValueId,displayValue,const DeepCollectionEquality().hash(measurements));

@override
String toString() {
  return 'ItemDetailSizeMeasurementGroupDto(sizeValueId: $sizeValueId, displayValue: $displayValue, measurements: $measurements)';
}


}

/// @nodoc
abstract mixin class $ItemDetailSizeMeasurementGroupDtoCopyWith<$Res>  {
  factory $ItemDetailSizeMeasurementGroupDtoCopyWith(ItemDetailSizeMeasurementGroupDto value, $Res Function(ItemDetailSizeMeasurementGroupDto) _then) = _$ItemDetailSizeMeasurementGroupDtoCopyWithImpl;
@useResult
$Res call({
 int sizeValueId, String displayValue, List<ItemDetailMeasurementDto> measurements
});




}
/// @nodoc
class _$ItemDetailSizeMeasurementGroupDtoCopyWithImpl<$Res>
    implements $ItemDetailSizeMeasurementGroupDtoCopyWith<$Res> {
  _$ItemDetailSizeMeasurementGroupDtoCopyWithImpl(this._self, this._then);

  final ItemDetailSizeMeasurementGroupDto _self;
  final $Res Function(ItemDetailSizeMeasurementGroupDto) _then;

/// Create a copy of ItemDetailSizeMeasurementGroupDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sizeValueId = null,Object? displayValue = null,Object? measurements = null,}) {
  return _then(_self.copyWith(
sizeValueId: null == sizeValueId ? _self.sizeValueId : sizeValueId // ignore: cast_nullable_to_non_nullable
as int,displayValue: null == displayValue ? _self.displayValue : displayValue // ignore: cast_nullable_to_non_nullable
as String,measurements: null == measurements ? _self.measurements : measurements // ignore: cast_nullable_to_non_nullable
as List<ItemDetailMeasurementDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDetailSizeMeasurementGroupDto].
extension ItemDetailSizeMeasurementGroupDtoPatterns on ItemDetailSizeMeasurementGroupDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDetailSizeMeasurementGroupDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDetailSizeMeasurementGroupDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDetailSizeMeasurementGroupDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDetailSizeMeasurementGroupDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDetailSizeMeasurementGroupDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDetailSizeMeasurementGroupDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sizeValueId,  String displayValue,  List<ItemDetailMeasurementDto> measurements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDetailSizeMeasurementGroupDto() when $default != null:
return $default(_that.sizeValueId,_that.displayValue,_that.measurements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sizeValueId,  String displayValue,  List<ItemDetailMeasurementDto> measurements)  $default,) {final _that = this;
switch (_that) {
case _ItemDetailSizeMeasurementGroupDto():
return $default(_that.sizeValueId,_that.displayValue,_that.measurements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sizeValueId,  String displayValue,  List<ItemDetailMeasurementDto> measurements)?  $default,) {final _that = this;
switch (_that) {
case _ItemDetailSizeMeasurementGroupDto() when $default != null:
return $default(_that.sizeValueId,_that.displayValue,_that.measurements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemDetailSizeMeasurementGroupDto implements ItemDetailSizeMeasurementGroupDto {
  const _ItemDetailSizeMeasurementGroupDto({required this.sizeValueId, required this.displayValue, final  List<ItemDetailMeasurementDto> measurements = const []}): _measurements = measurements;
  factory _ItemDetailSizeMeasurementGroupDto.fromJson(Map<String, dynamic> json) => _$ItemDetailSizeMeasurementGroupDtoFromJson(json);

@override final  int sizeValueId;
@override final  String displayValue;
 final  List<ItemDetailMeasurementDto> _measurements;
@override@JsonKey() List<ItemDetailMeasurementDto> get measurements {
  if (_measurements is EqualUnmodifiableListView) return _measurements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_measurements);
}


/// Create a copy of ItemDetailSizeMeasurementGroupDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDetailSizeMeasurementGroupDtoCopyWith<_ItemDetailSizeMeasurementGroupDto> get copyWith => __$ItemDetailSizeMeasurementGroupDtoCopyWithImpl<_ItemDetailSizeMeasurementGroupDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDetailSizeMeasurementGroupDto&&(identical(other.sizeValueId, sizeValueId) || other.sizeValueId == sizeValueId)&&(identical(other.displayValue, displayValue) || other.displayValue == displayValue)&&const DeepCollectionEquality().equals(other._measurements, _measurements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sizeValueId,displayValue,const DeepCollectionEquality().hash(_measurements));

@override
String toString() {
  return 'ItemDetailSizeMeasurementGroupDto(sizeValueId: $sizeValueId, displayValue: $displayValue, measurements: $measurements)';
}


}

/// @nodoc
abstract mixin class _$ItemDetailSizeMeasurementGroupDtoCopyWith<$Res> implements $ItemDetailSizeMeasurementGroupDtoCopyWith<$Res> {
  factory _$ItemDetailSizeMeasurementGroupDtoCopyWith(_ItemDetailSizeMeasurementGroupDto value, $Res Function(_ItemDetailSizeMeasurementGroupDto) _then) = __$ItemDetailSizeMeasurementGroupDtoCopyWithImpl;
@override @useResult
$Res call({
 int sizeValueId, String displayValue, List<ItemDetailMeasurementDto> measurements
});




}
/// @nodoc
class __$ItemDetailSizeMeasurementGroupDtoCopyWithImpl<$Res>
    implements _$ItemDetailSizeMeasurementGroupDtoCopyWith<$Res> {
  __$ItemDetailSizeMeasurementGroupDtoCopyWithImpl(this._self, this._then);

  final _ItemDetailSizeMeasurementGroupDto _self;
  final $Res Function(_ItemDetailSizeMeasurementGroupDto) _then;

/// Create a copy of ItemDetailSizeMeasurementGroupDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sizeValueId = null,Object? displayValue = null,Object? measurements = null,}) {
  return _then(_ItemDetailSizeMeasurementGroupDto(
sizeValueId: null == sizeValueId ? _self.sizeValueId : sizeValueId // ignore: cast_nullable_to_non_nullable
as int,displayValue: null == displayValue ? _self.displayValue : displayValue // ignore: cast_nullable_to_non_nullable
as String,measurements: null == measurements ? _self._measurements : measurements // ignore: cast_nullable_to_non_nullable
as List<ItemDetailMeasurementDto>,
  ));
}


}


/// @nodoc
mixin _$ItemDetailMeasurementDto {

 String get measurementType; double get value;
/// Create a copy of ItemDetailMeasurementDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDetailMeasurementDtoCopyWith<ItemDetailMeasurementDto> get copyWith => _$ItemDetailMeasurementDtoCopyWithImpl<ItemDetailMeasurementDto>(this as ItemDetailMeasurementDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDetailMeasurementDto&&(identical(other.measurementType, measurementType) || other.measurementType == measurementType)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,measurementType,value);

@override
String toString() {
  return 'ItemDetailMeasurementDto(measurementType: $measurementType, value: $value)';
}


}

/// @nodoc
abstract mixin class $ItemDetailMeasurementDtoCopyWith<$Res>  {
  factory $ItemDetailMeasurementDtoCopyWith(ItemDetailMeasurementDto value, $Res Function(ItemDetailMeasurementDto) _then) = _$ItemDetailMeasurementDtoCopyWithImpl;
@useResult
$Res call({
 String measurementType, double value
});




}
/// @nodoc
class _$ItemDetailMeasurementDtoCopyWithImpl<$Res>
    implements $ItemDetailMeasurementDtoCopyWith<$Res> {
  _$ItemDetailMeasurementDtoCopyWithImpl(this._self, this._then);

  final ItemDetailMeasurementDto _self;
  final $Res Function(ItemDetailMeasurementDto) _then;

/// Create a copy of ItemDetailMeasurementDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? measurementType = null,Object? value = null,}) {
  return _then(_self.copyWith(
measurementType: null == measurementType ? _self.measurementType : measurementType // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDetailMeasurementDto].
extension ItemDetailMeasurementDtoPatterns on ItemDetailMeasurementDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDetailMeasurementDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDetailMeasurementDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDetailMeasurementDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDetailMeasurementDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDetailMeasurementDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDetailMeasurementDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String measurementType,  double value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDetailMeasurementDto() when $default != null:
return $default(_that.measurementType,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String measurementType,  double value)  $default,) {final _that = this;
switch (_that) {
case _ItemDetailMeasurementDto():
return $default(_that.measurementType,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String measurementType,  double value)?  $default,) {final _that = this;
switch (_that) {
case _ItemDetailMeasurementDto() when $default != null:
return $default(_that.measurementType,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemDetailMeasurementDto implements ItemDetailMeasurementDto {
  const _ItemDetailMeasurementDto({required this.measurementType, required this.value});
  factory _ItemDetailMeasurementDto.fromJson(Map<String, dynamic> json) => _$ItemDetailMeasurementDtoFromJson(json);

@override final  String measurementType;
@override final  double value;

/// Create a copy of ItemDetailMeasurementDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDetailMeasurementDtoCopyWith<_ItemDetailMeasurementDto> get copyWith => __$ItemDetailMeasurementDtoCopyWithImpl<_ItemDetailMeasurementDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDetailMeasurementDto&&(identical(other.measurementType, measurementType) || other.measurementType == measurementType)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,measurementType,value);

@override
String toString() {
  return 'ItemDetailMeasurementDto(measurementType: $measurementType, value: $value)';
}


}

/// @nodoc
abstract mixin class _$ItemDetailMeasurementDtoCopyWith<$Res> implements $ItemDetailMeasurementDtoCopyWith<$Res> {
  factory _$ItemDetailMeasurementDtoCopyWith(_ItemDetailMeasurementDto value, $Res Function(_ItemDetailMeasurementDto) _then) = __$ItemDetailMeasurementDtoCopyWithImpl;
@override @useResult
$Res call({
 String measurementType, double value
});




}
/// @nodoc
class __$ItemDetailMeasurementDtoCopyWithImpl<$Res>
    implements _$ItemDetailMeasurementDtoCopyWith<$Res> {
  __$ItemDetailMeasurementDtoCopyWithImpl(this._self, this._then);

  final _ItemDetailMeasurementDto _self;
  final $Res Function(_ItemDetailMeasurementDto) _then;

/// Create a copy of ItemDetailMeasurementDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? measurementType = null,Object? value = null,}) {
  return _then(_ItemDetailMeasurementDto(
measurementType: null == measurementType ? _self.measurementType : measurementType // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ItemDetailLabelDto {

 int get id; String get name;
/// Create a copy of ItemDetailLabelDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDetailLabelDtoCopyWith<ItemDetailLabelDto> get copyWith => _$ItemDetailLabelDtoCopyWithImpl<ItemDetailLabelDto>(this as ItemDetailLabelDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDetailLabelDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ItemDetailLabelDto(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $ItemDetailLabelDtoCopyWith<$Res>  {
  factory $ItemDetailLabelDtoCopyWith(ItemDetailLabelDto value, $Res Function(ItemDetailLabelDto) _then) = _$ItemDetailLabelDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$ItemDetailLabelDtoCopyWithImpl<$Res>
    implements $ItemDetailLabelDtoCopyWith<$Res> {
  _$ItemDetailLabelDtoCopyWithImpl(this._self, this._then);

  final ItemDetailLabelDto _self;
  final $Res Function(ItemDetailLabelDto) _then;

/// Create a copy of ItemDetailLabelDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDetailLabelDto].
extension ItemDetailLabelDtoPatterns on ItemDetailLabelDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDetailLabelDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDetailLabelDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDetailLabelDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDetailLabelDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDetailLabelDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDetailLabelDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDetailLabelDto() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _ItemDetailLabelDto():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _ItemDetailLabelDto() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemDetailLabelDto implements ItemDetailLabelDto {
  const _ItemDetailLabelDto({required this.id, required this.name});
  factory _ItemDetailLabelDto.fromJson(Map<String, dynamic> json) => _$ItemDetailLabelDtoFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of ItemDetailLabelDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDetailLabelDtoCopyWith<_ItemDetailLabelDto> get copyWith => __$ItemDetailLabelDtoCopyWithImpl<_ItemDetailLabelDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDetailLabelDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ItemDetailLabelDto(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ItemDetailLabelDtoCopyWith<$Res> implements $ItemDetailLabelDtoCopyWith<$Res> {
  factory _$ItemDetailLabelDtoCopyWith(_ItemDetailLabelDto value, $Res Function(_ItemDetailLabelDto) _then) = __$ItemDetailLabelDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$ItemDetailLabelDtoCopyWithImpl<$Res>
    implements _$ItemDetailLabelDtoCopyWith<$Res> {
  __$ItemDetailLabelDtoCopyWithImpl(this._self, this._then);

  final _ItemDetailLabelDto _self;
  final $Res Function(_ItemDetailLabelDto) _then;

/// Create a copy of ItemDetailLabelDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_ItemDetailLabelDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ItemDetailAttributeDto {

 String get attributeName; String get value;
/// Create a copy of ItemDetailAttributeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDetailAttributeDtoCopyWith<ItemDetailAttributeDto> get copyWith => _$ItemDetailAttributeDtoCopyWithImpl<ItemDetailAttributeDto>(this as ItemDetailAttributeDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDetailAttributeDto&&(identical(other.attributeName, attributeName) || other.attributeName == attributeName)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attributeName,value);

@override
String toString() {
  return 'ItemDetailAttributeDto(attributeName: $attributeName, value: $value)';
}


}

/// @nodoc
abstract mixin class $ItemDetailAttributeDtoCopyWith<$Res>  {
  factory $ItemDetailAttributeDtoCopyWith(ItemDetailAttributeDto value, $Res Function(ItemDetailAttributeDto) _then) = _$ItemDetailAttributeDtoCopyWithImpl;
@useResult
$Res call({
 String attributeName, String value
});




}
/// @nodoc
class _$ItemDetailAttributeDtoCopyWithImpl<$Res>
    implements $ItemDetailAttributeDtoCopyWith<$Res> {
  _$ItemDetailAttributeDtoCopyWithImpl(this._self, this._then);

  final ItemDetailAttributeDto _self;
  final $Res Function(ItemDetailAttributeDto) _then;

/// Create a copy of ItemDetailAttributeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attributeName = null,Object? value = null,}) {
  return _then(_self.copyWith(
attributeName: null == attributeName ? _self.attributeName : attributeName // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDetailAttributeDto].
extension ItemDetailAttributeDtoPatterns on ItemDetailAttributeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDetailAttributeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDetailAttributeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDetailAttributeDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDetailAttributeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDetailAttributeDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDetailAttributeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String attributeName,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDetailAttributeDto() when $default != null:
return $default(_that.attributeName,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String attributeName,  String value)  $default,) {final _that = this;
switch (_that) {
case _ItemDetailAttributeDto():
return $default(_that.attributeName,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String attributeName,  String value)?  $default,) {final _that = this;
switch (_that) {
case _ItemDetailAttributeDto() when $default != null:
return $default(_that.attributeName,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ItemDetailAttributeDto implements ItemDetailAttributeDto {
  const _ItemDetailAttributeDto({required this.attributeName, required this.value});
  factory _ItemDetailAttributeDto.fromJson(Map<String, dynamic> json) => _$ItemDetailAttributeDtoFromJson(json);

@override final  String attributeName;
@override final  String value;

/// Create a copy of ItemDetailAttributeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDetailAttributeDtoCopyWith<_ItemDetailAttributeDto> get copyWith => __$ItemDetailAttributeDtoCopyWithImpl<_ItemDetailAttributeDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDetailAttributeDto&&(identical(other.attributeName, attributeName) || other.attributeName == attributeName)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attributeName,value);

@override
String toString() {
  return 'ItemDetailAttributeDto(attributeName: $attributeName, value: $value)';
}


}

/// @nodoc
abstract mixin class _$ItemDetailAttributeDtoCopyWith<$Res> implements $ItemDetailAttributeDtoCopyWith<$Res> {
  factory _$ItemDetailAttributeDtoCopyWith(_ItemDetailAttributeDto value, $Res Function(_ItemDetailAttributeDto) _then) = __$ItemDetailAttributeDtoCopyWithImpl;
@override @useResult
$Res call({
 String attributeName, String value
});




}
/// @nodoc
class __$ItemDetailAttributeDtoCopyWithImpl<$Res>
    implements _$ItemDetailAttributeDtoCopyWith<$Res> {
  __$ItemDetailAttributeDtoCopyWithImpl(this._self, this._then);

  final _ItemDetailAttributeDto _self;
  final $Res Function(_ItemDetailAttributeDto) _then;

/// Create a copy of ItemDetailAttributeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attributeName = null,Object? value = null,}) {
  return _then(_ItemDetailAttributeDto(
attributeName: null == attributeName ? _self.attributeName : attributeName // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
