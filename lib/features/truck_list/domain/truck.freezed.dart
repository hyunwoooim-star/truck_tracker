// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truck.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Truck {

 String get id; String get truckNumber; String get driverName; TruckStatus get status; String get foodType; String get locationDescription; double get latitude; double get longitude; bool get isFavorite; String get imageUrl; String get ownerEmail;// 사장님 이메일 (인증용)
 String? get bankAccount;// 은행 계좌번호 (송금용 QR)
 String get announcement;// 오늘의 특별 공지
 int get favoriteCount;// 즐겨찾기 카운트 (전체 사용자)
 double get avgRating;// 평균 별점
 int get totalReviews;// 총 리뷰 개수
 bool get isOpen;// 영업 중 여부 (FCM 트리거용)
 Map<String, dynamic>? get weeklySchedule;
/// Create a copy of Truck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruckCopyWith<Truck> get copyWith => _$TruckCopyWithImpl<Truck>(this as Truck, _$identity);

  /// Serializes this Truck to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Truck&&(identical(other.id, id) || other.id == id)&&(identical(other.truckNumber, truckNumber) || other.truckNumber == truckNumber)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.status, status) || other.status == status)&&(identical(other.foodType, foodType) || other.foodType == foodType)&&(identical(other.locationDescription, locationDescription) || other.locationDescription == locationDescription)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.ownerEmail, ownerEmail) || other.ownerEmail == ownerEmail)&&(identical(other.bankAccount, bankAccount) || other.bankAccount == bankAccount)&&(identical(other.announcement, announcement) || other.announcement == announcement)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&const DeepCollectionEquality().equals(other.weeklySchedule, weeklySchedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,truckNumber,driverName,status,foodType,locationDescription,latitude,longitude,isFavorite,imageUrl,ownerEmail,bankAccount,announcement,favoriteCount,avgRating,totalReviews,isOpen,const DeepCollectionEquality().hash(weeklySchedule));

@override
String toString() {
  return 'Truck(id: $id, truckNumber: $truckNumber, driverName: $driverName, status: $status, foodType: $foodType, locationDescription: $locationDescription, latitude: $latitude, longitude: $longitude, isFavorite: $isFavorite, imageUrl: $imageUrl, ownerEmail: $ownerEmail, bankAccount: $bankAccount, announcement: $announcement, favoriteCount: $favoriteCount, avgRating: $avgRating, totalReviews: $totalReviews, isOpen: $isOpen, weeklySchedule: $weeklySchedule)';
}


}

/// @nodoc
abstract mixin class $TruckCopyWith<$Res>  {
  factory $TruckCopyWith(Truck value, $Res Function(Truck) _then) = _$TruckCopyWithImpl;
@useResult
$Res call({
 String id, String truckNumber, String driverName, TruckStatus status, String foodType, String locationDescription, double latitude, double longitude, bool isFavorite, String imageUrl, String ownerEmail, String? bankAccount, String announcement, int favoriteCount, double avgRating, int totalReviews, bool isOpen, Map<String, dynamic>? weeklySchedule
});




}
/// @nodoc
class _$TruckCopyWithImpl<$Res>
    implements $TruckCopyWith<$Res> {
  _$TruckCopyWithImpl(this._self, this._then);

  final Truck _self;
  final $Res Function(Truck) _then;

/// Create a copy of Truck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? truckNumber = null,Object? driverName = null,Object? status = null,Object? foodType = null,Object? locationDescription = null,Object? latitude = null,Object? longitude = null,Object? isFavorite = null,Object? imageUrl = null,Object? ownerEmail = null,Object? bankAccount = freezed,Object? announcement = null,Object? favoriteCount = null,Object? avgRating = null,Object? totalReviews = null,Object? isOpen = null,Object? weeklySchedule = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,truckNumber: null == truckNumber ? _self.truckNumber : truckNumber // ignore: cast_nullable_to_non_nullable
as String,driverName: null == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TruckStatus,foodType: null == foodType ? _self.foodType : foodType // ignore: cast_nullable_to_non_nullable
as String,locationDescription: null == locationDescription ? _self.locationDescription : locationDescription // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,ownerEmail: null == ownerEmail ? _self.ownerEmail : ownerEmail // ignore: cast_nullable_to_non_nullable
as String,bankAccount: freezed == bankAccount ? _self.bankAccount : bankAccount // ignore: cast_nullable_to_non_nullable
as String?,announcement: null == announcement ? _self.announcement : announcement // ignore: cast_nullable_to_non_nullable
as String,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double,totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,weeklySchedule: freezed == weeklySchedule ? _self.weeklySchedule : weeklySchedule // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Truck].
extension TruckPatterns on Truck {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Truck value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Truck() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Truck value)  $default,){
final _that = this;
switch (_that) {
case _Truck():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Truck value)?  $default,){
final _that = this;
switch (_that) {
case _Truck() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String truckNumber,  String driverName,  TruckStatus status,  String foodType,  String locationDescription,  double latitude,  double longitude,  bool isFavorite,  String imageUrl,  String ownerEmail,  String? bankAccount,  String announcement,  int favoriteCount,  double avgRating,  int totalReviews,  bool isOpen,  Map<String, dynamic>? weeklySchedule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Truck() when $default != null:
return $default(_that.id,_that.truckNumber,_that.driverName,_that.status,_that.foodType,_that.locationDescription,_that.latitude,_that.longitude,_that.isFavorite,_that.imageUrl,_that.ownerEmail,_that.bankAccount,_that.announcement,_that.favoriteCount,_that.avgRating,_that.totalReviews,_that.isOpen,_that.weeklySchedule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String truckNumber,  String driverName,  TruckStatus status,  String foodType,  String locationDescription,  double latitude,  double longitude,  bool isFavorite,  String imageUrl,  String ownerEmail,  String? bankAccount,  String announcement,  int favoriteCount,  double avgRating,  int totalReviews,  bool isOpen,  Map<String, dynamic>? weeklySchedule)  $default,) {final _that = this;
switch (_that) {
case _Truck():
return $default(_that.id,_that.truckNumber,_that.driverName,_that.status,_that.foodType,_that.locationDescription,_that.latitude,_that.longitude,_that.isFavorite,_that.imageUrl,_that.ownerEmail,_that.bankAccount,_that.announcement,_that.favoriteCount,_that.avgRating,_that.totalReviews,_that.isOpen,_that.weeklySchedule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String truckNumber,  String driverName,  TruckStatus status,  String foodType,  String locationDescription,  double latitude,  double longitude,  bool isFavorite,  String imageUrl,  String ownerEmail,  String? bankAccount,  String announcement,  int favoriteCount,  double avgRating,  int totalReviews,  bool isOpen,  Map<String, dynamic>? weeklySchedule)?  $default,) {final _that = this;
switch (_that) {
case _Truck() when $default != null:
return $default(_that.id,_that.truckNumber,_that.driverName,_that.status,_that.foodType,_that.locationDescription,_that.latitude,_that.longitude,_that.isFavorite,_that.imageUrl,_that.ownerEmail,_that.bankAccount,_that.announcement,_that.favoriteCount,_that.avgRating,_that.totalReviews,_that.isOpen,_that.weeklySchedule);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Truck extends Truck {
  const _Truck({required this.id, required this.truckNumber, required this.driverName, required this.status, required this.foodType, required this.locationDescription, required this.latitude, required this.longitude, this.isFavorite = false, required this.imageUrl, this.ownerEmail = '', this.bankAccount, this.announcement = '', this.favoriteCount = 0, this.avgRating = 0.0, this.totalReviews = 0, this.isOpen = false, final  Map<String, dynamic>? weeklySchedule}): _weeklySchedule = weeklySchedule,super._();
  factory _Truck.fromJson(Map<String, dynamic> json) => _$TruckFromJson(json);

@override final  String id;
@override final  String truckNumber;
@override final  String driverName;
@override final  TruckStatus status;
@override final  String foodType;
@override final  String locationDescription;
@override final  double latitude;
@override final  double longitude;
@override@JsonKey() final  bool isFavorite;
@override final  String imageUrl;
@override@JsonKey() final  String ownerEmail;
// 사장님 이메일 (인증용)
@override final  String? bankAccount;
// 은행 계좌번호 (송금용 QR)
@override@JsonKey() final  String announcement;
// 오늘의 특별 공지
@override@JsonKey() final  int favoriteCount;
// 즐겨찾기 카운트 (전체 사용자)
@override@JsonKey() final  double avgRating;
// 평균 별점
@override@JsonKey() final  int totalReviews;
// 총 리뷰 개수
@override@JsonKey() final  bool isOpen;
// 영업 중 여부 (FCM 트리거용)
 final  Map<String, dynamic>? _weeklySchedule;
// 영업 중 여부 (FCM 트리거용)
@override Map<String, dynamic>? get weeklySchedule {
  final value = _weeklySchedule;
  if (value == null) return null;
  if (_weeklySchedule is EqualUnmodifiableMapView) return _weeklySchedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Truck
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TruckCopyWith<_Truck> get copyWith => __$TruckCopyWithImpl<_Truck>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TruckToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Truck&&(identical(other.id, id) || other.id == id)&&(identical(other.truckNumber, truckNumber) || other.truckNumber == truckNumber)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.status, status) || other.status == status)&&(identical(other.foodType, foodType) || other.foodType == foodType)&&(identical(other.locationDescription, locationDescription) || other.locationDescription == locationDescription)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.ownerEmail, ownerEmail) || other.ownerEmail == ownerEmail)&&(identical(other.bankAccount, bankAccount) || other.bankAccount == bankAccount)&&(identical(other.announcement, announcement) || other.announcement == announcement)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&const DeepCollectionEquality().equals(other._weeklySchedule, _weeklySchedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,truckNumber,driverName,status,foodType,locationDescription,latitude,longitude,isFavorite,imageUrl,ownerEmail,bankAccount,announcement,favoriteCount,avgRating,totalReviews,isOpen,const DeepCollectionEquality().hash(_weeklySchedule));

@override
String toString() {
  return 'Truck(id: $id, truckNumber: $truckNumber, driverName: $driverName, status: $status, foodType: $foodType, locationDescription: $locationDescription, latitude: $latitude, longitude: $longitude, isFavorite: $isFavorite, imageUrl: $imageUrl, ownerEmail: $ownerEmail, bankAccount: $bankAccount, announcement: $announcement, favoriteCount: $favoriteCount, avgRating: $avgRating, totalReviews: $totalReviews, isOpen: $isOpen, weeklySchedule: $weeklySchedule)';
}


}

/// @nodoc
abstract mixin class _$TruckCopyWith<$Res> implements $TruckCopyWith<$Res> {
  factory _$TruckCopyWith(_Truck value, $Res Function(_Truck) _then) = __$TruckCopyWithImpl;
@override @useResult
$Res call({
 String id, String truckNumber, String driverName, TruckStatus status, String foodType, String locationDescription, double latitude, double longitude, bool isFavorite, String imageUrl, String ownerEmail, String? bankAccount, String announcement, int favoriteCount, double avgRating, int totalReviews, bool isOpen, Map<String, dynamic>? weeklySchedule
});




}
/// @nodoc
class __$TruckCopyWithImpl<$Res>
    implements _$TruckCopyWith<$Res> {
  __$TruckCopyWithImpl(this._self, this._then);

  final _Truck _self;
  final $Res Function(_Truck) _then;

/// Create a copy of Truck
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? truckNumber = null,Object? driverName = null,Object? status = null,Object? foodType = null,Object? locationDescription = null,Object? latitude = null,Object? longitude = null,Object? isFavorite = null,Object? imageUrl = null,Object? ownerEmail = null,Object? bankAccount = freezed,Object? announcement = null,Object? favoriteCount = null,Object? avgRating = null,Object? totalReviews = null,Object? isOpen = null,Object? weeklySchedule = freezed,}) {
  return _then(_Truck(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,truckNumber: null == truckNumber ? _self.truckNumber : truckNumber // ignore: cast_nullable_to_non_nullable
as String,driverName: null == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TruckStatus,foodType: null == foodType ? _self.foodType : foodType // ignore: cast_nullable_to_non_nullable
as String,locationDescription: null == locationDescription ? _self.locationDescription : locationDescription // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,ownerEmail: null == ownerEmail ? _self.ownerEmail : ownerEmail // ignore: cast_nullable_to_non_nullable
as String,bankAccount: freezed == bankAccount ? _self.bankAccount : bankAccount // ignore: cast_nullable_to_non_nullable
as String?,announcement: null == announcement ? _self.announcement : announcement // ignore: cast_nullable_to_non_nullable
as String,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double,totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,weeklySchedule: freezed == weeklySchedule ? _self._weeklySchedule : weeklySchedule // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
