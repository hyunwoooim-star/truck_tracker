import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_approval.freezed.dart';
part 'business_approval.g.dart';

enum ApprovalStatus { pending, approved, rejected }

@freezed
sealed class BusinessApproval with _$BusinessApproval {
  const BusinessApproval._();

  const factory BusinessApproval({
    required String truckId,
    required String ownerId,
    required String ownerEmail,
    required String truckName,
    @Default(0) int menuCount,
    @Default(false) bool scheduleSet,
    @Default(false) bool imageUploaded,
    @Default(ApprovalStatus.pending) ApprovalStatus status,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectionReason,
  }) = _BusinessApproval;

  factory BusinessApproval.fromJson(Map<String, dynamic> json) =>
      _$BusinessApprovalFromJson(json);

  factory BusinessApproval.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BusinessApproval(
      truckId: doc.id,
      ownerId: data['ownerId'] as String? ?? '',
      ownerEmail: data['ownerEmail'] as String? ?? '',
      truckName: data['truckName'] as String? ?? '',
      menuCount: data['menuCount'] as int? ?? 0,
      scheduleSet: data['scheduleSet'] as bool? ?? false,
      imageUploaded: data['imageUploaded'] as bool? ?? false,
      status: _statusFromString(data['status'] as String?),
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
      reviewedAt: (data['reviewedAt'] as Timestamp?)?.toDate(),
      reviewedBy: data['reviewedBy'] as String?,
      rejectionReason: data['rejectionReason'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'ownerEmail': ownerEmail,
      'truckName': truckName,
      'menuCount': menuCount,
      'scheduleSet': scheduleSet,
      'imageUploaded': imageUploaded,
      'status': status.name,
      'submittedAt': submittedAt != null
          ? Timestamp.fromDate(submittedAt!)
          : FieldValue.serverTimestamp(),
      'reviewedAt':
          reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
      'reviewedBy': reviewedBy,
      'rejectionReason': rejectionReason,
    };
  }

  static ApprovalStatus _statusFromString(String? status) {
    switch (status) {
      case 'approved':
        return ApprovalStatus.approved;
      case 'rejected':
        return ApprovalStatus.rejected;
      default:
        return ApprovalStatus.pending;
    }
  }

  bool get isPending => status == ApprovalStatus.pending;
  bool get isApproved => status == ApprovalStatus.approved;
  bool get isRejected => status == ApprovalStatus.rejected;
}
