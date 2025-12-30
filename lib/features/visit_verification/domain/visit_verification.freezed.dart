// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisitVerification {

 String get id; String get visitorId; String get visitorName; String? get visitorPhotoUrl; String get truckId; String get truckName; DateTime get verifiedAt; double get distanceMeters;// 인증 시점의 거리
 double get latitude;// 인증 시점의 사용자 위치
 double get longitude;
/// Create a copy of VisitVerification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitVerificationCopyWith<VisitVerification> get copyWith => _$VisitVerificationCopyWithImpl<VisitVerification>(this as VisitVerification, _$identity);

  /// Serializes this VisitVerification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitVerification&&(identical(other.id, id) || other.id == id)&&(identical(other.visitorId, visitorId) || other.visitorId == visitorId)&&(identical(other.visitorName, visitorName) || other.visitorName == visitorName)&&(identical(other.visitorPhotoUrl, visitorPhotoUrl) || other.visitorPhotoUrl == visitorPhotoUrl)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.truckName, truckName) || other.truckName == truckName)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,visitorId,visitorName,visitorPhotoUrl,truckId,truckName,verifiedAt,distanceMeters,latitude,longitude);

@override
String toString() {
  return 'VisitVerification(id: $id, visitorId: $visitorId, visitorName: $visitorName, visitorPhotoUrl: $visitorPhotoUrl, truckId: $truckId, truckName: $truckName, verifiedAt: $verifiedAt, distanceMeters: $distanceMeters, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $VisitVerificationCopyWith<$Res>  {
  factory $VisitVerificationCopyWith(VisitVerification value, $Res Function(VisitVerification) _then) = _$VisitVerificationCopyWithImpl;
@useResult
$Res call({
 String id, String visitorId, String visitorName, String? visitorPhotoUrl, String truckId, String truckName, DateTime verifiedAt, double distanceMeters, double latitude, double longitude
});




}
/// @nodoc
class _$VisitVerificationCopyWithImpl<$Res>
    implements $VisitVerificationCopyWith<$Res> {
  _$VisitVerificationCopyWithImpl(this._self, this._then);

  final VisitVerification _self;
  final $Res Function(VisitVerification) _then;

/// Create a copy of VisitVerification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? visitorId = null,Object? visitorName = null,Object? visitorPhotoUrl = freezed,Object? truckId = null,Object? truckName = null,Object? verifiedAt = null,Object? distanceMeters = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,visitorId: null == visitorId ? _self.visitorId : visitorId // ignore: cast_nullable_to_non_nullable
as String,visitorName: null == visitorName ? _self.visitorName : visitorName // ignore: cast_nullable_to_non_nullable
as String,visitorPhotoUrl: freezed == visitorPhotoUrl ? _self.visitorPhotoUrl : visitorPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,truckName: null == truckName ? _self.truckName : truckName // ignore: cast_nullable_to_non_nullable
as String,verifiedAt: null == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [VisitVerification].
extension VisitVerificationPatterns on VisitVerification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisitVerification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisitVerification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisitVerification value)  $default,){
final _that = this;
switch (_that) {
case _VisitVerification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisitVerification value)?  $default,){
final _that = this;
switch (_that) {
case _VisitVerification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String visitorId,  String visitorName,  String? visitorPhotoUrl,  String truckId,  String truckName,  DateTime verifiedAt,  double distanceMeters,  double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisitVerification() when $default != null:
return $default(_that.id,_that.visitorId,_that.visitorName,_that.visitorPhotoUrl,_that.truckId,_that.truckName,_that.verifiedAt,_that.distanceMeters,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String visitorId,  String visitorName,  String? visitorPhotoUrl,  String truckId,  String truckName,  DateTime verifiedAt,  double distanceMeters,  double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _VisitVerification():
return $default(_that.id,_that.visitorId,_that.visitorName,_that.visitorPhotoUrl,_that.truckId,_that.truckName,_that.verifiedAt,_that.distanceMeters,_that.latitude,_that.longitude);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String visitorId,  String visitorName,  String? visitorPhotoUrl,  String truckId,  String truckName,  DateTime verifiedAt,  double distanceMeters,  double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _VisitVerification() when $default != null:
return $default(_that.id,_that.visitorId,_that.visitorName,_that.visitorPhotoUrl,_that.truckId,_that.truckName,_that.verifiedAt,_that.distanceMeters,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisitVerification extends VisitVerification {
  const _VisitVerification({required this.id, required this.visitorId, required this.visitorName, this.visitorPhotoUrl, required this.truckId, required this.truckName, required this.verifiedAt, required this.distanceMeters, required this.latitude, required this.longitude}): super._();
  factory _VisitVerification.fromJson(Map<String, dynamic> json) => _$VisitVerificationFromJson(json);

@override final  String id;
@override final  String visitorId;
@override final  String visitorName;
@override final  String? visitorPhotoUrl;
@override final  String truckId;
@override final  String truckName;
@override final  DateTime verifiedAt;
@override final  double distanceMeters;
// 인증 시점의 거리
@override final  double latitude;
// 인증 시점의 사용자 위치
@override final  double longitude;

/// Create a copy of VisitVerification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitVerificationCopyWith<_VisitVerification> get copyWith => __$VisitVerificationCopyWithImpl<_VisitVerification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisitVerificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisitVerification&&(identical(other.id, id) || other.id == id)&&(identical(other.visitorId, visitorId) || other.visitorId == visitorId)&&(identical(other.visitorName, visitorName) || other.visitorName == visitorName)&&(identical(other.visitorPhotoUrl, visitorPhotoUrl) || other.visitorPhotoUrl == visitorPhotoUrl)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.truckName, truckName) || other.truckName == truckName)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,visitorId,visitorName,visitorPhotoUrl,truckId,truckName,verifiedAt,distanceMeters,latitude,longitude);

@override
String toString() {
  return 'VisitVerification(id: $id, visitorId: $visitorId, visitorName: $visitorName, visitorPhotoUrl: $visitorPhotoUrl, truckId: $truckId, truckName: $truckName, verifiedAt: $verifiedAt, distanceMeters: $distanceMeters, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$VisitVerificationCopyWith<$Res> implements $VisitVerificationCopyWith<$Res> {
  factory _$VisitVerificationCopyWith(_VisitVerification value, $Res Function(_VisitVerification) _then) = __$VisitVerificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String visitorId, String visitorName, String? visitorPhotoUrl, String truckId, String truckName, DateTime verifiedAt, double distanceMeters, double latitude, double longitude
});




}
/// @nodoc
class __$VisitVerificationCopyWithImpl<$Res>
    implements _$VisitVerificationCopyWith<$Res> {
  __$VisitVerificationCopyWithImpl(this._self, this._then);

  final _VisitVerification _self;
  final $Res Function(_VisitVerification) _then;

/// Create a copy of VisitVerification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? visitorId = null,Object? visitorName = null,Object? visitorPhotoUrl = freezed,Object? truckId = null,Object? truckName = null,Object? verifiedAt = null,Object? distanceMeters = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_VisitVerification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,visitorId: null == visitorId ? _self.visitorId : visitorId // ignore: cast_nullable_to_non_nullable
as String,visitorName: null == visitorName ? _self.visitorName : visitorName // ignore: cast_nullable_to_non_nullable
as String,visitorPhotoUrl: freezed == visitorPhotoUrl ? _self.visitorPhotoUrl : visitorPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,truckName: null == truckName ? _self.truckName : truckName // ignore: cast_nullable_to_non_nullable
as String,verifiedAt: null == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$TruckVisitStats {

 String get truckId; int get totalVisits; int get uniqueVisitors; List<RecentVisitor> get recentVisitors;
/// Create a copy of TruckVisitStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruckVisitStatsCopyWith<TruckVisitStats> get copyWith => _$TruckVisitStatsCopyWithImpl<TruckVisitStats>(this as TruckVisitStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TruckVisitStats&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.totalVisits, totalVisits) || other.totalVisits == totalVisits)&&(identical(other.uniqueVisitors, uniqueVisitors) || other.uniqueVisitors == uniqueVisitors)&&const DeepCollectionEquality().equals(other.recentVisitors, recentVisitors));
}


@override
int get hashCode => Object.hash(runtimeType,truckId,totalVisits,uniqueVisitors,const DeepCollectionEquality().hash(recentVisitors));

@override
String toString() {
  return 'TruckVisitStats(truckId: $truckId, totalVisits: $totalVisits, uniqueVisitors: $uniqueVisitors, recentVisitors: $recentVisitors)';
}


}

/// @nodoc
abstract mixin class $TruckVisitStatsCopyWith<$Res>  {
  factory $TruckVisitStatsCopyWith(TruckVisitStats value, $Res Function(TruckVisitStats) _then) = _$TruckVisitStatsCopyWithImpl;
@useResult
$Res call({
 String truckId, int totalVisits, int uniqueVisitors, List<RecentVisitor> recentVisitors
});




}
/// @nodoc
class _$TruckVisitStatsCopyWithImpl<$Res>
    implements $TruckVisitStatsCopyWith<$Res> {
  _$TruckVisitStatsCopyWithImpl(this._self, this._then);

  final TruckVisitStats _self;
  final $Res Function(TruckVisitStats) _then;

/// Create a copy of TruckVisitStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? truckId = null,Object? totalVisits = null,Object? uniqueVisitors = null,Object? recentVisitors = null,}) {
  return _then(_self.copyWith(
truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,totalVisits: null == totalVisits ? _self.totalVisits : totalVisits // ignore: cast_nullable_to_non_nullable
as int,uniqueVisitors: null == uniqueVisitors ? _self.uniqueVisitors : uniqueVisitors // ignore: cast_nullable_to_non_nullable
as int,recentVisitors: null == recentVisitors ? _self.recentVisitors : recentVisitors // ignore: cast_nullable_to_non_nullable
as List<RecentVisitor>,
  ));
}

}


/// Adds pattern-matching-related methods to [TruckVisitStats].
extension TruckVisitStatsPatterns on TruckVisitStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TruckVisitStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TruckVisitStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TruckVisitStats value)  $default,){
final _that = this;
switch (_that) {
case _TruckVisitStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TruckVisitStats value)?  $default,){
final _that = this;
switch (_that) {
case _TruckVisitStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String truckId,  int totalVisits,  int uniqueVisitors,  List<RecentVisitor> recentVisitors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TruckVisitStats() when $default != null:
return $default(_that.truckId,_that.totalVisits,_that.uniqueVisitors,_that.recentVisitors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String truckId,  int totalVisits,  int uniqueVisitors,  List<RecentVisitor> recentVisitors)  $default,) {final _that = this;
switch (_that) {
case _TruckVisitStats():
return $default(_that.truckId,_that.totalVisits,_that.uniqueVisitors,_that.recentVisitors);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String truckId,  int totalVisits,  int uniqueVisitors,  List<RecentVisitor> recentVisitors)?  $default,) {final _that = this;
switch (_that) {
case _TruckVisitStats() when $default != null:
return $default(_that.truckId,_that.totalVisits,_that.uniqueVisitors,_that.recentVisitors);case _:
  return null;

}
}

}

/// @nodoc


class _TruckVisitStats implements TruckVisitStats {
  const _TruckVisitStats({required this.truckId, this.totalVisits = 0, this.uniqueVisitors = 0, final  List<RecentVisitor> recentVisitors = const []}): _recentVisitors = recentVisitors;
  

@override final  String truckId;
@override@JsonKey() final  int totalVisits;
@override@JsonKey() final  int uniqueVisitors;
 final  List<RecentVisitor> _recentVisitors;
@override@JsonKey() List<RecentVisitor> get recentVisitors {
  if (_recentVisitors is EqualUnmodifiableListView) return _recentVisitors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentVisitors);
}


/// Create a copy of TruckVisitStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TruckVisitStatsCopyWith<_TruckVisitStats> get copyWith => __$TruckVisitStatsCopyWithImpl<_TruckVisitStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TruckVisitStats&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.totalVisits, totalVisits) || other.totalVisits == totalVisits)&&(identical(other.uniqueVisitors, uniqueVisitors) || other.uniqueVisitors == uniqueVisitors)&&const DeepCollectionEquality().equals(other._recentVisitors, _recentVisitors));
}


@override
int get hashCode => Object.hash(runtimeType,truckId,totalVisits,uniqueVisitors,const DeepCollectionEquality().hash(_recentVisitors));

@override
String toString() {
  return 'TruckVisitStats(truckId: $truckId, totalVisits: $totalVisits, uniqueVisitors: $uniqueVisitors, recentVisitors: $recentVisitors)';
}


}

/// @nodoc
abstract mixin class _$TruckVisitStatsCopyWith<$Res> implements $TruckVisitStatsCopyWith<$Res> {
  factory _$TruckVisitStatsCopyWith(_TruckVisitStats value, $Res Function(_TruckVisitStats) _then) = __$TruckVisitStatsCopyWithImpl;
@override @useResult
$Res call({
 String truckId, int totalVisits, int uniqueVisitors, List<RecentVisitor> recentVisitors
});




}
/// @nodoc
class __$TruckVisitStatsCopyWithImpl<$Res>
    implements _$TruckVisitStatsCopyWith<$Res> {
  __$TruckVisitStatsCopyWithImpl(this._self, this._then);

  final _TruckVisitStats _self;
  final $Res Function(_TruckVisitStats) _then;

/// Create a copy of TruckVisitStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? truckId = null,Object? totalVisits = null,Object? uniqueVisitors = null,Object? recentVisitors = null,}) {
  return _then(_TruckVisitStats(
truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,totalVisits: null == totalVisits ? _self.totalVisits : totalVisits // ignore: cast_nullable_to_non_nullable
as int,uniqueVisitors: null == uniqueVisitors ? _self.uniqueVisitors : uniqueVisitors // ignore: cast_nullable_to_non_nullable
as int,recentVisitors: null == recentVisitors ? _self._recentVisitors : recentVisitors // ignore: cast_nullable_to_non_nullable
as List<RecentVisitor>,
  ));
}


}

/// @nodoc
mixin _$RecentVisitor {

 String get visitorId; String get visitorName; String? get visitorPhotoUrl; DateTime get lastVisitAt; int get visitCount;
/// Create a copy of RecentVisitor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentVisitorCopyWith<RecentVisitor> get copyWith => _$RecentVisitorCopyWithImpl<RecentVisitor>(this as RecentVisitor, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentVisitor&&(identical(other.visitorId, visitorId) || other.visitorId == visitorId)&&(identical(other.visitorName, visitorName) || other.visitorName == visitorName)&&(identical(other.visitorPhotoUrl, visitorPhotoUrl) || other.visitorPhotoUrl == visitorPhotoUrl)&&(identical(other.lastVisitAt, lastVisitAt) || other.lastVisitAt == lastVisitAt)&&(identical(other.visitCount, visitCount) || other.visitCount == visitCount));
}


@override
int get hashCode => Object.hash(runtimeType,visitorId,visitorName,visitorPhotoUrl,lastVisitAt,visitCount);

@override
String toString() {
  return 'RecentVisitor(visitorId: $visitorId, visitorName: $visitorName, visitorPhotoUrl: $visitorPhotoUrl, lastVisitAt: $lastVisitAt, visitCount: $visitCount)';
}


}

/// @nodoc
abstract mixin class $RecentVisitorCopyWith<$Res>  {
  factory $RecentVisitorCopyWith(RecentVisitor value, $Res Function(RecentVisitor) _then) = _$RecentVisitorCopyWithImpl;
@useResult
$Res call({
 String visitorId, String visitorName, String? visitorPhotoUrl, DateTime lastVisitAt, int visitCount
});




}
/// @nodoc
class _$RecentVisitorCopyWithImpl<$Res>
    implements $RecentVisitorCopyWith<$Res> {
  _$RecentVisitorCopyWithImpl(this._self, this._then);

  final RecentVisitor _self;
  final $Res Function(RecentVisitor) _then;

/// Create a copy of RecentVisitor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? visitorId = null,Object? visitorName = null,Object? visitorPhotoUrl = freezed,Object? lastVisitAt = null,Object? visitCount = null,}) {
  return _then(_self.copyWith(
visitorId: null == visitorId ? _self.visitorId : visitorId // ignore: cast_nullable_to_non_nullable
as String,visitorName: null == visitorName ? _self.visitorName : visitorName // ignore: cast_nullable_to_non_nullable
as String,visitorPhotoUrl: freezed == visitorPhotoUrl ? _self.visitorPhotoUrl : visitorPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,lastVisitAt: null == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as DateTime,visitCount: null == visitCount ? _self.visitCount : visitCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentVisitor].
extension RecentVisitorPatterns on RecentVisitor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentVisitor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentVisitor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentVisitor value)  $default,){
final _that = this;
switch (_that) {
case _RecentVisitor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentVisitor value)?  $default,){
final _that = this;
switch (_that) {
case _RecentVisitor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String visitorId,  String visitorName,  String? visitorPhotoUrl,  DateTime lastVisitAt,  int visitCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentVisitor() when $default != null:
return $default(_that.visitorId,_that.visitorName,_that.visitorPhotoUrl,_that.lastVisitAt,_that.visitCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String visitorId,  String visitorName,  String? visitorPhotoUrl,  DateTime lastVisitAt,  int visitCount)  $default,) {final _that = this;
switch (_that) {
case _RecentVisitor():
return $default(_that.visitorId,_that.visitorName,_that.visitorPhotoUrl,_that.lastVisitAt,_that.visitCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String visitorId,  String visitorName,  String? visitorPhotoUrl,  DateTime lastVisitAt,  int visitCount)?  $default,) {final _that = this;
switch (_that) {
case _RecentVisitor() when $default != null:
return $default(_that.visitorId,_that.visitorName,_that.visitorPhotoUrl,_that.lastVisitAt,_that.visitCount);case _:
  return null;

}
}

}

/// @nodoc


class _RecentVisitor implements RecentVisitor {
  const _RecentVisitor({required this.visitorId, required this.visitorName, this.visitorPhotoUrl, required this.lastVisitAt, this.visitCount = 1});
  

@override final  String visitorId;
@override final  String visitorName;
@override final  String? visitorPhotoUrl;
@override final  DateTime lastVisitAt;
@override@JsonKey() final  int visitCount;

/// Create a copy of RecentVisitor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentVisitorCopyWith<_RecentVisitor> get copyWith => __$RecentVisitorCopyWithImpl<_RecentVisitor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentVisitor&&(identical(other.visitorId, visitorId) || other.visitorId == visitorId)&&(identical(other.visitorName, visitorName) || other.visitorName == visitorName)&&(identical(other.visitorPhotoUrl, visitorPhotoUrl) || other.visitorPhotoUrl == visitorPhotoUrl)&&(identical(other.lastVisitAt, lastVisitAt) || other.lastVisitAt == lastVisitAt)&&(identical(other.visitCount, visitCount) || other.visitCount == visitCount));
}


@override
int get hashCode => Object.hash(runtimeType,visitorId,visitorName,visitorPhotoUrl,lastVisitAt,visitCount);

@override
String toString() {
  return 'RecentVisitor(visitorId: $visitorId, visitorName: $visitorName, visitorPhotoUrl: $visitorPhotoUrl, lastVisitAt: $lastVisitAt, visitCount: $visitCount)';
}


}

/// @nodoc
abstract mixin class _$RecentVisitorCopyWith<$Res> implements $RecentVisitorCopyWith<$Res> {
  factory _$RecentVisitorCopyWith(_RecentVisitor value, $Res Function(_RecentVisitor) _then) = __$RecentVisitorCopyWithImpl;
@override @useResult
$Res call({
 String visitorId, String visitorName, String? visitorPhotoUrl, DateTime lastVisitAt, int visitCount
});




}
/// @nodoc
class __$RecentVisitorCopyWithImpl<$Res>
    implements _$RecentVisitorCopyWith<$Res> {
  __$RecentVisitorCopyWithImpl(this._self, this._then);

  final _RecentVisitor _self;
  final $Res Function(_RecentVisitor) _then;

/// Create a copy of RecentVisitor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? visitorId = null,Object? visitorName = null,Object? visitorPhotoUrl = freezed,Object? lastVisitAt = null,Object? visitCount = null,}) {
  return _then(_RecentVisitor(
visitorId: null == visitorId ? _self.visitorId : visitorId // ignore: cast_nullable_to_non_nullable
as String,visitorName: null == visitorName ? _self.visitorName : visitorName // ignore: cast_nullable_to_non_nullable
as String,visitorPhotoUrl: freezed == visitorPhotoUrl ? _self.visitorPhotoUrl : visitorPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,lastVisitAt: null == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as DateTime,visitCount: null == visitCount ? _self.visitCount : visitCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
