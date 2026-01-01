// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_approval.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessApproval {

 String get truckId; String get ownerId; String get ownerEmail; String get truckName; int get menuCount; bool get scheduleSet; bool get imageUploaded; ApprovalStatus get status; DateTime? get submittedAt; DateTime? get reviewedAt; String? get reviewedBy; String? get rejectionReason;
/// Create a copy of BusinessApproval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessApprovalCopyWith<BusinessApproval> get copyWith => _$BusinessApprovalCopyWithImpl<BusinessApproval>(this as BusinessApproval, _$identity);

  /// Serializes this BusinessApproval to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessApproval&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerEmail, ownerEmail) || other.ownerEmail == ownerEmail)&&(identical(other.truckName, truckName) || other.truckName == truckName)&&(identical(other.menuCount, menuCount) || other.menuCount == menuCount)&&(identical(other.scheduleSet, scheduleSet) || other.scheduleSet == scheduleSet)&&(identical(other.imageUploaded, imageUploaded) || other.imageUploaded == imageUploaded)&&(identical(other.status, status) || other.status == status)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,truckId,ownerId,ownerEmail,truckName,menuCount,scheduleSet,imageUploaded,status,submittedAt,reviewedAt,reviewedBy,rejectionReason);

@override
String toString() {
  return 'BusinessApproval(truckId: $truckId, ownerId: $ownerId, ownerEmail: $ownerEmail, truckName: $truckName, menuCount: $menuCount, scheduleSet: $scheduleSet, imageUploaded: $imageUploaded, status: $status, submittedAt: $submittedAt, reviewedAt: $reviewedAt, reviewedBy: $reviewedBy, rejectionReason: $rejectionReason)';
}


}

/// @nodoc
abstract mixin class $BusinessApprovalCopyWith<$Res>  {
  factory $BusinessApprovalCopyWith(BusinessApproval value, $Res Function(BusinessApproval) _then) = _$BusinessApprovalCopyWithImpl;
@useResult
$Res call({
 String truckId, String ownerId, String ownerEmail, String truckName, int menuCount, bool scheduleSet, bool imageUploaded, ApprovalStatus status, DateTime? submittedAt, DateTime? reviewedAt, String? reviewedBy, String? rejectionReason
});




}
/// @nodoc
class _$BusinessApprovalCopyWithImpl<$Res>
    implements $BusinessApprovalCopyWith<$Res> {
  _$BusinessApprovalCopyWithImpl(this._self, this._then);

  final BusinessApproval _self;
  final $Res Function(BusinessApproval) _then;

/// Create a copy of BusinessApproval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? truckId = null,Object? ownerId = null,Object? ownerEmail = null,Object? truckName = null,Object? menuCount = null,Object? scheduleSet = null,Object? imageUploaded = null,Object? status = null,Object? submittedAt = freezed,Object? reviewedAt = freezed,Object? reviewedBy = freezed,Object? rejectionReason = freezed,}) {
  return _then(_self.copyWith(
truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,ownerEmail: null == ownerEmail ? _self.ownerEmail : ownerEmail // ignore: cast_nullable_to_non_nullable
as String,truckName: null == truckName ? _self.truckName : truckName // ignore: cast_nullable_to_non_nullable
as String,menuCount: null == menuCount ? _self.menuCount : menuCount // ignore: cast_nullable_to_non_nullable
as int,scheduleSet: null == scheduleSet ? _self.scheduleSet : scheduleSet // ignore: cast_nullable_to_non_nullable
as bool,imageUploaded: null == imageUploaded ? _self.imageUploaded : imageUploaded // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApprovalStatus,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessApproval].
extension BusinessApprovalPatterns on BusinessApproval {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessApproval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessApproval() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessApproval value)  $default,){
final _that = this;
switch (_that) {
case _BusinessApproval():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessApproval value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessApproval() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String truckId,  String ownerId,  String ownerEmail,  String truckName,  int menuCount,  bool scheduleSet,  bool imageUploaded,  ApprovalStatus status,  DateTime? submittedAt,  DateTime? reviewedAt,  String? reviewedBy,  String? rejectionReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessApproval() when $default != null:
return $default(_that.truckId,_that.ownerId,_that.ownerEmail,_that.truckName,_that.menuCount,_that.scheduleSet,_that.imageUploaded,_that.status,_that.submittedAt,_that.reviewedAt,_that.reviewedBy,_that.rejectionReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String truckId,  String ownerId,  String ownerEmail,  String truckName,  int menuCount,  bool scheduleSet,  bool imageUploaded,  ApprovalStatus status,  DateTime? submittedAt,  DateTime? reviewedAt,  String? reviewedBy,  String? rejectionReason)  $default,) {final _that = this;
switch (_that) {
case _BusinessApproval():
return $default(_that.truckId,_that.ownerId,_that.ownerEmail,_that.truckName,_that.menuCount,_that.scheduleSet,_that.imageUploaded,_that.status,_that.submittedAt,_that.reviewedAt,_that.reviewedBy,_that.rejectionReason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String truckId,  String ownerId,  String ownerEmail,  String truckName,  int menuCount,  bool scheduleSet,  bool imageUploaded,  ApprovalStatus status,  DateTime? submittedAt,  DateTime? reviewedAt,  String? reviewedBy,  String? rejectionReason)?  $default,) {final _that = this;
switch (_that) {
case _BusinessApproval() when $default != null:
return $default(_that.truckId,_that.ownerId,_that.ownerEmail,_that.truckName,_that.menuCount,_that.scheduleSet,_that.imageUploaded,_that.status,_that.submittedAt,_that.reviewedAt,_that.reviewedBy,_that.rejectionReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessApproval extends BusinessApproval {
  const _BusinessApproval({required this.truckId, required this.ownerId, required this.ownerEmail, required this.truckName, this.menuCount = 0, this.scheduleSet = false, this.imageUploaded = false, this.status = ApprovalStatus.pending, this.submittedAt, this.reviewedAt, this.reviewedBy, this.rejectionReason}): super._();
  factory _BusinessApproval.fromJson(Map<String, dynamic> json) => _$BusinessApprovalFromJson(json);

@override final  String truckId;
@override final  String ownerId;
@override final  String ownerEmail;
@override final  String truckName;
@override@JsonKey() final  int menuCount;
@override@JsonKey() final  bool scheduleSet;
@override@JsonKey() final  bool imageUploaded;
@override@JsonKey() final  ApprovalStatus status;
@override final  DateTime? submittedAt;
@override final  DateTime? reviewedAt;
@override final  String? reviewedBy;
@override final  String? rejectionReason;

/// Create a copy of BusinessApproval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessApprovalCopyWith<_BusinessApproval> get copyWith => __$BusinessApprovalCopyWithImpl<_BusinessApproval>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessApprovalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessApproval&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerEmail, ownerEmail) || other.ownerEmail == ownerEmail)&&(identical(other.truckName, truckName) || other.truckName == truckName)&&(identical(other.menuCount, menuCount) || other.menuCount == menuCount)&&(identical(other.scheduleSet, scheduleSet) || other.scheduleSet == scheduleSet)&&(identical(other.imageUploaded, imageUploaded) || other.imageUploaded == imageUploaded)&&(identical(other.status, status) || other.status == status)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,truckId,ownerId,ownerEmail,truckName,menuCount,scheduleSet,imageUploaded,status,submittedAt,reviewedAt,reviewedBy,rejectionReason);

@override
String toString() {
  return 'BusinessApproval(truckId: $truckId, ownerId: $ownerId, ownerEmail: $ownerEmail, truckName: $truckName, menuCount: $menuCount, scheduleSet: $scheduleSet, imageUploaded: $imageUploaded, status: $status, submittedAt: $submittedAt, reviewedAt: $reviewedAt, reviewedBy: $reviewedBy, rejectionReason: $rejectionReason)';
}


}

/// @nodoc
abstract mixin class _$BusinessApprovalCopyWith<$Res> implements $BusinessApprovalCopyWith<$Res> {
  factory _$BusinessApprovalCopyWith(_BusinessApproval value, $Res Function(_BusinessApproval) _then) = __$BusinessApprovalCopyWithImpl;
@override @useResult
$Res call({
 String truckId, String ownerId, String ownerEmail, String truckName, int menuCount, bool scheduleSet, bool imageUploaded, ApprovalStatus status, DateTime? submittedAt, DateTime? reviewedAt, String? reviewedBy, String? rejectionReason
});




}
/// @nodoc
class __$BusinessApprovalCopyWithImpl<$Res>
    implements _$BusinessApprovalCopyWith<$Res> {
  __$BusinessApprovalCopyWithImpl(this._self, this._then);

  final _BusinessApproval _self;
  final $Res Function(_BusinessApproval) _then;

/// Create a copy of BusinessApproval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? truckId = null,Object? ownerId = null,Object? ownerEmail = null,Object? truckName = null,Object? menuCount = null,Object? scheduleSet = null,Object? imageUploaded = null,Object? status = null,Object? submittedAt = freezed,Object? reviewedAt = freezed,Object? reviewedBy = freezed,Object? rejectionReason = freezed,}) {
  return _then(_BusinessApproval(
truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,ownerEmail: null == ownerEmail ? _self.ownerEmail : ownerEmail // ignore: cast_nullable_to_non_nullable
as String,truckName: null == truckName ? _self.truckName : truckName // ignore: cast_nullable_to_non_nullable
as String,menuCount: null == menuCount ? _self.menuCount : menuCount // ignore: cast_nullable_to_non_nullable
as int,scheduleSet: null == scheduleSet ? _self.scheduleSet : scheduleSet // ignore: cast_nullable_to_non_nullable
as bool,imageUploaded: null == imageUploaded ? _self.imageUploaded : imageUploaded // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApprovalStatus,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
