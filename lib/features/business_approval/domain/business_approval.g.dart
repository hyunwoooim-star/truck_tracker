// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_approval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusinessApproval _$BusinessApprovalFromJson(Map<String, dynamic> json) =>
    _BusinessApproval(
      truckId: json['truckId'] as String,
      ownerId: json['ownerId'] as String,
      ownerEmail: json['ownerEmail'] as String,
      truckName: json['truckName'] as String,
      menuCount: (json['menuCount'] as num?)?.toInt() ?? 0,
      scheduleSet: json['scheduleSet'] as bool? ?? false,
      imageUploaded: json['imageUploaded'] as bool? ?? false,
      status:
          $enumDecodeNullable(_$ApprovalStatusEnumMap, json['status']) ??
          ApprovalStatus.pending,
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      reviewedBy: json['reviewedBy'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );

Map<String, dynamic> _$BusinessApprovalToJson(_BusinessApproval instance) =>
    <String, dynamic>{
      'truckId': instance.truckId,
      'ownerId': instance.ownerId,
      'ownerEmail': instance.ownerEmail,
      'truckName': instance.truckName,
      'menuCount': instance.menuCount,
      'scheduleSet': instance.scheduleSet,
      'imageUploaded': instance.imageUploaded,
      'status': _$ApprovalStatusEnumMap[instance.status]!,
      'submittedAt': instance.submittedAt?.toIso8601String(),
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'reviewedBy': instance.reviewedBy,
      'rejectionReason': instance.rejectionReason,
    };

const _$ApprovalStatusEnumMap = {
  ApprovalStatus.pending: 'pending',
  ApprovalStatus.approved: 'approved',
  ApprovalStatus.rejected: 'rejected',
};
