import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/payment.dart';

part 'payment_repository.g.dart';

/// TossPayments configuration
///
/// API keys are loaded from environment variables:
/// - TOSS_CLIENT_KEY: Client key for Toss Payments
/// - TOSS_SECRET_KEY: Secret key for Toss Payments
/// - TOSS_IS_PRODUCTION: Set to 'true' for production mode
///
/// Build with: flutter build --dart-define=TOSS_CLIENT_KEY=xxx --dart-define=TOSS_SECRET_KEY=xxx
class TossPaymentsConfig {
  // 테스트 키 (개발용 - 환경변수 없을 때 폴백)
  static const String _testClientKey = 'test_ck_D5GePWvyJnrK0W0k6q8gLzN97Eoq';
  static const String _testSecretKey = 'test_sk_zXLkKEypNArWmo50nX3lmeaxYG5R';

  // 환경변수에서 로드 (GitHub Secrets에서 주입)
  static const String _envClientKey = String.fromEnvironment('TOSS_CLIENT_KEY');
  static const String _envSecretKey = String.fromEnvironment('TOSS_SECRET_KEY');
  static const bool isProduction = bool.fromEnvironment('TOSS_IS_PRODUCTION', defaultValue: false);

  // 환경변수 있으면 사용, 없으면 테스트 키 사용
  static String get clientKey => _envClientKey.isNotEmpty ? _envClientKey : _testClientKey;
  static String get secretKey => _envSecretKey.isNotEmpty ? _envSecretKey : _testSecretKey;

  // API URLs
  static const String baseUrl = 'https://api.tosspayments.com';
  static const String confirmUrl = '$baseUrl/v1/payments/confirm';
  static const String cancelUrl = '$baseUrl/v1/payments';
}

/// Repository for managing payments
class PaymentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _paymentsCollection =>
      _firestore.collection('payments');

  // ═══════════════════════════════════════════════════════════
  // PAYMENT CREATION & CONFIRMATION
  // ═══════════════════════════════════════════════════════════

  /// Create a pending payment record
  Future<String> createPayment(Payment payment) async {
    AppLogger.debug('Creating payment for order ${payment.orderId}', tag: 'PaymentRepository');

    try {
      final docRef = await _paymentsCollection.add(payment.toFirestore());
      AppLogger.success('Payment created: ${docRef.id}', tag: 'PaymentRepository');
      return docRef.id;
    } catch (e, stackTrace) {
      AppLogger.error('Error creating payment', error: e, stackTrace: stackTrace, tag: 'PaymentRepository');
      rethrow;
    }
  }

  /// Confirm payment with TossPayments API
  Future<PaymentResult> confirmPayment({
    required String paymentKey,
    required String orderId,
    required int amount,
  }) async {
    AppLogger.debug('Confirming payment: $paymentKey', tag: 'PaymentRepository');

    try {
      // Encode secret key for Basic Auth
      final credentials = base64Encode(utf8.encode('${TossPaymentsConfig.secretKey}:'));

      final response = await http.post(
        Uri.parse(TossPaymentsConfig.confirmUrl),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'paymentKey': paymentKey,
          'orderId': orderId,
          'amount': amount,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        AppLogger.success('Payment confirmed successfully', tag: 'PaymentRepository');

        // Update payment record in Firestore
        await _updatePaymentFromConfirmation(orderId, data);

        return PaymentResult(
          success: true,
          paymentKey: data['paymentKey'] as String?,
          orderId: data['orderId'] as String?,
          amount: (data['totalAmount'] as num?)?.toInt(),
        );
      } else {
        final errorCode = data['code'] as String?;
        final errorMessage = data['message'] as String?;

        AppLogger.warning('Payment confirmation failed: $errorCode - $errorMessage', tag: 'PaymentRepository');

        // Update payment status to failed
        await _updatePaymentStatus(orderId, PaymentStatus.failed, failReason: errorMessage);

        return PaymentResult(
          success: false,
          errorCode: errorCode,
          errorMessage: errorMessage,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error confirming payment', error: e, stackTrace: stackTrace, tag: 'PaymentRepository');

      return PaymentResult(
        success: false,
        errorCode: 'NETWORK_ERROR',
        errorMessage: '네트워크 오류가 발생했습니다. 다시 시도해주세요.',
      );
    }
  }

  /// Cancel payment
  Future<PaymentResult> cancelPayment({
    required String paymentKey,
    required String cancelReason,
  }) async {
    AppLogger.debug('Cancelling payment: $paymentKey', tag: 'PaymentRepository');

    try {
      final credentials = base64Encode(utf8.encode('${TossPaymentsConfig.secretKey}:'));

      final response = await http.post(
        Uri.parse('${TossPaymentsConfig.cancelUrl}/$paymentKey/cancel'),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cancelReason': cancelReason,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        AppLogger.success('Payment cancelled successfully', tag: 'PaymentRepository');

        // Update payment status
        final orderId = data['orderId'] as String?;
        if (orderId != null) {
          await _updatePaymentStatus(orderId, PaymentStatus.cancelled);
        }

        return const PaymentResult(success: true);
      } else {
        return PaymentResult(
          success: false,
          errorCode: data['code'] as String?,
          errorMessage: data['message'] as String?,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error cancelling payment', error: e, stackTrace: stackTrace, tag: 'PaymentRepository');

      return PaymentResult(
        success: false,
        errorCode: 'NETWORK_ERROR',
        errorMessage: '결제 취소 중 오류가 발생했습니다.',
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // PAYMENT QUERIES
  // ═══════════════════════════════════════════════════════════

  /// Get payment by order ID
  Future<Payment?> getPaymentByOrderId(String orderId) async {
    AppLogger.debug('Fetching payment for order $orderId', tag: 'PaymentRepository');

    try {
      final snapshot = await _paymentsCollection
          .where('orderId', isEqualTo: orderId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return Payment.fromFirestore(snapshot.docs.first);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching payment', error: e, stackTrace: stackTrace, tag: 'PaymentRepository');
      return null;
    }
  }

  /// Get all payments for a user
  Stream<List<Payment>> watchUserPayments(String userId) {
    AppLogger.debug('Watching payments for user $userId', tag: 'PaymentRepository');

    return _paymentsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              return Payment.fromFirestore(doc);
            } catch (e) {
              AppLogger.warning('Error parsing payment ${doc.id}', tag: 'PaymentRepository');
              return null;
            }
          })
          .whereType<Payment>()
          .toList();
    });
  }

  // ═══════════════════════════════════════════════════════════
  // INTERNAL HELPERS
  // ═══════════════════════════════════════════════════════════

  Future<void> _updatePaymentFromConfirmation(
    String orderId,
    Map<String, dynamic> confirmData,
  ) async {
    try {
      final snapshot = await _paymentsCollection
          .where('orderId', isEqualTo: orderId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return;

      final doc = snapshot.docs.first;

      // Extract card info if available
      final card = confirmData['card'] as Map<String, dynamic>?;
      final transfer = confirmData['transfer'] as Map<String, dynamic>?;

      await doc.reference.update({
        'status': 'completed',
        'paymentKey': confirmData['paymentKey'],
        'transactionId': confirmData['transactionId'],
        'receiptUrl': confirmData['receipt']?['url'],
        if (card != null) 'cardNumber': card['number'],
        if (card != null) 'cardCompany': card['company'],
        if (transfer != null) 'bankName': transfer['bank'],
        'paidAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      AppLogger.warning('Error updating payment confirmation', tag: 'PaymentRepository');
    }
  }

  Future<void> _updatePaymentStatus(
    String orderId,
    PaymentStatus status, {
    String? failReason,
  }) async {
    try {
      final snapshot = await _paymentsCollection
          .where('orderId', isEqualTo: orderId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return;

      final doc = snapshot.docs.first;

      await doc.reference.update({
        'status': status.name,
        if (failReason != null) 'failReason': failReason,
        if (status == PaymentStatus.cancelled) 'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      AppLogger.warning('Error updating payment status', tag: 'PaymentRepository');
    }
  }
}

// ═══════════════════════════════════════════════════════════
// PROVIDERS
// ═══════════════════════════════════════════════════════════

@riverpod
PaymentRepository paymentRepository(Ref ref) {
  return PaymentRepository();
}

/// Provider for watching user payments
@riverpod
Stream<List<Payment>> userPayments(Ref ref, String userId) {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.watchUserPayments(userId);
}
