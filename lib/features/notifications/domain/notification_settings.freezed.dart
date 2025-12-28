// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationSettings _$NotificationSettingsFromJson(Map<String, dynamic> json) {
  return _NotificationSettings.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettings {
  String get userId => throw _privateConstructorUsedError;
  bool get truckOpenings => throw _privateConstructorUsedError; // 트럭 영업 시작
  bool get orderUpdates => throw _privateConstructorUsedError; // 주문 상태 변경
  bool get newCoupons => throw _privateConstructorUsedError; // 새 쿠폰 발행
  bool get reviews => throw _privateConstructorUsedError; // 리뷰 답글
  bool get promotions => throw _privateConstructorUsedError; // 프로모션
  bool get nearbyTrucks => throw _privateConstructorUsedError; // 근처 트럭 (위치 기반)
  int get nearbyRadius => throw _privateConstructorUsedError; // 반경 (미터), 기본 1km
  bool get followedTrucks => throw _privateConstructorUsedError; // 팔로우한 트럭 활동
  bool get chatMessages => throw _privateConstructorUsedError; // 채팅 메시지
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsCopyWith<NotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsCopyWith<$Res> {
  factory $NotificationSettingsCopyWith(
    NotificationSettings value,
    $Res Function(NotificationSettings) then,
  ) = _$NotificationSettingsCopyWithImpl<$Res, NotificationSettings>;
  @useResult
  $Res call({
    String userId,
    bool truckOpenings,
    bool orderUpdates,
    bool newCoupons,
    bool reviews,
    bool promotions,
    bool nearbyTrucks,
    int nearbyRadius,
    bool followedTrucks,
    bool chatMessages,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class _$NotificationSettingsCopyWithImpl<
  $Res,
  $Val extends NotificationSettings
>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? truckOpenings = null,
    Object? orderUpdates = null,
    Object? newCoupons = null,
    Object? reviews = null,
    Object? promotions = null,
    Object? nearbyTrucks = null,
    Object? nearbyRadius = null,
    Object? followedTrucks = null,
    Object? chatMessages = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            truckOpenings: null == truckOpenings
                ? _value.truckOpenings
                : truckOpenings // ignore: cast_nullable_to_non_nullable
                      as bool,
            orderUpdates: null == orderUpdates
                ? _value.orderUpdates
                : orderUpdates // ignore: cast_nullable_to_non_nullable
                      as bool,
            newCoupons: null == newCoupons
                ? _value.newCoupons
                : newCoupons // ignore: cast_nullable_to_non_nullable
                      as bool,
            reviews: null == reviews
                ? _value.reviews
                : reviews // ignore: cast_nullable_to_non_nullable
                      as bool,
            promotions: null == promotions
                ? _value.promotions
                : promotions // ignore: cast_nullable_to_non_nullable
                      as bool,
            nearbyTrucks: null == nearbyTrucks
                ? _value.nearbyTrucks
                : nearbyTrucks // ignore: cast_nullable_to_non_nullable
                      as bool,
            nearbyRadius: null == nearbyRadius
                ? _value.nearbyRadius
                : nearbyRadius // ignore: cast_nullable_to_non_nullable
                      as int,
            followedTrucks: null == followedTrucks
                ? _value.followedTrucks
                : followedTrucks // ignore: cast_nullable_to_non_nullable
                      as bool,
            chatMessages: null == chatMessages
                ? _value.chatMessages
                : chatMessages // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastUpdated: freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationSettingsImplCopyWith<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  factory _$$NotificationSettingsImplCopyWith(
    _$NotificationSettingsImpl value,
    $Res Function(_$NotificationSettingsImpl) then,
  ) = __$$NotificationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    bool truckOpenings,
    bool orderUpdates,
    bool newCoupons,
    bool reviews,
    bool promotions,
    bool nearbyTrucks,
    int nearbyRadius,
    bool followedTrucks,
    bool chatMessages,
    DateTime? lastUpdated,
  });
}

/// @nodoc
class __$$NotificationSettingsImplCopyWithImpl<$Res>
    extends _$NotificationSettingsCopyWithImpl<$Res, _$NotificationSettingsImpl>
    implements _$$NotificationSettingsImplCopyWith<$Res> {
  __$$NotificationSettingsImplCopyWithImpl(
    _$NotificationSettingsImpl _value,
    $Res Function(_$NotificationSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? truckOpenings = null,
    Object? orderUpdates = null,
    Object? newCoupons = null,
    Object? reviews = null,
    Object? promotions = null,
    Object? nearbyTrucks = null,
    Object? nearbyRadius = null,
    Object? followedTrucks = null,
    Object? chatMessages = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(
      _$NotificationSettingsImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        truckOpenings: null == truckOpenings
            ? _value.truckOpenings
            : truckOpenings // ignore: cast_nullable_to_non_nullable
                  as bool,
        orderUpdates: null == orderUpdates
            ? _value.orderUpdates
            : orderUpdates // ignore: cast_nullable_to_non_nullable
                  as bool,
        newCoupons: null == newCoupons
            ? _value.newCoupons
            : newCoupons // ignore: cast_nullable_to_non_nullable
                  as bool,
        reviews: null == reviews
            ? _value.reviews
            : reviews // ignore: cast_nullable_to_non_nullable
                  as bool,
        promotions: null == promotions
            ? _value.promotions
            : promotions // ignore: cast_nullable_to_non_nullable
                  as bool,
        nearbyTrucks: null == nearbyTrucks
            ? _value.nearbyTrucks
            : nearbyTrucks // ignore: cast_nullable_to_non_nullable
                  as bool,
        nearbyRadius: null == nearbyRadius
            ? _value.nearbyRadius
            : nearbyRadius // ignore: cast_nullable_to_non_nullable
                  as int,
        followedTrucks: null == followedTrucks
            ? _value.followedTrucks
            : followedTrucks // ignore: cast_nullable_to_non_nullable
                  as bool,
        chatMessages: null == chatMessages
            ? _value.chatMessages
            : chatMessages // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastUpdated: freezed == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsImpl extends _NotificationSettings {
  const _$NotificationSettingsImpl({
    required this.userId,
    this.truckOpenings = true,
    this.orderUpdates = true,
    this.newCoupons = true,
    this.reviews = true,
    this.promotions = true,
    this.nearbyTrucks = false,
    this.nearbyRadius = 1000,
    this.followedTrucks = true,
    this.chatMessages = true,
    this.lastUpdated,
  }) : super._();

  factory _$NotificationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final bool truckOpenings;
  // 트럭 영업 시작
  @override
  @JsonKey()
  final bool orderUpdates;
  // 주문 상태 변경
  @override
  @JsonKey()
  final bool newCoupons;
  // 새 쿠폰 발행
  @override
  @JsonKey()
  final bool reviews;
  // 리뷰 답글
  @override
  @JsonKey()
  final bool promotions;
  // 프로모션
  @override
  @JsonKey()
  final bool nearbyTrucks;
  // 근처 트럭 (위치 기반)
  @override
  @JsonKey()
  final int nearbyRadius;
  // 반경 (미터), 기본 1km
  @override
  @JsonKey()
  final bool followedTrucks;
  // 팔로우한 트럭 활동
  @override
  @JsonKey()
  final bool chatMessages;
  // 채팅 메시지
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'NotificationSettings(userId: $userId, truckOpenings: $truckOpenings, orderUpdates: $orderUpdates, newCoupons: $newCoupons, reviews: $reviews, promotions: $promotions, nearbyTrucks: $nearbyTrucks, nearbyRadius: $nearbyRadius, followedTrucks: $followedTrucks, chatMessages: $chatMessages, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.truckOpenings, truckOpenings) ||
                other.truckOpenings == truckOpenings) &&
            (identical(other.orderUpdates, orderUpdates) ||
                other.orderUpdates == orderUpdates) &&
            (identical(other.newCoupons, newCoupons) ||
                other.newCoupons == newCoupons) &&
            (identical(other.reviews, reviews) || other.reviews == reviews) &&
            (identical(other.promotions, promotions) ||
                other.promotions == promotions) &&
            (identical(other.nearbyTrucks, nearbyTrucks) ||
                other.nearbyTrucks == nearbyTrucks) &&
            (identical(other.nearbyRadius, nearbyRadius) ||
                other.nearbyRadius == nearbyRadius) &&
            (identical(other.followedTrucks, followedTrucks) ||
                other.followedTrucks == followedTrucks) &&
            (identical(other.chatMessages, chatMessages) ||
                other.chatMessages == chatMessages) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    truckOpenings,
    orderUpdates,
    newCoupons,
    reviews,
    promotions,
    nearbyTrucks,
    nearbyRadius,
    followedTrucks,
    chatMessages,
    lastUpdated,
  );

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
  get copyWith =>
      __$$NotificationSettingsImplCopyWithImpl<_$NotificationSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsImplToJson(this);
  }
}

abstract class _NotificationSettings extends NotificationSettings {
  const factory _NotificationSettings({
    required final String userId,
    final bool truckOpenings,
    final bool orderUpdates,
    final bool newCoupons,
    final bool reviews,
    final bool promotions,
    final bool nearbyTrucks,
    final int nearbyRadius,
    final bool followedTrucks,
    final bool chatMessages,
    final DateTime? lastUpdated,
  }) = _$NotificationSettingsImpl;
  const _NotificationSettings._() : super._();

  factory _NotificationSettings.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsImpl.fromJson;

  @override
  String get userId;
  @override
  bool get truckOpenings; // 트럭 영업 시작
  @override
  bool get orderUpdates; // 주문 상태 변경
  @override
  bool get newCoupons; // 새 쿠폰 발행
  @override
  bool get reviews; // 리뷰 답글
  @override
  bool get promotions; // 프로모션
  @override
  bool get nearbyTrucks; // 근처 트럭 (위치 기반)
  @override
  int get nearbyRadius; // 반경 (미터), 기본 1km
  @override
  bool get followedTrucks; // 팔로우한 트럭 활동
  @override
  bool get chatMessages; // 채팅 메시지
  @override
  DateTime? get lastUpdated;

  /// Create a copy of NotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
