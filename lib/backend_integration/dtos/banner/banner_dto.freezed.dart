// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BannerDto _$BannerDtoFromJson(Map<String, dynamic> json) {
  return _BannerDto.fromJson(json);
}

/// @nodoc
mixin _$BannerDto {
  int get id => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get redirectionRoute => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;

  /// Create a copy of BannerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BannerDtoCopyWith<BannerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerDtoCopyWith<$Res> {
  factory $BannerDtoCopyWith(BannerDto value, $Res Function(BannerDto) then) =
      _$BannerDtoCopyWithImpl<$Res, BannerDto>;
  @useResult
  $Res call({
    int id,
    int type,
    String title,
    String? subtitle,
    String? description,
    String? redirectionRoute,
    List<String> imageUrls,
  });
}

/// @nodoc
class _$BannerDtoCopyWithImpl<$Res, $Val extends BannerDto>
    implements $BannerDtoCopyWith<$Res> {
  _$BannerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BannerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? description = freezed,
    Object? redirectionRoute = freezed,
    Object? imageUrls = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            subtitle: freezed == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            redirectionRoute: freezed == redirectionRoute
                ? _value.redirectionRoute
                : redirectionRoute // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrls: null == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BannerDtoImplCopyWith<$Res>
    implements $BannerDtoCopyWith<$Res> {
  factory _$$BannerDtoImplCopyWith(
    _$BannerDtoImpl value,
    $Res Function(_$BannerDtoImpl) then,
  ) = __$$BannerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int type,
    String title,
    String? subtitle,
    String? description,
    String? redirectionRoute,
    List<String> imageUrls,
  });
}

/// @nodoc
class __$$BannerDtoImplCopyWithImpl<$Res>
    extends _$BannerDtoCopyWithImpl<$Res, _$BannerDtoImpl>
    implements _$$BannerDtoImplCopyWith<$Res> {
  __$$BannerDtoImplCopyWithImpl(
    _$BannerDtoImpl _value,
    $Res Function(_$BannerDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BannerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? description = freezed,
    Object? redirectionRoute = freezed,
    Object? imageUrls = null,
  }) {
    return _then(
      _$BannerDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        subtitle: freezed == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        redirectionRoute: freezed == redirectionRoute
            ? _value.redirectionRoute
            : redirectionRoute // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrls: null == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$BannerDtoImpl implements _BannerDto {
  const _$BannerDtoImpl({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.description,
    this.redirectionRoute,
    final List<String> imageUrls = const [],
  }) : _imageUrls = imageUrls;

  factory _$BannerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BannerDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int type;
  @override
  final String title;
  @override
  final String? subtitle;
  @override
  final String? description;
  @override
  final String? redirectionRoute;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  String toString() {
    return 'BannerDto(id: $id, type: $type, title: $title, subtitle: $subtitle, description: $description, redirectionRoute: $redirectionRoute, imageUrls: $imageUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BannerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.redirectionRoute, redirectionRoute) ||
                other.redirectionRoute == redirectionRoute) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    title,
    subtitle,
    description,
    redirectionRoute,
    const DeepCollectionEquality().hash(_imageUrls),
  );

  /// Create a copy of BannerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BannerDtoImplCopyWith<_$BannerDtoImpl> get copyWith =>
      __$$BannerDtoImplCopyWithImpl<_$BannerDtoImpl>(this, _$identity);
}

abstract class _BannerDto implements BannerDto {
  const factory _BannerDto({
    required final int id,
    required final int type,
    required final String title,
    final String? subtitle,
    final String? description,
    final String? redirectionRoute,
    final List<String> imageUrls,
  }) = _$BannerDtoImpl;

  factory _BannerDto.fromJson(Map<String, dynamic> json) =
      _$BannerDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get type;
  @override
  String get title;
  @override
  String? get subtitle;
  @override
  String? get description;
  @override
  String? get redirectionRoute;
  @override
  List<String> get imageUrls;

  /// Create a copy of BannerDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BannerDtoImplCopyWith<_$BannerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
