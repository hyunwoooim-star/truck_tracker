import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../storage/image_upload_service.dart';
import '../../truck_list/presentation/truck_provider.dart';
import '../../truck_list/domain/truck.dart';
import '../../truck_map/presentation/map_first_screen.dart';
import 'owner_status_provider.dart';
import 'tabs/tabs.dart';

// Mustard and Charcoal color scheme
const Color _mustard = AppTheme.mustardYellow;
const Color _charcoal = AppTheme.midnightCharcoal;

/// Owner Dashboard Screen - 사장님 대시보드
/// BottomNavigationBar 기반 4탭 구조 (2026-01-01)
class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ownerTruckAsync = ref.watch(ownerTruckProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: _charcoal,
      appBar: _buildAppBar(l10n),
      body: ownerTruckAsync.when(
        data: (truck) {
          if (truck == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_shipping_outlined, color: Colors.white24, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noTruckRegistered,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          }
          return _buildTabContent(truck);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: _mustard),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadingTruckData,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ownerTruckAsync.when(
        data: (truck) => truck != null ? _buildBottomNav(l10n) : null,
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  /// 상단 AppBar
  AppBar _buildAppBar(AppLocalizations l10n) {
    final titles = [
      l10n.ownerCommandCenter,
      l10n.orderManagement,
      l10n.todayStats,
      l10n.more,
    ];

    return AppBar(
      title: Text(titles[_currentIndex]),
      backgroundColor: _charcoal,
      foregroundColor: _mustard,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.map_outlined),
        tooltip: '지도 보기',
        onPressed: () {
          // 지도 화면으로 이동 (손님 뷰)
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const MapFirstScreen(),
            ),
          );
        },
      ),
      actions: [
        if (_currentIndex == 0) ...[
          // 홈 탭에서만 설정 아이콘 표시
          IconButton(
            icon: const Icon(Icons.settings, size: 24),
            tooltip: l10n.settings,
            onPressed: () => _showSettingsDialog(context, ref),
          ),
        ],
      ],
    );
  }

  /// 탭 컨텐츠
  Widget _buildTabContent(Truck truck) {
    switch (_currentIndex) {
      case 0:
        return OwnerHomeTab(truck: truck);
      case 1:
        return OwnerOrdersTab(truckId: truck.id);
      case 2:
        return OwnerAnalyticsTab(truckId: truck.id);
      case 3:
        return OwnerMoreTab(truck: truck);
      default:
        return OwnerHomeTab(truck: truck);
    }
  }

  /// 하단 네비게이션 바
  Widget _buildBottomNav(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.charcoalDark,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: l10n.home,
                isSelected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              _NavItem(
                icon: Icons.receipt_long,
                label: l10n.orders,
                isSelected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _NavItem(
                icon: Icons.bar_chart_rounded,
                label: l10n.stats,
                isSelected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              _NavItem(
                icon: Icons.more_horiz,
                label: l10n.more,
                isSelected: _currentIndex == 3,
                onTap: () => setState(() => _currentIndex = 3),
              ),
            ],
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

}

/// 하단 네비게이션 아이템
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _mustard.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? _mustard : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _mustard : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
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

  /// Upload image to Firebase Storage (WebP 압축 적용)
  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return _existingImageUrl;

    setState(() => _isUploadingImage = true);

    try {
      final imageService = ImageUploadService();

      XFile xFile;
      if (kIsWeb) {
        xFile = _selectedImage as XFile;
      } else {
        xFile = XFile((_selectedImage as File).path);
      }

      final downloadUrl = await imageService.uploadTruckImage(
        xFile,
        int.tryParse(widget.truck.id) ?? 0,
      );

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
