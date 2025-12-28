import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../truck_detail/presentation/truck_detail_screen.dart';
import '../../truck_list/data/truck_repository.dart';
import '../../truck_list/domain/truck.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../data/follow_repository.dart';

/// User Profile Screen showing followed trucks and statistics
class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.following),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: 80,
                color: AppTheme.textTertiary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.loginRequiredToOrder,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final followsAsync = ref.watch(userFollowsProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myFollowedTrucks),
        centerTitle: true,
      ),
      body: followsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: AppTheme.textTertiary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.errorOccurred,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(userFollowsProvider(user.uid));
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (follows) {
          if (follows.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noFollowedTrucks,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.browseAndFollowTrucks,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Statistics Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.charcoalMedium,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.mustardYellow30,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      icon: Icons.favorite,
                      label: l10n.following,
                      value: '${follows.length}',
                      color: Colors.red,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: AppTheme.charcoalLight,
                    ),
                    _StatItem(
                      icon: Icons.notifications_active,
                      label: l10n.notifications,
                      value: '${follows.where((f) => f.notificationsEnabled).length}',
                      color: AppTheme.electricBlue,
                    ),
                  ],
                ),
              ),
              // Followed Trucks List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: follows.length,
                  itemBuilder: (context, index) {
                    final follow = follows[index];
                    return _FollowedTruckCard(
                      follow: follow,
                      userId: user.uid,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _FollowedTruckCard extends ConsumerWidget {
  const _FollowedTruckCard({
    required this.follow,
    required this.userId,
  });

  final follow;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final truckAsync = ref.watch(singleTruckProvider(follow.truckId));

    return truckAsync.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (truck) {
        if (truck == null) return const SizedBox.shrink();

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TruckDetailScreen(truck: truck),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Truck Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: truck.imageUrl,
                      width: 80,
                      height: 80,
                      maxHeightDiskCache: 160,
                      maxWidthDiskCache: 160,
                      memCacheHeight: 160,
                      memCacheWidth: 160,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: AppTheme.mustardYellow10,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 80,
                        color: AppTheme.charcoalMedium,
                        child: const Icon(Icons.local_shipping),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Truck Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          truck.foodType,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                truck.locationDescription,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: AppTheme.electricBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              truck.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.electricBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              follow.notificationsEnabled
                                  ? Icons.notifications_active
                                  : Icons.notifications_off,
                              size: 14,
                              color: follow.notificationsEnabled
                                  ? AppTheme.electricBlue
                                  : AppTheme.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              follow.notificationsEnabled
                                  ? l10n.notificationsOn
                                  : l10n.notificationsOff,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: follow.notificationsEnabled
                                        ? AppTheme.electricBlue
                                        : AppTheme.textTertiary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Unfollow Button
                  IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      final repository = ref.read(followRepositoryProvider);
                      try {
                        await repository.unfollowTruck(
                          userId: userId,
                          truckId: truck.id,
                        );
                        if (context.mounted) {
                          SnackBarHelper.showInfo(context, l10n.unfollowedTruck);
                        }
                        // Refresh the list
                        ref.invalidate(userFollowsProvider(userId));
                      } catch (e) {
                        if (context.mounted) {
                          SnackBarHelper.showError(context, l10n.errorOccurred);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
