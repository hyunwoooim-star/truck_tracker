import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/features/payment/domain/payment.dart';

void main() {
  group('Payment Model', () {
    late Payment payment;

    setUp(() {
      payment = Payment(
        id: 'payment_123',
        orderId: 'order_456',
        userId: 'user_789',
        amount: 15000,
        method: PaymentMethodType.card,
        status: PaymentStatus.completed,
        paymentKey: 'toss_key_abc',
        cardNumber: '****-****-****-1234',
        cardCompany: '삼성카드',
        paidAt: DateTime(2025, 12, 31, 12, 0, 0),
        createdAt: DateTime(2025, 12, 31, 11, 55, 0),
      );
    });

    test('should create Payment with required fields', () {
      final simplePayment = Payment(
        id: 'p1',
        orderId: 'o1',
        userId: 'u1',
        amount: 10000,
        method: PaymentMethodType.card,
        status: PaymentStatus.pending,
      );

      expect(simplePayment.id, 'p1');
      expect(simplePayment.orderId, 'o1');
      expect(simplePayment.userId, 'u1');
      expect(simplePayment.amount, 10000);
      expect(simplePayment.method, PaymentMethodType.card);
      expect(simplePayment.status, PaymentStatus.pending);
    });

    test('isCompleted should return true when status is completed', () {
      expect(payment.isCompleted, isTrue);

      final pendingPayment = payment.copyWith(status: PaymentStatus.pending);
      expect(pendingPayment.isCompleted, isFalse);

      final failedPayment = payment.copyWith(status: PaymentStatus.failed);
      expect(failedPayment.isCompleted, isFalse);
    });

    test('canBeCancelled should return true when completed and not yet cancelled', () {
      expect(payment.canBeCancelled, isTrue);

      final cancelledPayment = payment.copyWith(
        cancelledAt: DateTime.now(),
      );
      expect(cancelledPayment.canBeCancelled, isFalse);

      final pendingPayment = payment.copyWith(status: PaymentStatus.pending);
      expect(pendingPayment.canBeCancelled, isFalse);
    });

    group('methodDisplayName', () {
      test('should return correct Korean name for each payment method', () {
        expect(
          payment.copyWith(method: PaymentMethodType.card).methodDisplayName,
          '카드',
        );
        expect(
          payment.copyWith(method: PaymentMethodType.transfer).methodDisplayName,
          '계좌이체',
        );
        expect(
          payment.copyWith(method: PaymentMethodType.virtualAccount).methodDisplayName,
          '가상계좌',
        );
        expect(
          payment.copyWith(method: PaymentMethodType.mobilePay).methodDisplayName,
          '휴대폰',
        );
        expect(
          payment.copyWith(method: PaymentMethodType.tossPay).methodDisplayName,
          '토스페이',
        );
        expect(
          payment.copyWith(method: PaymentMethodType.kakaoPay).methodDisplayName,
          '카카오페이',
        );
        expect(
          payment.copyWith(method: PaymentMethodType.naverPay).methodDisplayName,
          '네이버페이',
        );
        expect(
          payment.copyWith(method: PaymentMethodType.cash).methodDisplayName,
          '현금',
        );
      });
    });

    group('statusDisplayName', () {
      test('should return correct Korean name for each status', () {
        expect(
          payment.copyWith(status: PaymentStatus.pending).statusDisplayName,
          '결제 대기',
        );
        expect(
          payment.copyWith(status: PaymentStatus.inProgress).statusDisplayName,
          '결제 진행 중',
        );
        expect(
          payment.copyWith(status: PaymentStatus.completed).statusDisplayName,
          '결제 완료',
        );
        expect(
          payment.copyWith(status: PaymentStatus.failed).statusDisplayName,
          '결제 실패',
        );
        expect(
          payment.copyWith(status: PaymentStatus.cancelled).statusDisplayName,
          '결제 취소',
        );
        expect(
          payment.copyWith(status: PaymentStatus.refunded).statusDisplayName,
          '환불 완료',
        );
        expect(
          payment.copyWith(status: PaymentStatus.partialRefunded).statusDisplayName,
          '부분 환불',
        );
      });
    });

    test('toFirestore should convert Payment to Map correctly', () {
      final firestoreMap = payment.toFirestore();

      expect(firestoreMap['orderId'], 'order_456');
      expect(firestoreMap['userId'], 'user_789');
      expect(firestoreMap['amount'], 15000);
      expect(firestoreMap['method'], 'card');
      expect(firestoreMap['status'], 'completed');
      expect(firestoreMap['paymentKey'], 'toss_key_abc');
      expect(firestoreMap['cardNumber'], '****-****-****-1234');
      expect(firestoreMap['cardCompany'], '삼성카드');
    });

    test('toFirestore should not include null optional fields', () {
      final minimalPayment = Payment(
        id: 'p1',
        orderId: 'o1',
        userId: 'u1',
        amount: 5000,
        method: PaymentMethodType.cash,
        status: PaymentStatus.pending,
      );

      final firestoreMap = minimalPayment.toFirestore();

      expect(firestoreMap.containsKey('paymentKey'), isFalse);
      expect(firestoreMap.containsKey('transactionId'), isFalse);
      expect(firestoreMap.containsKey('receiptUrl'), isFalse);
      expect(firestoreMap.containsKey('cardNumber'), isFalse);
      expect(firestoreMap.containsKey('failReason'), isFalse);
    });
  });

  group('PaymentRequest', () {
    test('should create PaymentRequest with required fields', () {
      final request = PaymentRequest(
        orderId: 'order_123',
        orderName: '떡볶이 외 2건',
        amount: 25000,
        customerName: '홍길동',
        customerEmail: 'hong@example.com',
      );

      expect(request.orderId, 'order_123');
      expect(request.orderName, '떡볶이 외 2건');
      expect(request.amount, 25000);
      expect(request.customerName, '홍길동');
      expect(request.customerEmail, 'hong@example.com');
      expect(request.method, PaymentMethodType.card); // default value
    });

    test('should create PaymentRequest with optional fields', () {
      final request = PaymentRequest(
        orderId: 'order_123',
        orderName: '타코야끼',
        amount: 8000,
        customerName: '김철수',
        customerEmail: 'kim@example.com',
        customerMobilePhone: '010-1234-5678',
        method: PaymentMethodType.kakaoPay,
      );

      expect(request.customerMobilePhone, '010-1234-5678');
      expect(request.method, PaymentMethodType.kakaoPay);
    });
  });

  group('PaymentResult', () {
    test('should create successful PaymentResult', () {
      final result = PaymentResult(
        success: true,
        paymentKey: 'toss_key_xyz',
        orderId: 'order_123',
        amount: 15000,
      );

      expect(result.success, isTrue);
      expect(result.paymentKey, 'toss_key_xyz');
      expect(result.orderId, 'order_123');
      expect(result.amount, 15000);
      expect(result.errorCode, isNull);
      expect(result.errorMessage, isNull);
    });

    test('should create failed PaymentResult', () {
      final result = PaymentResult(
        success: false,
        errorCode: 'PAY_PROCESS_CANCELED',
        errorMessage: '사용자가 결제를 취소했습니다.',
      );

      expect(result.success, isFalse);
      expect(result.errorCode, 'PAY_PROCESS_CANCELED');
      expect(result.errorMessage, '사용자가 결제를 취소했습니다.');
      expect(result.paymentKey, isNull);
    });
  });

  group('PaymentMethodType enum', () {
    test('should have all expected values', () {
      expect(PaymentMethodType.values.length, 8);
      expect(PaymentMethodType.values, contains(PaymentMethodType.card));
      expect(PaymentMethodType.values, contains(PaymentMethodType.transfer));
      expect(PaymentMethodType.values, contains(PaymentMethodType.virtualAccount));
      expect(PaymentMethodType.values, contains(PaymentMethodType.mobilePay));
      expect(PaymentMethodType.values, contains(PaymentMethodType.tossPay));
      expect(PaymentMethodType.values, contains(PaymentMethodType.kakaoPay));
      expect(PaymentMethodType.values, contains(PaymentMethodType.naverPay));
      expect(PaymentMethodType.values, contains(PaymentMethodType.cash));
    });
  });

  group('PaymentStatus enum', () {
    test('should have all expected values', () {
      expect(PaymentStatus.values.length, 7);
      expect(PaymentStatus.values, contains(PaymentStatus.pending));
      expect(PaymentStatus.values, contains(PaymentStatus.inProgress));
      expect(PaymentStatus.values, contains(PaymentStatus.completed));
      expect(PaymentStatus.values, contains(PaymentStatus.failed));
      expect(PaymentStatus.values, contains(PaymentStatus.cancelled));
      expect(PaymentStatus.values, contains(PaymentStatus.refunded));
      expect(PaymentStatus.values, contains(PaymentStatus.partialRefunded));
    });
  });
}
