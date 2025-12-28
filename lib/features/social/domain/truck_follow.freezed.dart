// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truck_follow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TruckFollow {

 String get id; String get userId; String get truckId; DateTime get followedAt; bool get notificationsEnabled;
/// Create a copy of TruckFollow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruckFollowCopyWith<TruckFollow> get copyWith => _$TruckFollowCopyWithImpl<TruckFollow>(this as TruckFollow, _$identity);

  /// Serializes this TruckFollow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TruckFollow&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.followedAt, followedAt) || other.followedAt == followedAt)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,truckId,followedAt,notificationsEnabled);

@override
String toString() {
  return 'TruckFollow(id: $id, userId: $userId, truckId: $truckId, followedAt: $followedAt, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class $TruckFollowCopyWith<$Res>  {
  factory $TruckFollowCopyWith(TruckFollow value, $Res Function(TruckFollow) _then) = _$TruckFollowCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String truckId, DateTime followedAt, bool notificationsEnabled
});




}
/// @nodoc
class _$TruckFollowCopyWithImpl<$Res>
    implements $TruckFollowCopyWith<$Res> {
  _$TruckFollowCopyWithImpl(this._self, this._then);

  final TruckFollow _self;
  final $Res Function(TruckFollow) _then;

/// Create a copy of TruckFollow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? truckId = null,Object? followedAt = null,Object? notificationsEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,followedAt: null == followedAt ? _self.followedAt : followedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TruckFollow].
extension TruckFollowPatterns on TruckFollow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TruckFollow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TruckFollow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TruckFollow value)  $default,){
final _that = this;
switch (_that) {
case _TruckFollow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TruckFollow value)?  $default,){
final _that = this;
switch (_that) {
case _TruckFollow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String truckId,  DateTime followedAt,  bool notificationsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TruckFollow() when $default != null:
return $default(_that.id,_that.userId,_that.truckId,_that.followedAt,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String truckId,  DateTime followedAt,  bool notificationsEnabled)  $default,) {final _that = this;
switch (_that) {
case _TruckFollow():
return $default(_that.id,_that.userId,_that.truckId,_that.followedAt,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String truckId,  DateTime followedAt,  bool notificationsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _TruckFollow() when $default != null:
return $default(_that.id,_that.userId,_that.truckId,_that.followedAt,_that.notificationsEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TruckFollow extends TruckFollow {
  const _TruckFollow({required this.id, required this.userId, required this.truckId, required this.followedAt, this.notificationsEnabled = true}): super._();
  factory _TruckFollow.fromJson(Map<String, dynamic> json) => _$TruckFollowFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String truckId;
@override final  DateTime followedAt;
@override@JsonKey() final  bool notificationsEnabled;

/// Create a copy of TruckFollow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TruckFollowCopyWith<_TruckFollow> get copyWith => __$TruckFollowCopyWithImpl<_TruckFollow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TruckFollowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TruckFollow&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.followedAt, followedAt) || other.followedAt == followedAt)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,truckId,followedAt,notificationsEnabled);

@override
String toString() {
  return 'TruckFollow(id: $id, userId: $userId, truckId: $truckId, followedAt: $followedAt, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class _$TruckFollowCopyWith<$Res> implements $TruckFollowCopyWith<$Res> {
  factory _$TruckFollowCopyWith(_TruckFollow value, $Res Function(_TruckFollow) _then) = __$TruckFollowCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String truckId, DateTime followedAt, bool notificationsEnabled
});




}
/// @nodoc
class __$TruckFollowCopyWithImpl<$Res>
    implements _$TruckFollowCopyWith<$Res> {
  __$TruckFollowCopyWithImpl(this._self, this._then);

  final _TruckFollow _self;
  final $Res Function(_TruckFollow) _then;

/// Create a copy of TruckFollow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? truckId = null,Object? followedAt = null,Object? notificationsEnabled = null,}) {
  return _then(_TruckFollow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,followedAt: null == followedAt ? _self.followedAt : followedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
