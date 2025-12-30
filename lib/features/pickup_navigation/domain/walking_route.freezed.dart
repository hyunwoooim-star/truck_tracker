// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walking_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalkingRoute {

/// 총 거리 (미터)
 int get distanceMeters;/// 총 거리 텍스트 (예: "1.2km")
 String get distanceText;/// 예상 소요 시간 (초)
 int get durationSeconds;/// 예상 소요 시간 텍스트 (예: "15분")
 String get durationText;/// 출발지 주소
 String get startAddress;/// 도착지 주소
 String get endAddress;/// 경로 폴리라인 포인트
 List<LatLngPoint> get polylinePoints;/// 상세 경로 단계
 List<RouteStep> get steps;
/// Create a copy of WalkingRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalkingRouteCopyWith<WalkingRoute> get copyWith => _$WalkingRouteCopyWithImpl<WalkingRoute>(this as WalkingRoute, _$identity);

  /// Serializes this WalkingRoute to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalkingRoute&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.durationText, durationText) || other.durationText == durationText)&&(identical(other.startAddress, startAddress) || other.startAddress == startAddress)&&(identical(other.endAddress, endAddress) || other.endAddress == endAddress)&&const DeepCollectionEquality().equals(other.polylinePoints, polylinePoints)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,distanceMeters,distanceText,durationSeconds,durationText,startAddress,endAddress,const DeepCollectionEquality().hash(polylinePoints),const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'WalkingRoute(distanceMeters: $distanceMeters, distanceText: $distanceText, durationSeconds: $durationSeconds, durationText: $durationText, startAddress: $startAddress, endAddress: $endAddress, polylinePoints: $polylinePoints, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $WalkingRouteCopyWith<$Res>  {
  factory $WalkingRouteCopyWith(WalkingRoute value, $Res Function(WalkingRoute) _then) = _$WalkingRouteCopyWithImpl;
@useResult
$Res call({
 int distanceMeters, String distanceText, int durationSeconds, String durationText, String startAddress, String endAddress, List<LatLngPoint> polylinePoints, List<RouteStep> steps
});




}
/// @nodoc
class _$WalkingRouteCopyWithImpl<$Res>
    implements $WalkingRouteCopyWith<$Res> {
  _$WalkingRouteCopyWithImpl(this._self, this._then);

  final WalkingRoute _self;
  final $Res Function(WalkingRoute) _then;

/// Create a copy of WalkingRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? distanceMeters = null,Object? distanceText = null,Object? durationSeconds = null,Object? durationText = null,Object? startAddress = null,Object? endAddress = null,Object? polylinePoints = null,Object? steps = null,}) {
  return _then(_self.copyWith(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int,distanceText: null == distanceText ? _self.distanceText : distanceText // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,durationText: null == durationText ? _self.durationText : durationText // ignore: cast_nullable_to_non_nullable
as String,startAddress: null == startAddress ? _self.startAddress : startAddress // ignore: cast_nullable_to_non_nullable
as String,endAddress: null == endAddress ? _self.endAddress : endAddress // ignore: cast_nullable_to_non_nullable
as String,polylinePoints: null == polylinePoints ? _self.polylinePoints : polylinePoints // ignore: cast_nullable_to_non_nullable
as List<LatLngPoint>,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<RouteStep>,
  ));
}

}


/// Adds pattern-matching-related methods to [WalkingRoute].
extension WalkingRoutePatterns on WalkingRoute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalkingRoute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalkingRoute() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalkingRoute value)  $default,){
final _that = this;
switch (_that) {
case _WalkingRoute():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalkingRoute value)?  $default,){
final _that = this;
switch (_that) {
case _WalkingRoute() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int distanceMeters,  String distanceText,  int durationSeconds,  String durationText,  String startAddress,  String endAddress,  List<LatLngPoint> polylinePoints,  List<RouteStep> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalkingRoute() when $default != null:
return $default(_that.distanceMeters,_that.distanceText,_that.durationSeconds,_that.durationText,_that.startAddress,_that.endAddress,_that.polylinePoints,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int distanceMeters,  String distanceText,  int durationSeconds,  String durationText,  String startAddress,  String endAddress,  List<LatLngPoint> polylinePoints,  List<RouteStep> steps)  $default,) {final _that = this;
switch (_that) {
case _WalkingRoute():
return $default(_that.distanceMeters,_that.distanceText,_that.durationSeconds,_that.durationText,_that.startAddress,_that.endAddress,_that.polylinePoints,_that.steps);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int distanceMeters,  String distanceText,  int durationSeconds,  String durationText,  String startAddress,  String endAddress,  List<LatLngPoint> polylinePoints,  List<RouteStep> steps)?  $default,) {final _that = this;
switch (_that) {
case _WalkingRoute() when $default != null:
return $default(_that.distanceMeters,_that.distanceText,_that.durationSeconds,_that.durationText,_that.startAddress,_that.endAddress,_that.polylinePoints,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalkingRoute extends WalkingRoute {
  const _WalkingRoute({required this.distanceMeters, required this.distanceText, required this.durationSeconds, required this.durationText, required this.startAddress, required this.endAddress, required final  List<LatLngPoint> polylinePoints, required final  List<RouteStep> steps}): _polylinePoints = polylinePoints,_steps = steps,super._();
  factory _WalkingRoute.fromJson(Map<String, dynamic> json) => _$WalkingRouteFromJson(json);

/// 총 거리 (미터)
@override final  int distanceMeters;
/// 총 거리 텍스트 (예: "1.2km")
@override final  String distanceText;
/// 예상 소요 시간 (초)
@override final  int durationSeconds;
/// 예상 소요 시간 텍스트 (예: "15분")
@override final  String durationText;
/// 출발지 주소
@override final  String startAddress;
/// 도착지 주소
@override final  String endAddress;
/// 경로 폴리라인 포인트
 final  List<LatLngPoint> _polylinePoints;
/// 경로 폴리라인 포인트
@override List<LatLngPoint> get polylinePoints {
  if (_polylinePoints is EqualUnmodifiableListView) return _polylinePoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_polylinePoints);
}

/// 상세 경로 단계
 final  List<RouteStep> _steps;
/// 상세 경로 단계
@override List<RouteStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of WalkingRoute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalkingRouteCopyWith<_WalkingRoute> get copyWith => __$WalkingRouteCopyWithImpl<_WalkingRoute>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalkingRouteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalkingRoute&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.durationText, durationText) || other.durationText == durationText)&&(identical(other.startAddress, startAddress) || other.startAddress == startAddress)&&(identical(other.endAddress, endAddress) || other.endAddress == endAddress)&&const DeepCollectionEquality().equals(other._polylinePoints, _polylinePoints)&&const DeepCollectionEquality().equals(other._steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,distanceMeters,distanceText,durationSeconds,durationText,startAddress,endAddress,const DeepCollectionEquality().hash(_polylinePoints),const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'WalkingRoute(distanceMeters: $distanceMeters, distanceText: $distanceText, durationSeconds: $durationSeconds, durationText: $durationText, startAddress: $startAddress, endAddress: $endAddress, polylinePoints: $polylinePoints, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$WalkingRouteCopyWith<$Res> implements $WalkingRouteCopyWith<$Res> {
  factory _$WalkingRouteCopyWith(_WalkingRoute value, $Res Function(_WalkingRoute) _then) = __$WalkingRouteCopyWithImpl;
@override @useResult
$Res call({
 int distanceMeters, String distanceText, int durationSeconds, String durationText, String startAddress, String endAddress, List<LatLngPoint> polylinePoints, List<RouteStep> steps
});




}
/// @nodoc
class __$WalkingRouteCopyWithImpl<$Res>
    implements _$WalkingRouteCopyWith<$Res> {
  __$WalkingRouteCopyWithImpl(this._self, this._then);

  final _WalkingRoute _self;
  final $Res Function(_WalkingRoute) _then;

/// Create a copy of WalkingRoute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? distanceMeters = null,Object? distanceText = null,Object? durationSeconds = null,Object? durationText = null,Object? startAddress = null,Object? endAddress = null,Object? polylinePoints = null,Object? steps = null,}) {
  return _then(_WalkingRoute(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int,distanceText: null == distanceText ? _self.distanceText : distanceText // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,durationText: null == durationText ? _self.durationText : durationText // ignore: cast_nullable_to_non_nullable
as String,startAddress: null == startAddress ? _self.startAddress : startAddress // ignore: cast_nullable_to_non_nullable
as String,endAddress: null == endAddress ? _self.endAddress : endAddress // ignore: cast_nullable_to_non_nullable
as String,polylinePoints: null == polylinePoints ? _self._polylinePoints : polylinePoints // ignore: cast_nullable_to_non_nullable
as List<LatLngPoint>,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<RouteStep>,
  ));
}


}


/// @nodoc
mixin _$RouteStep {

/// 안내 텍스트
 String get instruction;/// 거리 (미터)
 int get distanceMeters;/// 거리 텍스트
 String get distanceText;/// 소요 시간 (초)
 int get durationSeconds;/// 소요 시간 텍스트
 String get durationText;/// 시작 위도
 double get startLat;/// 시작 경도
 double get startLng;/// 종료 위도
 double get endLat;/// 종료 경도
 double get endLng;/// 방향 전환 유형 (turn-left, turn-right 등)
 String? get maneuver;
/// Create a copy of RouteStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteStepCopyWith<RouteStep> get copyWith => _$RouteStepCopyWithImpl<RouteStep>(this as RouteStep, _$identity);

  /// Serializes this RouteStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteStep&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.durationText, durationText) || other.durationText == durationText)&&(identical(other.startLat, startLat) || other.startLat == startLat)&&(identical(other.startLng, startLng) || other.startLng == startLng)&&(identical(other.endLat, endLat) || other.endLat == endLat)&&(identical(other.endLng, endLng) || other.endLng == endLng)&&(identical(other.maneuver, maneuver) || other.maneuver == maneuver));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instruction,distanceMeters,distanceText,durationSeconds,durationText,startLat,startLng,endLat,endLng,maneuver);

@override
String toString() {
  return 'RouteStep(instruction: $instruction, distanceMeters: $distanceMeters, distanceText: $distanceText, durationSeconds: $durationSeconds, durationText: $durationText, startLat: $startLat, startLng: $startLng, endLat: $endLat, endLng: $endLng, maneuver: $maneuver)';
}


}

/// @nodoc
abstract mixin class $RouteStepCopyWith<$Res>  {
  factory $RouteStepCopyWith(RouteStep value, $Res Function(RouteStep) _then) = _$RouteStepCopyWithImpl;
@useResult
$Res call({
 String instruction, int distanceMeters, String distanceText, int durationSeconds, String durationText, double startLat, double startLng, double endLat, double endLng, String? maneuver
});




}
/// @nodoc
class _$RouteStepCopyWithImpl<$Res>
    implements $RouteStepCopyWith<$Res> {
  _$RouteStepCopyWithImpl(this._self, this._then);

  final RouteStep _self;
  final $Res Function(RouteStep) _then;

/// Create a copy of RouteStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instruction = null,Object? distanceMeters = null,Object? distanceText = null,Object? durationSeconds = null,Object? durationText = null,Object? startLat = null,Object? startLng = null,Object? endLat = null,Object? endLng = null,Object? maneuver = freezed,}) {
  return _then(_self.copyWith(
instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int,distanceText: null == distanceText ? _self.distanceText : distanceText // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,durationText: null == durationText ? _self.durationText : durationText // ignore: cast_nullable_to_non_nullable
as String,startLat: null == startLat ? _self.startLat : startLat // ignore: cast_nullable_to_non_nullable
as double,startLng: null == startLng ? _self.startLng : startLng // ignore: cast_nullable_to_non_nullable
as double,endLat: null == endLat ? _self.endLat : endLat // ignore: cast_nullable_to_non_nullable
as double,endLng: null == endLng ? _self.endLng : endLng // ignore: cast_nullable_to_non_nullable
as double,maneuver: freezed == maneuver ? _self.maneuver : maneuver // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteStep].
extension RouteStepPatterns on RouteStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteStep value)  $default,){
final _that = this;
switch (_that) {
case _RouteStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteStep value)?  $default,){
final _that = this;
switch (_that) {
case _RouteStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String instruction,  int distanceMeters,  String distanceText,  int durationSeconds,  String durationText,  double startLat,  double startLng,  double endLat,  double endLng,  String? maneuver)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteStep() when $default != null:
return $default(_that.instruction,_that.distanceMeters,_that.distanceText,_that.durationSeconds,_that.durationText,_that.startLat,_that.startLng,_that.endLat,_that.endLng,_that.maneuver);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String instruction,  int distanceMeters,  String distanceText,  int durationSeconds,  String durationText,  double startLat,  double startLng,  double endLat,  double endLng,  String? maneuver)  $default,) {final _that = this;
switch (_that) {
case _RouteStep():
return $default(_that.instruction,_that.distanceMeters,_that.distanceText,_that.durationSeconds,_that.durationText,_that.startLat,_that.startLng,_that.endLat,_that.endLng,_that.maneuver);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String instruction,  int distanceMeters,  String distanceText,  int durationSeconds,  String durationText,  double startLat,  double startLng,  double endLat,  double endLng,  String? maneuver)?  $default,) {final _that = this;
switch (_that) {
case _RouteStep() when $default != null:
return $default(_that.instruction,_that.distanceMeters,_that.distanceText,_that.durationSeconds,_that.durationText,_that.startLat,_that.startLng,_that.endLat,_that.endLng,_that.maneuver);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteStep implements RouteStep {
  const _RouteStep({required this.instruction, required this.distanceMeters, required this.distanceText, required this.durationSeconds, required this.durationText, required this.startLat, required this.startLng, required this.endLat, required this.endLng, this.maneuver});
  factory _RouteStep.fromJson(Map<String, dynamic> json) => _$RouteStepFromJson(json);

/// 안내 텍스트
@override final  String instruction;
/// 거리 (미터)
@override final  int distanceMeters;
/// 거리 텍스트
@override final  String distanceText;
/// 소요 시간 (초)
@override final  int durationSeconds;
/// 소요 시간 텍스트
@override final  String durationText;
/// 시작 위도
@override final  double startLat;
/// 시작 경도
@override final  double startLng;
/// 종료 위도
@override final  double endLat;
/// 종료 경도
@override final  double endLng;
/// 방향 전환 유형 (turn-left, turn-right 등)
@override final  String? maneuver;

/// Create a copy of RouteStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteStepCopyWith<_RouteStep> get copyWith => __$RouteStepCopyWithImpl<_RouteStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteStep&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.durationText, durationText) || other.durationText == durationText)&&(identical(other.startLat, startLat) || other.startLat == startLat)&&(identical(other.startLng, startLng) || other.startLng == startLng)&&(identical(other.endLat, endLat) || other.endLat == endLat)&&(identical(other.endLng, endLng) || other.endLng == endLng)&&(identical(other.maneuver, maneuver) || other.maneuver == maneuver));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instruction,distanceMeters,distanceText,durationSeconds,durationText,startLat,startLng,endLat,endLng,maneuver);

@override
String toString() {
  return 'RouteStep(instruction: $instruction, distanceMeters: $distanceMeters, distanceText: $distanceText, durationSeconds: $durationSeconds, durationText: $durationText, startLat: $startLat, startLng: $startLng, endLat: $endLat, endLng: $endLng, maneuver: $maneuver)';
}


}

/// @nodoc
abstract mixin class _$RouteStepCopyWith<$Res> implements $RouteStepCopyWith<$Res> {
  factory _$RouteStepCopyWith(_RouteStep value, $Res Function(_RouteStep) _then) = __$RouteStepCopyWithImpl;
@override @useResult
$Res call({
 String instruction, int distanceMeters, String distanceText, int durationSeconds, String durationText, double startLat, double startLng, double endLat, double endLng, String? maneuver
});




}
/// @nodoc
class __$RouteStepCopyWithImpl<$Res>
    implements _$RouteStepCopyWith<$Res> {
  __$RouteStepCopyWithImpl(this._self, this._then);

  final _RouteStep _self;
  final $Res Function(_RouteStep) _then;

/// Create a copy of RouteStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instruction = null,Object? distanceMeters = null,Object? distanceText = null,Object? durationSeconds = null,Object? durationText = null,Object? startLat = null,Object? startLng = null,Object? endLat = null,Object? endLng = null,Object? maneuver = freezed,}) {
  return _then(_RouteStep(
instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int,distanceText: null == distanceText ? _self.distanceText : distanceText // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,durationText: null == durationText ? _self.durationText : durationText // ignore: cast_nullable_to_non_nullable
as String,startLat: null == startLat ? _self.startLat : startLat // ignore: cast_nullable_to_non_nullable
as double,startLng: null == startLng ? _self.startLng : startLng // ignore: cast_nullable_to_non_nullable
as double,endLat: null == endLat ? _self.endLat : endLat // ignore: cast_nullable_to_non_nullable
as double,endLng: null == endLng ? _self.endLng : endLng // ignore: cast_nullable_to_non_nullable
as double,maneuver: freezed == maneuver ? _self.maneuver : maneuver // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LatLngPoint {

 double get lat; double get lng;
/// Create a copy of LatLngPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LatLngPointCopyWith<LatLngPoint> get copyWith => _$LatLngPointCopyWithImpl<LatLngPoint>(this as LatLngPoint, _$identity);

  /// Serializes this LatLngPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatLngPoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'LatLngPoint(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $LatLngPointCopyWith<$Res>  {
  factory $LatLngPointCopyWith(LatLngPoint value, $Res Function(LatLngPoint) _then) = _$LatLngPointCopyWithImpl;
@useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class _$LatLngPointCopyWithImpl<$Res>
    implements $LatLngPointCopyWith<$Res> {
  _$LatLngPointCopyWithImpl(this._self, this._then);

  final LatLngPoint _self;
  final $Res Function(LatLngPoint) _then;

/// Create a copy of LatLngPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LatLngPoint].
extension LatLngPointPatterns on LatLngPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LatLngPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LatLngPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LatLngPoint value)  $default,){
final _that = this;
switch (_that) {
case _LatLngPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LatLngPoint value)?  $default,){
final _that = this;
switch (_that) {
case _LatLngPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LatLngPoint() when $default != null:
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng)  $default,) {final _that = this;
switch (_that) {
case _LatLngPoint():
return $default(_that.lat,_that.lng);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng)?  $default,) {final _that = this;
switch (_that) {
case _LatLngPoint() when $default != null:
return $default(_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LatLngPoint implements LatLngPoint {
  const _LatLngPoint({required this.lat, required this.lng});
  factory _LatLngPoint.fromJson(Map<String, dynamic> json) => _$LatLngPointFromJson(json);

@override final  double lat;
@override final  double lng;

/// Create a copy of LatLngPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LatLngPointCopyWith<_LatLngPoint> get copyWith => __$LatLngPointCopyWithImpl<_LatLngPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LatLngPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LatLngPoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'LatLngPoint(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$LatLngPointCopyWith<$Res> implements $LatLngPointCopyWith<$Res> {
  factory _$LatLngPointCopyWith(_LatLngPoint value, $Res Function(_LatLngPoint) _then) = __$LatLngPointCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class __$LatLngPointCopyWithImpl<$Res>
    implements _$LatLngPointCopyWith<$Res> {
  __$LatLngPointCopyWithImpl(this._self, this._then);

  final _LatLngPoint _self;
  final $Res Function(_LatLngPoint) _then;

/// Create a copy of LatLngPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_LatLngPoint(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
