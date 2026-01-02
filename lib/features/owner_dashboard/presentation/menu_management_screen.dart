import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../truck_detail/domain/menu_item.dart';
import '../../truck_detail/presentation/truck_detail_provider.dart';
import 'owner_status_provider.dart';

/// Screen for managing menu items
class MenuManagementScreen extends ConsumerWidget {
  const MenuManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ownerTruckAsync = ref.watch(ownerTruckProvider);

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: Text(l10n.menuManagement),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
      ),
      body: ownerTruckAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.mustardYellow),
        ),
        error: (e, _) => Center(
          child: Text(l10n.errorOccurred, style: const TextStyle(color: Colors.red)),
        ),
        data: (truck) {
          if (truck == null) {
            return Center(
              child: Text(l10n.noTruckRegistered,
                  style: const TextStyle(color: Colors.white70)),
            );
          }
          return _MenuList(truckId: truck.id);
        },
      ),
      floatingActionButton: ownerTruckAsync.maybeWhen(
        data: (truck) => truck != null
            ? FloatingActionButton.extended(
                onPressed: () => _showAddEditDialog(context, ref, truck.id, null),
                backgroundColor: AppTheme.mustardYellow,
                foregroundColor: Colors.black,
                icon: const Icon(Icons.add),
                label: Text(l10n.addMenuItem),
              )
            : null,
        orElse: () => null,
      ),
    );
  }

  void _showAddEditDialog(
      BuildContext context, WidgetRef ref, String truckId, MenuItem? existingItem) {
    showDialog(
      context: context,
      builder: (_) => _MenuItemDialog(
        truckId: truckId,
        existingItem: existingItem,
      ),
    );
  }
}

class _MenuList extends ConsumerWidget {
  const _MenuList({required this.truckId});

  final String truckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(truckDetailStreamProvider(truckId));

    return detailAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(l10n.errorOccurred, style: const TextStyle(color: Colors.red)),
      ),
      data: (detail) {
        if (detail == null || detail.menuItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.charcoalMedium,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.noMenuItems,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '아래 + 버튼을 눌러 메뉴를 추가하세요',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          );
        }

        final availableCount = detail.menuItems.where((m) => !m.isSoldOut).length;
        final soldOutCount = detail.menuItems.where((m) => m.isSoldOut).length;

        return Column(
          children: [
            // Stats header
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.charcoalMedium,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.mustardYellow30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('전체', detail.menuItems.length.toString(), AppTheme.mustardYellow),
                  Container(width: 1, height: 40, color: AppTheme.mustardYellow30),
                  _buildStatItem('판매 중', availableCount.toString(), Colors.green),
                  Container(width: 1, height: 40, color: AppTheme.mustardYellow30),
                  _buildStatItem('품절', soldOutCount.toString(), Colors.red),
                ],
              ),
            ),
            // Menu list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                itemCount: detail.menuItems.length,
                itemBuilder: (context, index) {
                  final item = detail.menuItems[index];
                  return _MenuItemCard(
                    item: item,
                    truckId: truckId,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _MenuItemCard extends ConsumerWidget {
  const _MenuItemCard({
    required this.item,
    required this.truckId,
  });

  final MenuItem item;
  final String truckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.charcoalMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: item.isSoldOut ? AppTheme.red50 : AppTheme.mustardYellow30,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Menu item image
            if (item.imageUrl.isNotEmpty)
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: item.isSoldOut ? Colors.grey[700]! : AppTheme.mustardYellow30,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ColorFiltered(
                    colorFilter: item.isSoldOut
                        ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                        : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.charcoalMedium,
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.mustardYellow,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.charcoalMedium,
                        child: const Icon(Icons.broken_image, color: Colors.grey, size: 32),
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: AppTheme.charcoalMedium,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.mustardYellow30),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: item.isSoldOut ? Colors.grey[700] : AppTheme.mustardYellow,
                  size: 32,
                ),
              ),
            // Menu item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      color: item.isSoldOut ? Colors.grey[600] : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: item.isSoldOut ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\u20a9${item.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                    style: TextStyle(
                      color: item.isSoldOut ? Colors.grey[700] : AppTheme.mustardYellow,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Actions
            Column(
              children: [
                // Sold out toggle
                Switch(
                  value: !item.isSoldOut,
                  onChanged: (value) async {
                    final repository = ref.read(truckDetailRepositoryProvider);
                    await repository.toggleMenuItemSoldOut(truckId, item.id);
                  },
                  activeTrackColor: AppTheme.green30,
                  inactiveThumbColor: Colors.red,
                ),
                Text(
                  item.isSoldOut ? l10n.soldOut : l10n.available,
                  style: TextStyle(
                    color: item.isSoldOut ? Colors.red : Colors.green,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Edit button
            IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.electricBlue),
              onPressed: () => _showEditDialog(context, ref),
              tooltip: l10n.editMenuItem,
            ),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(context, ref, l10n),
              tooltip: l10n.deleteMenuItem,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _MenuItemDialog(
        truckId: truckId,
        existingItem: item,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.charcoalMedium,
        title: Text(l10n.deleteMenuItem, style: const TextStyle(color: Colors.white)),
        content: Text(l10n.confirmDeleteMenuItem,
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final repository = ref.read(truckDetailRepositoryProvider);
                await repository.deleteMenuItem(truckId, item.id);
                if (context.mounted) {
                  SnackBarHelper.showSuccess(context, l10n.menuItemDeleted);
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarHelper.showError(context, l10n.errorOccurred);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _MenuItemDialog extends ConsumerStatefulWidget {
  const _MenuItemDialog({
    required this.truckId,
    this.existingItem,
  });

  final String truckId;
  final MenuItem? existingItem;

  @override
  ConsumerState<_MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends ConsumerState<_MenuItemDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  // Image handling
  final ImagePicker _imagePicker = ImagePicker();
  dynamic _selectedImage; // File for mobile, XFile for web
  String? _existingImageUrl;
  bool _isUploadingImage = false;

  bool get isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingItem?.name ?? '');
    _priceController =
        TextEditingController(text: widget.existingItem?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.existingItem?.description ?? '');
    _existingImageUrl = widget.existingItem?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      backgroundColor: AppTheme.midnightCharcoal,
      title: Text(
        isEditing ? l10n.editMenuItem : l10n.addMenuItem,
        style: const TextStyle(color: AppTheme.mustardYellow),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image picker section
            _buildImagePicker(l10n),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.menuItemName,
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: l10n.menuItemNameHint,
                hintStyle: const TextStyle(color: Colors.white30),
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
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.menuItemPrice,
                labelStyle: const TextStyle(color: Colors.white70),
                prefixText: '\u20a9 ',
                prefixStyle: const TextStyle(color: Colors.white70),
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
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: l10n.menuItemDescription,
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
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel, style: const TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveMenuItem,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.mustardYellow,
            foregroundColor: Colors.black,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }

  Future<void> _saveMenuItem() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    final priceText = _priceController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty) {
      SnackBarHelper.showWarning(context, l10n.pleaseEnterReviewContent);
      return;
    }

    final price = int.tryParse(priceText);
    if (price == null || price <= 0) {
      SnackBarHelper.showWarning(context, l10n.invalidAmount);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload image if selected
      String? imageUrl = _existingImageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImage();
      }

      final repository = ref.read(truckDetailRepositoryProvider);

      if (isEditing) {
        final updatedItem = widget.existingItem!.copyWith(
          name: name,
          price: price,
          description: description,
          imageUrl: imageUrl ?? '',
        );
        await repository.updateMenuItem(widget.truckId, updatedItem);
        if (mounted) {
          Navigator.pop(context);
          SnackBarHelper.showSuccess(context, l10n.menuItemUpdated);
        }
      } else {
        final newItem = MenuItem(
          id: 'menu_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          price: price,
          description: description,
          imageUrl: imageUrl ?? '',
        );
        await repository.addMenuItem(widget.truckId, newItem);
        if (mounted) {
          Navigator.pop(context);
          SnackBarHelper.showSuccess(context, l10n.menuItemAdded);
        }
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

  /// Build image picker widget
  Widget _buildImagePicker(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.menuItemImage,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _isLoading ? null : _pickImage,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: AppTheme.charcoalMedium,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.mustardYellow30),
            ),
            child: _buildImagePreview(),
          ),
        ),
        if (_selectedImage != null || (_existingImageUrl?.isNotEmpty ?? false))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton.icon(
              onPressed: _isLoading ? null : _removeImage,
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
              label: Text(
                l10n.removeImage,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }

  /// Build image preview based on current state
  Widget _buildImagePreview() {
    // Show uploading indicator
    if (_isUploadingImage) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.mustardYellow),
            SizedBox(height: 8),
            Text(
              '이미지 업로드 중...',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      );
    }

    // Show selected image (from picker)
    if (_selectedImage != null) {
      if (kIsWeb) {
        // Web: XFile
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            (_selectedImage as XFile).path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
          ),
        );
      } else {
        // Mobile: File
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _selectedImage as File,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
          ),
        );
      }
    }

    // Show existing image URL
    if (_existingImageUrl?.isNotEmpty ?? false) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: _existingImageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 150,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(color: AppTheme.mustardYellow),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.broken_image,
            color: Colors.grey,
            size: 48,
          ),
        ),
      );
    }

    // Show placeholder
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, color: AppTheme.mustardYellow, size: 48),
        SizedBox(height: 8),
        Text(
          '이미지 추가',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          '권장: 정사각형, 최대 2MB',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
        Text(
          '(자동 WebP 최적화)',
          style: TextStyle(color: Colors.white30, fontSize: 10),
        ),
      ],
    );
  }

  /// Pick image from gallery or camera
  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context);

    // Show bottom sheet with options
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
        maxWidth: 800,
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
        SnackBarHelper.showError(context, l10n.errorOccurred);
      }
    }
  }

  /// Remove selected image
  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _existingImageUrl = null;
    });
  }

  /// Upload image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    setState(() => _isUploadingImage = true);

    try {
      final storage = FirebaseStorage.instance;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = 'menu_images/${widget.truckId}/menu_$timestamp.jpg';
      final ref = storage.ref().child(path);

      UploadTask uploadTask;
      if (kIsWeb) {
        // Web upload
        final xFile = _selectedImage as XFile;
        final bytes = await xFile.readAsBytes();
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        // Mobile upload
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
}
