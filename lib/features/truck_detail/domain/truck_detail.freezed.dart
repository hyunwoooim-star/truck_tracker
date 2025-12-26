// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truck_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TruckDetail _$TruckDetailFromJson(Map<String, dynamic> json) {
  return _TruckDetail.fromJson(json);
}

/// @nodoc
mixin _$TruckDetail {
  String get truckId => throw _privateConstructorUsedError;
  String get operatingHours => throw _privateConstructorUsedError;
  List<MenuItem> get menuItems => throw _privateConstructorUsedError;
  List<Review> get reviews => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this TruckDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TruckDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TruckDetailCopyWith<TruckDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TruckDetailCopyWith<$Res> {
  factory $TruckDetailCopyWith(
    TruckDetail value,
    $Res Function(TruckDetail) then,
  ) = _$TruckDetailCopyWithImpl<$Res, TruckDetail>;
  @useResult
  $Res call({
    String truckId,
    String operatingHours,
    List<MenuItem> menuItems,
    List<Review> reviews,
    double averageRating,
    String description,
  });
}

/// @nodoc
class _$TruckDetailCopyWithImpl<$Res, $Val extends TruckDetail>
    implements $TruckDetailCopyWith<$Res> {
  _$TruckDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TruckDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? truckId = null,
    Object? operatingHours = null,
    Object? menuItems = null,
    Object? reviews = null,
    Object? averageRating = null,
    Object? description = null,
  }) {
    return _then(
      _value.copyWith(
            truckId: null == truckId
                ? _value.truckId
                : truckId // ignore: cast_nullable_to_non_nullable
                      as String,
            operatingHours: null == operatingHours
                ? _value.operatingHours
                : operatingHours // ignore: cast_nullable_to_non_nullable
                      as String,
            menuItems: null == menuItems
                ? _value.menuItems
                : menuItems // ignore: cast_nullable_to_non_nullable
                      as List<MenuItem>,
            reviews: null == reviews
                ? _value.reviews
                : reviews // ignore: cast_nullable_to_non_nullable
                      as List<Review>,
            averageRating: null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TruckDetailImplCopyWith<$Res>
    implements $TruckDetailCopyWith<$Res> {
  factory _$$TruckDetailImplCopyWith(
    _$TruckDetailImpl value,
    $Res Function(_$TruckDetailImpl) then,
  ) = __$$TruckDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String truckId,
    String operatingHours,
    List<MenuItem> menuItems,
    List<Review> reviews,
    double averageRating,
    String description,
  });
}

/// @nodoc
class __$$TruckDetailImplCopyWithImpl<$Res>
    extends _$TruckDetailCopyWithImpl<$Res, _$TruckDetailImpl>
    implements _$$TruckDetailImplCopyWith<$Res> {
  __$$TruckDetailImplCopyWithImpl(
    _$TruckDetailImpl _value,
    $Res Function(_$TruckDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TruckDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? truckId = null,
    Object? operatingHours = null,
    Object? menuItems = null,
    Object? reviews = null,
    Object? averageRating = null,
    Object? description = null,
  }) {
    return _then(
      _$TruckDetailImpl(
        truckId: null == truckId
            ? _value.truckId
            : truckId // ignore: cast_nullable_to_non_nullable
                  as String,
        operatingHours: null == operatingHours
            ? _value.operatingHours
            : operatingHours // ignore: cast_nullable_to_non_nullable
                  as String,
        menuItems: null == menuItems
            ? _value._menuItems
            : menuItems // ignore: cast_nullable_to_non_nullable
                  as List<MenuItem>,
        reviews: null == reviews
            ? _value._reviews
            : reviews // ignore: cast_nullable_to_non_nullable
                  as List<Review>,
        averageRating: null == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TruckDetailImpl extends _TruckDetail {
  const _$TruckDetailImpl({
    required this.truckId,
    required this.operatingHours,
    required final List<MenuItem> menuItems,
    required final List<Review> reviews,
    this.averageRating = 4.5,
    this.description = '',
  }) : _menuItems = menuItems,
       _reviews = reviews,
       super._();

  factory _$TruckDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$TruckDetailImplFromJson(json);

  @override
  final String truckId;
  @override
  final String operatingHours;
  final List<MenuItem> _menuItems;
  @override
  List<MenuItem> get menuItems {
    if (_menuItems is EqualUnmodifiableListView) return _menuItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_menuItems);
  }

  final List<Review> _reviews;
  @override
  List<Review> get reviews {
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviews);
  }

  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final String description;

  @override
  String toString() {
    return 'TruckDetail(truckId: $truckId, operatingHours: $operatingHours, menuItems: $menuItems, reviews: $reviews, averageRating: $averageRating, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TruckDetailImpl &&
            (identical(other.truckId, truckId) || other.truckId == truckId) &&
            (identical(other.operatingHours, operatingHours) ||
                other.operatingHours == operatingHours) &&
            const DeepCollectionEquality().equals(
              other._menuItems,
              _menuItems,
            ) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    truckId,
    operatingHours,
    const DeepCollectionEquality().hash(_menuItems),
    const DeepCollectionEquality().hash(_reviews),
    averageRating,
    description,
  );

  /// Create a copy of TruckDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TruckDetailImplCopyWith<_$TruckDetailImpl> get copyWith =>
      __$$TruckDetailImplCopyWithImpl<_$TruckDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TruckDetailImplToJson(this);
  }
}

abstract class _TruckDetail extends TruckDetail {
  const factory _TruckDetail({
    required final String truckId,
    required final String operatingHours,
    required final List<MenuItem> menuItems,
    required final List<Review> reviews,
    final double averageRating,
    final String description,
  }) = _$TruckDetailImpl;
  const _TruckDetail._() : super._();

  factory _TruckDetail.fromJson(Map<String, dynamic> json) =
      _$TruckDetailImpl.fromJson;

  @override
  String get truckId;
  @override
  String get operatingHours;
  @override
  List<MenuItem> get menuItems;
  @override
  List<Review> get reviews;
  @override
  double get averageRating;
  @override
  String get description;

  /// Create a copy of TruckDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TruckDetailImplCopyWith<_$TruckDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
