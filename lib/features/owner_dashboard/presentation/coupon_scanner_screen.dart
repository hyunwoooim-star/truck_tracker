import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../stamp_card/data/stamp_card_repository.dart';
import '../../stamp_card/domain/stamp_card.dart';

/// 사장님용 쿠폰 스캐너 화면
/// 고객의 쿠폰 QR 코드를 스캔하여 사용 처리합니다.
class CouponScannerScreen extends ConsumerStatefulWidget {
  final String truckId;

  const CouponScannerScreen({
    super.key,
    required this.truckId,
  });

  @override
  ConsumerState<CouponScannerScreen> createState() => _CouponScannerScreenState();
}

class _CouponScannerScreenState extends ConsumerState<CouponScannerScreen> {
  MobileScannerController? _scannerController;
  bool _isProcessing = false;
  String? _lastScannedCode;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null && code.startsWith('REWARD:')) {
        // 같은 코드 중복 스캔 방지
        if (code == _lastScannedCode) return;
        _lastScannedCode = code;

        final rewardId = code.substring(7); // Remove 'REWARD:' prefix
        _processReward(rewardId);
        break;
      }
    }
  }

  Future<void> _processReward(String rewardId) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    final l10n = AppLocalizations.of(context);
    final ownerId = ref.read(currentUserIdProvider);

    if (ownerId == null) {
      SnackBarHelper.showError(context, l10n.loginRequired);
      setState(() => _isProcessing = false);
      return;
    }

    try {
      final repository = ref.read(stampCardRepositoryProvider);

      // 리워드 정보 확인 및 사용 처리
      final result = await _validateAndUseReward(repository, rewardId, ownerId);

      if (mounted) {
        if (result.success) {
          _showSuccessDialog(result.reward!);
        } else {
          SnackBarHelper.showError(context, result.error!);
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, l10n.couponScanFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
        // 스캔 재개를 위해 약간의 딜레이 후 lastScannedCode 초기화
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _lastScannedCode = null;
          }
        });
      }
    }
  }

  Future<_RewardValidationResult> _validateAndUseReward(
    StampCardRepository repository,
    String rewardId,
    String ownerId,
  ) async {
    final l10n = AppLocalizations.of(context);

    // Firestore에서 리워드 정보 가져오기
    final reward = await _getRewardById(rewardId);

    if (reward == null) {
      return _RewardValidationResult.error(l10n.couponNotFound);
    }

    if (reward.isUsed) {
      return _RewardValidationResult.error(l10n.couponAlreadyUsed);
    }

    if (reward.truckId != widget.truckId) {
      return _RewardValidationResult.error(l10n.couponWrongTruck);
    }

    // 리워드 사용 처리
    final success = await repository.useReward(rewardId, ownerId);

    if (success) {
      return _RewardValidationResult.success(reward);
    } else {
      return _RewardValidationResult.error(l10n.couponUseFailed);
    }
  }

  Future<Reward?> _getRewardById(String rewardId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('rewards').doc(rewardId).get();

      if (!doc.exists) return null;
      return Reward.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  void _showSuccessDialog(Reward reward) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.midnightCharcoal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.couponUsedSuccess,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.charcoalLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    reward.visitorName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        reward.rewardType.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        reward.rewardType.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.mustardYellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.mustardYellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(l10n.confirm),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(l10n.couponScanner),
        backgroundColor: AppTheme.midnightCharcoal,
        elevation: 0,
        actions: [
          // 카메라 전환 버튼
          IconButton(
            onPressed: () => _scannerController?.switchCamera(),
            icon: const Icon(Icons.cameraswitch),
          ),
          // 플래시 토글
          IconButton(
            onPressed: () => _scannerController?.toggleTorch(),
            icon: const Icon(Icons.flash_on),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 스캐너 뷰
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),

          // 스캔 영역 오버레이
          _buildScanOverlay(),

          // 처리 중 인디케이터
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.mustardYellow,
                ),
              ),
            ),

          // 하단 안내
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.couponScanGuide,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.couponScanDescription,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return CustomPaint(
      painter: _ScanOverlayPainter(),
      child: const SizedBox.expand(),
    );
  }
}

/// 스캔 영역 오버레이 페인터
class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final scanAreaSize = size.width * 0.7;
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2 - 50;
    final right = left + scanAreaSize;
    final bottom = top + scanAreaSize;

    // 반투명 배경
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(left, top, right, bottom),
        const Radius.circular(16),
      ))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // 스캔 영역 테두리
    final borderPaint = Paint()
      ..color = AppTheme.mustardYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, top, right, bottom),
        const Radius.circular(16),
      ),
      borderPaint,
    );

    // 모서리 강조
    final cornerLength = 30.0;
    final cornerPaint = Paint()
      ..color = AppTheme.mustardYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // 좌상단
    canvas.drawLine(Offset(left, top + 20), Offset(left, top + cornerLength + 20), cornerPaint);
    canvas.drawLine(Offset(left, top + 20), Offset(left + cornerLength, top + 20), cornerPaint);

    // 우상단
    canvas.drawLine(Offset(right, top + 20), Offset(right, top + cornerLength + 20), cornerPaint);
    canvas.drawLine(Offset(right, top + 20), Offset(right - cornerLength, top + 20), cornerPaint);

    // 좌하단
    canvas.drawLine(Offset(left, bottom - 20), Offset(left, bottom - cornerLength - 20), cornerPaint);
    canvas.drawLine(Offset(left, bottom - 20), Offset(left + cornerLength, bottom - 20), cornerPaint);

    // 우하단
    canvas.drawLine(Offset(right, bottom - 20), Offset(right, bottom - cornerLength - 20), cornerPaint);
    canvas.drawLine(Offset(right, bottom - 20), Offset(right - cornerLength, bottom - 20), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 리워드 검증 결과
class _RewardValidationResult {
  final bool success;
  final Reward? reward;
  final String? error;

  _RewardValidationResult._({
    required this.success,
    this.reward,
    this.error,
  });

  factory _RewardValidationResult.success(Reward reward) {
    return _RewardValidationResult._(success: true, reward: reward);
  }

  factory _RewardValidationResult.error(String error) {
    return _RewardValidationResult._(success: false, error: error);
  }
}
