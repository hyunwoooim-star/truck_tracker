// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

 String get id; String get orderId; String get userId; int get amount; PaymentMethodType get method; PaymentStatus get status; String? get paymentKey;// TossPayments 결제 키
 String? get transactionId;// PG사 거래 ID
 String? get receiptUrl;// 영수증 URL
 String? get cardNumber;// 카드번호 마스킹
 String? get cardCompany;// 카드사
 String? get bankName;// 은행명 (계좌이체/가상계좌)
 String? get accountNumber;// 계좌번호 (가상계좌)
 String? get failReason;// 실패 사유
 DateTime? get paidAt;// 결제 완료 시각
 DateTime? get cancelledAt;// 취소 시각
 DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.method, method) || other.method == method)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.cardCompany, cardCompany) || other.cardCompany == cardCompany)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.failReason, failReason) || other.failReason == failReason)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,userId,amount,method,status,paymentKey,transactionId,receiptUrl,cardNumber,cardCompany,bankName,accountNumber,failReason,paidAt,cancelledAt,createdAt,updatedAt);

@override
String toString() {
  return 'Payment(id: $id, orderId: $orderId, userId: $userId, amount: $amount, method: $method, status: $status, paymentKey: $paymentKey, transactionId: $transactionId, receiptUrl: $receiptUrl, cardNumber: $cardNumber, cardCompany: $cardCompany, bankName: $bankName, accountNumber: $accountNumber, failReason: $failReason, paidAt: $paidAt, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, String userId, int amount, PaymentMethodType method, PaymentStatus status, String? paymentKey, String? transactionId, String? receiptUrl, String? cardNumber, String? cardCompany, String? bankName, String? accountNumber, String? failReason, DateTime? paidAt, DateTime? cancelledAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? userId = null,Object? amount = null,Object? method = null,Object? status = null,Object? paymentKey = freezed,Object? transactionId = freezed,Object? receiptUrl = freezed,Object? cardNumber = freezed,Object? cardCompany = freezed,Object? bankName = freezed,Object? accountNumber = freezed,Object? failReason = freezed,Object? paidAt = freezed,Object? cancelledAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethodType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentKey: freezed == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,cardCompany: freezed == cardCompany ? _self.cardCompany : cardCompany // ignore: cast_nullable_to_non_nullable
as String?,bankName: freezed == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String?,accountNumber: freezed == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String?,failReason: freezed == failReason ? _self.failReason : failReason // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  String userId,  int amount,  PaymentMethodType method,  PaymentStatus status,  String? paymentKey,  String? transactionId,  String? receiptUrl,  String? cardNumber,  String? cardCompany,  String? bankName,  String? accountNumber,  String? failReason,  DateTime? paidAt,  DateTime? cancelledAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.orderId,_that.userId,_that.amount,_that.method,_that.status,_that.paymentKey,_that.transactionId,_that.receiptUrl,_that.cardNumber,_that.cardCompany,_that.bankName,_that.accountNumber,_that.failReason,_that.paidAt,_that.cancelledAt,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  String userId,  int amount,  PaymentMethodType method,  PaymentStatus status,  String? paymentKey,  String? transactionId,  String? receiptUrl,  String? cardNumber,  String? cardCompany,  String? bankName,  String? accountNumber,  String? failReason,  DateTime? paidAt,  DateTime? cancelledAt,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.orderId,_that.userId,_that.amount,_that.method,_that.status,_that.paymentKey,_that.transactionId,_that.receiptUrl,_that.cardNumber,_that.cardCompany,_that.bankName,_that.accountNumber,_that.failReason,_that.paidAt,_that.cancelledAt,_that.createdAt,_that.updatedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  String userId,  int amount,  PaymentMethodType method,  PaymentStatus status,  String? paymentKey,  String? transactionId,  String? receiptUrl,  String? cardNumber,  String? cardCompany,  String? bankName,  String? accountNumber,  String? failReason,  DateTime? paidAt,  DateTime? cancelledAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.orderId,_that.userId,_that.amount,_that.method,_that.status,_that.paymentKey,_that.transactionId,_that.receiptUrl,_that.cardNumber,_that.cardCompany,_that.bankName,_that.accountNumber,_that.failReason,_that.paidAt,_that.cancelledAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment extends Payment {
  const _Payment({required this.id, required this.orderId, required this.userId, required this.amount, required this.method, required this.status, this.paymentKey, this.transactionId, this.receiptUrl, this.cardNumber, this.cardCompany, this.bankName, this.accountNumber, this.failReason, this.paidAt, this.cancelledAt, this.createdAt, this.updatedAt}): super._();
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  String id;
@override final  String orderId;
@override final  String userId;
@override final  int amount;
@override final  PaymentMethodType method;
@override final  PaymentStatus status;
@override final  String? paymentKey;
// TossPayments 결제 키
@override final  String? transactionId;
// PG사 거래 ID
@override final  String? receiptUrl;
// 영수증 URL
@override final  String? cardNumber;
// 카드번호 마스킹
@override final  String? cardCompany;
// 카드사
@override final  String? bankName;
// 은행명 (계좌이체/가상계좌)
@override final  String? accountNumber;
// 계좌번호 (가상계좌)
@override final  String? failReason;
// 실패 사유
@override final  DateTime? paidAt;
// 결제 완료 시각
@override final  DateTime? cancelledAt;
// 취소 시각
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.method, method) || other.method == method)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.cardCompany, cardCompany) || other.cardCompany == cardCompany)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.failReason, failReason) || other.failReason == failReason)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,userId,amount,method,status,paymentKey,transactionId,receiptUrl,cardNumber,cardCompany,bankName,accountNumber,failReason,paidAt,cancelledAt,createdAt,updatedAt);

@override
String toString() {
  return 'Payment(id: $id, orderId: $orderId, userId: $userId, amount: $amount, method: $method, status: $status, paymentKey: $paymentKey, transactionId: $transactionId, receiptUrl: $receiptUrl, cardNumber: $cardNumber, cardCompany: $cardCompany, bankName: $bankName, accountNumber: $accountNumber, failReason: $failReason, paidAt: $paidAt, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, String userId, int amount, PaymentMethodType method, PaymentStatus status, String? paymentKey, String? transactionId, String? receiptUrl, String? cardNumber, String? cardCompany, String? bankName, String? accountNumber, String? failReason, DateTime? paidAt, DateTime? cancelledAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? userId = null,Object? amount = null,Object? method = null,Object? status = null,Object? paymentKey = freezed,Object? transactionId = freezed,Object? receiptUrl = freezed,Object? cardNumber = freezed,Object? cardCompany = freezed,Object? bankName = freezed,Object? accountNumber = freezed,Object? failReason = freezed,Object? paidAt = freezed,Object? cancelledAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethodType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentKey: freezed == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,cardNumber: freezed == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String?,cardCompany: freezed == cardCompany ? _self.cardCompany : cardCompany // ignore: cast_nullable_to_non_nullable
as String?,bankName: freezed == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String?,accountNumber: freezed == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String?,failReason: freezed == failReason ? _self.failReason : failReason // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PaymentRequest {

 String get orderId; String get orderName; int get amount; String get customerName; String get customerEmail; String? get customerMobilePhone; PaymentMethodType get method;
/// Create a copy of PaymentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentRequestCopyWith<PaymentRequest> get copyWith => _$PaymentRequestCopyWithImpl<PaymentRequest>(this as PaymentRequest, _$identity);

  /// Serializes this PaymentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentRequest&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderName, orderName) || other.orderName == orderName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerEmail, customerEmail) || other.customerEmail == customerEmail)&&(identical(other.customerMobilePhone, customerMobilePhone) || other.customerMobilePhone == customerMobilePhone)&&(identical(other.method, method) || other.method == method));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,orderName,amount,customerName,customerEmail,customerMobilePhone,method);

@override
String toString() {
  return 'PaymentRequest(orderId: $orderId, orderName: $orderName, amount: $amount, customerName: $customerName, customerEmail: $customerEmail, customerMobilePhone: $customerMobilePhone, method: $method)';
}


}

/// @nodoc
abstract mixin class $PaymentRequestCopyWith<$Res>  {
  factory $PaymentRequestCopyWith(PaymentRequest value, $Res Function(PaymentRequest) _then) = _$PaymentRequestCopyWithImpl;
@useResult
$Res call({
 String orderId, String orderName, int amount, String customerName, String customerEmail, String? customerMobilePhone, PaymentMethodType method
});




}
/// @nodoc
class _$PaymentRequestCopyWithImpl<$Res>
    implements $PaymentRequestCopyWith<$Res> {
  _$PaymentRequestCopyWithImpl(this._self, this._then);

  final PaymentRequest _self;
  final $Res Function(PaymentRequest) _then;

/// Create a copy of PaymentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? orderName = null,Object? amount = null,Object? customerName = null,Object? customerEmail = null,Object? customerMobilePhone = freezed,Object? method = null,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderName: null == orderName ? _self.orderName : orderName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerEmail: null == customerEmail ? _self.customerEmail : customerEmail // ignore: cast_nullable_to_non_nullable
as String,customerMobilePhone: freezed == customerMobilePhone ? _self.customerMobilePhone : customerMobilePhone // ignore: cast_nullable_to_non_nullable
as String?,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethodType,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentRequest].
extension PaymentRequestPatterns on PaymentRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentRequest value)  $default,){
final _that = this;
switch (_that) {
case _PaymentRequest():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  String orderName,  int amount,  String customerName,  String customerEmail,  String? customerMobilePhone,  PaymentMethodType method)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentRequest() when $default != null:
return $default(_that.orderId,_that.orderName,_that.amount,_that.customerName,_that.customerEmail,_that.customerMobilePhone,_that.method);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  String orderName,  int amount,  String customerName,  String customerEmail,  String? customerMobilePhone,  PaymentMethodType method)  $default,) {final _that = this;
switch (_that) {
case _PaymentRequest():
return $default(_that.orderId,_that.orderName,_that.amount,_that.customerName,_that.customerEmail,_that.customerMobilePhone,_that.method);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  String orderName,  int amount,  String customerName,  String customerEmail,  String? customerMobilePhone,  PaymentMethodType method)?  $default,) {final _that = this;
switch (_that) {
case _PaymentRequest() when $default != null:
return $default(_that.orderId,_that.orderName,_that.amount,_that.customerName,_that.customerEmail,_that.customerMobilePhone,_that.method);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentRequest implements PaymentRequest {
  const _PaymentRequest({required this.orderId, required this.orderName, required this.amount, required this.customerName, required this.customerEmail, this.customerMobilePhone, this.method = PaymentMethodType.card});
  factory _PaymentRequest.fromJson(Map<String, dynamic> json) => _$PaymentRequestFromJson(json);

@override final  String orderId;
@override final  String orderName;
@override final  int amount;
@override final  String customerName;
@override final  String customerEmail;
@override final  String? customerMobilePhone;
@override@JsonKey() final  PaymentMethodType method;

/// Create a copy of PaymentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentRequestCopyWith<_PaymentRequest> get copyWith => __$PaymentRequestCopyWithImpl<_PaymentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentRequest&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderName, orderName) || other.orderName == orderName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerEmail, customerEmail) || other.customerEmail == customerEmail)&&(identical(other.customerMobilePhone, customerMobilePhone) || other.customerMobilePhone == customerMobilePhone)&&(identical(other.method, method) || other.method == method));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,orderName,amount,customerName,customerEmail,customerMobilePhone,method);

@override
String toString() {
  return 'PaymentRequest(orderId: $orderId, orderName: $orderName, amount: $amount, customerName: $customerName, customerEmail: $customerEmail, customerMobilePhone: $customerMobilePhone, method: $method)';
}


}

/// @nodoc
abstract mixin class _$PaymentRequestCopyWith<$Res> implements $PaymentRequestCopyWith<$Res> {
  factory _$PaymentRequestCopyWith(_PaymentRequest value, $Res Function(_PaymentRequest) _then) = __$PaymentRequestCopyWithImpl;
@override @useResult
$Res call({
 String orderId, String orderName, int amount, String customerName, String customerEmail, String? customerMobilePhone, PaymentMethodType method
});




}
/// @nodoc
class __$PaymentRequestCopyWithImpl<$Res>
    implements _$PaymentRequestCopyWith<$Res> {
  __$PaymentRequestCopyWithImpl(this._self, this._then);

  final _PaymentRequest _self;
  final $Res Function(_PaymentRequest) _then;

/// Create a copy of PaymentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? orderName = null,Object? amount = null,Object? customerName = null,Object? customerEmail = null,Object? customerMobilePhone = freezed,Object? method = null,}) {
  return _then(_PaymentRequest(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderName: null == orderName ? _self.orderName : orderName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerEmail: null == customerEmail ? _self.customerEmail : customerEmail // ignore: cast_nullable_to_non_nullable
as String,customerMobilePhone: freezed == customerMobilePhone ? _self.customerMobilePhone : customerMobilePhone // ignore: cast_nullable_to_non_nullable
as String?,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethodType,
  ));
}


}


/// @nodoc
mixin _$PaymentResult {

 bool get success; String? get paymentKey; String? get orderId; int? get amount; String? get errorCode; String? get errorMessage;
/// Create a copy of PaymentResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentResultCopyWith<PaymentResult> get copyWith => _$PaymentResultCopyWithImpl<PaymentResult>(this as PaymentResult, _$identity);

  /// Serializes this PaymentResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentResult&&(identical(other.success, success) || other.success == success)&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,paymentKey,orderId,amount,errorCode,errorMessage);

@override
String toString() {
  return 'PaymentResult(success: $success, paymentKey: $paymentKey, orderId: $orderId, amount: $amount, errorCode: $errorCode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PaymentResultCopyWith<$Res>  {
  factory $PaymentResultCopyWith(PaymentResult value, $Res Function(PaymentResult) _then) = _$PaymentResultCopyWithImpl;
@useResult
$Res call({
 bool success, String? paymentKey, String? orderId, int? amount, String? errorCode, String? errorMessage
});




}
/// @nodoc
class _$PaymentResultCopyWithImpl<$Res>
    implements $PaymentResultCopyWith<$Res> {
  _$PaymentResultCopyWithImpl(this._self, this._then);

  final PaymentResult _self;
  final $Res Function(PaymentResult) _then;

/// Create a copy of PaymentResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? paymentKey = freezed,Object? orderId = freezed,Object? amount = freezed,Object? errorCode = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,paymentKey: freezed == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentResult].
extension PaymentResultPatterns on PaymentResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentResult value)  $default,){
final _that = this;
switch (_that) {
case _PaymentResult():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentResult value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String? paymentKey,  String? orderId,  int? amount,  String? errorCode,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentResult() when $default != null:
return $default(_that.success,_that.paymentKey,_that.orderId,_that.amount,_that.errorCode,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String? paymentKey,  String? orderId,  int? amount,  String? errorCode,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PaymentResult():
return $default(_that.success,_that.paymentKey,_that.orderId,_that.amount,_that.errorCode,_that.errorMessage);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String? paymentKey,  String? orderId,  int? amount,  String? errorCode,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PaymentResult() when $default != null:
return $default(_that.success,_that.paymentKey,_that.orderId,_that.amount,_that.errorCode,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentResult implements PaymentResult {
  const _PaymentResult({required this.success, this.paymentKey, this.orderId, this.amount, this.errorCode, this.errorMessage});
  factory _PaymentResult.fromJson(Map<String, dynamic> json) => _$PaymentResultFromJson(json);

@override final  bool success;
@override final  String? paymentKey;
@override final  String? orderId;
@override final  int? amount;
@override final  String? errorCode;
@override final  String? errorMessage;

/// Create a copy of PaymentResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentResultCopyWith<_PaymentResult> get copyWith => __$PaymentResultCopyWithImpl<_PaymentResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentResult&&(identical(other.success, success) || other.success == success)&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,paymentKey,orderId,amount,errorCode,errorMessage);

@override
String toString() {
  return 'PaymentResult(success: $success, paymentKey: $paymentKey, orderId: $orderId, amount: $amount, errorCode: $errorCode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PaymentResultCopyWith<$Res> implements $PaymentResultCopyWith<$Res> {
  factory _$PaymentResultCopyWith(_PaymentResult value, $Res Function(_PaymentResult) _then) = __$PaymentResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String? paymentKey, String? orderId, int? amount, String? errorCode, String? errorMessage
});




}
/// @nodoc
class __$PaymentResultCopyWithImpl<$Res>
    implements _$PaymentResultCopyWith<$Res> {
  __$PaymentResultCopyWithImpl(this._self, this._then);

  final _PaymentResult _self;
  final $Res Function(_PaymentResult) _then;

/// Create a copy of PaymentResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? paymentKey = freezed,Object? orderId = freezed,Object? amount = freezed,Object? errorCode = freezed,Object? errorMessage = freezed,}) {
  return _then(_PaymentResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,paymentKey: freezed == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
