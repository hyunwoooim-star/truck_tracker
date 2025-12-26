// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'talk_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TalkMessage _$TalkMessageFromJson(Map<String, dynamic> json) {
  return _TalkMessage.fromJson(json);
}

/// @nodoc
mixin _$TalkMessage {
  String get id => throw _privateConstructorUsedError;
  String get truckId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  bool get isOwner =>
      throw _privateConstructorUsedError; // true if message is from truck owner
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TalkMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TalkMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TalkMessageCopyWith<TalkMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TalkMessageCopyWith<$Res> {
  factory $TalkMessageCopyWith(
    TalkMessage value,
    $Res Function(TalkMessage) then,
  ) = _$TalkMessageCopyWithImpl<$Res, TalkMessage>;
  @useResult
  $Res call({
    String id,
    String truckId,
    String userId,
    String userName,
    String message,
    bool isOwner,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$TalkMessageCopyWithImpl<$Res, $Val extends TalkMessage>
    implements $TalkMessageCopyWith<$Res> {
  _$TalkMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TalkMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? truckId = null,
    Object? userId = null,
    Object? userName = null,
    Object? message = null,
    Object? isOwner = null,
    Object? createdAt = freezed,
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
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            isOwner: null == isOwner
                ? _value.isOwner
                : isOwner // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TalkMessageImplCopyWith<$Res>
    implements $TalkMessageCopyWith<$Res> {
  factory _$$TalkMessageImplCopyWith(
    _$TalkMessageImpl value,
    $Res Function(_$TalkMessageImpl) then,
  ) = __$$TalkMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String truckId,
    String userId,
    String userName,
    String message,
    bool isOwner,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$TalkMessageImplCopyWithImpl<$Res>
    extends _$TalkMessageCopyWithImpl<$Res, _$TalkMessageImpl>
    implements _$$TalkMessageImplCopyWith<$Res> {
  __$$TalkMessageImplCopyWithImpl(
    _$TalkMessageImpl _value,
    $Res Function(_$TalkMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TalkMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? truckId = null,
    Object? userId = null,
    Object? userName = null,
    Object? message = null,
    Object? isOwner = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$TalkMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        truckId: null == truckId
            ? _value.truckId
            : truckId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        isOwner: null == isOwner
            ? _value.isOwner
            : isOwner // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TalkMessageImpl implements _TalkMessage {
  const _$TalkMessageImpl({
    required this.id,
    required this.truckId,
    required this.userId,
    required this.userName,
    required this.message,
    this.isOwner = false,
    this.createdAt,
  });

  factory _$TalkMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TalkMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String truckId;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String message;
  @override
  @JsonKey()
  final bool isOwner;
  // true if message is from truck owner
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TalkMessage(id: $id, truckId: $truckId, userId: $userId, userName: $userName, message: $message, isOwner: $isOwner, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TalkMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.truckId, truckId) || other.truckId == truckId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    truckId,
    userId,
    userName,
    message,
    isOwner,
    createdAt,
  );

  /// Create a copy of TalkMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TalkMessageImplCopyWith<_$TalkMessageImpl> get copyWith =>
      __$$TalkMessageImplCopyWithImpl<_$TalkMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TalkMessageImplToJson(this);
  }
}

abstract class _TalkMessage implements TalkMessage {
  const factory _TalkMessage({
    required final String id,
    required final String truckId,
    required final String userId,
    required final String userName,
    required final String message,
    final bool isOwner,
    final DateTime? createdAt,
  }) = _$TalkMessageImpl;

  factory _TalkMessage.fromJson(Map<String, dynamic> json) =
      _$TalkMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get truckId;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get message;
  @override
  bool get isOwner; // true if message is from truck owner
  @override
  DateTime? get createdAt;

  /// Create a copy of TalkMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TalkMessageImplCopyWith<_$TalkMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
