import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/app_logger.dart';
import '../data/payment_repository.dart';
import '../domain/payment.dart';

/// WebView for TossPayments checkout
class TossPaymentWebView extends ConsumerStatefulWidget {
  const TossPaymentWebView({
    super.key,
    required this.orderId,
    required this.orderName,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.method,
  });

  final String orderId;
  final String orderName;
  final int amount;
  final String customerName;
  final String customerEmail;
  final PaymentMethodType method;

  @override
  ConsumerState<TossPaymentWebView> createState() => _TossPaymentWebViewState();
}

class _TossPaymentWebViewState extends ConsumerState<TossPaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.midnightCharcoal)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageStarted: (url) {
            AppLogger.debug('Payment page started: $url', tag: 'TossPayment');
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
            AppLogger.debug('Payment page finished: $url', tag: 'TossPayment');
          },
          onNavigationRequest: (request) {
            final url = request.url;
            AppLogger.debug('Navigation request: $url', tag: 'TossPayment');

            // Handle success callback
            if (url.contains('success') || url.contains('payment/success')) {
              _handlePaymentSuccess(url);
              return NavigationDecision.prevent;
            }

            // Handle fail callback
            if (url.contains('fail') || url.contains('payment/fail')) {
              _handlePaymentFail(url);
              return NavigationDecision.prevent;
            }

            // Handle cancel
            if (url.contains('cancel')) {
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            AppLogger.error('WebView error: ${error.description}', tag: 'TossPayment');
          },
        ),
      )
      ..addJavaScriptChannel(
        'TruckTracker',
        onMessageReceived: (message) {
          _handleJsMessage(message.message);
        },
      )
      ..loadHtmlString(_generatePaymentHtml());
  }

  String _generatePaymentHtml() {
    final methodName = _getMethodName(widget.method);

    return '''
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>결제</title>
  <script src="https://js.tosspayments.com/v1/payment"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background-color: #1a1a2e;
      color: #ffffff;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    .loading {
      text-align: center;
    }
    .spinner {
      width: 48px;
      height: 48px;
      border: 4px solid rgba(0, 245, 212, 0.2);
      border-top: 4px solid #00f5d4;
      border-radius: 50%;
      animation: spin 1s linear infinite;
      margin: 0 auto 20px;
    }
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    .message {
      font-size: 16px;
      color: #a0a0a0;
    }
    .error {
      color: #ff6b6b;
      text-align: center;
      padding: 20px;
    }
  </style>
</head>
<body>
  <div class="loading" id="loading">
    <div class="spinner"></div>
    <p class="message">결제창을 불러오는 중...</p>
  </div>
  <div class="error" id="error" style="display: none;"></div>

  <script>
    var clientKey = '${TossPaymentsConfig.clientKey}';
    var tossPayments = TossPayments(clientKey);

    // Success/Fail URLs (handled by WebView navigation delegate)
    var successUrl = 'https://truck-tracker.app/payment/success';
    var failUrl = 'https://truck-tracker.app/payment/fail';

    tossPayments.requestPayment('$methodName', {
      amount: ${widget.amount},
      orderId: '${widget.orderId}',
      orderName: '${_escapeHtml(widget.orderName)}',
      customerName: '${_escapeHtml(widget.customerName)}',
      customerEmail: '${widget.customerEmail}',
      successUrl: successUrl,
      failUrl: failUrl,
    })
    .catch(function(error) {
      if (error.code === 'USER_CANCEL') {
        // User cancelled
        if (window.TruckTracker) {
          window.TruckTracker.postMessage(JSON.stringify({
            type: 'cancel'
          }));
        }
      } else {
        // Error occurred
        document.getElementById('loading').style.display = 'none';
        document.getElementById('error').style.display = 'block';
        document.getElementById('error').textContent = error.message || '결제 중 오류가 발생했습니다';

        if (window.TruckTracker) {
          window.TruckTracker.postMessage(JSON.stringify({
            type: 'error',
            code: error.code,
            message: error.message
          }));
        }
      }
    });
  </script>
</body>
</html>
''';
  }

  String _getMethodName(PaymentMethodType method) {
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
      default:
        return '카드';
    }
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  void _handleJsMessage(String message) {
    try {
      final data = jsonDecode(message) as Map<String, dynamic>;
      final type = data['type'] as String?;

      if (type == 'cancel') {
        Navigator.pop(context);
      } else if (type == 'error') {
        Navigator.pop(
          context,
          PaymentResult(
            success: false,
            errorCode: data['code'] as String?,
            errorMessage: data['message'] as String?,
          ),
        );
      }
    } catch (e) {
      AppLogger.warning('Error parsing JS message: $message', tag: 'TossPayment');
    }
  }

  Future<void> _handlePaymentSuccess(String url) async {
    AppLogger.debug('Payment success URL: $url', tag: 'TossPayment');

    // Parse URL parameters
    final uri = Uri.parse(url);
    final paymentKey = uri.queryParameters['paymentKey'];
    final orderId = uri.queryParameters['orderId'];
    final amount = int.tryParse(uri.queryParameters['amount'] ?? '');

    if (paymentKey == null || orderId == null || amount == null) {
      Navigator.pop(
        context,
        const PaymentResult(
          success: false,
          errorCode: 'INVALID_CALLBACK',
          errorMessage: '결제 정보가 올바르지 않습니다',
        ),
      );
      return;
    }

    // Confirm payment with TossPayments API
    final repository = ref.read(paymentRepositoryProvider);
    final result = await repository.confirmPayment(
      paymentKey: paymentKey,
      orderId: orderId,
      amount: amount,
    );

    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  void _handlePaymentFail(String url) {
    AppLogger.debug('Payment fail URL: $url', tag: 'TossPayment');

    final uri = Uri.parse(url);
    final errorCode = uri.queryParameters['code'];
    final errorMessage = uri.queryParameters['message'];

    Navigator.pop(
      context,
      PaymentResult(
        success: false,
        errorCode: errorCode,
        errorMessage: errorMessage ?? '결제에 실패했습니다',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제'),
        backgroundColor: AppTheme.midnightCharcoal,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // WebView
          if (!kIsWeb)
            WebViewWidget(controller: _controller)
          else
            // Web fallback - show message
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.web,
                    size: 64,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '웹에서는 결제를 지원하지 않습니다',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '모바일 앱에서 결제해 주세요',
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('돌아가기'),
                  ),
                ],
              ),
            ),

          // Loading indicator
          if (_isLoading && !kIsWeb)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppTheme.charcoalLight,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.electricBlue),
              ),
            ),
        ],
      ),
    );
  }
}
