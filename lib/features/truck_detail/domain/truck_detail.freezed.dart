// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truck_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TruckDetail {

 String get truckId; String get operatingHours; List<MenuItem> get menuItems; List<Review> get reviews; double get averageRating; String get description;
/// Create a copy of TruckDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruckDetailCopyWith<TruckDetail> get copyWith => _$TruckDetailCopyWithImpl<TruckDetail>(this as TruckDetail, _$identity);

  /// Serializes this TruckDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TruckDetail&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.operatingHours, operatingHours) || other.operatingHours == operatingHours)&&const DeepCollectionEquality().equals(other.menuItems, menuItems)&&const DeepCollectionEquality().equals(other.reviews, reviews)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,truckId,operatingHours,const DeepCollectionEquality().hash(menuItems),const DeepCollectionEquality().hash(reviews),averageRating,description);

@override
String toString() {
  return 'TruckDetail(truckId: $truckId, operatingHours: $operatingHours, menuItems: $menuItems, reviews: $reviews, averageRating: $averageRating, description: $description)';
}


}

/// @nodoc
abstract mixin class $TruckDetailCopyWith<$Res>  {
  factory $TruckDetailCopyWith(TruckDetail value, $Res Function(TruckDetail) _then) = _$TruckDetailCopyWithImpl;
@useResult
$Res call({
 String truckId, String operatingHours, List<MenuItem> menuItems, List<Review> reviews, double averageRating, String description
});




}
/// @nodoc
class _$TruckDetailCopyWithImpl<$Res>
    implements $TruckDetailCopyWith<$Res> {
  _$TruckDetailCopyWithImpl(this._self, this._then);

  final TruckDetail _self;
  final $Res Function(TruckDetail) _then;

/// Create a copy of TruckDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? truckId = null,Object? operatingHours = null,Object? menuItems = null,Object? reviews = null,Object? averageRating = null,Object? description = null,}) {
  return _then(_self.copyWith(
truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,operatingHours: null == operatingHours ? _self.operatingHours : operatingHours // ignore: cast_nullable_to_non_nullable
as String,menuItems: null == menuItems ? _self.menuItems : menuItems // ignore: cast_nullable_to_non_nullable
as List<MenuItem>,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<Review>,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TruckDetail].
extension TruckDetailPatterns on TruckDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TruckDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TruckDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TruckDetail value)  $default,){
final _that = this;
switch (_that) {
case _TruckDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TruckDetail value)?  $default,){
final _that = this;
switch (_that) {
case _TruckDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String truckId,  String operatingHours,  List<MenuItem> menuItems,  List<Review> reviews,  double averageRating,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TruckDetail() when $default != null:
return $default(_that.truckId,_that.operatingHours,_that.menuItems,_that.reviews,_that.averageRating,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String truckId,  String operatingHours,  List<MenuItem> menuItems,  List<Review> reviews,  double averageRating,  String description)  $default,) {final _that = this;
switch (_that) {
case _TruckDetail():
return $default(_that.truckId,_that.operatingHours,_that.menuItems,_that.reviews,_that.averageRating,_that.description);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String truckId,  String operatingHours,  List<MenuItem> menuItems,  List<Review> reviews,  double averageRating,  String description)?  $default,) {final _that = this;
switch (_that) {
case _TruckDetail() when $default != null:
return $default(_that.truckId,_that.operatingHours,_that.menuItems,_that.reviews,_that.averageRating,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TruckDetail extends TruckDetail {
  const _TruckDetail({required this.truckId, required this.operatingHours, required final  List<MenuItem> menuItems, required final  List<Review> reviews, this.averageRating = 4.5, this.description = ''}): _menuItems = menuItems,_reviews = reviews,super._();
  factory _TruckDetail.fromJson(Map<String, dynamic> json) => _$TruckDetailFromJson(json);

@override final  String truckId;
@override final  String operatingHours;
 final  List<MenuItem> _menuItems;
@override List<MenuItem> get menuItems {
  if (_menuItems is EqualUnmodifiableListView) return _menuItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_menuItems);
}

 final  List<Review> _reviews;
@override List<Review> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}

@override@JsonKey() final  double averageRating;
@override@JsonKey() final  String description;

/// Create a copy of TruckDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TruckDetailCopyWith<_TruckDetail> get copyWith => __$TruckDetailCopyWithImpl<_TruckDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TruckDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TruckDetail&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.operatingHours, operatingHours) || other.operatingHours == operatingHours)&&const DeepCollectionEquality().equals(other._menuItems, _menuItems)&&const DeepCollectionEquality().equals(other._reviews, _reviews)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,truckId,operatingHours,const DeepCollectionEquality().hash(_menuItems),const DeepCollectionEquality().hash(_reviews),averageRating,description);

@override
String toString() {
  return 'TruckDetail(truckId: $truckId, operatingHours: $operatingHours, menuItems: $menuItems, reviews: $reviews, averageRating: $averageRating, description: $description)';
}


}

/// @nodoc
abstract mixin class _$TruckDetailCopyWith<$Res> implements $TruckDetailCopyWith<$Res> {
  factory _$TruckDetailCopyWith(_TruckDetail value, $Res Function(_TruckDetail) _then) = __$TruckDetailCopyWithImpl;
@override @useResult
$Res call({
 String truckId, String operatingHours, List<MenuItem> menuItems, List<Review> reviews, double averageRating, String description
});




}
/// @nodoc
class __$TruckDetailCopyWithImpl<$Res>
    implements _$TruckDetailCopyWith<$Res> {
  __$TruckDetailCopyWithImpl(this._self, this._then);

  final _TruckDetail _self;
  final $Res Function(_TruckDetail) _then;

/// Create a copy of TruckDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? truckId = null,Object? operatingHours = null,Object? menuItems = null,Object? reviews = null,Object? averageRating = null,Object? description = null,}) {
  return _then(_TruckDetail(
truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,operatingHours: null == operatingHours ? _self.operatingHours : operatingHours // ignore: cast_nullable_to_non_nullable
as String,menuItems: null == menuItems ? _self._menuItems : menuItems // ignore: cast_nullable_to_non_nullable
as List<MenuItem>,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<Review>,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
