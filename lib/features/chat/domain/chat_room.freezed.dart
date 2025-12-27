// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) {
  return _ChatRoom.fromJson(json);
}

/// @nodoc
mixin _$ChatRoom {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get truckId => throw _privateConstructorUsedError;
  DateTime get lastMessageAt => throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get truckName => throw _privateConstructorUsedError;

  /// Serializes this ChatRoom to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatRoomCopyWith<ChatRoom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomCopyWith<$Res> {
  factory $ChatRoomCopyWith(ChatRoom value, $Res Function(ChatRoom) then) =
      _$ChatRoomCopyWithImpl<$Res, ChatRoom>;
  @useResult
  $Res call({
    String id,
    String userId,
    String truckId,
    DateTime lastMessageAt,
    String lastMessage,
    int unreadCount,
    String? userName,
    String? truckName,
  });
}

/// @nodoc
class _$ChatRoomCopyWithImpl<$Res, $Val extends ChatRoom>
    implements $ChatRoomCopyWith<$Res> {
  _$ChatRoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? truckId = null,
    Object? lastMessageAt = null,
    Object? lastMessage = null,
    Object? unreadCount = null,
    Object? userName = freezed,
    Object? truckName = freezed,
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
            lastMessageAt: null == lastMessageAt
                ? _value.lastMessageAt
                : lastMessageAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastMessage: null == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                      as String,
            unreadCount: null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                      as int,
            userName: freezed == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String?,
            truckName: freezed == truckName
                ? _value.truckName
                : truckName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatRoomImplCopyWith<$Res>
    implements $ChatRoomCopyWith<$Res> {
  factory _$$ChatRoomImplCopyWith(
    _$ChatRoomImpl value,
    $Res Function(_$ChatRoomImpl) then,
  ) = __$$ChatRoomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String truckId,
    DateTime lastMessageAt,
    String lastMessage,
    int unreadCount,
    String? userName,
    String? truckName,
  });
}

/// @nodoc
class __$$ChatRoomImplCopyWithImpl<$Res>
    extends _$ChatRoomCopyWithImpl<$Res, _$ChatRoomImpl>
    implements _$$ChatRoomImplCopyWith<$Res> {
  __$$ChatRoomImplCopyWithImpl(
    _$ChatRoomImpl _value,
    $Res Function(_$ChatRoomImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? truckId = null,
    Object? lastMessageAt = null,
    Object? lastMessage = null,
    Object? unreadCount = null,
    Object? userName = freezed,
    Object? truckName = freezed,
  }) {
    return _then(
      _$ChatRoomImpl(
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
        lastMessageAt: null == lastMessageAt
            ? _value.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastMessage: null == lastMessage
            ? _value.lastMessage
            : lastMessage // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        userName: freezed == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String?,
        truckName: freezed == truckName
            ? _value.truckName
            : truckName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatRoomImpl extends _ChatRoom {
  const _$ChatRoomImpl({
    required this.id,
    required this.userId,
    required this.truckId,
    required this.lastMessageAt,
    required this.lastMessage,
    this.unreadCount = 0,
    this.userName,
    this.truckName,
  }) : super._();

  factory _$ChatRoomImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatRoomImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String truckId;
  @override
  final DateTime lastMessageAt;
  @override
  final String lastMessage;
  @override
  @JsonKey()
  final int unreadCount;
  @override
  final String? userName;
  @override
  final String? truckName;

  @override
  String toString() {
    return 'ChatRoom(id: $id, userId: $userId, truckId: $truckId, lastMessageAt: $lastMessageAt, lastMessage: $lastMessage, unreadCount: $unreadCount, userName: $userName, truckName: $truckName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatRoomImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.truckId, truckId) || other.truckId == truckId) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.truckName, truckName) ||
                other.truckName == truckName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    truckId,
    lastMessageAt,
    lastMessage,
    unreadCount,
    userName,
    truckName,
  );

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatRoomImplCopyWith<_$ChatRoomImpl> get copyWith =>
      __$$ChatRoomImplCopyWithImpl<_$ChatRoomImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatRoomImplToJson(this);
  }
}

abstract class _ChatRoom extends ChatRoom {
  const factory _ChatRoom({
    required final String id,
    required final String userId,
    required final String truckId,
    required final DateTime lastMessageAt,
    required final String lastMessage,
    final int unreadCount,
    final String? userName,
    final String? truckName,
  }) = _$ChatRoomImpl;
  const _ChatRoom._() : super._();

  factory _ChatRoom.fromJson(Map<String, dynamic> json) =
      _$ChatRoomImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get truckId;
  @override
  DateTime get lastMessageAt;
  @override
  String get lastMessage;
  @override
  int get unreadCount;
  @override
  String? get userName;
  @override
  String? get truckName;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatRoomImplCopyWith<_$ChatRoomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
