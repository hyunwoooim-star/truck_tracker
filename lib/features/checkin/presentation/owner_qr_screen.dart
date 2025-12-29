import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../owner_dashboard/presentation/owner_status_provider.dart';
import '../../truck_list/presentation/truck_provider.dart';

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
    final l10n = AppLocalizations.of(context);

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
          final hasBankAccount = truck.bankAccount != null && truck.bankAccount!.isNotEmpty;
          final qrData = _showBankTransfer
              ? (hasBankAccount ? truck.bankAccount! : '')
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

                  // QR Code or Bank Account Setup
                  if (_showBankTransfer && !hasBankAccount) ...[
                    // Bank account not set - show setup prompt
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.mustardYellow30),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.account_balance,
                            color: Colors.white54,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.bankAccountNotSet,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => _showBankAccountDialog(context, ref, truck.id, truck.bankAccount),
                            icon: const Icon(Icons.add),
                            label: Text(l10n.setBankAccount),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _mustard,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
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
                  ],

                  const SizedBox(height: 32),

                  // Truck ID / Bank Account display
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
                        Icon(
                          _showBankTransfer ? Icons.account_balance : Icons.qr_code,
                          color: _mustard,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _showBankTransfer
                                ? (hasBankAccount ? truck.bankAccount! : l10n.bankAccountNotSet)
                                : l10n.truckID(truck.id),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_showBankTransfer && hasBankAccount) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _showBankAccountDialog(context, ref, truck.id, truck.bankAccount),
                            icon: const Icon(Icons.edit, size: 16),
                            color: _mustard,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
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
        error: (error, stackTrace) => Center(
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

  void _showBankAccountDialog(BuildContext context, WidgetRef ref, String truckId, String? existingAccount) {
    final l10n = AppLocalizations.of(context);

    // Parse existing account if present (format: "은행명 계좌번호 (예금주)")
    String existingBank = '';
    String existingNumber = '';
    String existingHolder = '';

    if (existingAccount != null && existingAccount.isNotEmpty) {
      // Try to parse the format: "은행명 계좌번호 (예금주)"
      final match = RegExp(r'^(.+?)\s+(.+?)\s+\((.+?)\)$').firstMatch(existingAccount);
      if (match != null) {
        existingBank = match.group(1) ?? '';
        existingNumber = match.group(2) ?? '';
        existingHolder = match.group(3) ?? '';
      } else {
        // If format doesn't match, put everything in account number
        existingNumber = existingAccount;
      }
    }

    final bankController = TextEditingController(text: existingBank);
    final numberController = TextEditingController(text: existingNumber);
    final holderController = TextEditingController(text: existingHolder);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _charcoal,
        title: Text(
          existingAccount != null && existingAccount.isNotEmpty
              ? l10n.editBankAccount
              : l10n.bankAccountSettings,
          style: const TextStyle(color: _mustard),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bankController,
                decoration: InputDecoration(
                  labelText: l10n.bankName,
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintText: l10n.bankNameHint,
                  hintStyle: const TextStyle(color: Colors.white30),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.account_balance, color: _mustard),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: numberController,
                decoration: InputDecoration(
                  labelText: l10n.accountNumber,
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintText: l10n.accountNumberHint,
                  hintStyle: const TextStyle(color: Colors.white30),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.numbers, color: _mustard),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: holderController,
                decoration: InputDecoration(
                  labelText: l10n.accountHolder,
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintText: l10n.accountHolderHint,
                  hintStyle: const TextStyle(color: Colors.white30),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person, color: _mustard),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              final bank = bankController.text.trim();
              final number = numberController.text.trim();
              final holder = holderController.text.trim();

              if (bank.isEmpty || number.isEmpty || holder.isEmpty) {
                SnackBarHelper.showWarning(context, l10n.pleaseFillAllFields);
                return;
              }

              // Format: "은행명 계좌번호 (예금주)"
              final bankAccount = '$bank $number ($holder)';

              try {
                final repository = ref.read(truckRepositoryProvider);
                await repository.updateBankAccount(truckId, bankAccount);

                if (context.mounted) {
                  Navigator.pop(context);
                  SnackBarHelper.showSuccess(context, l10n.bankAccountSaved);
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarHelper.showError(context, '${l10n.error}: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _mustard,
              foregroundColor: Colors.black,
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
