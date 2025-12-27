// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truck.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Truck _$TruckFromJson(Map<String, dynamic> json) {
  return _Truck.fromJson(json);
}

/// @nodoc
mixin _$Truck {
  String get id => throw _privateConstructorUsedError;
  String get truckNumber => throw _privateConstructorUsedError;
  String get driverName => throw _privateConstructorUsedError;
  TruckStatus get status => throw _privateConstructorUsedError;
  String get foodType => throw _privateConstructorUsedError;
  String get locationDescription => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get ownerEmail => throw _privateConstructorUsedError; // 사장님 이메일 (인증용)
  String? get bankAccount =>
      throw _privateConstructorUsedError; // 은행 계좌번호 (송금용 QR)
  String get announcement => throw _privateConstructorUsedError; // 오늘의 특별 공지
  int get favoriteCount =>
      throw _privateConstructorUsedError; // 즐겨찾기 카운트 (전체 사용자)
  double get avgRating => throw _privateConstructorUsedError; // 평균 별점
  int get totalReviews => throw _privateConstructorUsedError; // 총 리뷰 개수
  bool get isOpen => throw _privateConstructorUsedError; // 영업 중 여부 (FCM 트리거용)
  Map<String, dynamic>? get weeklySchedule =>
      throw _privateConstructorUsedError;

  /// Serializes this Truck to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Truck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TruckCopyWith<Truck> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TruckCopyWith<$Res> {
  factory $TruckCopyWith(Truck value, $Res Function(Truck) then) =
      _$TruckCopyWithImpl<$Res, Truck>;
  @useResult
  $Res call({
    String id,
    String truckNumber,
    String driverName,
    TruckStatus status,
    String foodType,
    String locationDescription,
    double latitude,
    double longitude,
    bool isFavorite,
    String imageUrl,
    String ownerEmail,
    String? bankAccount,
    String announcement,
    int favoriteCount,
    double avgRating,
    int totalReviews,
    bool isOpen,
    Map<String, dynamic>? weeklySchedule,
  });
}

/// @nodoc
class _$TruckCopyWithImpl<$Res, $Val extends Truck>
    implements $TruckCopyWith<$Res> {
  _$TruckCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Truck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? truckNumber = null,
    Object? driverName = null,
    Object? status = null,
    Object? foodType = null,
    Object? locationDescription = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? isFavorite = null,
    Object? imageUrl = null,
    Object? ownerEmail = null,
    Object? bankAccount = freezed,
    Object? announcement = null,
    Object? favoriteCount = null,
    Object? avgRating = null,
    Object? totalReviews = null,
    Object? isOpen = null,
    Object? weeklySchedule = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            truckNumber: null == truckNumber
                ? _value.truckNumber
                : truckNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            driverName: null == driverName
                ? _value.driverName
                : driverName // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TruckStatus,
            foodType: null == foodType
                ? _value.foodType
                : foodType // ignore: cast_nullable_to_non_nullable
                      as String,
            locationDescription: null == locationDescription
                ? _value.locationDescription
                : locationDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerEmail: null == ownerEmail
                ? _value.ownerEmail
                : ownerEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            bankAccount: freezed == bankAccount
                ? _value.bankAccount
                : bankAccount // ignore: cast_nullable_to_non_nullable
                      as String?,
            announcement: null == announcement
                ? _value.announcement
                : announcement // ignore: cast_nullable_to_non_nullable
                      as String,
            favoriteCount: null == favoriteCount
                ? _value.favoriteCount
                : favoriteCount // ignore: cast_nullable_to_non_nullable
                      as int,
            avgRating: null == avgRating
                ? _value.avgRating
                : avgRating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReviews: null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int,
            isOpen: null == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                      as bool,
            weeklySchedule: freezed == weeklySchedule
                ? _value.weeklySchedule
                : weeklySchedule // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TruckImplCopyWith<$Res> implements $TruckCopyWith<$Res> {
  factory _$$TruckImplCopyWith(
    _$TruckImpl value,
    $Res Function(_$TruckImpl) then,
  ) = __$$TruckImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String truckNumber,
    String driverName,
    TruckStatus status,
    String foodType,
    String locationDescription,
    double latitude,
    double longitude,
    bool isFavorite,
    String imageUrl,
    String ownerEmail,
    String? bankAccount,
    String announcement,
    int favoriteCount,
    double avgRating,
    int totalReviews,
    bool isOpen,
    Map<String, dynamic>? weeklySchedule,
  });
}

/// @nodoc
class __$$TruckImplCopyWithImpl<$Res>
    extends _$TruckCopyWithImpl<$Res, _$TruckImpl>
    implements _$$TruckImplCopyWith<$Res> {
  __$$TruckImplCopyWithImpl(
    _$TruckImpl _value,
    $Res Function(_$TruckImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Truck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? truckNumber = null,
    Object? driverName = null,
    Object? status = null,
    Object? foodType = null,
    Object? locationDescription = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? isFavorite = null,
    Object? imageUrl = null,
    Object? ownerEmail = null,
    Object? bankAccount = freezed,
    Object? announcement = null,
    Object? favoriteCount = null,
    Object? avgRating = null,
    Object? totalReviews = null,
    Object? isOpen = null,
    Object? weeklySchedule = freezed,
  }) {
    return _then(
      _$TruckImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        truckNumber: null == truckNumber
            ? _value.truckNumber
            : truckNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        driverName: null == driverName
            ? _value.driverName
            : driverName // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TruckStatus,
        foodType: null == foodType
            ? _value.foodType
            : foodType // ignore: cast_nullable_to_non_nullable
                  as String,
        locationDescription: null == locationDescription
            ? _value.locationDescription
            : locationDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerEmail: null == ownerEmail
            ? _value.ownerEmail
            : ownerEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        bankAccount: freezed == bankAccount
            ? _value.bankAccount
            : bankAccount // ignore: cast_nullable_to_non_nullable
                  as String?,
        announcement: null == announcement
            ? _value.announcement
            : announcement // ignore: cast_nullable_to_non_nullable
                  as String,
        favoriteCount: null == favoriteCount
            ? _value.favoriteCount
            : favoriteCount // ignore: cast_nullable_to_non_nullable
                  as int,
        avgRating: null == avgRating
            ? _value.avgRating
            : avgRating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReviews: null == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int,
        isOpen: null == isOpen
            ? _value.isOpen
            : isOpen // ignore: cast_nullable_to_non_nullable
                  as bool,
        weeklySchedule: freezed == weeklySchedule
            ? _value._weeklySchedule
            : weeklySchedule // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TruckImpl extends _Truck {
  const _$TruckImpl({
    required this.id,
    required this.truckNumber,
    required this.driverName,
    required this.status,
    required this.foodType,
    required this.locationDescription,
    required this.latitude,
    required this.longitude,
    this.isFavorite = false,
    required this.imageUrl,
    this.ownerEmail = '',
    this.bankAccount,
    this.announcement = '',
    this.favoriteCount = 0,
    this.avgRating = 0.0,
    this.totalReviews = 0,
    this.isOpen = false,
    final Map<String, dynamic>? weeklySchedule,
  }) : _weeklySchedule = weeklySchedule,
       super._();

  factory _$TruckImpl.fromJson(Map<String, dynamic> json) =>
      _$$TruckImplFromJson(json);

  @override
  final String id;
  @override
  final String truckNumber;
  @override
  final String driverName;
  @override
  final TruckStatus status;
  @override
  final String foodType;
  @override
  final String locationDescription;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final String imageUrl;
  @override
  @JsonKey()
  final String ownerEmail;
  // 사장님 이메일 (인증용)
  @override
  final String? bankAccount;
  // 은행 계좌번호 (송금용 QR)
  @override
  @JsonKey()
  final String announcement;
  // 오늘의 특별 공지
  @override
  @JsonKey()
  final int favoriteCount;
  // 즐겨찾기 카운트 (전체 사용자)
  @override
  @JsonKey()
  final double avgRating;
  // 평균 별점
  @override
  @JsonKey()
  final int totalReviews;
  // 총 리뷰 개수
  @override
  @JsonKey()
  final bool isOpen;
  // 영업 중 여부 (FCM 트리거용)
  final Map<String, dynamic>? _weeklySchedule;
  // 영업 중 여부 (FCM 트리거용)
  @override
  Map<String, dynamic>? get weeklySchedule {
    final value = _weeklySchedule;
    if (value == null) return null;
    if (_weeklySchedule is EqualUnmodifiableMapView) return _weeklySchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Truck(id: $id, truckNumber: $truckNumber, driverName: $driverName, status: $status, foodType: $foodType, locationDescription: $locationDescription, latitude: $latitude, longitude: $longitude, isFavorite: $isFavorite, imageUrl: $imageUrl, ownerEmail: $ownerEmail, bankAccount: $bankAccount, announcement: $announcement, favoriteCount: $favoriteCount, avgRating: $avgRating, totalReviews: $totalReviews, isOpen: $isOpen, weeklySchedule: $weeklySchedule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TruckImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.truckNumber, truckNumber) ||
                other.truckNumber == truckNumber) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.foodType, foodType) ||
                other.foodType == foodType) &&
            (identical(other.locationDescription, locationDescription) ||
                other.locationDescription == locationDescription) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.ownerEmail, ownerEmail) ||
                other.ownerEmail == ownerEmail) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.announcement, announcement) ||
                other.announcement == announcement) &&
            (identical(other.favoriteCount, favoriteCount) ||
                other.favoriteCount == favoriteCount) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            const DeepCollectionEquality().equals(
              other._weeklySchedule,
              _weeklySchedule,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    truckNumber,
    driverName,
    status,
    foodType,
    locationDescription,
    latitude,
    longitude,
    isFavorite,
    imageUrl,
    ownerEmail,
    bankAccount,
    announcement,
    favoriteCount,
    avgRating,
    totalReviews,
    isOpen,
    const DeepCollectionEquality().hash(_weeklySchedule),
  );

  /// Create a copy of Truck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TruckImplCopyWith<_$TruckImpl> get copyWith =>
      __$$TruckImplCopyWithImpl<_$TruckImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TruckImplToJson(this);
  }
}

abstract class _Truck extends Truck {
  const factory _Truck({
    required final String id,
    required final String truckNumber,
    required final String driverName,
    required final TruckStatus status,
    required final String foodType,
    required final String locationDescription,
    required final double latitude,
    required final double longitude,
    final bool isFavorite,
    required final String imageUrl,
    final String ownerEmail,
    final String? bankAccount,
    final String announcement,
    final int favoriteCount,
    final double avgRating,
    final int totalReviews,
    final bool isOpen,
    final Map<String, dynamic>? weeklySchedule,
  }) = _$TruckImpl;
  const _Truck._() : super._();

  factory _Truck.fromJson(Map<String, dynamic> json) = _$TruckImpl.fromJson;

  @override
  String get id;
  @override
  String get truckNumber;
  @override
  String get driverName;
  @override
  TruckStatus get status;
  @override
  String get foodType;
  @override
  String get locationDescription;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  bool get isFavorite;
  @override
  String get imageUrl;
  @override
  String get ownerEmail; // 사장님 이메일 (인증용)
  @override
  String? get bankAccount; // 은행 계좌번호 (송금용 QR)
  @override
  String get announcement; // 오늘의 특별 공지
  @override
  int get favoriteCount; // 즐겨찾기 카운트 (전체 사용자)
  @override
  double get avgRating; // 평균 별점
  @override
  int get totalReviews; // 총 리뷰 개수
  @override
  bool get isOpen; // 영업 중 여부 (FCM 트리거용)
  @override
  Map<String, dynamic>? get weeklySchedule;

  /// Create a copy of Truck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TruckImplCopyWith<_$TruckImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
