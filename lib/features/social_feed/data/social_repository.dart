import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/post.dart';

part 'social_repository.g.dart';

/// Repository for social feed operations
class SocialRepository {
  SocialRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _postsRef =>
      _firestore.collection('posts');

  CollectionReference<Map<String, dynamic>> _commentsRef(String postId) =>
      _postsRef.doc(postId).collection('comments');

  CollectionReference<Map<String, dynamic>> _likesRef(String postId) =>
      _postsRef.doc(postId).collection('likes');

  // ========== POSTS ==========

  /// Get feed posts stream (newest first)
  Stream<List<Post>> getFeedStream({int limit = 20}) {
    return _postsRef
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }

  /// Get posts by truck
  Stream<List<Post>> getPostsByTruck(String truckId, {int limit = 20}) {
    return _postsRef
        .where('truckId', isEqualTo: truckId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }

  /// Get posts by hashtag
  Stream<List<Post>> getPostsByHashtag(String hashtag, {int limit = 20}) {
    return _postsRef
        .where('hashtags', arrayContains: hashtag.toLowerCase())
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }

  /// Get posts by user
  Stream<List<Post>> getPostsByUser(String userId, {int limit = 20}) {
    return _postsRef
        .where('authorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }

  /// Create a new post
  Future<String> createPost(Post post) async {
    final docRef = await _postsRef.add(post.toFirestore());
    return docRef.id;
  }

  /// Delete a post
  Future<void> deletePost(String postId) async {
    // Delete all comments
    final commentsSnapshot = await _commentsRef(postId).get();
    for (final doc in commentsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete all likes
    final likesSnapshot = await _likesRef(postId).get();
    for (final doc in likesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete the post
    await _postsRef.doc(postId).delete();
  }

  // ========== LIKES ==========

  /// Toggle like on a post
  Future<bool> toggleLike(String postId, String userId) async {
    final likeDoc = _likesRef(postId).doc(userId);
    final likeSnapshot = await likeDoc.get();

    if (likeSnapshot.exists) {
      // Unlike
      await likeDoc.delete();
      await _postsRef.doc(postId).update({
        'likeCount': FieldValue.increment(-1),
      });
      return false;
    } else {
      // Like
      await likeDoc.set({
        'postId': postId,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _postsRef.doc(postId).update({
        'likeCount': FieldValue.increment(1),
      });
      return true;
    }
  }

  /// Check if user liked a post
  Future<bool> isLikedByUser(String postId, String userId) async {
    final likeDoc = await _likesRef(postId).doc(userId).get();
    return likeDoc.exists;
  }

  /// Get like status for multiple posts
  Future<Map<String, bool>> getLikeStatusForPosts(
      List<String> postIds, String userId) async {
    final results = <String, bool>{};
    for (final postId in postIds) {
      results[postId] = await isLikedByUser(postId, userId);
    }
    return results;
  }

  // ========== COMMENTS ==========

  /// Get comments for a post
  Stream<List<Comment>> getComments(String postId) {
    return _commentsRef(postId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList());
  }

  /// Add a comment to a post
  Future<String> addComment(Comment comment) async {
    final docRef = await _commentsRef(comment.postId).add(comment.toFirestore());

    // Increment comment count
    await _postsRef.doc(comment.postId).update({
      'commentCount': FieldValue.increment(1),
    });

    return docRef.id;
  }

  /// Delete a comment
  Future<void> deleteComment(String postId, String commentId) async {
    await _commentsRef(postId).doc(commentId).delete();

    // Decrement comment count
    await _postsRef.doc(postId).update({
      'commentCount': FieldValue.increment(-1),
    });
  }

  // ========== HASHTAGS ==========

  /// Get trending hashtags
  Future<List<String>> getTrendingHashtags({int limit = 10}) async {
    // Get recent posts and count hashtags
    final snapshot = await _postsRef
        .orderBy('createdAt', descending: true)
        .limit(100)
        .get();

    final hashtagCounts = <String, int>{};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final hashtags = (data['hashtags'] as List<dynamic>?)?.cast<String>() ?? [];
      for (final tag in hashtags) {
        hashtagCounts[tag] = (hashtagCounts[tag] ?? 0) + 1;
      }
    }

    // Sort by count and return top hashtags
    final sortedTags = hashtagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedTags.take(limit).map((e) => e.key).toList();
  }

  /// Search hashtags
  Future<List<String>> searchHashtags(String query, {int limit = 10}) async {
    if (query.isEmpty) return [];

    final normalizedQuery = query.toLowerCase();
    final trending = await getTrendingHashtags(limit: 50);

    return trending
        .where((tag) => tag.toLowerCase().contains(normalizedQuery))
        .take(limit)
        .toList();
  }
}

@riverpod
SocialRepository socialRepository(Ref ref) {
  return SocialRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Post>> feedPosts(Ref ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getFeedStream();
}

@riverpod
Stream<List<Post>> postsByHashtag(Ref ref, String hashtag) {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getPostsByHashtag(hashtag);
}

@riverpod
Stream<List<Post>> postsByTruck(Ref ref, String truckId) {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getPostsByTruck(truckId);
}

@riverpod
Stream<List<Comment>> postComments(Ref ref, String postId) {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getComments(postId);
}

@riverpod
Future<List<String>> trendingHashtags(Ref ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getTrendingHashtags();
}
