import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../truck_list/presentation/truck_provider.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../data/checkin_repository.dart';

class CustomerCheckinScreen extends ConsumerStatefulWidget {
  const CustomerCheckinScreen({super.key});

  @override
  ConsumerState<CustomerCheckinScreen> createState() => _CustomerCheckinScreenState();
}

class _CustomerCheckinScreenState extends ConsumerState<CustomerCheckinScreen> {
  final TextEditingController _truckIdController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _isProcessing = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    // Listen for scanner errors
    _scannerController.start().catchError((error) {
      if (error is MobileScannerException) {
        _handleScannerError(error);
      }
    });
  }

  @override
  void dispose() {
    _truckIdController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _handleScannerError(MobileScannerException error) {
    setState(() {
      _hasError = true;
      switch (error.errorCode) {
        case MobileScannerErrorCode.permissionDenied:
          _errorMessage = '카메라 권한이 필요합니다';
          break;
        case MobileScannerErrorCode.unsupported:
          _errorMessage = '이 기기에서 카메라를 사용할 수 없습니다';
          break;
        default:
          _errorMessage = '카메라를 시작할 수 없습니다';
      }
    });
  }

  Future<void> _restartScanner() async {
    setState(() {
      _hasError = false;
      _errorMessage = null;
    });
    await _scannerController.start();
  }

  Widget _buildScannerError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? '카메라 오류',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _restartScanner,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processCheckIn(String truckId) async {
    final l10n = AppLocalizations.of(context);

    if (truckId.isEmpty) {
      _showError(l10n.pleaseEnterTruckID);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception(l10n.userNotLoggedIn);
      }

      // Get truck details
      final truckRepository = ref.read(truckRepositoryProvider);
      final truck = await truckRepository.getTruck(truckId);

      if (truck == null) {
        throw Exception(l10n.truckNotFound);
      }

      // Check if already checked in today
      final checkinRepository = ref.read(checkinRepositoryProvider);
      final hasCheckedIn = await checkinRepository.hasCheckedInToday(
        currentUser.uid,
        truckId,
      );

      if (hasCheckedIn) {
        if (mounted) {
          _showError(l10n.alreadyCheckedInToday);
        }
        return;
      }

      // Record check-in
      await checkinRepository.checkIn(
        userId: currentUser.uid,
        userName: currentUser.displayName ?? currentUser.email ?? 'User',
        truckId: truckId,
        truckName: truck.truckNumber,
      );

      if (mounted) {
        _showSuccess(truck.truckNumber);
        _truckIdController.clear();
      }
    } catch (e) {
      if (mounted) {
        _showError(l10n.checkInFailed(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showError(String message) {
    SnackBarHelper.showError(context, message);
  }

  void _showSuccess(String truckName) {
    final l10n = AppLocalizations.of(context);
    SnackBarHelper.showSuccess(context, '${l10n.checkInSuccessful} - ${l10n.loyaltyPoints(truckName)}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: Text(l10n.checkIn),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.electricBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.mustardYellow20,
                    AppTheme.mustardYellow05,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.mustardYellow30,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 64,
                    color: AppTheme.electricBlue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.scanQRCodeToCheckIn,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.earnLoyaltyPoints,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // QR Scanner
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.mustardYellow20,
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: _hasError
                  ? _buildScannerError()
                  : Stack(
                      children: [
                        MobileScanner(
                          controller: _scannerController,
                          onDetect: (capture) {
                            final barcodes = capture.barcodes;
                            for (final barcode in barcodes) {
                              if (barcode.rawValue != null && !_isProcessing) {
                                final truckId = barcode.rawValue!;
                                _truckIdController.text = truckId;
                                _processCheckIn(truckId);
                                break;
                              }
                            }
                          },
                        ),
                        // Scan overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.electricBlue.withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        // Torch toggle button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            onPressed: () async {
                              await _scannerController.toggleTorch();
                              setState(() {
                                _torchOn = !_torchOn;
                              });
                            },
                            icon: Icon(
                              _torchOn ? Icons.flash_on : Icons.flash_off,
                              color: _torchOn
                                  ? AppTheme.mustardYellow
                                  : Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 24),

            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[700])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.or,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[700])),
              ],
            ),

            const SizedBox(height: 24),

            // Manual Entry
            Text(
              l10n.enterTruckID,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _truckIdController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: l10n.enterTruckIDHint,
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[800]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.electricBlue,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.local_shipping,
                  color: AppTheme.electricBlue,
                ),
              ),
              enabled: !_isProcessing,
              onSubmitted: _processCheckIn,
            ),

            const SizedBox(height: 20),

            // Check-In Button
            ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () => _processCheckIn(_truckIdController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[800],
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      l10n.checkInButton,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),

            const SizedBox(height: 32),

            // Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.mustardYellow20,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.electricBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.howItWorks,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.howItWorksList,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
