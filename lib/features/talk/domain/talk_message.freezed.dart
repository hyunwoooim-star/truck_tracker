// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'talk_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TalkMessage {

 String get id; String get truckId; String get userId; String get userName; String get message; bool get isOwner;// true if message is from truck owner
 DateTime? get createdAt;
/// Create a copy of TalkMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TalkMessageCopyWith<TalkMessage> get copyWith => _$TalkMessageCopyWithImpl<TalkMessage>(this as TalkMessage, _$identity);

  /// Serializes this TalkMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TalkMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.message, message) || other.message == message)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,truckId,userId,userName,message,isOwner,createdAt);

@override
String toString() {
  return 'TalkMessage(id: $id, truckId: $truckId, userId: $userId, userName: $userName, message: $message, isOwner: $isOwner, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TalkMessageCopyWith<$Res>  {
  factory $TalkMessageCopyWith(TalkMessage value, $Res Function(TalkMessage) _then) = _$TalkMessageCopyWithImpl;
@useResult
$Res call({
 String id, String truckId, String userId, String userName, String message, bool isOwner, DateTime? createdAt
});




}
/// @nodoc
class _$TalkMessageCopyWithImpl<$Res>
    implements $TalkMessageCopyWith<$Res> {
  _$TalkMessageCopyWithImpl(this._self, this._then);

  final TalkMessage _self;
  final $Res Function(TalkMessage) _then;

/// Create a copy of TalkMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? truckId = null,Object? userId = null,Object? userName = null,Object? message = null,Object? isOwner = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TalkMessage].
extension TalkMessagePatterns on TalkMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TalkMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TalkMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TalkMessage value)  $default,){
final _that = this;
switch (_that) {
case _TalkMessage():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TalkMessage value)?  $default,){
final _that = this;
switch (_that) {
case _TalkMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String truckId,  String userId,  String userName,  String message,  bool isOwner,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TalkMessage() when $default != null:
return $default(_that.id,_that.truckId,_that.userId,_that.userName,_that.message,_that.isOwner,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String truckId,  String userId,  String userName,  String message,  bool isOwner,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TalkMessage():
return $default(_that.id,_that.truckId,_that.userId,_that.userName,_that.message,_that.isOwner,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String truckId,  String userId,  String userName,  String message,  bool isOwner,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TalkMessage() when $default != null:
return $default(_that.id,_that.truckId,_that.userId,_that.userName,_that.message,_that.isOwner,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TalkMessage implements TalkMessage {
  const _TalkMessage({required this.id, required this.truckId, required this.userId, required this.userName, required this.message, this.isOwner = false, this.createdAt});
  factory _TalkMessage.fromJson(Map<String, dynamic> json) => _$TalkMessageFromJson(json);

@override final  String id;
@override final  String truckId;
@override final  String userId;
@override final  String userName;
@override final  String message;
@override@JsonKey() final  bool isOwner;
// true if message is from truck owner
@override final  DateTime? createdAt;

/// Create a copy of TalkMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TalkMessageCopyWith<_TalkMessage> get copyWith => __$TalkMessageCopyWithImpl<_TalkMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TalkMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TalkMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.message, message) || other.message == message)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,truckId,userId,userName,message,isOwner,createdAt);

@override
String toString() {
  return 'TalkMessage(id: $id, truckId: $truckId, userId: $userId, userName: $userName, message: $message, isOwner: $isOwner, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TalkMessageCopyWith<$Res> implements $TalkMessageCopyWith<$Res> {
  factory _$TalkMessageCopyWith(_TalkMessage value, $Res Function(_TalkMessage) _then) = __$TalkMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String truckId, String userId, String userName, String message, bool isOwner, DateTime? createdAt
});




}
/// @nodoc
class __$TalkMessageCopyWithImpl<$Res>
    implements _$TalkMessageCopyWith<$Res> {
  __$TalkMessageCopyWithImpl(this._self, this._then);

  final _TalkMessage _self;
  final $Res Function(_TalkMessage) _then;

/// Create a copy of TalkMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? truckId = null,Object? userId = null,Object? userName = null,Object? message = null,Object? isOwner = null,Object? createdAt = freezed,}) {
  return _then(_TalkMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
