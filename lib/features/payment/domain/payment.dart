import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

/// Payment method types
enum PaymentMethodType {
  card, // 카드
  transfer, // 계좌이체
  virtualAccount, // 가상계좌
  mobilePay, // 휴대폰 결제
  tossPay, // 토스페이
  kakaoPay, // 카카오페이
  naverPay, // 네이버페이
  cash, // 현금 (오프라인)
}

/// Payment status
enum PaymentStatus {
  pending, // 결제 대기
  inProgress, // 결제 진행 중
  completed, // 결제 완료
  failed, // 결제 실패
  cancelled, // 결제 취소
  refunded, // 환불 완료
  partialRefunded, // 부분 환불
}

/// Payment model for tracking payment transactions
@freezed
sealed class Payment with _$Payment {
  const Payment._();

  const factory Payment({
    required String id,
    required String orderId,
    required String userId,
    required int amount,
    required PaymentMethodType method,
    required PaymentStatus status,
    String? paymentKey, // TossPayments 결제 키
    String? transactionId, // PG사 거래 ID
    String? receiptUrl, // 영수증 URL
    String? cardNumber, // 카드번호 마스킹
    String? cardCompany, // 카드사
    String? bankName, // 은행명 (계좌이체/가상계좌)
    String? accountNumber, // 계좌번호 (가상계좌)
    String? failReason, // 실패 사유
    DateTime? paidAt, // 결제 완료 시각
    DateTime? cancelledAt, // 취소 시각
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  /// Create from Firestore document
  factory Payment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Payment(
      id: doc.id,
      orderId: data['orderId'] ?? '',
      userId: data['userId'] ?? '',
      amount: (data['amount'] as num?)?.toInt() ?? 0,
      method: _methodFromString(data['method'] as String? ?? 'card'),
      status: _statusFromString(data['status'] as String? ?? 'pending'),
      paymentKey: data['paymentKey'],
      transactionId: data['transactionId'],
      receiptUrl: data['receiptUrl'],
      cardNumber: data['cardNumber'],
      cardCompany: data['cardCompany'],
      bankName: data['bankName'],
      accountNumber: data['accountNumber'],
      failReason: data['failReason'],
      paidAt: (data['paidAt'] as Timestamp?)?.toDate(),
      cancelledAt: (data['cancelledAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'method': method.name,
      'status': status.name,
      if (paymentKey != null) 'paymentKey': paymentKey,
      if (transactionId != null) 'transactionId': transactionId,
      if (receiptUrl != null) 'receiptUrl': receiptUrl,
      if (cardNumber != null) 'cardNumber': cardNumber,
      if (cardCompany != null) 'cardCompany': cardCompany,
      if (bankName != null) 'bankName': bankName,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (failReason != null) 'failReason': failReason,
      if (paidAt != null) 'paidAt': Timestamp.fromDate(paidAt!),
      if (cancelledAt != null) 'cancelledAt': Timestamp.fromDate(cancelledAt!),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Check if payment is completed
  bool get isCompleted => status == PaymentStatus.completed;

  /// Check if payment can be cancelled
  bool get canBeCancelled =>
      status == PaymentStatus.completed &&
      cancelledAt == null;

  /// Get display name for payment method
  String get methodDisplayName {
    switch (method) {
      case PaymentMethodType.card:
        return '카드';
      case PaymentMethodType.transfer:
        return '계좌이체';
      case PaymentMethodType.virtualAccount:
        return '가상계좌';
      case PaymentMethodType.mobilePay:
        return '휴대폰';
      case PaymentMethodType.tossPay:
        return '토스페이';
      case PaymentMethodType.kakaoPay:
        return '카카오페이';
      case PaymentMethodType.naverPay:
        return '네이버페이';
      case PaymentMethodType.cash:
        return '현금';
    }
  }

  /// Get display name for payment status
  String get statusDisplayName {
    switch (status) {
      case PaymentStatus.pending:
        return '결제 대기';
      case PaymentStatus.inProgress:
        return '결제 진행 중';
      case PaymentStatus.completed:
        return '결제 완료';
      case PaymentStatus.failed:
        return '결제 실패';
      case PaymentStatus.cancelled:
        return '결제 취소';
      case PaymentStatus.refunded:
        return '환불 완료';
      case PaymentStatus.partialRefunded:
        return '부분 환불';
    }
  }

  static PaymentMethodType _methodFromString(String method) {
    switch (method) {
      case 'card':
        return PaymentMethodType.card;
      case 'transfer':
        return PaymentMethodType.transfer;
      case 'virtualAccount':
        return PaymentMethodType.virtualAccount;
      case 'mobilePay':
        return PaymentMethodType.mobilePay;
      case 'tossPay':
        return PaymentMethodType.tossPay;
      case 'kakaoPay':
        return PaymentMethodType.kakaoPay;
      case 'naverPay':
        return PaymentMethodType.naverPay;
      case 'cash':
        return PaymentMethodType.cash;
      default:
        return PaymentMethodType.card;
    }
  }

  static PaymentStatus _statusFromString(String status) {
    switch (status) {
      case 'pending':
        return PaymentStatus.pending;
      case 'inProgress':
        return PaymentStatus.inProgress;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'cancelled':
        return PaymentStatus.cancelled;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'partialRefunded':
        return PaymentStatus.partialRefunded;
      default:
        return PaymentStatus.pending;
    }
  }
}

/// Payment request for initiating payment
@freezed
sealed class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required String orderId,
    required String orderName,
    required int amount,
    required String customerName,
    required String customerEmail,
    String? customerMobilePhone,
    @Default(PaymentMethodType.card) PaymentMethodType method,
  }) = _PaymentRequest;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);
}

/// Payment result from PG callback
@freezed
sealed class PaymentResult with _$PaymentResult {
  const factory PaymentResult({
    required bool success,
    String? paymentKey,
    String? orderId,
    int? amount,
    String? errorCode,
    String? errorMessage,
  }) = _PaymentResult;

  factory PaymentResult.fromJson(Map<String, dynamic> json) =>
      _$PaymentResultFromJson(json);
}
