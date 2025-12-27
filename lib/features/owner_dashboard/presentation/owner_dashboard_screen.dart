import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/themes/app_theme.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../truck_list/presentation/truck_provider.dart';
import '../../location/location_service.dart';
import '../../truck_list/data/truck_repository.dart';
import '../../order/domain/order.dart';
import '../../order/data/order_repository.dart';
import '../../truck_detail/presentation/truck_detail_provider.dart';
import 'analytics_screen.dart';
import 'owner_status_provider.dart';
import 'schedule_management_screen.dart';
import '../../checkin/presentation/owner_qr_screen.dart';
import '../../talk/presentation/talk_widget.dart';
import '../../../scripts/migrate_mock_data.dart';

// Mustard and Charcoal color scheme
const Color _mustard = AppTheme.mustardYellow;
const Color _charcoal = AppTheme.midnightCharcoal;

// ❌ REMOVED: Mock sales data provider (todaySalesProvider, SalesItem)
// TODO: Implement real-time sales tracking from order data

class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  final LocationService _locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    final ownerTruckAsync = ref.watch(ownerTruckProvider);
    final currentEmail = ref.watch(currentUserEmailProvider);
    final numberFormat = NumberFormat('#,###');
    final l10n = AppLocalizations.of(context)!;

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
            icon: const Icon(Icons.analytics),
            tooltip: l10n.analyticsTooltip,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AnalyticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: l10n.uploadDataTooltip,
            onPressed: () => _showMigrationDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Cash Sale Button - TOP PRIORITY
                _buildCashSaleButton(context, ref, truck, l10n),
                const SizedBox(height: 16),

                // One-Touch GPS Open Button
                _buildGpsOpenButton(context, ref, truck, l10n),

                // Today's Announcement Section
                _buildAnnouncementSection(context, ref, truck, l10n),

                // ❌ REMOVED: Live Stats (mock data)
                // TODO: Implement real-time stats from order data
                // _buildLiveStats(ref, truck, numberFormat, l10n),

                // Kanban Order Board
                _buildKanbanBoard(ref, truck, l10n),

                // Sold-Out Toggles
                _buildSoldOutToggles(ref, truck, l10n),

                // Customer Conversations (Talk Widget)
                _buildTalkSection(truck, l10n),
              ],
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

  Widget _buildGpsOpenButton(BuildContext context, WidgetRef ref, truck, AppLocalizations l10n) {
    final isOperating = ref.watch(ownerOperatingStatusProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          if (isOperating) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.alreadyOpenForBusiness),
                backgroundColor: _mustard,
              ),
            );
            return;
          }

          try {
            final position = await _locationService.getCurrentPosition();

            if (position == null) {
              throw Exception(l10n.couldNotGetGPSLocation);
            }

            final repository = ref.read(truckRepositoryProvider);
            // Use openForBusiness instead of updateLocation to trigger FCM
            await repository.openForBusiness(
              truck.id,
              position.latitude,
              position.longitude,
            );

            await ref.read(ownerOperatingStatusProvider.notifier).setStatus(true);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.businessStartedNotification),
                  backgroundColor: _mustard,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n.error}: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _mustard,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 20),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.my_location, size: 28, color: Colors.black),
            const SizedBox(width: 12),
            Text(
              isOperating ? l10n.businessOpen : l10n.startBusiness,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementSection(BuildContext context, WidgetRef ref, truck, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.campaign, color: _mustard, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.todaysSpecialNotice,
                style: const TextStyle(
                  color: _mustard,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            truck.announcement.isEmpty
                ? l10n.noAnnouncementSet
                : truck.announcement,
            style: TextStyle(
              color: truck.announcement.isEmpty ? Colors.white38 : Colors.white,
              fontSize: 14,
              fontStyle: truck.announcement.isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAnnouncementDialog(context, ref, truck, l10n),
              icon: const Icon(Icons.edit, size: 16, color: _mustard),
              label: Text(
                l10n.editAnnouncement,
                style: const TextStyle(color: _mustard),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _mustard),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnnouncementDialog(BuildContext context, WidgetRef ref, truck, AppLocalizations l10n) {
    final announcementController = TextEditingController(text: truck.announcement);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _charcoal,
        title: Text(
          l10n.todaysSpecialNotice,
          style: const TextStyle(color: _mustard),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.announcementDisplayedMessage,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: announcementController,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: l10n.announcement,
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: l10n.announcementHint,
                hintStyle: const TextStyle(color: Colors.white30),
                border: const OutlineInputBorder(),
                counterStyle: const TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              final announcement = announcementController.text.trim();

              try {
                final repository = ref.read(truckRepositoryProvider);
                await repository.updateAnnouncement(truck.id, announcement);

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.announcementUpdated),
                      backgroundColor: _mustard,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.error}: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
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

  Widget _buildCashSaleButton(BuildContext context, WidgetRef ref, truck, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: () => _showCashSaleDialog(context, ref, truck, l10n),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          l10n.inputCashSale,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900, // Bold black text
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _showCashSaleDialog(BuildContext context, WidgetRef ref, truck, AppLocalizations l10n) {
    final amountController = TextEditingController();
    final itemController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _charcoal,
        title: Text(l10n.inputCashSale, style: const TextStyle(color: _mustard)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemController,
              decoration: InputDecoration(
                labelText: l10n.itemName,
                labelStyle: const TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.amount,
                labelStyle: const TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _mustard),
            onPressed: () async {
              final amount = int.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.invalidAmount)),
                );
                return;
              }

              // 🔄 FIXED: Use Order model for cash sales (unified schema)
              final currentUser = ref.read(currentUserProvider);
              final order = Order(
                id: '', // Will be set by Firestore
                userId: currentUser?.uid ?? 'unknown',
                userName: currentUser?.displayName ?? currentUser?.email ?? 'Cash Customer',
                truckId: truck.id,
                truckName: truck.foodType,
                items: [], // Empty for manual cash sales
                totalAmount: amount,
                status: OrderStatus.completed,
                paymentMethod: 'cash',
                source: 'manual',
                itemName: itemController.text.trim().isEmpty
                    ? null
                    : itemController.text.trim(),
              );

              try {
                final orderRepo = ref.read(orderRepositoryProvider);
                await orderRepo.placeOrder(order);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.cashSaleRecorded(NumberFormat('#,###').format(amount))),
                      backgroundColor: _mustard,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${l10n.error}: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: Text(l10n.save, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // ❌ REMOVED: _buildLiveStats method (88 lines) - used mock todaySalesProvider
  // TODO: Implement real-time stats widget using actual order data from truckOrdersProvider
  // Should show:
  // - Regular customers nearby (from customer_checkin data)
  // - Today's revenue (sum of completed orders)

  Widget _buildKanbanBoard(WidgetRef ref, truck, AppLocalizations l10n) {
    final ordersAsync = ref.watch(truckOrdersProvider(truck.id));

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.orderBoard,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ordersAsync.when(
            data: (orders) {
              final pending = orders.where((o) => o.status == OrderStatus.pending).toList();
              final preparing = orders.where((o) => o.status == OrderStatus.preparing).toList();
              final ready = orders.where((o) => o.status == OrderStatus.ready).toList();

              return SizedBox(
                height: 320,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildKanbanColumn(l10n.pending, pending, AppTheme.mustardYellow30, ref),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKanbanColumn(l10n.preparing, preparing, AppTheme.orange30, ref),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKanbanColumn(l10n.ready, ready, AppTheme.green30, ref),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: _mustard),
            ),
            error: (_, __) => Center(
              child: Text(
                l10n.errorLoadingOrders,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn(String title, List<Order> orders, Color color, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${orders.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(order, ref);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _charcoal,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.mustardYellow20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.userName,
            style: const TextStyle(
              color: _mustard,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${order.items.length} items - ₩${order.totalAmount}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (order.status == OrderStatus.pending)
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: _mustard, size: 20),
                  onPressed: () => _moveOrder(order, OrderStatus.preparing, ref),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (order.status == OrderStatus.preparing)
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green, size: 20),
                  onPressed: () => _moveOrder(order, OrderStatus.ready, ref),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _moveOrder(Order order, OrderStatus newStatus, WidgetRef ref) async {
    final repository = ref.read(orderRepositoryProvider);
    await repository.updateOrderStatus(order.id, newStatus);
  }

  Widget _buildSoldOutToggles(WidgetRef ref, truck, AppLocalizations l10n) {
    final detailAsync = ref.watch(truckDetailStreamProvider(truck.id));

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.menuItems,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          detailAsync.when(
            data: (detail) {
              if (detail == null || detail.menuItems.isEmpty) {
                return Text(
                  l10n.noMenuItems,
                  style: const TextStyle(color: Colors.white70),
                );
              }

              return Column(
                children: detail.menuItems.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: item.isSoldOut
                            ? AppTheme.red50
                            : AppTheme.mustardYellow30,
                      ),
                    ),
                    child: Row(
                      children: [
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
                                  decoration: item.isSoldOut
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₩${item.price}',
                                style: TextStyle(
                                  color: item.isSoldOut ? Colors.grey[700] : _mustard,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: !item.isSoldOut,
                          onChanged: (value) => _toggleSoldOut(item, truck.id, ref),
                          activeColor: _mustard,
                          inactiveThumbColor: Colors.red,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const CircularProgressIndicator(color: _mustard),
            error: (_, __) => Text(
              l10n.errorLoadingMenu,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleSoldOut(item, String truckId, WidgetRef ref) async {
    final detailProvider = ref.read(truckDetailNotifierProvider(truckId).notifier);
    await detailProvider.toggleMenuItemSoldOut(item.id);
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
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
              ref.invalidate(truckListProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  /// Show migration dialog to upload data to Firestore
  void _showMigrationDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Firestore 데이터 마이그레이션'),
        content: Text(
          '8개의 트럭 데이터를 Firestore에 업로드하시겠습니까?\n\n'
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
    final l10n = AppLocalizations.of(context)!;
    // Show loading
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Text(l10n.uploadingData),
            ],
          ),
          backgroundColor: AppTheme.baeminMint,
          duration: const Duration(seconds: 5),
        ),
      );
    }

    try {
      final repository = ref.read(truckRepositoryProvider);
      await runMockDataMigration(repository);

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 16),
                Text('✅ 8개 트럭 데이터가 성공적으로 업로드되었습니다!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(child: Text('❌ 업로드 실패: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Widget _buildTalkSection(dynamic truck, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.chat, color: _mustard, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.customerConversations,
                style: const TextStyle(
                  color: _mustard,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: TalkWidget(
              truckId: truck.id,
              isOwner: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesItemCard extends StatelessWidget {
  const _SalesItemCard({required this.sale});

  final SalesItem sale;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black03,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.mustardYellow10,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_long,
              color: AppTheme.baeminMint,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sale.item,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sale.time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₩${numberFormat.format(sale.amount)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.baeminMint,
            ),
          ),
        ],
      ),
    );
  }
}

