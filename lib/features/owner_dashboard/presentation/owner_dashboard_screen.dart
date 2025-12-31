import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../truck_list/presentation/truck_provider.dart';
import '../../truck_list/domain/truck.dart';
import '../../order/data/order_repository.dart';
import 'analytics_screen.dart';
import 'coupon_management_screen.dart';
import 'menu_management_screen.dart';
import 'owner_status_provider.dart';
import 'review_management_screen.dart';
import 'schedule_management_screen.dart';
import '../../checkin/presentation/owner_qr_screen.dart';
import '../../analytics/presentation/revenue_dashboard_screen.dart';
import '../../notifications/presentation/push_notification_tool.dart';
import '../../truck_map/presentation/map_first_screen.dart';
import '../../../scripts/migrate_mock_data.dart';
import 'widgets/widgets.dart';

// Mustard and Charcoal color scheme
const Color _mustard = AppTheme.mustardYellow;
const Color _charcoal = AppTheme.midnightCharcoal;

/// Owner Dashboard Screen - 사장님 대시보드
/// 1,570줄 → 6개 위젯으로 분리됨 (2025-12-30)
class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final ownerTruckAsync = ref.watch(ownerTruckProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: _charcoal,
      appBar: AppBar(
        title: Text(l10n.ownerCommandCenter),
        backgroundColor: _charcoal,
        foregroundColor: _mustard,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            tooltip: l10n.qrCheckInTooltip,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const OwnerQRScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: l10n.scheduleTooltip,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ScheduleManagementScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            tooltip: l10n.menuManagement,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MenuManagementScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.local_offer),
            tooltip: '쿠폰 관리',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CouponManagementScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.rate_review),
            tooltip: l10n.manageReviews,
            onPressed: () {
              final ownerTruck = ref.read(ownerTruckProvider).value;
              if (ownerTruck != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReviewManagementScreen(truckId: ownerTruck.id),
                  ),
                );
              }
            },
          ),
          // 매출/분석 메뉴
          PopupMenuButton<String>(
            icon: const Icon(Icons.analytics),
            tooltip: l10n.analyticsTooltip,
            onSelected: (value) {
              switch (value) {
                case 'revenue':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RevenueDashboardScreen(),
                    ),
                  );
                  break;
                case 'analytics':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AnalyticsScreen(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'revenue',
                child: Row(
                  children: [
                    Icon(Icons.attach_money, size: 20),
                    SizedBox(width: 8),
                    Text('매출 대시보드'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'analytics',
                child: Row(
                  children: [
                    Icon(Icons.bar_chart, size: 20),
                    SizedBox(width: 8),
                    Text('조회/리뷰 분석'),
                  ],
                ),
              ),
            ],
          ),
          // 푸시 알림 발송
          IconButton(
            icon: const Icon(Icons.notifications_active),
            tooltip: '알림 발송',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PushNotificationTool(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: l10n.uploadDataTooltip,
            onPressed: () => _showMigrationDialog(context, ref),
          ),
          // 손님 화면 미리보기 (지도에서 내 트럭이 어떻게 보이는지)
          IconButton(
            icon: const Icon(Icons.storefront, color: Colors.cyan),
            tooltip: '손님 화면 보기',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MapFirstScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '설정',
            onPressed: () => _showSettingsDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
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
          final ordersAsync = ref.watch(truckOrdersProvider(truck.id));

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 현금 매출 입력 버튼
                OwnerCashSaleButton(truck: truck),
                const SizedBox(height: 16),

                // GPS 영업 시작 버튼
                OwnerGpsButton(truck: truck),

                // 오늘의 공지사항
                OwnerAnnouncementSection(truck: truck),

                // 오늘의 주문 통계
                ordersAsync.when(
                  data: (orders) => OwnerStatsCard(orders: orders),
                  loading: () => const SizedBox.shrink(),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                ),

                // 칸반 주문 보드
                OwnerOrderKanban(truckId: truck.id),

                // 품절 토글
                OwnerSoldOutToggles(truckId: truck.id),

                // 고객 대화
                OwnerTalkSection(truckId: truck.id),
              ],
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

  /// Show settings dialog for owner profile
  void _showSettingsDialog(BuildContext context, WidgetRef ref) {
    final ownerTruckAsync = ref.read(ownerTruckProvider);

    ownerTruckAsync.when(
      data: (truck) {
        if (truck == null) {
          SnackBarHelper.showWarning(context, '트럭 정보를 불러올 수 없습니다');
          return;
        }
        showDialog(
          context: context,
          builder: (context) => _TruckSettingsDialog(truck: truck),
        );
      },
      loading: () {
        SnackBarHelper.showInfo(context, '트럭 정보를 불러오는 중...');
      },
      error: (error, _) {
        SnackBarHelper.showError(context, '오류: $error');
      },
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Sign out from Firebase
              await ref.read(authServiceProvider).signOut();

              // 🔄 CRITICAL: Invalidate all user-specific providers to clear cached data
              ref.invalidate(currentUserTruckIdProvider);
              ref.invalidate(currentUserProvider);
              ref.invalidate(currentUserIdProvider);
              ref.invalidate(currentUserEmailProvider);
              ref.invalidate(ownerTruckProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  /// Show migration dialog to upload data to Firestore
  void _showMigrationDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.firestoreMigration),
        content: Text(
          '${l10n.confirmMigration}\n\n'
          '${l10n.uploadDataWarning}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _runMigration(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.baeminMint,
            ),
            child: Text(l10n.upload),
          ),
        ],
      ),
    );
  }

  /// Run the migration
  Future<void> _runMigration(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    // Show loading
    if (context.mounted) {
      SnackBarHelper.showInfo(context, l10n.uploadingData);
    }

    try {
      final repository = ref.read(truckRepositoryProvider);
      await runMockDataMigration(repository);

      if (context.mounted) {
        SnackBarHelper.showSuccess(context, l10n.migrationSuccess);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showError(context, l10n.uploadFailed(e));
      }
    }
  }

}

/// Truck settings dialog with image upload
class _TruckSettingsDialog extends ConsumerStatefulWidget {
  const _TruckSettingsDialog({required this.truck});

  final Truck truck;

  @override
  ConsumerState<_TruckSettingsDialog> createState() => _TruckSettingsDialogState();
}

class _TruckSettingsDialogState extends ConsumerState<_TruckSettingsDialog> {
  late TextEditingController _truckNameController;
  late TextEditingController _driverNameController;
  late TextEditingController _phoneController;

  final ImagePicker _imagePicker = ImagePicker();
  dynamic _selectedImage;
  String? _existingImageUrl;
  bool _isLoading = false;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _truckNameController = TextEditingController(text: widget.truck.truckNumber);
    _driverNameController = TextEditingController(text: widget.truck.driverName);
    _phoneController = TextEditingController(text: widget.truck.contactPhone);
    _existingImageUrl = widget.truck.imageUrl;
  }

  @override
  void dispose() {
    _truckNameController.dispose();
    _driverNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      backgroundColor: AppTheme.midnightCharcoal,
      title: const Text(
        '트럭 정보 수정',
        style: TextStyle(color: AppTheme.mustardYellow),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Text(
                l10n.truckImage,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildImagePicker(l10n),
              const SizedBox(height: 20),
              // Text fields
              _buildTextField(_truckNameController, '트럭 이름'),
              const SizedBox(height: 12),
              _buildTextField(_driverNameController, '사장님 이름'),
              const SizedBox(height: 12),
              _buildTextField(_phoneController, '연락처', keyboardType: TextInputType.phone),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('취소', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveSettings,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.mustardYellow,
            foregroundColor: Colors.black,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: AppTheme.charcoalMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.mustardYellow30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.mustardYellow),
        ),
      ),
    );
  }

  Widget _buildImagePicker(AppLocalizations l10n) {
    return GestureDetector(
      onTap: _isLoading ? null : _pickImage,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: AppTheme.charcoalMedium,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.mustardYellow30),
        ),
        child: _buildImagePreview(),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_isUploadingImage) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.mustardYellow),
            SizedBox(height: 8),
            Text('이미지 업로드 중...', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      );
    }

    if (_selectedImage != null) {
      if (kIsWeb) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                (_selectedImage as XFile).path,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),
            _buildRemoveButton(),
          ],
        );
      } else {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedImage as File,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),
            _buildRemoveButton(),
          ],
        );
      }
    }

    if (_existingImageUrl?.isNotEmpty ?? false) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: _existingImageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: AppTheme.mustardYellow),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.broken_image,
                color: Colors.grey,
                size: 48,
              ),
            ),
          ),
          _buildRemoveButton(),
        ],
      );
    }

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, color: AppTheme.mustardYellow, size: 48),
        SizedBox(height: 8),
        Text('트럭 이미지 추가', style: TextStyle(color: Colors.white70, fontSize: 14)),
        Text('탭하여 선택', style: TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _buildRemoveButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: _removeImage,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context);

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppTheme.charcoalMedium,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.selectImageSource,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppTheme.mustardYellow),
                title: Text(l10n.gallery, style: const TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              if (!kIsWeb) ...[
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: AppTheme.electricBlue),
                  title: Text(l10n.camera, style: const TextStyle(color: Colors.white)),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          if (kIsWeb) {
            _selectedImage = pickedFile;
          } else {
            _selectedImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        SnackBarHelper.showError(context, l10n.errorOccurred);
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _existingImageUrl = null;
    });
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return _existingImageUrl;

    setState(() => _isUploadingImage = true);

    try {
      final storage = FirebaseStorage.instance;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = 'truck_images/${widget.truck.id}/truck_$timestamp.jpg';
      final ref = storage.ref().child(path);

      UploadTask uploadTask;
      if (kIsWeb) {
        final xFile = _selectedImage as XFile;
        final bytes = await xFile.readAsBytes();
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        uploadTask = ref.putFile(_selectedImage as File);
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        SnackBarHelper.showError(context, l10n.imageUploadFailed);
      }
      return null;
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  Future<void> _saveSettings() async {
    final l10n = AppLocalizations.of(context);

    setState(() => _isLoading = true);

    try {
      // Upload image if selected
      String? imageUrl = _existingImageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImage();
      }

      final truckRepository = ref.read(truckRepositoryProvider);
      await truckRepository.updateTruckProfile(
        truckId: widget.truck.id,
        truckNumber: _truckNameController.text.trim(),
        driverName: _driverNameController.text.trim(),
        contactPhone: _phoneController.text.trim(),
        imageUrl: imageUrl,
      );

      // Refresh truck data
      ref.invalidate(ownerTruckProvider);

      if (mounted) {
        Navigator.pop(context);
        SnackBarHelper.showSuccess(context, l10n.truckImageUploadSuccess);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, l10n.errorOccurred);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

