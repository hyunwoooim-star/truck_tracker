// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walking_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalkingRoute _$WalkingRouteFromJson(Map<String, dynamic> json) =>
    _WalkingRoute(
      distanceMeters: (json['distanceMeters'] as num).toInt(),
      distanceText: json['distanceText'] as String,
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      durationText: json['durationText'] as String,
      startAddress: json['startAddress'] as String,
      endAddress: json['endAddress'] as String,
      polylinePoints: (json['polylinePoints'] as List<dynamic>)
          .map((e) => LatLngPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => RouteStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalkingRouteToJson(_WalkingRoute instance) =>
    <String, dynamic>{
      'distanceMeters': instance.distanceMeters,
      'distanceText': instance.distanceText,
      'durationSeconds': instance.durationSeconds,
      'durationText': instance.durationText,
      'startAddress': instance.startAddress,
      'endAddress': instance.endAddress,
      'polylinePoints': instance.polylinePoints,
      'steps': instance.steps,
    };

_RouteStep _$RouteStepFromJson(Map<String, dynamic> json) => _RouteStep(
  instruction: json['instruction'] as String,
  distanceMeters: (json['distanceMeters'] as num).toInt(),
  distanceText: json['distanceText'] as String,
  durationSeconds: (json['durationSeconds'] as num).toInt(),
  durationText: json['durationText'] as String,
  startLat: (json['startLat'] as num).toDouble(),
  startLng: (json['startLng'] as num).toDouble(),
  endLat: (json['endLat'] as num).toDouble(),
  endLng: (json['endLng'] as num).toDouble(),
  maneuver: json['maneuver'] as String?,
);

Map<String, dynamic> _$RouteStepToJson(_RouteStep instance) =>
    <String, dynamic>{
      'instruction': instance.instruction,
      'distanceMeters': instance.distanceMeters,
      'distanceText': instance.distanceText,
      'durationSeconds': instance.durationSeconds,
      'durationText': instance.durationText,
      'startLat': instance.startLat,
      'startLng': instance.startLng,
      'endLat': instance.endLat,
      'endLng': instance.endLng,
      'maneuver': instance.maneuver,
    };

_LatLngPoint _$LatLngPointFromJson(Map<String, dynamic> json) => _LatLngPoint(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
);

Map<String, dynamic> _$LatLngPointToJson(_LatLngPoint instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};
