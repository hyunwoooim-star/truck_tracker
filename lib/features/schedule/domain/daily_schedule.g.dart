// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyScheduleImpl _$$DailyScheduleImplFromJson(Map<String, dynamic> json) =>
    _$DailyScheduleImpl(
      isOpen: json['isOpen'] as bool? ?? false,
      location: json['location'] as String? ?? '',
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$DailyScheduleImplToJson(_$DailyScheduleImpl instance) =>
    <String, dynamic>{
      'isOpen': instance.isOpen,
      'location': instance.location,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
