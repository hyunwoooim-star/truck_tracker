import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/bank_account.dart';

part 'bank_transfer_repository.g.dart';

@riverpod
BankTransferRepository bankTransferRepository(BankTransferRepositoryRef ref) {
  return BankTransferRepository(FirebaseFirestore.instance);
}

/// 계좌이체 관련 Repository
class BankTransferRepository {
  final FirebaseFirestore _firestore;

  BankTransferRepository(this._firestore);

  /// 트럭의 계좌 정보 조회
  Future<BankAccount?> getBankAccount(String truckId) async {
    try {
      final doc = await _firestore
          .collection('truck_details')
          .doc(truckId)
          .get();

      if (!doc.exists) {
        AppLogger.debug('No truck_details document for truck: $truckId', tag: 'BankTransferRepository');
        return null;
      }

      final data = doc.data();
      if (data == null || data['bankAccount'] == null) {
        AppLogger.debug('No bankAccount in truck_details: $truckId', tag: 'BankTransferRepository');
        return null;
      }

      final bankAccountData = data['bankAccount'] as Map<String, dynamic>;
      return BankAccount.fromJson(bankAccountData);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get bank account', error: e, stackTrace: stackTrace, tag: 'BankTransferRepository');
      return null;
    }
  }

  /// 트럭의 계좌 정보 저장/업데이트
  Future<void> saveBankAccount(String truckId, BankAccount bankAccount) async {
    try {
      await _firestore
          .collection('truck_details')
          .doc(truckId)
          .set({
        'bankAccount': bankAccount.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      AppLogger.success('Bank account saved for truck: $truckId', tag: 'BankTransferRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save bank account', error: e, stackTrace: stackTrace, tag: 'BankTransferRepository');
      rethrow;
    }
  }

  /// 트럭의 계좌 정보 삭제
  Future<void> deleteBankAccount(String truckId) async {
    try {
      await _firestore
          .collection('truck_details')
          .doc(truckId)
          .update({
        'bankAccount': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Bank account deleted for truck: $truckId', tag: 'BankTransferRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete bank account', error: e, stackTrace: stackTrace, tag: 'BankTransferRepository');
      rethrow;
    }
  }

  /// 계좌 정보 실시간 스트림
  Stream<BankAccount?> watchBankAccount(String truckId) {
    return _firestore
        .collection('truck_details')
        .doc(truckId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null || data['bankAccount'] == null) return null;

      final bankAccountData = data['bankAccount'] as Map<String, dynamic>;
      return BankAccount.fromJson(bankAccountData);
    });
  }
}

/// 계좌 정보 Provider
@riverpod
Future<BankAccount?> bankAccount(BankAccountRef ref, String truckId) async {
  final repository = ref.watch(bankTransferRepositoryProvider);
  return repository.getBankAccount(truckId);
}

/// 계좌 정보 실시간 Provider
@riverpod
Stream<BankAccount?> bankAccountStream(BankAccountStreamRef ref, String truckId) {
  final repository = ref.watch(bankTransferRepositoryProvider);
  return repository.watchBankAccount(truckId);
}
