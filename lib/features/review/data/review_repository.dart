import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    debugPrint('📝 ReviewRepository: Adding review');
    debugPrint('   Truck ID: ${review.truckId}');
    debugPrint('   User: ${review.userName}');
    debugPrint('   Rating: ${review.rating} stars');

    try {
      final docRef = await _reviewsCollection.add(Review.toFirestore(review));

      // Update truck's rating statistics
      final avgRating = await getAverageRating(review.truckId);
      final totalReviews = await getReviewCount(review.truckId);
      await _truckRepository.updateRatings(review.truckId, avgRating, totalReviews);

      debugPrint('✅ Review added: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error adding review: $e');
      rethrow;
    }
  }

  /// Update a review
  Future<void> updateReview(String reviewId, Map<String, dynamic> updates) async {
    debugPrint('📝 ReviewRepository: Updating review $reviewId');
    
    try {
      await _reviewsCollection.doc(reviewId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      debugPrint('✅ Review updated');
    } catch (e) {
      debugPrint('❌ Error updating review: $e');
      rethrow;
    }
  }

  /// Delete a review
  Future<void> deleteReview(String reviewId) async {
    debugPrint('📝 ReviewRepository: Deleting review $reviewId');

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

      debugPrint('✅ Review deleted');
    } catch (e) {
      debugPrint('❌ Error deleting review: $e');
      rethrow;
    }
  }

  /// Add owner reply to a review
  Future<void> addOwnerReply(String reviewId, String ownerReply) async {
    debugPrint('💬 ReviewRepository: Adding owner reply to review $reviewId');

    try {
      await _reviewsCollection.doc(reviewId).update({
        'ownerReply': ownerReply,
        'ownerReplyAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Owner reply added');
    } catch (e) {
      debugPrint('❌ Error adding owner reply: $e');
      rethrow;
    }
  }

  /// Delete owner reply from a review
  Future<void> deleteOwnerReply(String reviewId) async {
    debugPrint('💬 ReviewRepository: Deleting owner reply from review $reviewId');

    try {
      await _reviewsCollection.doc(reviewId).update({
        'ownerReply': null,
        'ownerReplyAt': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Owner reply deleted');
    } catch (e) {
      debugPrint('❌ Error deleting owner reply: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Watch reviews for a truck (real-time stream, limited for performance)
  Stream<List<Review>> watchTruckReviews(String truckId, {int limit = 20}) {
    debugPrint('📡 ReviewRepository: Watching reviews for truck $truckId (limit: $limit)');

    return _reviewsCollection
        .where('truckId', isEqualTo: truckId)
        .orderBy('createdAt', descending: true)
        .limit(limit)  // 🚀 OPTIMIZATION: Limit to prevent excessive reads
        .snapshots()
        .map((snapshot) {
      final reviews = snapshot.docs.map((doc) {
        try {
          return Review.fromFirestore(doc);
        } catch (e) {
          debugPrint('⚠️ Error parsing review ${doc.id}: $e');
          return null;
        }
      }).whereType<Review>().toList();
      
      debugPrint('📡 Loaded ${reviews.length} reviews for truck $truckId');
      return reviews;
    });
  }

  /// Get reviews for a truck (one-time fetch, limited for performance)
  Future<List<Review>> getTruckReviews(String truckId, {int limit = 100}) async {
    debugPrint('📝 ReviewRepository: Fetching reviews for truck $truckId (limit: $limit)');

    try {
      final snapshot = await _reviewsCollection
          .where('truckId', isEqualTo: truckId)
          .orderBy('createdAt', descending: true)
          .limit(limit)  // 🚀 OPTIMIZATION: Limit to prevent excessive reads
          .get();
      
      final reviews = snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();
      
      debugPrint('✅ Fetched ${reviews.length} reviews');
      return reviews;
    } catch (e) {
      debugPrint('❌ Error fetching reviews: $e');
      return [];
    }
  }

  /// Get user's reviews (limited for performance)
  Future<List<Review>> getUserReviews(String userId, {int limit = 50}) async {
    debugPrint('📝 ReviewRepository: Fetching reviews by user $userId (limit: $limit)');

    try {
      final snapshot = await _reviewsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)  // 🚀 OPTIMIZATION: Limit to prevent excessive reads
          .get();
      
      final reviews = snapshot.docs
          .map((doc) => Review.fromFirestore(doc))
          .toList();
      
      debugPrint('✅ Fetched ${reviews.length} reviews by user');
      return reviews;
    } catch (e) {
      debugPrint('❌ Error fetching user reviews: $e');
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
      
      debugPrint('⭐ Average rating for truck $truckId: ${average.toStringAsFixed(1)}');
      return average;
    } catch (e) {
      debugPrint('❌ Error calculating average rating: $e');
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
    } catch (e) {
      debugPrint('❌ Error getting review count: $e');
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
    } catch (e) {
      debugPrint('❌ Error checking user review: $e');
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





