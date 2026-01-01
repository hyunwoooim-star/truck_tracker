import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';

part 'admin_stats_repository.g.dart';

/// Admin statistics model
class AdminStats {
  final int pendingOwnerRequests;
  final int totalApprovedOwners;
  final int totalRejectedOwners;
  final int totalUsers;
  final int totalTrucks;
  final double approvalRate;
  final DateTime? lastUpdated;

  const AdminStats({
    this.pendingOwnerRequests = 0,
    this.totalApprovedOwners = 0,
    this.totalRejectedOwners = 0,
    this.totalUsers = 0,
    this.totalTrucks = 0,
    this.approvalRate = 0.0,
    this.lastUpdated,
  });

  factory AdminStats.fromFirestore(Map<String, dynamic> data) {
    final approved = (data['totalApprovedOwners'] as num?)?.toInt() ?? 0;
    final rejected = (data['totalRejectedOwners'] as num?)?.toInt() ?? 0;
    final total = approved + rejected;

    return AdminStats(
      pendingOwnerRequests: (data['pendingOwnerRequests'] as num?)?.toInt() ?? 0,
      totalApprovedOwners: approved,
      totalRejectedOwners: rejected,
      totalUsers: (data['totalUsers'] as num?)?.toInt() ?? 0,
      totalTrucks: (data['totalTrucks'] as num?)?.toInt() ?? 0,
      approvalRate: total > 0 ? (approved / total * 100) : 0.0,
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'pendingOwnerRequests': pendingOwnerRequests,
      'totalApprovedOwners': totalApprovedOwners,
      'totalRejectedOwners': totalRejectedOwners,
      'totalUsers': totalUsers,
      'totalTrucks': totalTrucks,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }
}

/// Repository for admin statistics
class AdminStatsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream admin statistics in real-time
  /// Always computes from collections for accuracy (ignores cached stats doc)
  Stream<AdminStats> watchAdminStats() {
    AppLogger.debug('Watching admin stats (live computation)', tag: 'AdminStats');

    // Watch users collection for changes and recompute stats
    return _firestore.collection('users').snapshots().asyncMap((_) async {
      return _computeStatsFromCollections();
    });
  }

  /// Compute stats by querying collections (uses actual documents, not count())
  Future<AdminStats> _computeStatsFromCollections() async {
    AppLogger.debug('Computing stats from collections (live)', tag: 'AdminStats');

    try {
      // Get owner requests (fetch actual docs to avoid cache issues)
      final ownerRequestsSnapshot = await _firestore
          .collection('owner_requests')
          .get(const GetOptions(source: Source.server));

      int pending = 0;
      int approved = 0;
      int rejected = 0;

      for (final doc in ownerRequestsSnapshot.docs) {
        final status = doc.data()['status'] as String?;
        if (status == 'pending') {
          pending++;
        } else if (status == 'approved') {
          approved++;
        } else if (status == 'rejected') {
          rejected++;
        }
      }

      // Get total users count (fetch from server to avoid cache)
      final usersSnapshot = await _firestore
          .collection('users')
          .get(const GetOptions(source: Source.server));
      final totalUsers = usersSnapshot.docs.length;

      // Get total trucks count (fetch from server to avoid cache)
      final trucksSnapshot = await _firestore
          .collection('trucks')
          .get(const GetOptions(source: Source.server));
      final totalTrucks = trucksSnapshot.docs.length;

      final total = approved + rejected;

      AppLogger.debug('Stats computed: users=$totalUsers, trucks=$totalTrucks, pending=$pending, approved=$approved', tag: 'AdminStats');

      return AdminStats(
        pendingOwnerRequests: pending,
        totalApprovedOwners: approved,
        totalRejectedOwners: rejected,
        totalUsers: totalUsers,
        totalTrucks: totalTrucks,
        approvalRate: total > 0 ? (approved / total * 100) : 0.0,
        lastUpdated: DateTime.now(),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error computing admin stats', error: e, stackTrace: stackTrace, tag: 'AdminStats');
      return const AdminStats();
    }
  }

  /// Get pending requests for the admin approval queue
  Stream<List<Map<String, dynamic>>> watchPendingRequests() {
    return _firestore
        .collection('owner_requests')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Get recent activity (approvals/rejections)
  Stream<List<Map<String, dynamic>>> watchRecentActivity({int limit = 10}) {
    return _firestore
        .collection('owner_requests')
        .where('status', whereIn: ['approved', 'rejected'])
        .orderBy('reviewedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
}

// ═══════════════════════════════════════════════════════════
// PROVIDERS
// ═══════════════════════════════════════════════════════════

@riverpod
AdminStatsRepository adminStatsRepository(Ref ref) {
  return AdminStatsRepository();
}

@riverpod
Stream<AdminStats> adminStats(Ref ref) {
  final repository = ref.watch(adminStatsRepositoryProvider);
  return repository.watchAdminStats();
}

@riverpod
Stream<List<Map<String, dynamic>>> pendingOwnerRequests(Ref ref) {
  final repository = ref.watch(adminStatsRepositoryProvider);
  return repository.watchPendingRequests();
}

@riverpod
Stream<List<Map<String, dynamic>>> recentAdminActivity(Ref ref) {
  final repository = ref.watch(adminStatsRepositoryProvider);
  return repository.watchRecentActivity();
}
