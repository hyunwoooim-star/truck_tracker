// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truck_follow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TruckFollow _$TruckFollowFromJson(Map<String, dynamic> json) {
  return _TruckFollow.fromJson(json);
}

/// @nodoc
mixin _$TruckFollow {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get truckId => throw _privateConstructorUsedError;
  DateTime get followedAt => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;

  /// Serializes this TruckFollow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TruckFollow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TruckFollowCopyWith<TruckFollow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TruckFollowCopyWith<$Res> {
  factory $TruckFollowCopyWith(
    TruckFollow value,
    $Res Function(TruckFollow) then,
  ) = _$TruckFollowCopyWithImpl<$Res, TruckFollow>;
  @useResult
  $Res call({
    String id,
    String userId,
    String truckId,
    DateTime followedAt,
    bool notificationsEnabled,
  });
}

/// @nodoc
class _$TruckFollowCopyWithImpl<$Res, $Val extends TruckFollow>
    implements $TruckFollowCopyWith<$Res> {
  _$TruckFollowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TruckFollow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? truckId = null,
    Object? followedAt = null,
    Object? notificationsEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            truckId: null == truckId
                ? _value.truckId
                : truckId // ignore: cast_nullable_to_non_nullable
                      as String,
            followedAt: null == followedAt
                ? _value.followedAt
                : followedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            notificationsEnabled: null == notificationsEnabled
                ? _value.notificationsEnabled
                : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TruckFollowImplCopyWith<$Res>
    implements $TruckFollowCopyWith<$Res> {
  factory _$$TruckFollowImplCopyWith(
    _$TruckFollowImpl value,
    $Res Function(_$TruckFollowImpl) then,
  ) = __$$TruckFollowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String truckId,
    DateTime followedAt,
    bool notificationsEnabled,
  });
}

/// @nodoc
class __$$TruckFollowImplCopyWithImpl<$Res>
    extends _$TruckFollowCopyWithImpl<$Res, _$TruckFollowImpl>
    implements _$$TruckFollowImplCopyWith<$Res> {
  __$$TruckFollowImplCopyWithImpl(
    _$TruckFollowImpl _value,
    $Res Function(_$TruckFollowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TruckFollow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? truckId = null,
    Object? followedAt = null,
    Object? notificationsEnabled = null,
  }) {
    return _then(
      _$TruckFollowImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        truckId: null == truckId
            ? _value.truckId
            : truckId // ignore: cast_nullable_to_non_nullable
                  as String,
        followedAt: null == followedAt
            ? _value.followedAt
            : followedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        notificationsEnabled: null == notificationsEnabled
            ? _value.notificationsEnabled
            : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TruckFollowImpl extends _TruckFollow {
  const _$TruckFollowImpl({
    required this.id,
    required this.userId,
    required this.truckId,
    required this.followedAt,
    this.notificationsEnabled = true,
  }) : super._();

  factory _$TruckFollowImpl.fromJson(Map<String, dynamic> json) =>
      _$$TruckFollowImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String truckId;
  @override
  final DateTime followedAt;
  @override
  @JsonKey()
  final bool notificationsEnabled;

  @override
  String toString() {
    return 'TruckFollow(id: $id, userId: $userId, truckId: $truckId, followedAt: $followedAt, notificationsEnabled: $notificationsEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TruckFollowImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.truckId, truckId) || other.truckId == truckId) &&
            (identical(other.followedAt, followedAt) ||
                other.followedAt == followedAt) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    truckId,
    followedAt,
    notificationsEnabled,
  );

  /// Create a copy of TruckFollow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TruckFollowImplCopyWith<_$TruckFollowImpl> get copyWith =>
      __$$TruckFollowImplCopyWithImpl<_$TruckFollowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TruckFollowImplToJson(this);
  }
}

abstract class _TruckFollow extends TruckFollow {
  const factory _TruckFollow({
    required final String id,
    required final String userId,
    required final String truckId,
    required final DateTime followedAt,
    final bool notificationsEnabled,
  }) = _$TruckFollowImpl;
  const _TruckFollow._() : super._();

  factory _TruckFollow.fromJson(Map<String, dynamic> json) =
      _$TruckFollowImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get truckId;
  @override
  DateTime get followedAt;
  @override
  bool get notificationsEnabled;

  /// Create a copy of TruckFollow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TruckFollowImplCopyWith<_$TruckFollowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
