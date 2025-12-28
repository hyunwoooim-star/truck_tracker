// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Coupon {

 String get id; String get truckId; String get code; CouponType get type; int? get discountPercent;// % 할인 (type == percentage)
 int? get discountAmount;// 고정 금액 할인 (type == fixed)
 String? get freeItemName;// 무료 아이템 이름 (type == freeItem)
 DateTime get validFrom; DateTime get validUntil; int get maxUses; int get currentUses; List<String> get usedBy;// userId 목록
 bool get isActive; String? get description;
/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponCopyWith<Coupon> get copyWith => _$CouponCopyWithImpl<Coupon>(this as Coupon, _$identity);

  /// Serializes this Coupon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coupon&&(identical(other.id, id) || other.id == id)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.code, code) || other.code == code)&&(identical(other.type, type) || other.type == type)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.freeItemName, freeItemName) || other.freeItemName == freeItemName)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.maxUses, maxUses) || other.maxUses == maxUses)&&(identical(other.currentUses, currentUses) || other.currentUses == currentUses)&&const DeepCollectionEquality().equals(other.usedBy, usedBy)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,truckId,code,type,discountPercent,discountAmount,freeItemName,validFrom,validUntil,maxUses,currentUses,const DeepCollectionEquality().hash(usedBy),isActive,description);

@override
String toString() {
  return 'Coupon(id: $id, truckId: $truckId, code: $code, type: $type, discountPercent: $discountPercent, discountAmount: $discountAmount, freeItemName: $freeItemName, validFrom: $validFrom, validUntil: $validUntil, maxUses: $maxUses, currentUses: $currentUses, usedBy: $usedBy, isActive: $isActive, description: $description)';
}


}

/// @nodoc
abstract mixin class $CouponCopyWith<$Res>  {
  factory $CouponCopyWith(Coupon value, $Res Function(Coupon) _then) = _$CouponCopyWithImpl;
@useResult
$Res call({
 String id, String truckId, String code, CouponType type, int? discountPercent, int? discountAmount, String? freeItemName, DateTime validFrom, DateTime validUntil, int maxUses, int currentUses, List<String> usedBy, bool isActive, String? description
});




}
/// @nodoc
class _$CouponCopyWithImpl<$Res>
    implements $CouponCopyWith<$Res> {
  _$CouponCopyWithImpl(this._self, this._then);

  final Coupon _self;
  final $Res Function(Coupon) _then;

/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? truckId = null,Object? code = null,Object? type = null,Object? discountPercent = freezed,Object? discountAmount = freezed,Object? freeItemName = freezed,Object? validFrom = null,Object? validUntil = null,Object? maxUses = null,Object? currentUses = null,Object? usedBy = null,Object? isActive = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CouponType,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int?,freeItemName: freezed == freeItemName ? _self.freeItemName : freeItemName // ignore: cast_nullable_to_non_nullable
as String?,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime,maxUses: null == maxUses ? _self.maxUses : maxUses // ignore: cast_nullable_to_non_nullable
as int,currentUses: null == currentUses ? _self.currentUses : currentUses // ignore: cast_nullable_to_non_nullable
as int,usedBy: null == usedBy ? _self.usedBy : usedBy // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Coupon].
extension CouponPatterns on Coupon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coupon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coupon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coupon value)  $default,){
final _that = this;
switch (_that) {
case _Coupon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coupon value)?  $default,){
final _that = this;
switch (_that) {
case _Coupon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String truckId,  String code,  CouponType type,  int? discountPercent,  int? discountAmount,  String? freeItemName,  DateTime validFrom,  DateTime validUntil,  int maxUses,  int currentUses,  List<String> usedBy,  bool isActive,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coupon() when $default != null:
return $default(_that.id,_that.truckId,_that.code,_that.type,_that.discountPercent,_that.discountAmount,_that.freeItemName,_that.validFrom,_that.validUntil,_that.maxUses,_that.currentUses,_that.usedBy,_that.isActive,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String truckId,  String code,  CouponType type,  int? discountPercent,  int? discountAmount,  String? freeItemName,  DateTime validFrom,  DateTime validUntil,  int maxUses,  int currentUses,  List<String> usedBy,  bool isActive,  String? description)  $default,) {final _that = this;
switch (_that) {
case _Coupon():
return $default(_that.id,_that.truckId,_that.code,_that.type,_that.discountPercent,_that.discountAmount,_that.freeItemName,_that.validFrom,_that.validUntil,_that.maxUses,_that.currentUses,_that.usedBy,_that.isActive,_that.description);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String truckId,  String code,  CouponType type,  int? discountPercent,  int? discountAmount,  String? freeItemName,  DateTime validFrom,  DateTime validUntil,  int maxUses,  int currentUses,  List<String> usedBy,  bool isActive,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _Coupon() when $default != null:
return $default(_that.id,_that.truckId,_that.code,_that.type,_that.discountPercent,_that.discountAmount,_that.freeItemName,_that.validFrom,_that.validUntil,_that.maxUses,_that.currentUses,_that.usedBy,_that.isActive,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Coupon extends Coupon {
  const _Coupon({required this.id, required this.truckId, required this.code, required this.type, this.discountPercent, this.discountAmount, this.freeItemName, required this.validFrom, required this.validUntil, required this.maxUses, this.currentUses = 0, final  List<String> usedBy = const [], this.isActive = true, this.description}): _usedBy = usedBy,super._();
  factory _Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);

@override final  String id;
@override final  String truckId;
@override final  String code;
@override final  CouponType type;
@override final  int? discountPercent;
// % 할인 (type == percentage)
@override final  int? discountAmount;
// 고정 금액 할인 (type == fixed)
@override final  String? freeItemName;
// 무료 아이템 이름 (type == freeItem)
@override final  DateTime validFrom;
@override final  DateTime validUntil;
@override final  int maxUses;
@override@JsonKey() final  int currentUses;
 final  List<String> _usedBy;
@override@JsonKey() List<String> get usedBy {
  if (_usedBy is EqualUnmodifiableListView) return _usedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_usedBy);
}

// userId 목록
@override@JsonKey() final  bool isActive;
@override final  String? description;

/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CouponCopyWith<_Coupon> get copyWith => __$CouponCopyWithImpl<_Coupon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CouponToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coupon&&(identical(other.id, id) || other.id == id)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.code, code) || other.code == code)&&(identical(other.type, type) || other.type == type)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.freeItemName, freeItemName) || other.freeItemName == freeItemName)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.maxUses, maxUses) || other.maxUses == maxUses)&&(identical(other.currentUses, currentUses) || other.currentUses == currentUses)&&const DeepCollectionEquality().equals(other._usedBy, _usedBy)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,truckId,code,type,discountPercent,discountAmount,freeItemName,validFrom,validUntil,maxUses,currentUses,const DeepCollectionEquality().hash(_usedBy),isActive,description);

@override
String toString() {
  return 'Coupon(id: $id, truckId: $truckId, code: $code, type: $type, discountPercent: $discountPercent, discountAmount: $discountAmount, freeItemName: $freeItemName, validFrom: $validFrom, validUntil: $validUntil, maxUses: $maxUses, currentUses: $currentUses, usedBy: $usedBy, isActive: $isActive, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CouponCopyWith<$Res> implements $CouponCopyWith<$Res> {
  factory _$CouponCopyWith(_Coupon value, $Res Function(_Coupon) _then) = __$CouponCopyWithImpl;
@override @useResult
$Res call({
 String id, String truckId, String code, CouponType type, int? discountPercent, int? discountAmount, String? freeItemName, DateTime validFrom, DateTime validUntil, int maxUses, int currentUses, List<String> usedBy, bool isActive, String? description
});




}
/// @nodoc
class __$CouponCopyWithImpl<$Res>
    implements _$CouponCopyWith<$Res> {
  __$CouponCopyWithImpl(this._self, this._then);

  final _Coupon _self;
  final $Res Function(_Coupon) _then;

/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? truckId = null,Object? code = null,Object? type = null,Object? discountPercent = freezed,Object? discountAmount = freezed,Object? freeItemName = freezed,Object? validFrom = null,Object? validUntil = null,Object? maxUses = null,Object? currentUses = null,Object? usedBy = null,Object? isActive = null,Object? description = freezed,}) {
  return _then(_Coupon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CouponType,discountPercent: freezed == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int?,freeItemName: freezed == freeItemName ? _self.freeItemName : freeItemName // ignore: cast_nullable_to_non_nullable
as String?,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime,maxUses: null == maxUses ? _self.maxUses : maxUses // ignore: cast_nullable_to_non_nullable
as int,currentUses: null == currentUses ? _self.currentUses : currentUses // ignore: cast_nullable_to_non_nullable
as int,usedBy: null == usedBy ? _self._usedBy : usedBy // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
