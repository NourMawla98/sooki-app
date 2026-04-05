// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get name; String get brand; String get category; String get description; List<String> get features; Map<String, String> get specifications; double get price; double? get originalPrice; int? get discountPercentage; List<String> get imageUrls; String get thumbnailUrl; double get rating; int get reviewCount; int get stockCount; bool get isNew; bool get isVerified; List<ColorVariant> get colors; List<SizeVariant> get sizes;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.features, features)&&const DeepCollectionEquality().equals(other.specifications, specifications)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.stockCount, stockCount) || other.stockCount == stockCount)&&(identical(other.isNew, isNew) || other.isNew == isNew)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other.colors, colors)&&const DeepCollectionEquality().equals(other.sizes, sizes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,brand,category,description,const DeepCollectionEquality().hash(features),const DeepCollectionEquality().hash(specifications),price,originalPrice,discountPercentage,const DeepCollectionEquality().hash(imageUrls),thumbnailUrl,rating,reviewCount,stockCount,isNew,isVerified,const DeepCollectionEquality().hash(colors),const DeepCollectionEquality().hash(sizes)]);

@override
String toString() {
  return 'Product(id: $id, name: $name, brand: $brand, category: $category, description: $description, features: $features, specifications: $specifications, price: $price, originalPrice: $originalPrice, discountPercentage: $discountPercentage, imageUrls: $imageUrls, thumbnailUrl: $thumbnailUrl, rating: $rating, reviewCount: $reviewCount, stockCount: $stockCount, isNew: $isNew, isVerified: $isVerified, colors: $colors, sizes: $sizes)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String brand, String category, String description, List<String> features, Map<String, String> specifications, double price, double? originalPrice, int? discountPercentage, List<String> imageUrls, String thumbnailUrl, double rating, int reviewCount, int stockCount, bool isNew, bool isVerified, List<ColorVariant> colors, List<SizeVariant> sizes
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? brand = null,Object? category = null,Object? description = null,Object? features = null,Object? specifications = null,Object? price = null,Object? originalPrice = freezed,Object? discountPercentage = freezed,Object? imageUrls = null,Object? thumbnailUrl = null,Object? rating = null,Object? reviewCount = null,Object? stockCount = null,Object? isNew = null,Object? isVerified = null,Object? colors = null,Object? sizes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,specifications: null == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as Map<String, String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,discountPercentage: freezed == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as int?,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,stockCount: null == stockCount ? _self.stockCount : stockCount // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,colors: null == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as List<ColorVariant>,sizes: null == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<SizeVariant>,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String brand,  String category,  String description,  List<String> features,  Map<String, String> specifications,  double price,  double? originalPrice,  int? discountPercentage,  List<String> imageUrls,  String thumbnailUrl,  double rating,  int reviewCount,  int stockCount,  bool isNew,  bool isVerified,  List<ColorVariant> colors,  List<SizeVariant> sizes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.category,_that.description,_that.features,_that.specifications,_that.price,_that.originalPrice,_that.discountPercentage,_that.imageUrls,_that.thumbnailUrl,_that.rating,_that.reviewCount,_that.stockCount,_that.isNew,_that.isVerified,_that.colors,_that.sizes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String brand,  String category,  String description,  List<String> features,  Map<String, String> specifications,  double price,  double? originalPrice,  int? discountPercentage,  List<String> imageUrls,  String thumbnailUrl,  double rating,  int reviewCount,  int stockCount,  bool isNew,  bool isVerified,  List<ColorVariant> colors,  List<SizeVariant> sizes)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.brand,_that.category,_that.description,_that.features,_that.specifications,_that.price,_that.originalPrice,_that.discountPercentage,_that.imageUrls,_that.thumbnailUrl,_that.rating,_that.reviewCount,_that.stockCount,_that.isNew,_that.isVerified,_that.colors,_that.sizes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String brand,  String category,  String description,  List<String> features,  Map<String, String> specifications,  double price,  double? originalPrice,  int? discountPercentage,  List<String> imageUrls,  String thumbnailUrl,  double rating,  int reviewCount,  int stockCount,  bool isNew,  bool isVerified,  List<ColorVariant> colors,  List<SizeVariant> sizes)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.category,_that.description,_that.features,_that.specifications,_that.price,_that.originalPrice,_that.discountPercentage,_that.imageUrls,_that.thumbnailUrl,_that.rating,_that.reviewCount,_that.stockCount,_that.isNew,_that.isVerified,_that.colors,_that.sizes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.name, required this.brand, required this.category, this.description = '', final  List<String> features = const [], final  Map<String, String> specifications = const {}, required this.price, this.originalPrice, this.discountPercentage, final  List<String> imageUrls = const [], this.thumbnailUrl = '', this.rating = 0.0, this.reviewCount = 0, this.stockCount = 0, this.isNew = false, this.isVerified = false, final  List<ColorVariant> colors = const [], final  List<SizeVariant> sizes = const []}): _features = features,_specifications = specifications,_imageUrls = imageUrls,_colors = colors,_sizes = sizes;
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String name;
@override final  String brand;
@override final  String category;
@override@JsonKey() final  String description;
 final  List<String> _features;
@override@JsonKey() List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

 final  Map<String, String> _specifications;
@override@JsonKey() Map<String, String> get specifications {
  if (_specifications is EqualUnmodifiableMapView) return _specifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_specifications);
}

@override final  double price;
@override final  double? originalPrice;
@override final  int? discountPercentage;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey() final  String thumbnailUrl;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int reviewCount;
@override@JsonKey() final  int stockCount;
@override@JsonKey() final  bool isNew;
@override@JsonKey() final  bool isVerified;
 final  List<ColorVariant> _colors;
@override@JsonKey() List<ColorVariant> get colors {
  if (_colors is EqualUnmodifiableListView) return _colors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_colors);
}

 final  List<SizeVariant> _sizes;
@override@JsonKey() List<SizeVariant> get sizes {
  if (_sizes is EqualUnmodifiableListView) return _sizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizes);
}


/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._features, _features)&&const DeepCollectionEquality().equals(other._specifications, _specifications)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.stockCount, stockCount) || other.stockCount == stockCount)&&(identical(other.isNew, isNew) || other.isNew == isNew)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other._colors, _colors)&&const DeepCollectionEquality().equals(other._sizes, _sizes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,brand,category,description,const DeepCollectionEquality().hash(_features),const DeepCollectionEquality().hash(_specifications),price,originalPrice,discountPercentage,const DeepCollectionEquality().hash(_imageUrls),thumbnailUrl,rating,reviewCount,stockCount,isNew,isVerified,const DeepCollectionEquality().hash(_colors),const DeepCollectionEquality().hash(_sizes)]);

@override
String toString() {
  return 'Product(id: $id, name: $name, brand: $brand, category: $category, description: $description, features: $features, specifications: $specifications, price: $price, originalPrice: $originalPrice, discountPercentage: $discountPercentage, imageUrls: $imageUrls, thumbnailUrl: $thumbnailUrl, rating: $rating, reviewCount: $reviewCount, stockCount: $stockCount, isNew: $isNew, isVerified: $isVerified, colors: $colors, sizes: $sizes)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String brand, String category, String description, List<String> features, Map<String, String> specifications, double price, double? originalPrice, int? discountPercentage, List<String> imageUrls, String thumbnailUrl, double rating, int reviewCount, int stockCount, bool isNew, bool isVerified, List<ColorVariant> colors, List<SizeVariant> sizes
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? brand = null,Object? category = null,Object? description = null,Object? features = null,Object? specifications = null,Object? price = null,Object? originalPrice = freezed,Object? discountPercentage = freezed,Object? imageUrls = null,Object? thumbnailUrl = null,Object? rating = null,Object? reviewCount = null,Object? stockCount = null,Object? isNew = null,Object? isVerified = null,Object? colors = null,Object? sizes = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,specifications: null == specifications ? _self._specifications : specifications // ignore: cast_nullable_to_non_nullable
as Map<String, String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,discountPercentage: freezed == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as int?,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,stockCount: null == stockCount ? _self.stockCount : stockCount // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,colors: null == colors ? _self._colors : colors // ignore: cast_nullable_to_non_nullable
as List<ColorVariant>,sizes: null == sizes ? _self._sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<SizeVariant>,
  ));
}


}


/// @nodoc
mixin _$ColorVariant {

 String get name; String get hexCode; bool get isAvailable;
/// Create a copy of ColorVariant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColorVariantCopyWith<ColorVariant> get copyWith => _$ColorVariantCopyWithImpl<ColorVariant>(this as ColorVariant, _$identity);

  /// Serializes this ColorVariant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ColorVariant&&(identical(other.name, name) || other.name == name)&&(identical(other.hexCode, hexCode) || other.hexCode == hexCode)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,hexCode,isAvailable);

@override
String toString() {
  return 'ColorVariant(name: $name, hexCode: $hexCode, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $ColorVariantCopyWith<$Res>  {
  factory $ColorVariantCopyWith(ColorVariant value, $Res Function(ColorVariant) _then) = _$ColorVariantCopyWithImpl;
@useResult
$Res call({
 String name, String hexCode, bool isAvailable
});




}
/// @nodoc
class _$ColorVariantCopyWithImpl<$Res>
    implements $ColorVariantCopyWith<$Res> {
  _$ColorVariantCopyWithImpl(this._self, this._then);

  final ColorVariant _self;
  final $Res Function(ColorVariant) _then;

/// Create a copy of ColorVariant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? hexCode = null,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hexCode: null == hexCode ? _self.hexCode : hexCode // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ColorVariant].
extension ColorVariantPatterns on ColorVariant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ColorVariant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ColorVariant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ColorVariant value)  $default,){
final _that = this;
switch (_that) {
case _ColorVariant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ColorVariant value)?  $default,){
final _that = this;
switch (_that) {
case _ColorVariant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String hexCode,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ColorVariant() when $default != null:
return $default(_that.name,_that.hexCode,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String hexCode,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _ColorVariant():
return $default(_that.name,_that.hexCode,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String hexCode,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _ColorVariant() when $default != null:
return $default(_that.name,_that.hexCode,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ColorVariant implements ColorVariant {
  const _ColorVariant({required this.name, required this.hexCode, this.isAvailable = true});
  factory _ColorVariant.fromJson(Map<String, dynamic> json) => _$ColorVariantFromJson(json);

@override final  String name;
@override final  String hexCode;
@override@JsonKey() final  bool isAvailable;

/// Create a copy of ColorVariant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColorVariantCopyWith<_ColorVariant> get copyWith => __$ColorVariantCopyWithImpl<_ColorVariant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ColorVariantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColorVariant&&(identical(other.name, name) || other.name == name)&&(identical(other.hexCode, hexCode) || other.hexCode == hexCode)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,hexCode,isAvailable);

@override
String toString() {
  return 'ColorVariant(name: $name, hexCode: $hexCode, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$ColorVariantCopyWith<$Res> implements $ColorVariantCopyWith<$Res> {
  factory _$ColorVariantCopyWith(_ColorVariant value, $Res Function(_ColorVariant) _then) = __$ColorVariantCopyWithImpl;
@override @useResult
$Res call({
 String name, String hexCode, bool isAvailable
});




}
/// @nodoc
class __$ColorVariantCopyWithImpl<$Res>
    implements _$ColorVariantCopyWith<$Res> {
  __$ColorVariantCopyWithImpl(this._self, this._then);

  final _ColorVariant _self;
  final $Res Function(_ColorVariant) _then;

/// Create a copy of ColorVariant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? hexCode = null,Object? isAvailable = null,}) {
  return _then(_ColorVariant(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hexCode: null == hexCode ? _self.hexCode : hexCode // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SizeVariant {

 String get label; bool get isAvailable;
/// Create a copy of SizeVariant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeVariantCopyWith<SizeVariant> get copyWith => _$SizeVariantCopyWithImpl<SizeVariant>(this as SizeVariant, _$identity);

  /// Serializes this SizeVariant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeVariant&&(identical(other.label, label) || other.label == label)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,isAvailable);

@override
String toString() {
  return 'SizeVariant(label: $label, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $SizeVariantCopyWith<$Res>  {
  factory $SizeVariantCopyWith(SizeVariant value, $Res Function(SizeVariant) _then) = _$SizeVariantCopyWithImpl;
@useResult
$Res call({
 String label, bool isAvailable
});




}
/// @nodoc
class _$SizeVariantCopyWithImpl<$Res>
    implements $SizeVariantCopyWith<$Res> {
  _$SizeVariantCopyWithImpl(this._self, this._then);

  final SizeVariant _self;
  final $Res Function(SizeVariant) _then;

/// Create a copy of SizeVariant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SizeVariant].
extension SizeVariantPatterns on SizeVariant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SizeVariant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SizeVariant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SizeVariant value)  $default,){
final _that = this;
switch (_that) {
case _SizeVariant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SizeVariant value)?  $default,){
final _that = this;
switch (_that) {
case _SizeVariant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SizeVariant() when $default != null:
return $default(_that.label,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _SizeVariant():
return $default(_that.label,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _SizeVariant() when $default != null:
return $default(_that.label,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SizeVariant implements SizeVariant {
  const _SizeVariant({required this.label, this.isAvailable = true});
  factory _SizeVariant.fromJson(Map<String, dynamic> json) => _$SizeVariantFromJson(json);

@override final  String label;
@override@JsonKey() final  bool isAvailable;

/// Create a copy of SizeVariant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SizeVariantCopyWith<_SizeVariant> get copyWith => __$SizeVariantCopyWithImpl<_SizeVariant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SizeVariantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SizeVariant&&(identical(other.label, label) || other.label == label)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,isAvailable);

@override
String toString() {
  return 'SizeVariant(label: $label, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$SizeVariantCopyWith<$Res> implements $SizeVariantCopyWith<$Res> {
  factory _$SizeVariantCopyWith(_SizeVariant value, $Res Function(_SizeVariant) _then) = __$SizeVariantCopyWithImpl;
@override @useResult
$Res call({
 String label, bool isAvailable
});




}
/// @nodoc
class __$SizeVariantCopyWithImpl<$Res>
    implements _$SizeVariantCopyWith<$Res> {
  __$SizeVariantCopyWithImpl(this._self, this._then);

  final _SizeVariant _self;
  final $Res Function(_SizeVariant) _then;

/// Create a copy of SizeVariant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? isAvailable = null,}) {
  return _then(_SizeVariant(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Review {

 String get userName; double get rating; String get text; String get date; bool get isVerifiedPurchase; int get helpfulCount;
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCopyWith<Review> get copyWith => _$ReviewCopyWithImpl<Review>(this as Review, _$identity);

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Review&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.date, date) || other.date == date)&&(identical(other.isVerifiedPurchase, isVerifiedPurchase) || other.isVerifiedPurchase == isVerifiedPurchase)&&(identical(other.helpfulCount, helpfulCount) || other.helpfulCount == helpfulCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,rating,text,date,isVerifiedPurchase,helpfulCount);

@override
String toString() {
  return 'Review(userName: $userName, rating: $rating, text: $text, date: $date, isVerifiedPurchase: $isVerifiedPurchase, helpfulCount: $helpfulCount)';
}


}

/// @nodoc
abstract mixin class $ReviewCopyWith<$Res>  {
  factory $ReviewCopyWith(Review value, $Res Function(Review) _then) = _$ReviewCopyWithImpl;
@useResult
$Res call({
 String userName, double rating, String text, String date, bool isVerifiedPurchase, int helpfulCount
});




}
/// @nodoc
class _$ReviewCopyWithImpl<$Res>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._self, this._then);

  final Review _self;
  final $Res Function(Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = null,Object? rating = null,Object? text = null,Object? date = null,Object? isVerifiedPurchase = null,Object? helpfulCount = null,}) {
  return _then(_self.copyWith(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isVerifiedPurchase: null == isVerifiedPurchase ? _self.isVerifiedPurchase : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
as bool,helpfulCount: null == helpfulCount ? _self.helpfulCount : helpfulCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Review].
extension ReviewPatterns on Review {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Review value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Review value)  $default,){
final _that = this;
switch (_that) {
case _Review():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Review value)?  $default,){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userName,  double rating,  String text,  String date,  bool isVerifiedPurchase,  int helpfulCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.userName,_that.rating,_that.text,_that.date,_that.isVerifiedPurchase,_that.helpfulCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userName,  double rating,  String text,  String date,  bool isVerifiedPurchase,  int helpfulCount)  $default,) {final _that = this;
switch (_that) {
case _Review():
return $default(_that.userName,_that.rating,_that.text,_that.date,_that.isVerifiedPurchase,_that.helpfulCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userName,  double rating,  String text,  String date,  bool isVerifiedPurchase,  int helpfulCount)?  $default,) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.userName,_that.rating,_that.text,_that.date,_that.isVerifiedPurchase,_that.helpfulCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Review implements Review {
  const _Review({required this.userName, required this.rating, required this.text, required this.date, this.isVerifiedPurchase = false, this.helpfulCount = 0});
  factory _Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

@override final  String userName;
@override final  double rating;
@override final  String text;
@override final  String date;
@override@JsonKey() final  bool isVerifiedPurchase;
@override@JsonKey() final  int helpfulCount;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCopyWith<_Review> get copyWith => __$ReviewCopyWithImpl<_Review>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Review&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.date, date) || other.date == date)&&(identical(other.isVerifiedPurchase, isVerifiedPurchase) || other.isVerifiedPurchase == isVerifiedPurchase)&&(identical(other.helpfulCount, helpfulCount) || other.helpfulCount == helpfulCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,rating,text,date,isVerifiedPurchase,helpfulCount);

@override
String toString() {
  return 'Review(userName: $userName, rating: $rating, text: $text, date: $date, isVerifiedPurchase: $isVerifiedPurchase, helpfulCount: $helpfulCount)';
}


}

/// @nodoc
abstract mixin class _$ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$ReviewCopyWith(_Review value, $Res Function(_Review) _then) = __$ReviewCopyWithImpl;
@override @useResult
$Res call({
 String userName, double rating, String text, String date, bool isVerifiedPurchase, int helpfulCount
});




}
/// @nodoc
class __$ReviewCopyWithImpl<$Res>
    implements _$ReviewCopyWith<$Res> {
  __$ReviewCopyWithImpl(this._self, this._then);

  final _Review _self;
  final $Res Function(_Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = null,Object? rating = null,Object? text = null,Object? date = null,Object? isVerifiedPurchase = null,Object? helpfulCount = null,}) {
  return _then(_Review(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isVerifiedPurchase: null == isVerifiedPurchase ? _self.isVerifiedPurchase : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
as bool,helpfulCount: null == helpfulCount ? _self.helpfulCount : helpfulCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
