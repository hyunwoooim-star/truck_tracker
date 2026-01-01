import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/business_approval.dart';

part 'business_approval_repository.g.dart';

/// 영업 승인 요청 레포지토리
class BusinessApprovalRepository {
  BusinessApprovalRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('business_approvals');

  /// 승인 요청 생성
  Future<void> submitApproval(BusinessApproval approval) async {
    await _collection.doc(approval.truckId).set(approval.toFirestore());
  }

  /// 승인 요청 조회 (트럭 ID로)
  Future<BusinessApproval?> getApproval(String truckId) async {
    final doc = await _collection.doc(truckId).get();
    if (!doc.exists) return null;
    return BusinessApproval.fromFirestore(doc);
  }

  /// 승인 요청 스트림 (트럭 ID로)
  Stream<BusinessApproval?> watchApproval(String truckId) {
    return _collection.doc(truckId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return BusinessApproval.fromFirestore(doc);
    });
  }

  /// 대기 중인 승인 요청 목록 (관리자용)
  Stream<List<BusinessApproval>> watchPendingApprovals() {
    return _collection
        .where('status', isEqualTo: ApprovalStatus.pending.name)
        .orderBy('submittedAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BusinessApproval.fromFirestore(doc))
            .toList());
  }

  /// 모든 승인 요청 목록 (관리자용)
  Stream<List<BusinessApproval>> watchAllApprovals() {
    return _collection
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BusinessApproval.fromFirestore(doc))
            .toList());
  }

  /// 승인 처리 (관리자)
  Future<void> approve({
    required String truckId,
    required String reviewedBy,
  }) async {
    await _collection.doc(truckId).update({
      'status': ApprovalStatus.approved.name,
      'reviewedAt': FieldValue.serverTimestamp(),
      'reviewedBy': reviewedBy,
    });
  }

  /// 반려 처리 (관리자)
  Future<void> reject({
    required String truckId,
    required String reviewedBy,
    required String reason,
  }) async {
    await _collection.doc(truckId).update({
      'status': ApprovalStatus.rejected.name,
      'reviewedAt': FieldValue.serverTimestamp(),
      'reviewedBy': reviewedBy,
      'rejectionReason': reason,
    });
  }

  /// 재신청 (승인 요청 업데이트)
  Future<void> resubmit(BusinessApproval approval) async {
    final data = approval.toFirestore();
    data['status'] = ApprovalStatus.pending.name;
    data['submittedAt'] = FieldValue.serverTimestamp();
    data['reviewedAt'] = null;
    data['reviewedBy'] = null;
    data['rejectionReason'] = null;
    await _collection.doc(approval.truckId).set(data);
  }

  /// 승인 요청 삭제
  Future<void> deleteApproval(String truckId) async {
    await _collection.doc(truckId).delete();
  }
}

@riverpod
BusinessApprovalRepository businessApprovalRepository(
  BusinessApprovalRepositoryRef ref,
) {
  return BusinessApprovalRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<BusinessApproval?> businessApproval(
  BusinessApprovalRef ref,
  String truckId,
) {
  final repository = ref.watch(businessApprovalRepositoryProvider);
  return repository.watchApproval(truckId);
}

@riverpod
Stream<List<BusinessApproval>> pendingApprovals(PendingApprovalsRef ref) {
  final repository = ref.watch(businessApprovalRepositoryProvider);
  return repository.watchPendingApprovals();
}

@riverpod
Stream<List<BusinessApproval>> allApprovals(AllApprovalsRef ref) {
  final repository = ref.watch(businessApprovalRepositoryProvider);
  return repository.watchAllApprovals();
}
