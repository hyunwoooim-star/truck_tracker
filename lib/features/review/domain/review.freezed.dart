// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Review {

 String get id; String get truckId; String get userId; String get userName; String? get userPhotoURL; int get rating;// 1-5 stars
 String get comment; List<String> get photoUrls; String? get ownerReply;// Owner's reply to the review
 DateTime? get ownerReplyAt;// When owner replied
 DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCopyWith<Review> get copyWith => _$ReviewCopyWithImpl<Review>(this as Review, _$identity);

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Review&&(identical(other.id, id) || other.id == id)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userPhotoURL, userPhotoURL) || other.userPhotoURL == userPhotoURL)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other.photoUrls, photoUrls)&&(identical(other.ownerReply, ownerReply) || other.ownerReply == ownerReply)&&(identical(other.ownerReplyAt, ownerReplyAt) || other.ownerReplyAt == ownerReplyAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,truckId,userId,userName,userPhotoURL,rating,comment,const DeepCollectionEquality().hash(photoUrls),ownerReply,ownerReplyAt,createdAt,updatedAt);

@override
String toString() {
  return 'Review(id: $id, truckId: $truckId, userId: $userId, userName: $userName, userPhotoURL: $userPhotoURL, rating: $rating, comment: $comment, photoUrls: $photoUrls, ownerReply: $ownerReply, ownerReplyAt: $ownerReplyAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReviewCopyWith<$Res>  {
  factory $ReviewCopyWith(Review value, $Res Function(Review) _then) = _$ReviewCopyWithImpl;
@useResult
$Res call({
 String id, String truckId, String userId, String userName, String? userPhotoURL, int rating, String comment, List<String> photoUrls, String? ownerReply, DateTime? ownerReplyAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ReviewCopyWithImpl<$Res>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._self, this._then);

  final Review _self;
  final $Res Function(Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? truckId = null,Object? userId = null,Object? userName = null,Object? userPhotoURL = freezed,Object? rating = null,Object? comment = null,Object? photoUrls = null,Object? ownerReply = freezed,Object? ownerReplyAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userPhotoURL: freezed == userPhotoURL ? _self.userPhotoURL : userPhotoURL // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,photoUrls: null == photoUrls ? _self.photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,ownerReply: freezed == ownerReply ? _self.ownerReply : ownerReply // ignore: cast_nullable_to_non_nullable
as String?,ownerReplyAt: freezed == ownerReplyAt ? _self.ownerReplyAt : ownerReplyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Review].
extension ReviewPatterns on Review {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Review value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Review value)  $default,){
final _that = this;
switch (_that) {
case _Review():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Review value)?  $default,){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String truckId,  String userId,  String userName,  String? userPhotoURL,  int rating,  String comment,  List<String> photoUrls,  String? ownerReply,  DateTime? ownerReplyAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.truckId,_that.userId,_that.userName,_that.userPhotoURL,_that.rating,_that.comment,_that.photoUrls,_that.ownerReply,_that.ownerReplyAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String truckId,  String userId,  String userName,  String? userPhotoURL,  int rating,  String comment,  List<String> photoUrls,  String? ownerReply,  DateTime? ownerReplyAt,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Review():
return $default(_that.id,_that.truckId,_that.userId,_that.userName,_that.userPhotoURL,_that.rating,_that.comment,_that.photoUrls,_that.ownerReply,_that.ownerReplyAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String truckId,  String userId,  String userName,  String? userPhotoURL,  int rating,  String comment,  List<String> photoUrls,  String? ownerReply,  DateTime? ownerReplyAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.id,_that.truckId,_that.userId,_that.userName,_that.userPhotoURL,_that.rating,_that.comment,_that.photoUrls,_that.ownerReply,_that.ownerReplyAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Review implements Review {
  const _Review({required this.id, required this.truckId, required this.userId, required this.userName, this.userPhotoURL, required this.rating, required this.comment, final  List<String> photoUrls = const [], this.ownerReply, this.ownerReplyAt, this.createdAt, this.updatedAt}): _photoUrls = photoUrls;
  factory _Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

@override final  String id;
@override final  String truckId;
@override final  String userId;
@override final  String userName;
@override final  String? userPhotoURL;
@override final  int rating;
// 1-5 stars
@override final  String comment;
 final  List<String> _photoUrls;
@override@JsonKey() List<String> get photoUrls {
  if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoUrls);
}

@override final  String? ownerReply;
// Owner's reply to the review
@override final  DateTime? ownerReplyAt;
// When owner replied
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCopyWith<_Review> get copyWith => __$ReviewCopyWithImpl<_Review>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Review&&(identical(other.id, id) || other.id == id)&&(identical(other.truckId, truckId) || other.truckId == truckId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userPhotoURL, userPhotoURL) || other.userPhotoURL == userPhotoURL)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other._photoUrls, _photoUrls)&&(identical(other.ownerReply, ownerReply) || other.ownerReply == ownerReply)&&(identical(other.ownerReplyAt, ownerReplyAt) || other.ownerReplyAt == ownerReplyAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,truckId,userId,userName,userPhotoURL,rating,comment,const DeepCollectionEquality().hash(_photoUrls),ownerReply,ownerReplyAt,createdAt,updatedAt);

@override
String toString() {
  return 'Review(id: $id, truckId: $truckId, userId: $userId, userName: $userName, userPhotoURL: $userPhotoURL, rating: $rating, comment: $comment, photoUrls: $photoUrls, ownerReply: $ownerReply, ownerReplyAt: $ownerReplyAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$ReviewCopyWith(_Review value, $Res Function(_Review) _then) = __$ReviewCopyWithImpl;
@override @useResult
$Res call({
 String id, String truckId, String userId, String userName, String? userPhotoURL, int rating, String comment, List<String> photoUrls, String? ownerReply, DateTime? ownerReplyAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ReviewCopyWithImpl<$Res>
    implements _$ReviewCopyWith<$Res> {
  __$ReviewCopyWithImpl(this._self, this._then);

  final _Review _self;
  final $Res Function(_Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? truckId = null,Object? userId = null,Object? userName = null,Object? userPhotoURL = freezed,Object? rating = null,Object? comment = null,Object? photoUrls = null,Object? ownerReply = freezed,Object? ownerReplyAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Review(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,truckId: null == truckId ? _self.truckId : truckId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userPhotoURL: freezed == userPhotoURL ? _self.userPhotoURL : userPhotoURL // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,photoUrls: null == photoUrls ? _self._photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,ownerReply: freezed == ownerReply ? _self.ownerReply : ownerReply // ignore: cast_nullable_to_non_nullable
as String?,ownerReplyAt: freezed == ownerReplyAt ? _self.ownerReplyAt : ownerReplyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
