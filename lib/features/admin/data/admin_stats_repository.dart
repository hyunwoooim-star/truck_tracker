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
  Stream<AdminStats> watchAdminStats() {
    AppLogger.debug('Watching admin stats', tag: 'AdminStats');

    return _firestore
        .collection('stats')
        .doc('admin_overview')
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.exists && snapshot.data() != null) {
        return AdminStats.fromFirestore(snapshot.data()!);
      }

      // If stats document doesn't exist, compute from collections
      return _computeStatsFromCollections();
    });
  }

  /// Compute stats by querying collections (fallback)
  Future<AdminStats> _computeStatsFromCollections() async {
    AppLogger.debug('Computing stats from collections', tag: 'AdminStats');

    try {
      // Get pending owner requests count
      final pendingQuery = await _firestore
          .collection('owner_requests')
          .where('status', isEqualTo: 'pending')
          .count()
          .get();

      // Get approved owner requests count
      final approvedQuery = await _firestore
          .collection('owner_requests')
          .where('status', isEqualTo: 'approved')
          .count()
          .get();

      // Get rejected owner requests count
      final rejectedQuery = await _firestore
          .collection('owner_requests')
          .where('status', isEqualTo: 'rejected')
          .count()
          .get();

      // Get total users count
      final usersQuery = await _firestore
          .collection('users')
          .count()
          .get();

      // Get total trucks count
      final trucksQuery = await _firestore
          .collection('trucks')
          .count()
          .get();

      final pending = pendingQuery.count ?? 0;
      final approved = approvedQuery.count ?? 0;
      final rejected = rejectedQuery.count ?? 0;
      final total = approved + rejected;

      return AdminStats(
        pendingOwnerRequests: pending,
        totalApprovedOwners: approved,
        totalRejectedOwners: rejected,
        totalUsers: usersQuery.count ?? 0,
        totalTrucks: trucksQuery.count ?? 0,
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
