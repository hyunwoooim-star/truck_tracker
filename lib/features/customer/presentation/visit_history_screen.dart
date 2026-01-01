import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../checkin/data/checkin_repository.dart';
import '../../checkin/domain/checkin.dart';

/// 방문 기록 화면 - 손님의 체크인 히스토리
class VisitHistoryScreen extends ConsumerWidget {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: AppTheme.midnightCharcoal,
        appBar: AppBar(
          title: Text(l10n.visitHistory),
          backgroundColor: AppTheme.midnightCharcoal,
          foregroundColor: AppTheme.mustardYellow,
        ),
        body: Center(
          child: Text(
            l10n.loginRequired,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final checkinRepo = ref.watch(checkinRepositoryProvider);

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: Text(l10n.visitHistory),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
        elevation: 0,
      ),
      body: StreamBuilder<List<CheckIn>>(
        stream: checkinRepo.watchUserCheckins(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.mustardYellow),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${l10n.error}: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final checkins = snapshot.data ?? [];

          if (checkins.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.white30,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noVisitHistory,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.visitTrucksHint,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Group by date
          final groupedCheckins = <String, List<CheckIn>>{};
          final dateFormat = DateFormat('yyyy년 MM월 dd일');

          for (final checkin in checkins) {
            if (checkin.checkedInAt != null) {
              final dateKey = dateFormat.format(checkin.checkedInAt!);
              groupedCheckins.putIfAbsent(dateKey, () => []).add(checkin);
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedCheckins.length,
            itemBuilder: (context, index) {
              final dateKey = groupedCheckins.keys.elementAt(index);
              final dayCheckins = groupedCheckins[dateKey]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      dateKey,
                      style: const TextStyle(
                        color: AppTheme.mustardYellow,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Checkins for this date
                  ...dayCheckins.map((checkin) => _VisitCard(checkin: checkin)),
                  const SizedBox(height: 8),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _VisitCard extends StatelessWidget {
  final CheckIn checkin;

  const _VisitCard({required this.checkin});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final time = checkin.checkedInAt != null
        ? timeFormat.format(checkin.checkedInAt!)
        : '--:--';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.mustardYellow20,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_shipping,
              color: AppTheme.mustardYellow,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  checkin.truckName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.star,
                      size: 14,
                      color: AppTheme.mustardYellow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${checkin.loyaltyPoints}P',
                      style: const TextStyle(
                        color: AppTheme.mustardYellow,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
