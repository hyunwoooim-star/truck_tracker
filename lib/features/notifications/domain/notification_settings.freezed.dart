// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSettings {

 String get userId; bool get truckOpenings;// 트럭 영업 시작
 bool get orderUpdates;// 주문 상태 변경
 bool get newCoupons;// 새 쿠폰 발행
 bool get reviews;// 리뷰 답글
 bool get promotions;// 프로모션
 bool get nearbyTrucks;// 근처 트럭 (위치 기반)
 int get nearbyRadius;// 반경 (미터), 기본 1km
 bool get followedTrucks;// 팔로우한 트럭 활동
 bool get chatMessages;// 채팅 메시지
 DateTime? get lastUpdated;
/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSettingsCopyWith<NotificationSettings> get copyWith => _$NotificationSettingsCopyWithImpl<NotificationSettings>(this as NotificationSettings, _$identity);

  /// Serializes this NotificationSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSettings&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.truckOpenings, truckOpenings) || other.truckOpenings == truckOpenings)&&(identical(other.orderUpdates, orderUpdates) || other.orderUpdates == orderUpdates)&&(identical(other.newCoupons, newCoupons) || other.newCoupons == newCoupons)&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.promotions, promotions) || other.promotions == promotions)&&(identical(other.nearbyTrucks, nearbyTrucks) || other.nearbyTrucks == nearbyTrucks)&&(identical(other.nearbyRadius, nearbyRadius) || other.nearbyRadius == nearbyRadius)&&(identical(other.followedTrucks, followedTrucks) || other.followedTrucks == followedTrucks)&&(identical(other.chatMessages, chatMessages) || other.chatMessages == chatMessages)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,truckOpenings,orderUpdates,newCoupons,reviews,promotions,nearbyTrucks,nearbyRadius,followedTrucks,chatMessages,lastUpdated);

@override
String toString() {
  return 'NotificationSettings(userId: $userId, truckOpenings: $truckOpenings, orderUpdates: $orderUpdates, newCoupons: $newCoupons, reviews: $reviews, promotions: $promotions, nearbyTrucks: $nearbyTrucks, nearbyRadius: $nearbyRadius, followedTrucks: $followedTrucks, chatMessages: $chatMessages, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $NotificationSettingsCopyWith<$Res>  {
  factory $NotificationSettingsCopyWith(NotificationSettings value, $Res Function(NotificationSettings) _then) = _$NotificationSettingsCopyWithImpl;
@useResult
$Res call({
 String userId, bool truckOpenings, bool orderUpdates, bool newCoupons, bool reviews, bool promotions, bool nearbyTrucks, int nearbyRadius, bool followedTrucks, bool chatMessages, DateTime? lastUpdated
});




}
/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._self, this._then);

  final NotificationSettings _self;
  final $Res Function(NotificationSettings) _then;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? truckOpenings = null,Object? orderUpdates = null,Object? newCoupons = null,Object? reviews = null,Object? promotions = null,Object? nearbyTrucks = null,Object? nearbyRadius = null,Object? followedTrucks = null,Object? chatMessages = null,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,truckOpenings: null == truckOpenings ? _self.truckOpenings : truckOpenings // ignore: cast_nullable_to_non_nullable
as bool,orderUpdates: null == orderUpdates ? _self.orderUpdates : orderUpdates // ignore: cast_nullable_to_non_nullable
as bool,newCoupons: null == newCoupons ? _self.newCoupons : newCoupons // ignore: cast_nullable_to_non_nullable
as bool,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as bool,promotions: null == promotions ? _self.promotions : promotions // ignore: cast_nullable_to_non_nullable
as bool,nearbyTrucks: null == nearbyTrucks ? _self.nearbyTrucks : nearbyTrucks // ignore: cast_nullable_to_non_nullable
as bool,nearbyRadius: null == nearbyRadius ? _self.nearbyRadius : nearbyRadius // ignore: cast_nullable_to_non_nullable
as int,followedTrucks: null == followedTrucks ? _self.followedTrucks : followedTrucks // ignore: cast_nullable_to_non_nullable
as bool,chatMessages: null == chatMessages ? _self.chatMessages : chatMessages // ignore: cast_nullable_to_non_nullable
as bool,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationSettings].
extension NotificationSettingsPatterns on NotificationSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSettings value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSettings value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool truckOpenings,  bool orderUpdates,  bool newCoupons,  bool reviews,  bool promotions,  bool nearbyTrucks,  int nearbyRadius,  bool followedTrucks,  bool chatMessages,  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
return $default(_that.userId,_that.truckOpenings,_that.orderUpdates,_that.newCoupons,_that.reviews,_that.promotions,_that.nearbyTrucks,_that.nearbyRadius,_that.followedTrucks,_that.chatMessages,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool truckOpenings,  bool orderUpdates,  bool newCoupons,  bool reviews,  bool promotions,  bool nearbyTrucks,  int nearbyRadius,  bool followedTrucks,  bool chatMessages,  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _NotificationSettings():
return $default(_that.userId,_that.truckOpenings,_that.orderUpdates,_that.newCoupons,_that.reviews,_that.promotions,_that.nearbyTrucks,_that.nearbyRadius,_that.followedTrucks,_that.chatMessages,_that.lastUpdated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool truckOpenings,  bool orderUpdates,  bool newCoupons,  bool reviews,  bool promotions,  bool nearbyTrucks,  int nearbyRadius,  bool followedTrucks,  bool chatMessages,  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSettings() when $default != null:
return $default(_that.userId,_that.truckOpenings,_that.orderUpdates,_that.newCoupons,_that.reviews,_that.promotions,_that.nearbyTrucks,_that.nearbyRadius,_that.followedTrucks,_that.chatMessages,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationSettings extends NotificationSettings {
  const _NotificationSettings({required this.userId, this.truckOpenings = true, this.orderUpdates = true, this.newCoupons = true, this.reviews = true, this.promotions = true, this.nearbyTrucks = false, this.nearbyRadius = 1000, this.followedTrucks = true, this.chatMessages = true, this.lastUpdated}): super._();
  factory _NotificationSettings.fromJson(Map<String, dynamic> json) => _$NotificationSettingsFromJson(json);

@override final  String userId;
@override@JsonKey() final  bool truckOpenings;
// 트럭 영업 시작
@override@JsonKey() final  bool orderUpdates;
// 주문 상태 변경
@override@JsonKey() final  bool newCoupons;
// 새 쿠폰 발행
@override@JsonKey() final  bool reviews;
// 리뷰 답글
@override@JsonKey() final  bool promotions;
// 프로모션
@override@JsonKey() final  bool nearbyTrucks;
// 근처 트럭 (위치 기반)
@override@JsonKey() final  int nearbyRadius;
// 반경 (미터), 기본 1km
@override@JsonKey() final  bool followedTrucks;
// 팔로우한 트럭 활동
@override@JsonKey() final  bool chatMessages;
// 채팅 메시지
@override final  DateTime? lastUpdated;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSettingsCopyWith<_NotificationSettings> get copyWith => __$NotificationSettingsCopyWithImpl<_NotificationSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSettings&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.truckOpenings, truckOpenings) || other.truckOpenings == truckOpenings)&&(identical(other.orderUpdates, orderUpdates) || other.orderUpdates == orderUpdates)&&(identical(other.newCoupons, newCoupons) || other.newCoupons == newCoupons)&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.promotions, promotions) || other.promotions == promotions)&&(identical(other.nearbyTrucks, nearbyTrucks) || other.nearbyTrucks == nearbyTrucks)&&(identical(other.nearbyRadius, nearbyRadius) || other.nearbyRadius == nearbyRadius)&&(identical(other.followedTrucks, followedTrucks) || other.followedTrucks == followedTrucks)&&(identical(other.chatMessages, chatMessages) || other.chatMessages == chatMessages)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,truckOpenings,orderUpdates,newCoupons,reviews,promotions,nearbyTrucks,nearbyRadius,followedTrucks,chatMessages,lastUpdated);

@override
String toString() {
  return 'NotificationSettings(userId: $userId, truckOpenings: $truckOpenings, orderUpdates: $orderUpdates, newCoupons: $newCoupons, reviews: $reviews, promotions: $promotions, nearbyTrucks: $nearbyTrucks, nearbyRadius: $nearbyRadius, followedTrucks: $followedTrucks, chatMessages: $chatMessages, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$NotificationSettingsCopyWith<$Res> implements $NotificationSettingsCopyWith<$Res> {
  factory _$NotificationSettingsCopyWith(_NotificationSettings value, $Res Function(_NotificationSettings) _then) = __$NotificationSettingsCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool truckOpenings, bool orderUpdates, bool newCoupons, bool reviews, bool promotions, bool nearbyTrucks, int nearbyRadius, bool followedTrucks, bool chatMessages, DateTime? lastUpdated
});




}
/// @nodoc
class __$NotificationSettingsCopyWithImpl<$Res>
    implements _$NotificationSettingsCopyWith<$Res> {
  __$NotificationSettingsCopyWithImpl(this._self, this._then);

  final _NotificationSettings _self;
  final $Res Function(_NotificationSettings) _then;

/// Create a copy of NotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? truckOpenings = null,Object? orderUpdates = null,Object? newCoupons = null,Object? reviews = null,Object? promotions = null,Object? nearbyTrucks = null,Object? nearbyRadius = null,Object? followedTrucks = null,Object? chatMessages = null,Object? lastUpdated = freezed,}) {
  return _then(_NotificationSettings(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,truckOpenings: null == truckOpenings ? _self.truckOpenings : truckOpenings // ignore: cast_nullable_to_non_nullable
as bool,orderUpdates: null == orderUpdates ? _self.orderUpdates : orderUpdates // ignore: cast_nullable_to_non_nullable
as bool,newCoupons: null == newCoupons ? _self.newCoupons : newCoupons // ignore: cast_nullable_to_non_nullable
as bool,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as bool,promotions: null == promotions ? _self.promotions : promotions // ignore: cast_nullable_to_non_nullable
as bool,nearbyTrucks: null == nearbyTrucks ? _self.nearbyTrucks : nearbyTrucks // ignore: cast_nullable_to_non_nullable
as bool,nearbyRadius: null == nearbyRadius ? _self.nearbyRadius : nearbyRadius // ignore: cast_nullable_to_non_nullable
as int,followedTrucks: null == followedTrucks ? _self.followedTrucks : followedTrucks // ignore: cast_nullable_to_non_nullable
as bool,chatMessages: null == chatMessages ? _self.chatMessages : chatMessages // ignore: cast_nullable_to_non_nullable
as bool,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
