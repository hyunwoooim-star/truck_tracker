// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Coupon _$CouponFromJson(Map<String, dynamic> json) {
  return _Coupon.fromJson(json);
}

/// @nodoc
mixin _$Coupon {
  String get id => throw _privateConstructorUsedError;
  String get truckId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  CouponType get type => throw _privateConstructorUsedError;
  int? get discountPercent =>
      throw _privateConstructorUsedError; // % 할인 (type == percentage)
  int? get discountAmount =>
      throw _privateConstructorUsedError; // 고정 금액 할인 (type == fixed)
  String? get freeItemName =>
      throw _privateConstructorUsedError; // 무료 아이템 이름 (type == freeItem)
  DateTime get validFrom => throw _privateConstructorUsedError;
  DateTime get validUntil => throw _privateConstructorUsedError;
  int get maxUses => throw _privateConstructorUsedError;
  int get currentUses => throw _privateConstructorUsedError;
  List<String> get usedBy => throw _privateConstructorUsedError; // userId 목록
  bool get isActive => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this Coupon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponCopyWith<Coupon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponCopyWith<$Res> {
  factory $CouponCopyWith(Coupon value, $Res Function(Coupon) then) =
      _$CouponCopyWithImpl<$Res, Coupon>;
  @useResult
  $Res call({
    String id,
    String truckId,
    String code,
    CouponType type,
    int? discountPercent,
    int? discountAmount,
    String? freeItemName,
    DateTime validFrom,
    DateTime validUntil,
    int maxUses,
    int currentUses,
    List<String> usedBy,
    bool isActive,
    String? description,
  });
}

/// @nodoc
class _$CouponCopyWithImpl<$Res, $Val extends Coupon>
    implements $CouponCopyWith<$Res> {
  _$CouponCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? truckId = null,
    Object? code = null,
    Object? type = null,
    Object? discountPercent = freezed,
    Object? discountAmount = freezed,
    Object? freeItemName = freezed,
    Object? validFrom = null,
    Object? validUntil = null,
    Object? maxUses = null,
    Object? currentUses = null,
    Object? usedBy = null,
    Object? isActive = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            truckId: null == truckId
                ? _value.truckId
                : truckId // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as CouponType,
            discountPercent: freezed == discountPercent
                ? _value.discountPercent
                : discountPercent // ignore: cast_nullable_to_non_nullable
                      as int?,
            discountAmount: freezed == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as int?,
            freeItemName: freezed == freeItemName
                ? _value.freeItemName
                : freeItemName // ignore: cast_nullable_to_non_nullable
                      as String?,
            validFrom: null == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            validUntil: null == validUntil
                ? _value.validUntil
                : validUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            maxUses: null == maxUses
                ? _value.maxUses
                : maxUses // ignore: cast_nullable_to_non_nullable
                      as int,
            currentUses: null == currentUses
                ? _value.currentUses
                : currentUses // ignore: cast_nullable_to_non_nullable
                      as int,
            usedBy: null == usedBy
                ? _value.usedBy
                : usedBy // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CouponImplCopyWith<$Res> implements $CouponCopyWith<$Res> {
  factory _$$CouponImplCopyWith(
    _$CouponImpl value,
    $Res Function(_$CouponImpl) then,
  ) = __$$CouponImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String truckId,
    String code,
    CouponType type,
    int? discountPercent,
    int? discountAmount,
    String? freeItemName,
    DateTime validFrom,
    DateTime validUntil,
    int maxUses,
    int currentUses,
    List<String> usedBy,
    bool isActive,
    String? description,
  });
}

/// @nodoc
class __$$CouponImplCopyWithImpl<$Res>
    extends _$CouponCopyWithImpl<$Res, _$CouponImpl>
    implements _$$CouponImplCopyWith<$Res> {
  __$$CouponImplCopyWithImpl(
    _$CouponImpl _value,
    $Res Function(_$CouponImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? truckId = null,
    Object? code = null,
    Object? type = null,
    Object? discountPercent = freezed,
    Object? discountAmount = freezed,
    Object? freeItemName = freezed,
    Object? validFrom = null,
    Object? validUntil = null,
    Object? maxUses = null,
    Object? currentUses = null,
    Object? usedBy = null,
    Object? isActive = null,
    Object? description = freezed,
  }) {
    return _then(
      _$CouponImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        truckId: null == truckId
            ? _value.truckId
            : truckId // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as CouponType,
        discountPercent: freezed == discountPercent
            ? _value.discountPercent
            : discountPercent // ignore: cast_nullable_to_non_nullable
                  as int?,
        discountAmount: freezed == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as int?,
        freeItemName: freezed == freeItemName
            ? _value.freeItemName
            : freeItemName // ignore: cast_nullable_to_non_nullable
                  as String?,
        validFrom: null == validFrom
            ? _value.validFrom
            : validFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        validUntil: null == validUntil
            ? _value.validUntil
            : validUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        maxUses: null == maxUses
            ? _value.maxUses
            : maxUses // ignore: cast_nullable_to_non_nullable
                  as int,
        currentUses: null == currentUses
            ? _value.currentUses
            : currentUses // ignore: cast_nullable_to_non_nullable
                  as int,
        usedBy: null == usedBy
            ? _value._usedBy
            : usedBy // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CouponImpl extends _Coupon {
  const _$CouponImpl({
    required this.id,
    required this.truckId,
    required this.code,
    required this.type,
    this.discountPercent,
    this.discountAmount,
    this.freeItemName,
    required this.validFrom,
    required this.validUntil,
    required this.maxUses,
    this.currentUses = 0,
    final List<String> usedBy = const [],
    this.isActive = true,
    this.description,
  }) : _usedBy = usedBy,
       super._();

  factory _$CouponImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponImplFromJson(json);

  @override
  final String id;
  @override
  final String truckId;
  @override
  final String code;
  @override
  final CouponType type;
  @override
  final int? discountPercent;
  // % 할인 (type == percentage)
  @override
  final int? discountAmount;
  // 고정 금액 할인 (type == fixed)
  @override
  final String? freeItemName;
  // 무료 아이템 이름 (type == freeItem)
  @override
  final DateTime validFrom;
  @override
  final DateTime validUntil;
  @override
  final int maxUses;
  @override
  @JsonKey()
  final int currentUses;
  final List<String> _usedBy;
  @override
  @JsonKey()
  List<String> get usedBy {
    if (_usedBy is EqualUnmodifiableListView) return _usedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_usedBy);
  }

  // userId 목록
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? description;

  @override
  String toString() {
    return 'Coupon(id: $id, truckId: $truckId, code: $code, type: $type, discountPercent: $discountPercent, discountAmount: $discountAmount, freeItemName: $freeItemName, validFrom: $validFrom, validUntil: $validUntil, maxUses: $maxUses, currentUses: $currentUses, usedBy: $usedBy, isActive: $isActive, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.truckId, truckId) || other.truckId == truckId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.freeItemName, freeItemName) ||
                other.freeItemName == freeItemName) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.maxUses, maxUses) || other.maxUses == maxUses) &&
            (identical(other.currentUses, currentUses) ||
                other.currentUses == currentUses) &&
            const DeepCollectionEquality().equals(other._usedBy, _usedBy) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    truckId,
    code,
    type,
    discountPercent,
    discountAmount,
    freeItemName,
    validFrom,
    validUntil,
    maxUses,
    currentUses,
    const DeepCollectionEquality().hash(_usedBy),
    isActive,
    description,
  );

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponImplCopyWith<_$CouponImpl> get copyWith =>
      __$$CouponImplCopyWithImpl<_$CouponImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponImplToJson(this);
  }
}

abstract class _Coupon extends Coupon {
  const factory _Coupon({
    required final String id,
    required final String truckId,
    required final String code,
    required final CouponType type,
    final int? discountPercent,
    final int? discountAmount,
    final String? freeItemName,
    required final DateTime validFrom,
    required final DateTime validUntil,
    required final int maxUses,
    final int currentUses,
    final List<String> usedBy,
    final bool isActive,
    final String? description,
  }) = _$CouponImpl;
  const _Coupon._() : super._();

  factory _Coupon.fromJson(Map<String, dynamic> json) = _$CouponImpl.fromJson;

  @override
  String get id;
  @override
  String get truckId;
  @override
  String get code;
  @override
  CouponType get type;
  @override
  int? get discountPercent; // % 할인 (type == percentage)
  @override
  int? get discountAmount; // 고정 금액 할인 (type == fixed)
  @override
  String? get freeItemName; // 무료 아이템 이름 (type == freeItem)
  @override
  DateTime get validFrom;
  @override
  DateTime get validUntil;
  @override
  int get maxUses;
  @override
  int get currentUses;
  @override
  List<String> get usedBy; // userId 목록
  @override
  bool get isActive;
  @override
  String? get description;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponImplCopyWith<_$CouponImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
