import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_account.freezed.dart';
part 'bank_account.g.dart';

/// 계좌 정보 모델
@freezed
class BankAccount with _$BankAccount {
  const BankAccount._();

  const factory BankAccount({
    required String bankName, // 은행명 (예: 국민은행)
    required String accountNumber, // 계좌번호
    required String accountHolder, // 예금주
    String? bankCode, // 은행 코드 (선택사항)
  }) = _BankAccount;

  /// Firestore에서 읽기
  factory BankAccount.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BankAccount(
      bankName: data['bankName'] as String? ?? '',
      accountNumber: data['accountNumber'] as String? ?? '',
      accountHolder: data['accountHolder'] as String? ?? '',
      bankCode: data['bankCode'] as String?,
    );
  }

  /// Firestore에 쓰기
  Map<String, dynamic> toFirestore() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolder': accountHolder,
      if (bankCode != null) 'bankCode': bankCode,
    };
  }

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);

  /// 계좌번호 포맷팅 (하이픈 제거)
  String get formattedAccountNumber {
    return accountNumber.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// 복사용 텍스트 (은행명 예금주 계좌번호)
  String get copyText {
    return '$bankName $accountHolder $accountNumber';
  }

  /// 유효성 검증
  bool get isValid {
    return bankName.isNotEmpty &&
        accountNumber.isNotEmpty &&
        accountHolder.isNotEmpty &&
        formattedAccountNumber.length >= 10; // 최소 10자리
  }
}
