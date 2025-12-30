// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stamp_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StampCard {

 String get id; String get visitorId; String get visitorName; String get truckId; String get truckName; int get stampCount;// 현재 스탬프 수 (0-10)
 int get completedCards;// 완료된 카드 수 (10개 채울 때마다 +1)
 List<DateTime> get stampDates;// 스탬프 찍은 날짜들
 DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StampCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StampCardCopyWith<StampCard> get copyWith => _$StampCardCopyWithImpl<StampCard>(this as StampCard, _$identity);

  /// Serializes this StampCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StampCard&&(identical(other.id, id) || other.id == id)&&(identical(other.visitorId, visitorId) || other.visitorId == visitorId)&&(identical(other.visitorName, visitorName) || other.visitorName == visitorName)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.truckName, truckName) || other.truckName == truckName)&&(identical(other.stampCount, stampCount) || other.stampCount == stampCount)&&(identical(other.completedCards, completedCards) || other.completedCards == completedCards)&&const DeepCollectionEquality().equals(other.stampDates, stampDates)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,visitorId,visitorName,truckId,truckName,stampCount,completedCards,const DeepCollectionEquality().hash(stampDates),createdAt,updatedAt);

@override
String toString() {
  return 'StampCard(id: $id, visitorId: $visitorId, visitorName: $visitorName, truckId: $truckId, truckName: $truckName, stampCount: $stampCount, completedCards: $completedCards, stampDates: $stampDates, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StampCardCopyWith<$Res>  {
  factory $StampCardCopyWith(StampCard value, $Res Function(StampCard) _then) = _$StampCardCopyWithImpl;
@useResult
$Res call({
 String id, String visitorId, String visitorName, String truckId, String truckName, int stampCount, int completedCards, List<DateTime> stampDates, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StampCardCopyWithImpl<$Res>
    implements $StampCardCopyWith<$Res> {
  _$StampCardCopyWithImpl(this._self, this._then);

  final StampCard _self;
  final $Res Function(StampCard) _then;

/// Create a copy of StampCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? visitorId = null,Object? visitorName = null,Object? truckId = null,Object? truckName = null,Object? stampCount = null,Object? completedCards = null,Object? stampDates = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,visitorId: null == visitorId ? _self.visitorId : visitorId // ignore: cast_nullable_to_non_nullable
as String,visitorName: null == visitorName ? _self.visitorName : visitorName // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,truckName: null == truckName ? _self.truckName : truckName // ignore: cast_nullable_to_non_nullable
as String,stampCount: null == stampCount ? _self.stampCount : stampCount // ignore: cast_nullable_to_non_nullable
as int,completedCards: null == completedCards ? _self.completedCards : completedCards // ignore: cast_nullable_to_non_nullable
as int,stampDates: null == stampDates ? _self.stampDates : stampDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StampCard].
extension StampCardPatterns on StampCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StampCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StampCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StampCard value)  $default,){
final _that = this;
switch (_that) {
case _StampCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StampCard value)?  $default,){
final _that = this;
switch (_that) {
case _StampCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String visitorId,  String visitorName,  String truckId,  String truckName,  int stampCount,  int completedCards,  List<DateTime> stampDates,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StampCard() when $default != null:
return $default(_that.id,_that.visitorId,_that.visitorName,_that.truckId,_that.truckName,_that.stampCount,_that.completedCards,_that.stampDates,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String visitorId,  String visitorName,  String truckId,  String truckName,  int stampCount,  int completedCards,  List<DateTime> stampDates,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StampCard():
return $default(_that.id,_that.visitorId,_that.visitorName,_that.truckId,_that.truckName,_that.stampCount,_that.completedCards,_that.stampDates,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String visitorId,  String visitorName,  String truckId,  String truckName,  int stampCount,  int completedCards,  List<DateTime> stampDates,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StampCard() when $default != null:
return $default(_that.id,_that.visitorId,_that.visitorName,_that.truckId,_that.truckName,_that.stampCount,_that.completedCards,_that.stampDates,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StampCard extends StampCard {
  const _StampCard({required this.id, required this.visitorId, required this.visitorName, required this.truckId, required this.truckName, this.stampCount = 0, this.completedCards = 0, final  List<DateTime> stampDates = const [], required this.createdAt, required this.updatedAt}): _stampDates = stampDates,super._();
  factory _StampCard.fromJson(Map<String, dynamic> json) => _$StampCardFromJson(json);

@override final  String id;
@override final  String visitorId;
@override final  String visitorName;
@override final  String truckId;
@override final  String truckName;
@override@JsonKey() final  int stampCount;
// 현재 스탬프 수 (0-10)
@override@JsonKey() final  int completedCards;
// 완료된 카드 수 (10개 채울 때마다 +1)
 final  List<DateTime> _stampDates;
// 완료된 카드 수 (10개 채울 때마다 +1)
@override@JsonKey() List<DateTime> get stampDates {
  if (_stampDates is EqualUnmodifiableListView) return _stampDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stampDates);
}

// 스탬프 찍은 날짜들
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StampCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StampCardCopyWith<_StampCard> get copyWith => __$StampCardCopyWithImpl<_StampCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StampCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StampCard&&(identical(other.id, id) || other.id == id)&&(identical(other.visitorId, visitorId) || other.visitorId == visitorId)&&(identical(other.visitorName, visitorName) || other.visitorName == visitorName)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.truckName, truckName) || other.truckName == truckName)&&(identical(other.stampCount, stampCount) || other.stampCount == stampCount)&&(identical(other.completedCards, completedCards) || other.completedCards == completedCards)&&const DeepCollectionEquality().equals(other._stampDates, _stampDates)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,visitorId,visitorName,truckId,truckName,stampCount,completedCards,const DeepCollectionEquality().hash(_stampDates),createdAt,updatedAt);

@override
String toString() {
  return 'StampCard(id: $id, visitorId: $visitorId, visitorName: $visitorName, truckId: $truckId, truckName: $truckName, stampCount: $stampCount, completedCards: $completedCards, stampDates: $stampDates, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StampCardCopyWith<$Res> implements $StampCardCopyWith<$Res> {
  factory _$StampCardCopyWith(_StampCard value, $Res Function(_StampCard) _then) = __$StampCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String visitorId, String visitorName, String truckId, String truckName, int stampCount, int completedCards, List<DateTime> stampDates, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StampCardCopyWithImpl<$Res>
    implements _$StampCardCopyWith<$Res> {
  __$StampCardCopyWithImpl(this._self, this._then);

  final _StampCard _self;
  final $Res Function(_StampCard) _then;

/// Create a copy of StampCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? visitorId = null,Object? visitorName = null,Object? truckId = null,Object? truckName = null,Object? stampCount = null,Object? completedCards = null,Object? stampDates = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StampCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,visitorId: null == visitorId ? _self.visitorId : visitorId // ignore: cast_nullable_to_non_nullable
as String,visitorName: null == visitorName ? _self.visitorName : visitorName // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,truckName: null == truckName ? _self.truckName : truckName // ignore: cast_nullable_to_non_nullable
as String,stampCount: null == stampCount ? _self.stampCount : stampCount // ignore: cast_nullable_to_non_nullable
as int,completedCards: null == completedCards ? _self.completedCards : completedCards // ignore: cast_nullable_to_non_nullable
as int,stampDates: null == stampDates ? _self._stampDates : stampDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Reward {

 String get id; String get visitorId; String get visitorName; String get truckId; String get truckName; RewardType get rewardType; bool get isUsed; DateTime get earnedAt; DateTime? get usedAt; String? get usedByOwnerId;
/// Create a copy of Reward
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewardCopyWith<Reward> get copyWith => _$RewardCopyWithImpl<Reward>(this as Reward, _$identity);

  /// Serializes this Reward to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reward&&(identical(other.id, id) || other.id == id)&&(identical(other.visitorId, visitorId) || other.visitorId == visitorId)&&(identical(other.visitorName, visitorName) || other.visitorName == visitorName)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.truckName, truckName) || other.truckName == truckName)&&(identical(other.rewardType, rewardType) || other.rewardType == rewardType)&&(identical(other.isUsed, isUsed) || other.isUsed == isUsed)&&(identical(other.earnedAt, earnedAt) || other.earnedAt == earnedAt)&&(identical(other.usedAt, usedAt) || other.usedAt == usedAt)&&(identical(other.usedByOwnerId, usedByOwnerId) || other.usedByOwnerId == usedByOwnerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,visitorId,visitorName,truckId,truckName,rewardType,isUsed,earnedAt,usedAt,usedByOwnerId);

@override
String toString() {
  return 'Reward(id: $id, visitorId: $visitorId, visitorName: $visitorName, truckId: $truckId, truckName: $truckName, rewardType: $rewardType, isUsed: $isUsed, earnedAt: $earnedAt, usedAt: $usedAt, usedByOwnerId: $usedByOwnerId)';
}


}

/// @nodoc
abstract mixin class $RewardCopyWith<$Res>  {
  factory $RewardCopyWith(Reward value, $Res Function(Reward) _then) = _$RewardCopyWithImpl;
@useResult
$Res call({
 String id, String visitorId, String visitorName, String truckId, String truckName, RewardType rewardType, bool isUsed, DateTime earnedAt, DateTime? usedAt, String? usedByOwnerId
});




}
/// @nodoc
class _$RewardCopyWithImpl<$Res>
    implements $RewardCopyWith<$Res> {
  _$RewardCopyWithImpl(this._self, this._then);

  final Reward _self;
  final $Res Function(Reward) _then;

/// Create a copy of Reward
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? visitorId = null,Object? visitorName = null,Object? truckId = null,Object? truckName = null,Object? rewardType = null,Object? isUsed = null,Object? earnedAt = null,Object? usedAt = freezed,Object? usedByOwnerId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,visitorId: null == visitorId ? _self.visitorId : visitorId // ignore: cast_nullable_to_non_nullable
as String,visitorName: null == visitorName ? _self.visitorName : visitorName // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,truckName: null == truckName ? _self.truckName : truckName // ignore: cast_nullable_to_non_nullable
as String,rewardType: null == rewardType ? _self.rewardType : rewardType // ignore: cast_nullable_to_non_nullable
as RewardType,isUsed: null == isUsed ? _self.isUsed : isUsed // ignore: cast_nullable_to_non_nullable
as bool,earnedAt: null == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as DateTime,usedAt: freezed == usedAt ? _self.usedAt : usedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,usedByOwnerId: freezed == usedByOwnerId ? _self.usedByOwnerId : usedByOwnerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Reward].
extension RewardPatterns on Reward {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reward value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reward() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reward value)  $default,){
final _that = this;
switch (_that) {
case _Reward():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reward value)?  $default,){
final _that = this;
switch (_that) {
case _Reward() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String visitorId,  String visitorName,  String truckId,  String truckName,  RewardType rewardType,  bool isUsed,  DateTime earnedAt,  DateTime? usedAt,  String? usedByOwnerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reward() when $default != null:
return $default(_that.id,_that.visitorId,_that.visitorName,_that.truckId,_that.truckName,_that.rewardType,_that.isUsed,_that.earnedAt,_that.usedAt,_that.usedByOwnerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String visitorId,  String visitorName,  String truckId,  String truckName,  RewardType rewardType,  bool isUsed,  DateTime earnedAt,  DateTime? usedAt,  String? usedByOwnerId)  $default,) {final _that = this;
switch (_that) {
case _Reward():
return $default(_that.id,_that.visitorId,_that.visitorName,_that.truckId,_that.truckName,_that.rewardType,_that.isUsed,_that.earnedAt,_that.usedAt,_that.usedByOwnerId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String visitorId,  String visitorName,  String truckId,  String truckName,  RewardType rewardType,  bool isUsed,  DateTime earnedAt,  DateTime? usedAt,  String? usedByOwnerId)?  $default,) {final _that = this;
switch (_that) {
case _Reward() when $default != null:
return $default(_that.id,_that.visitorId,_that.visitorName,_that.truckId,_that.truckName,_that.rewardType,_that.isUsed,_that.earnedAt,_that.usedAt,_that.usedByOwnerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reward extends Reward {
  const _Reward({required this.id, required this.visitorId, required this.visitorName, required this.truckId, required this.truckName, required this.rewardType, this.isUsed = false, required this.earnedAt, this.usedAt, this.usedByOwnerId}): super._();
  factory _Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

@override final  String id;
@override final  String visitorId;
@override final  String visitorName;
@override final  String truckId;
@override final  String truckName;
@override final  RewardType rewardType;
@override@JsonKey() final  bool isUsed;
@override final  DateTime earnedAt;
@override final  DateTime? usedAt;
@override final  String? usedByOwnerId;

/// Create a copy of Reward
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewardCopyWith<_Reward> get copyWith => __$RewardCopyWithImpl<_Reward>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reward&&(identical(other.id, id) || other.id == id)&&(identical(other.visitorId, visitorId) || other.visitorId == visitorId)&&(identical(other.visitorName, visitorName) || other.visitorName == visitorName)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.truckName, truckName) || other.truckName == truckName)&&(identical(other.rewardType, rewardType) || other.rewardType == rewardType)&&(identical(other.isUsed, isUsed) || other.isUsed == isUsed)&&(identical(other.earnedAt, earnedAt) || other.earnedAt == earnedAt)&&(identical(other.usedAt, usedAt) || other.usedAt == usedAt)&&(identical(other.usedByOwnerId, usedByOwnerId) || other.usedByOwnerId == usedByOwnerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,visitorId,visitorName,truckId,truckName,rewardType,isUsed,earnedAt,usedAt,usedByOwnerId);

@override
String toString() {
  return 'Reward(id: $id, visitorId: $visitorId, visitorName: $visitorName, truckId: $truckId, truckName: $truckName, rewardType: $rewardType, isUsed: $isUsed, earnedAt: $earnedAt, usedAt: $usedAt, usedByOwnerId: $usedByOwnerId)';
}


}

/// @nodoc
abstract mixin class _$RewardCopyWith<$Res> implements $RewardCopyWith<$Res> {
  factory _$RewardCopyWith(_Reward value, $Res Function(_Reward) _then) = __$RewardCopyWithImpl;
@override @useResult
$Res call({
 String id, String visitorId, String visitorName, String truckId, String truckName, RewardType rewardType, bool isUsed, DateTime earnedAt, DateTime? usedAt, String? usedByOwnerId
});




}
/// @nodoc
class __$RewardCopyWithImpl<$Res>
    implements _$RewardCopyWith<$Res> {
  __$RewardCopyWithImpl(this._self, this._then);

  final _Reward _self;
  final $Res Function(_Reward) _then;

/// Create a copy of Reward
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? visitorId = null,Object? visitorName = null,Object? truckId = null,Object? truckName = null,Object? rewardType = null,Object? isUsed = null,Object? earnedAt = null,Object? usedAt = freezed,Object? usedByOwnerId = freezed,}) {
  return _then(_Reward(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,visitorId: null == visitorId ? _self.visitorId : visitorId // ignore: cast_nullable_to_non_nullable
as String,visitorName: null == visitorName ? _self.visitorName : visitorName // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,truckName: null == truckName ? _self.truckName : truckName // ignore: cast_nullable_to_non_nullable
as String,rewardType: null == rewardType ? _self.rewardType : rewardType // ignore: cast_nullable_to_non_nullable
as RewardType,isUsed: null == isUsed ? _self.isUsed : isUsed // ignore: cast_nullable_to_non_nullable
as bool,earnedAt: null == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as DateTime,usedAt: freezed == usedAt ? _self.usedAt : usedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,usedByOwnerId: freezed == usedByOwnerId ? _self.usedByOwnerId : usedByOwnerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
