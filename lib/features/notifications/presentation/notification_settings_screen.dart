import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../data/notification_preferences_repository.dart';
import '../services/nearby_truck_provider.dart';

/// Notification settings screen
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('알림 설정'),
          backgroundColor: AppTheme.baeminMint,
        ),
        body: const Center(
          child: Text('로그인이 필요합니다'),
        ),
      );
    }

    final settingsAsync = ref.watch(notificationSettingsStreamProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
        backgroundColor: AppTheme.baeminMint,
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          children: [
            // Header card
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: AppTheme.baeminMint,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '알림 설정',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${settings.enabledCount}개 알림 활성화',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final repo = ref.read(notificationPreferencesRepositoryProvider);
                              await repo.enableAllNotifications(user.uid);
                              ref.invalidate(notificationSettingsStreamProvider(user.uid));
                            },
                            child: const Text('전체 켜기'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final repo = ref.read(notificationPreferencesRepositoryProvider);
                              await repo.disableAllNotifications(user.uid);
                              ref.invalidate(notificationSettingsStreamProvider(user.uid));
                            },
                            child: const Text('전체 끄기'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // Notification type toggles
            _buildSectionHeader('기본 알림'),
            SwitchListTile(
              title: const Text('트럭 영업 시작'),
              subtitle: const Text('팔로우한 트럭이 영업을 시작하면 알림'),
              value: settings.truckOpenings,
              activeTrackColor: AppTheme.baeminMint.withAlpha(128),
              inactiveTrackColor: Colors.grey.withAlpha(77),
              onChanged: (value) async {
                final repo = ref.read(notificationPreferencesRepositoryProvider);
                await repo.toggleNotification(
                  userId: user.uid,
                  notificationType: 'truckOpenings',
                  enabled: value,
                );
              },
            ),
            SwitchListTile(
              title: const Text('주문 상태 변경'),
              subtitle: const Text('주문이 준비되면 알림'),
              value: settings.orderUpdates,
              activeTrackColor: AppTheme.baeminMint.withAlpha(128),
              inactiveTrackColor: Colors.grey.withAlpha(77),
              onChanged: (value) async {
                final repo = ref.read(notificationPreferencesRepositoryProvider);
                await repo.toggleNotification(
                  userId: user.uid,
                  notificationType: 'orderUpdates',
                  enabled: value,
                );
              },
            ),
            SwitchListTile(
              title: const Text('새 쿠폰'),
              subtitle: const Text('팔로우한 트럭이 새 쿠폰을 발행하면 알림'),
              value: settings.newCoupons,
              activeTrackColor: AppTheme.baeminMint.withAlpha(128),
              inactiveTrackColor: Colors.grey.withAlpha(77),
              onChanged: (value) async {
                final repo = ref.read(notificationPreferencesRepositoryProvider);
                await repo.toggleNotification(
                  userId: user.uid,
                  notificationType: 'newCoupons',
                  enabled: value,
                );
              },
            ),
            SwitchListTile(
              title: const Text('리뷰 답글'),
              subtitle: const Text('작성한 리뷰에 사장님이 답글을 달면 알림'),
              value: settings.reviews,
              activeTrackColor: AppTheme.baeminMint.withAlpha(128),
              inactiveTrackColor: Colors.grey.withAlpha(77),
              onChanged: (value) async {
                final repo = ref.read(notificationPreferencesRepositoryProvider);
                await repo.toggleNotification(
                  userId: user.uid,
                  notificationType: 'reviews',
                  enabled: value,
                );
              },
            ),

            const Divider(height: 1),

            _buildSectionHeader('소셜 알림'),
            SwitchListTile(
              title: const Text('팔로우한 트럭 활동'),
              subtitle: const Text('팔로우한 트럭의 새로운 소식 알림'),
              value: settings.followedTrucks,
              activeTrackColor: AppTheme.baeminMint.withAlpha(128),
              inactiveTrackColor: Colors.grey.withAlpha(77),
              onChanged: (value) async {
                final repo = ref.read(notificationPreferencesRepositoryProvider);
                await repo.toggleNotification(
                  userId: user.uid,
                  notificationType: 'followedTrucks',
                  enabled: value,
                );
              },
            ),
            SwitchListTile(
              title: const Text('채팅 메시지'),
              subtitle: const Text('새 채팅 메시지를 받으면 알림'),
              value: settings.chatMessages,
              activeTrackColor: AppTheme.baeminMint.withAlpha(128),
              inactiveTrackColor: Colors.grey.withAlpha(77),
              onChanged: (value) async {
                final repo = ref.read(notificationPreferencesRepositoryProvider);
                await repo.toggleNotification(
                  userId: user.uid,
                  notificationType: 'chatMessages',
                  enabled: value,
                );
              },
            ),

            const Divider(height: 1),

            _buildSectionHeader('마케팅'),
            SwitchListTile(
              title: const Text('프로모션'),
              subtitle: const Text('특별 이벤트 및 프로모션 알림'),
              value: settings.promotions,
              activeTrackColor: AppTheme.baeminMint.withAlpha(128),
              inactiveTrackColor: Colors.grey.withAlpha(77),
              onChanged: (value) async {
                final repo = ref.read(notificationPreferencesRepositoryProvider);
                await repo.toggleNotification(
                  userId: user.uid,
                  notificationType: 'promotions',
                  enabled: value,
                );
              },
            ),

            const Divider(height: 1),

            _buildSectionHeader('위치 기반 알림 🎯'),
            SwitchListTile(
              title: const Text('근처 트럭 알림'),
              subtitle: const Text('포켓몬GO 스타일! 근처에 트럭이 오면 알림'),
              value: settings.nearbyTrucks,
              activeTrackColor: AppTheme.baeminMint.withAlpha(128),
              inactiveTrackColor: Colors.grey.withAlpha(77),
              onChanged: (value) async {
                final repo = ref.read(notificationPreferencesRepositoryProvider);
                await repo.toggleNotification(
                  userId: user.uid,
                  notificationType: 'nearbyTrucks',
                  enabled: value,
                );

                // Start or stop monitoring
                final service = ref.read(nearbyTruckServiceProvider);
                if (value) {
                  await service.startMonitoring(
                    userId: user.uid,
                    settings: settings.copyWith(nearbyTrucks: true),
                  );
                  if (context.mounted) {
                    SnackBarHelper.showSuccess(context, '🚚 근처 트럭 모니터링 시작!');
                  }
                } else {
                  service.stopMonitoring();
                }
              },
            ),

            if (settings.nearbyTrucks) ...[
              // Monitoring status indicator
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withAlpha(100)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '모니터링 활성화됨',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '반경 ${settings.nearbyRadiusKm.toStringAsFixed(1)}km 내 트럭을 감시 중',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.radar, color: Colors.green),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '알림 반경: ${settings.nearbyRadiusKm.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Slider(
                      value: settings.nearbyRadius.toDouble(),
                      min: 500,
                      max: 5000,
                      divisions: 9,
                      label: '${settings.nearbyRadiusKm.toStringAsFixed(1)} km',
                      activeColor: AppTheme.baeminMint,
                      inactiveColor: Colors.grey.withAlpha(77),
                      onChanged: (value) async {
                        final repo = ref.read(notificationPreferencesRepositoryProvider);
                        await repo.updateNearbyRadius(
                          userId: user.uid,
                          radiusMeters: value.toInt(),
                        );

                        // Update service settings
                        final service = ref.read(nearbyTruckServiceProvider);
                        service.updateSettings(
                          settings.copyWith(nearbyRadius: value.toInt()),
                        );
                      },
                    ),
                    Text(
                      '🚚 ${settings.nearbyRadiusKm.toStringAsFixed(1)}km 이내에 트럭이 나타나면 알림을 받습니다!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Divider(height: 1),

            // Reset button
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('설정 초기화'),
                      content: const Text('알림 설정을 기본값으로 되돌립니다.\n계속하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('초기화'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final repo = ref.read(notificationPreferencesRepositoryProvider);
                    await repo.resetToDefault(user.uid);
                    ref.invalidate(notificationSettingsStreamProvider(user.uid));

                    if (!context.mounted) return;
                    SnackBarHelper.showInfo(context, '설정이 초기화되었습니다');
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('설정 초기화'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                '설정을 불러올 수 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
