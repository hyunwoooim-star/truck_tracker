import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/review.dart';
import '../../truck_list/data/truck_repository.dart';

part 'review_repository.g.dart';

/// Repository for managing reviews
class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TruckRepository _truckRepository = TruckRepository();

  CollectionReference<Map<String, dynamic>> get _reviewsCollection =>
      _firestore.collection('reviews');

  // ═══════════════════════════════════════════════════════════
  // WRITE OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Add a new review
  Future<String> addReview(Review review) async {
    AppLogger.debug('Adding review', tag: 'ReviewRepository');
    AppLogger.debug('Truck ID: ${review.truckId}', tag: 'ReviewRepository');
    AppLogger.debug('User: ${review.userName}', tag: 'ReviewRepository');
    AppLogger.debug('Rating: ${review.rating} stars', tag: 'ReviewRepository');

    try {
      final docRef = await _reviewsCollection.add(Review.toFirestore(review));

      // Update truck's rating statistics
      final avgRating = await getAverageRating(review.truckId);
      final totalReviews = await getReviewCount(review.truckId);
      await _truckRepository.updateRatings(review.truckId, avgRating, totalReviews);

      AppLogger.success('Review added: ${docRef.id}', tag: 'ReviewRepository');
      return docRef.id;
    } catch (e, stackTrace) {
      AppLogger.error('Error adding review', error: e, stackTrace: stackTrace, tag: 'ReviewRepository');
      rethrow;
    }
  }

  /// Update a review
  Future<void> updateReview(String reviewId, Map<String, dynamic> updates) async {
    AppLogger.debug('Updating review $reviewId', tag: 'ReviewRepository');

    try {
      await _reviewsCollection.doc(reviewId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Review updated', tag: 'ReviewRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error updating review', error: e, stackTrace: stackTrace, tag: 'ReviewRepository');
      rethrow;
    }
  }

  /// Delete a review
  Future<void> deleteReview(String reviewId) async {
    AppLogger.debug('Deleting review $reviewId', tag: 'ReviewRepository');

    try {
      // Get the review first to know which truck to update
      final doc = await _reviewsCollection.doc(reviewId).get();
      final truckId = doc.data()?['truckId'] as String?;

      await _reviewsCollection.doc(reviewId).delete();

      // Update truck's rating statistics if we know the truckId
      if (truckId != null) {
        final avgRating = await getAverageRating(truckId);
        final totalReviews = await getReviewCount(truckId);
        await _truckRepository.updateRatings(truckId, avgRating, totalReviews);
      }

      AppLogger.success('Review deleted', tag: 'ReviewRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting review', error: e, stackTrace: stackTrace, tag: 'ReviewRepository');
      rethrow;
    }
  }

  /// Add owner reply to a review
  Future<void> addOwnerReply(String reviewId, String ownerReply) async {
    AppLogger.debug('Adding owner reply to review $reviewId', tag: 'ReviewRepository');

    try {
      await _reviewsCollection.doc(reviewId).update({
        'ownerReply': ownerReply,
        'ownerReplyAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Owner reply added', tag: 'ReviewRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error adding owner reply', error: e, stackTrace: stackTrace, tag: 'ReviewRepository');
      rethrow;
    }
  }

  /// Delete owner reply from a review
  Future<void> deleteOwnerReply(String reviewId) async {
    AppLogger.debug('Deleting owner reply from review $reviewId', tag: 'ReviewRepository');

    try {
      await _reviewsCollection.doc(reviewId).update({
        'ownerReply': null,
        'ownerReplyAt': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Owner reply deleted', tag: 'ReviewRepository');
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting owner reply', error: e, stackTrace: stackTrace, tag: 'ReviewRepository');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Watch reviews for a truck (real-time stream, limited for performance)
  Stream<List<Review>> watchTruckReviews(String truckId, {int limit = 20}) {
    AppLogger.debug('Watching reviews for truck $truckId (limit: $limit)', tag: 'ReviewRepository');

    return _reviewsCollection
        .where('truckId', isEqualTo: truckId)
        .orderBy('createdAt', descending: true)
        .limit(limit)  // 🚀 OPTIMIZATION: Limit to prevent excessive reads
        .snapshots()
        .map((snapshot) {
      final reviews = snapshot.docs.map((doc) {
        try {
          return Review.fromFirestore(doc);
        } catch (e, stackTrace) {
          AppLogger.warning('Error parsing review ${doc.id}', tag: 'ReviewRepository');
          return null;
        }
      }).whereType<Review>().toList();

      AppLogger.debug('Loaded ${reviews.length} reviews for truck $truckId', tag: 'ReviewRepository');
      return reviews;
    });
  }

  /// Get reviews for a truck (one-time fetch, limited for performance)
  Future<List<Review>> getTruckReviews(String truckId, {int limit = 100}) async {
    AppLogger.debug('Fetching reviews for truck $truckId (limit: $limit)', tag: 'ReviewRepository');

    try {
      final snapshot = await _reviewsCollection
          .where('truckId', isEqualTo: truckId)
          .orderBy('createdAt', descending: true)
          .limit(limit)  // 🚀 OPTIMIZATION: Limit to prevent excessive reads
          .get();

      final reviews = snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();

      AppLogger.success('Fetched ${reviews.length} reviews', tag: 'ReviewRepository');
      return reviews;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching reviews', error: e, stackTrace: stackTrace, tag: 'ReviewRepository');
      return [];
    }
  }

  /// Get user's reviews (limited for performance)
  Future<List<Review>> getUserReviews(String userId, {int limit = 50}) async {
    AppLogger.debug('Fetching reviews by user $userId (limit: $limit)', tag: 'ReviewRepository');

    try {
      final snapshot = await _reviewsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)  // 🚀 OPTIMIZATION: Limit to prevent excessive reads
          .get();

      final reviews = snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();

      AppLogger.success('Fetched ${reviews.length} reviews by user', tag: 'ReviewRepository');
      return reviews;
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching user reviews', error: e, stackTrace: stackTrace, tag: 'ReviewRepository');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════

  /// Get average rating for a truck
  Future<double> getAverageRating(String truckId) async {
    try {
      final reviews = await getTruckReviews(truckId);

      if (reviews.isEmpty) return 0.0;

      final sum = reviews.fold<int>(0, (sum, review) => sum + review.rating);
      final average = sum / reviews.length;

      AppLogger.debug('Average rating for truck $truckId: ${average.toStringAsFixed(1)}', tag: 'ReviewRepository');
      return average;
    } catch (e, stackTrace) {
      AppLogger.error('Error calculating average rating', error: e, stackTrace: stackTrace, tag: 'ReviewRepository');
      return 0.0;
    }
  }

  /// Get review count for a truck
  Future<int> getReviewCount(String truckId) async {
    try {
      final snapshot = await _reviewsCollection
          .where('truckId', isEqualTo: truckId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting review count', error: e, stackTrace: stackTrace, tag: 'ReviewRepository');
      return 0;
    }
  }

  /// Check if user has reviewed a truck
  Future<bool> hasUserReviewed(String truckId, String userId) async {
    try {
      final snapshot = await _reviewsCollection
          .where('truckId', isEqualTo: truckId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e, stackTrace) {
      AppLogger.error('Error checking user review', error: e, stackTrace: stackTrace, tag: 'ReviewRepository');
      return false;
    }
  }
}

@riverpod
ReviewRepository reviewRepository(ReviewRepositoryRef ref) {
  return ReviewRepository();
}

/// Provider for watching reviews of a specific truck
@riverpod
Stream<List<Review>> truckReviews(TruckReviewsRef ref, String truckId) {
  final repository = ref.watch(reviewRepositoryProvider);
  return repository.watchTruckReviews(truckId);
}

/// Provider for average rating of a truck
@riverpod
Future<double> truckAverageRating(TruckAverageRatingRef ref, String truckId) {
  final repository = ref.watch(reviewRepositoryProvider);
  return repository.getAverageRating(truckId);
}





