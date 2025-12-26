import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../owner_dashboard/presentation/owner_status_provider.dart';

// Mustard and Charcoal color scheme
const Color _mustard = AppTheme.mustardYellow;
const Color _charcoal = AppTheme.midnightCharcoal;

class OwnerQRScreen extends ConsumerStatefulWidget {
  const OwnerQRScreen({super.key});

  @override
  ConsumerState<OwnerQRScreen> createState() => _OwnerQRScreenState();
}

class _OwnerQRScreenState extends ConsumerState<OwnerQRScreen> {
  bool _showBankTransfer = false;

  @override
  Widget build(BuildContext context) {
    final ownerTruckAsync = ref.watch(ownerTruckProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _charcoal,
      appBar: AppBar(
        title: Text(l10n.checkInQRCode),
        backgroundColor: _charcoal,
        foregroundColor: _mustard,
        elevation: 0,
      ),
      body: ownerTruckAsync.when(
        data: (truck) {
          if (truck == null) {
            return Center(
              child: Text(
                l10n.noTruckRegistered,
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          // QR data format: conditional based on toggle
          final qrData = _showBankTransfer
              ? (truck.bankAccount ?? 'BANK_ACCOUNT_NOT_SET')
              : truck.id;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Truck info card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.mustardYellow30),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.local_shipping,
                          color: _mustard,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          truck.truckNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          truck.foodType,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // QR Type Toggle
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildToggleButton(
                            label: l10n.checkInQR,
                            isSelected: !_showBankTransfer,
                            onTap: () => setState(() => _showBankTransfer = false),
                          ),
                        ),
                        Expanded(
                          child: _buildToggleButton(
                            label: l10n.bankTransfer,
                            isSelected: _showBankTransfer,
                            onTap: () => setState(() => _showBankTransfer = true),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Instructions
                  Text(
                    _showBankTransfer
                        ? l10n.showBankTransferQR
                        : l10n.customerscanQR,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // QR Code
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.mustardYellow30,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 280,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Truck ID display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.mustardYellow20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.qr_code,
                          color: _mustard,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.truckID(qrData),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Benefits info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.mustardYellow10,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.mustardYellow30),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: _mustard,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.checkInBenefits,
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.benefitsList,
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
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: _mustard),
        ),
        error: (_, __) => Center(
          child: Text(
            l10n.errorLoadingTruckData,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _mustard : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
