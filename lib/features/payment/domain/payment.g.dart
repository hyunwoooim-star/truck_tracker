// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  orderId: json['orderId'] as String,
  userId: json['userId'] as String,
  amount: (json['amount'] as num).toInt(),
  method: $enumDecode(_$PaymentMethodTypeEnumMap, json['method']),
  status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
  paymentKey: json['paymentKey'] as String?,
  transactionId: json['transactionId'] as String?,
  receiptUrl: json['receiptUrl'] as String?,
  cardNumber: json['cardNumber'] as String?,
  cardCompany: json['cardCompany'] as String?,
  bankName: json['bankName'] as String?,
  accountNumber: json['accountNumber'] as String?,
  failReason: json['failReason'] as String?,
  paidAt: json['paidAt'] == null
      ? null
      : DateTime.parse(json['paidAt'] as String),
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'orderId': instance.orderId,
  'userId': instance.userId,
  'amount': instance.amount,
  'method': _$PaymentMethodTypeEnumMap[instance.method]!,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'paymentKey': instance.paymentKey,
  'transactionId': instance.transactionId,
  'receiptUrl': instance.receiptUrl,
  'cardNumber': instance.cardNumber,
  'cardCompany': instance.cardCompany,
  'bankName': instance.bankName,
  'accountNumber': instance.accountNumber,
  'failReason': instance.failReason,
  'paidAt': instance.paidAt?.toIso8601String(),
  'cancelledAt': instance.cancelledAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.card: 'card',
  PaymentMethodType.transfer: 'transfer',
  PaymentMethodType.virtualAccount: 'virtualAccount',
  PaymentMethodType.mobilePay: 'mobilePay',
  PaymentMethodType.tossPay: 'tossPay',
  PaymentMethodType.kakaoPay: 'kakaoPay',
  PaymentMethodType.naverPay: 'naverPay',
  PaymentMethodType.cash: 'cash',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.inProgress: 'inProgress',
  PaymentStatus.completed: 'completed',
  PaymentStatus.failed: 'failed',
  PaymentStatus.cancelled: 'cancelled',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.partialRefunded: 'partialRefunded',
};

_PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    _PaymentRequest(
      orderId: json['orderId'] as String,
      orderName: json['orderName'] as String,
      amount: (json['amount'] as num).toInt(),
      customerName: json['customerName'] as String,
      customerEmail: json['customerEmail'] as String,
      customerMobilePhone: json['customerMobilePhone'] as String?,
      method:
          $enumDecodeNullable(_$PaymentMethodTypeEnumMap, json['method']) ??
          PaymentMethodType.card,
    );

Map<String, dynamic> _$PaymentRequestToJson(_PaymentRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'orderName': instance.orderName,
      'amount': instance.amount,
      'customerName': instance.customerName,
      'customerEmail': instance.customerEmail,
      'customerMobilePhone': instance.customerMobilePhone,
      'method': _$PaymentMethodTypeEnumMap[instance.method]!,
    };

_PaymentResult _$PaymentResultFromJson(Map<String, dynamic> json) =>
    _PaymentResult(
      success: json['success'] as bool,
      paymentKey: json['paymentKey'] as String?,
      orderId: json['orderId'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$PaymentResultToJson(_PaymentResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'paymentKey': instance.paymentKey,
      'orderId': instance.orderId,
      'amount': instance.amount,
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
    };
