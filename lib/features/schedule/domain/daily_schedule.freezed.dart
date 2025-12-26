// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailySchedule _$DailyScheduleFromJson(Map<String, dynamic> json) {
  return _DailySchedule.fromJson(json);
}

/// @nodoc
mixin _$DailySchedule {
  bool get isOpen => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError; // "18:00"
  String? get endTime => throw _privateConstructorUsedError; // "23:00"
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;

  /// Serializes this DailySchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailySchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyScheduleCopyWith<DailySchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyScheduleCopyWith<$Res> {
  factory $DailyScheduleCopyWith(
    DailySchedule value,
    $Res Function(DailySchedule) then,
  ) = _$DailyScheduleCopyWithImpl<$Res, DailySchedule>;
  @useResult
  $Res call({
    bool isOpen,
    String location,
    String? startTime,
    String? endTime,
    double? latitude,
    double? longitude,
  });
}

/// @nodoc
class _$DailyScheduleCopyWithImpl<$Res, $Val extends DailySchedule>
    implements $DailyScheduleCopyWith<$Res> {
  _$DailyScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailySchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOpen = null,
    Object? location = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(
      _value.copyWith(
            isOpen: null == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                      as bool,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyScheduleImplCopyWith<$Res>
    implements $DailyScheduleCopyWith<$Res> {
  factory _$$DailyScheduleImplCopyWith(
    _$DailyScheduleImpl value,
    $Res Function(_$DailyScheduleImpl) then,
  ) = __$$DailyScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isOpen,
    String location,
    String? startTime,
    String? endTime,
    double? latitude,
    double? longitude,
  });
}

/// @nodoc
class __$$DailyScheduleImplCopyWithImpl<$Res>
    extends _$DailyScheduleCopyWithImpl<$Res, _$DailyScheduleImpl>
    implements _$$DailyScheduleImplCopyWith<$Res> {
  __$$DailyScheduleImplCopyWithImpl(
    _$DailyScheduleImpl _value,
    $Res Function(_$DailyScheduleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailySchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOpen = null,
    Object? location = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(
      _$DailyScheduleImpl(
        isOpen: null == isOpen
            ? _value.isOpen
            : isOpen // ignore: cast_nullable_to_non_nullable
                  as bool,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyScheduleImpl implements _DailySchedule {
  const _$DailyScheduleImpl({
    this.isOpen = false,
    this.location = '',
    this.startTime,
    this.endTime,
    this.latitude,
    this.longitude,
  });

  factory _$DailyScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyScheduleImplFromJson(json);

  @override
  @JsonKey()
  final bool isOpen;
  @override
  @JsonKey()
  final String location;
  @override
  final String? startTime;
  // "18:00"
  @override
  final String? endTime;
  // "23:00"
  @override
  final double? latitude;
  @override
  final double? longitude;

  @override
  String toString() {
    return 'DailySchedule(isOpen: $isOpen, location: $location, startTime: $startTime, endTime: $endTime, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyScheduleImpl &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isOpen,
    location,
    startTime,
    endTime,
    latitude,
    longitude,
  );

  /// Create a copy of DailySchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyScheduleImplCopyWith<_$DailyScheduleImpl> get copyWith =>
      __$$DailyScheduleImplCopyWithImpl<_$DailyScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyScheduleImplToJson(this);
  }
}

abstract class _DailySchedule implements DailySchedule {
  const factory _DailySchedule({
    final bool isOpen,
    final String location,
    final String? startTime,
    final String? endTime,
    final double? latitude,
    final double? longitude,
  }) = _$DailyScheduleImpl;

  factory _DailySchedule.fromJson(Map<String, dynamic> json) =
      _$DailyScheduleImpl.fromJson;

  @override
  bool get isOpen;
  @override
  String get location;
  @override
  String? get startTime; // "18:00"
  @override
  String? get endTime; // "23:00"
  @override
  double? get latitude;
  @override
  double? get longitude;

  /// Create a copy of DailySchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyScheduleImplCopyWith<_$DailyScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
