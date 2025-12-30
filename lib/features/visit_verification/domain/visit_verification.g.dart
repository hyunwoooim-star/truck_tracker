// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisitVerification _$VisitVerificationFromJson(Map<String, dynamic> json) =>
    _VisitVerification(
      id: json['id'] as String,
      visitorId: json['visitorId'] as String,
      visitorName: json['visitorName'] as String,
      visitorPhotoUrl: json['visitorPhotoUrl'] as String?,
      truckId: json['truckId'] as String,
      truckName: json['truckName'] as String,
      verifiedAt: DateTime.parse(json['verifiedAt'] as String),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$VisitVerificationToJson(_VisitVerification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'visitorId': instance.visitorId,
      'visitorName': instance.visitorName,
      'visitorPhotoUrl': instance.visitorPhotoUrl,
      'truckId': instance.truckId,
      'truckName': instance.truckName,
      'verifiedAt': instance.verifiedAt.toIso8601String(),
      'distanceMeters': instance.distanceMeters,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
