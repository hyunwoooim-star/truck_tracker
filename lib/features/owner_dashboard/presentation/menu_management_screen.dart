import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../truck_detail/domain/menu_item.dart';
import '../../truck_detail/presentation/truck_detail_provider.dart';

/// Screen for managing menu items
class MenuManagementScreen extends ConsumerWidget {
  const MenuManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final truckIdAsync = ref.watch(currentUserTruckIdProvider);

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: Text(l10n.menuManagement),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
      ),
      body: truckIdAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(l10n.errorOccurred, style: const TextStyle(color: Colors.red)),
        ),
        data: (truckId) {
          if (truckId == null) {
            return Center(
              child: Text(l10n.noTruckRegistered,
                  style: const TextStyle(color: Colors.white70)),
            );
          }
          return _MenuList(truckId: truckId.toString());
        },
      ),
      floatingActionButton: truckIdAsync.maybeWhen(
        data: (truckId) => truckId != null
            ? FloatingActionButton.extended(
                onPressed: () => _showAddEditDialog(context, ref, truckId.toString(), null),
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
                Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[600]),
                const SizedBox(height: 16),
                Text(
                  l10n.noMenuItems,
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: detail.menuItems.length,
          itemBuilder: (context, index) {
            final item = detail.menuItems[index];
            return _MenuItemCard(
              item: item,
              truckId: truckId,
            );
          },
        );
      },
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Menu item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      color: item.isSoldOut ? Colors.grey[600] : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: item.isSoldOut ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\u20a9${item.price}',
                    style: TextStyle(
                      color: item.isSoldOut ? Colors.grey[700] : AppTheme.mustardYellow,
                      fontSize: 16,
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

  bool get isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingItem?.name ?? '');
    _priceController =
        TextEditingController(text: widget.existingItem?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.existingItem?.description ?? '');
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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.menuItemName,
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: l10n.menuItemNameHint,
                hintStyle: const TextStyle(color: Colors.white30),
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
      final repository = ref.read(truckDetailRepositoryProvider);

      if (isEditing) {
        final updatedItem = widget.existingItem!.copyWith(
          name: name,
          price: price,
          description: description,
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
}
