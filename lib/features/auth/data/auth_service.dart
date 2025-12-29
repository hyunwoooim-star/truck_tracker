import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../core/utils/app_logger.dart';

/// Unified Authentication Service
/// Supports Email, Google, and prepared for Kakao/Naver
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Get current user email
  String? get currentUserEmail => _auth.currentUser?.email;

  /// Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ═══════════════════════════════════════════════════════════
  // EMAIL AUTHENTICATION
  // ═══════════════════════════════════════════════════════════

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    AppLogger.debug('Signing in with email: $email', tag: 'AuthService');

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppLogger.success('Email sign in successful!', tag: 'AuthService');
      AppLogger.debug('User ID: ${userCredential.user?.uid}', tag: 'AuthService');
      AppLogger.debug('Email: ${userCredential.user?.email}', tag: 'AuthService');

      // Update user info in Firestore
      await _updateUserInfo(userCredential.user!, 'email');

      return userCredential;
    } catch (e, stackTrace) {
      AppLogger.error('Email sign in failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    AppLogger.debug('Signing up with email: $email', tag: 'AuthService');

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await userCredential.user?.updateDisplayName(displayName);
      }

      AppLogger.success('Email sign up successful!', tag: 'AuthService');
      AppLogger.debug('User ID: ${userCredential.user?.uid}', tag: 'AuthService');
      AppLogger.debug('Email: ${userCredential.user?.email}', tag: 'AuthService');

      // Create user document in Firestore
      await _createUserDocument(userCredential.user!, 'email');

      return userCredential;
    } catch (e, stackTrace) {
      AppLogger.error('Email sign up failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // GOOGLE AUTHENTICATION
  // ═══════════════════════════════════════════════════════════

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    AppLogger.debug('Google sign in - DISABLED FOR BUILD', tag: 'AuthService');
    AppLogger.warning('Google Sign-In implementation needs google_sign_in_web configuration', tag: 'AuthService');

    throw UnimplementedError('Google Sign-In temporarily disabled - requires web platform configuration');
  }

  // ═══════════════════════════════════════════════════════════
  // KAKAO AUTHENTICATION (Prepared structure)
  // ═══════════════════════════════════════════════════════════

  /// Sign in with Kakao (requires kakao_flutter_sdk setup)
  Future<UserCredential?> signInWithKakao() async {
    AppLogger.debug('Kakao sign in - NOT AVAILABLE', tag: 'AuthService');
    AppLogger.warning('Requires: kakao_flutter_sdk_user dependency', tag: 'AuthService');

    throw UnimplementedError('Kakao login requires kakao_flutter_sdk_user dependency');
  }

  // ═══════════════════════════════════════════════════════════
  // NAVER AUTHENTICATION (Prepared structure)
  // ═══════════════════════════════════════════════════════════

  /// Sign in with Naver (requires flutter_naver_login setup)
  Future<UserCredential?> signInWithNaver() async {
    AppLogger.debug('Naver sign in - NOT AVAILABLE', tag: 'AuthService');
    AppLogger.warning('Requires: flutter_naver_login dependency', tag: 'AuthService');

    throw UnimplementedError('Naver login requires flutter_naver_login dependency');
  }

  // ═══════════════════════════════════════════════════════════
  // USER MANAGEMENT
  // ═══════════════════════════════════════════════════════════

  /// Create user document in Firestore
  Future<void> _createUserDocument(User user, String loginMethod) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    
    final userData = {
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': user.displayName ?? user.email?.split('@')[0] ?? 'User',
      'photoURL': user.photoURL,
      'loginMethod': loginMethod,
      'role': 'customer', // Default role
      'ownedTruckId': null, // No truck initially
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await userDoc.set(userData, SetOptions(merge: true));

    AppLogger.success('User document created in Firestore', tag: 'AuthService');
    AppLogger.debug('Collection: users/${user.uid}', tag: 'AuthService');
  }

  /// Update user info in Firestore
  Future<void> _updateUserInfo(User user, String loginMethod) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    // Check if user document exists
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // Create new document
      await _createUserDocument(user, loginMethod);
    } else {
      // Update existing document
      await userDoc.update({
        'email': user.email ?? '',
        'displayName': user.displayName ?? docSnapshot.data()?['displayName'] ?? 'User',
        'photoURL': user.photoURL,
        'loginMethod': loginMethod,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('User document updated in Firestore', tag: 'AuthService');
    }
  }

  /// Get user role from Firestore
  Future<String> getUserRole(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.data()?['role'] ?? 'customer';
    } catch (e, stackTrace) {
      AppLogger.error('Error getting user role', error: e, stackTrace: stackTrace, tag: 'AuthService');
      return 'customer';
    }
  }

  /// Get user's owned truck ID
  Future<int?> getOwnedTruckId(String userId) async {
    try {
      AppLogger.debug('Checking owned truck ID for user: $userId', tag: 'AuthService');

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        AppLogger.warning('User document does not exist', tag: 'AuthService');
        return null;
      }

      final data = userDoc.data();
      final ownedTruckId = data?['ownedTruckId'];

      AppLogger.debug('User data: $data', tag: 'AuthService');
      AppLogger.debug('Owned truck ID: $ownedTruckId (type: ${ownedTruckId.runtimeType})', tag: 'AuthService');

      // Handle different possible types from Firestore
      if (ownedTruckId == null) {
        return null;
      } else if (ownedTruckId is int) {
        return ownedTruckId;
      } else if (ownedTruckId is String) {
        return int.tryParse(ownedTruckId);
      } else {
        AppLogger.warning('Unexpected type for ownedTruckId: ${ownedTruckId.runtimeType}', tag: 'AuthService');
        return null;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error getting owned truck ID', error: e, stackTrace: stackTrace, tag: 'AuthService');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // SIGN OUT
  // ═══════════════════════════════════════════════════════════

  /// Sign out from all providers
  Future<void> signOut() async {
    AppLogger.debug('Signing out', tag: 'AuthService');

    try {
      // Sign out from Firebase
      await _auth.signOut();

      AppLogger.success('Sign out successful', tag: 'AuthService');
    } catch (e, stackTrace) {
      AppLogger.error('Sign out failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    AppLogger.debug('Sending password reset email to: $email', tag: 'AuthService');

    try {
      await _auth.sendPasswordResetEmail(email: email);
      AppLogger.success('Password reset email sent', tag: 'AuthService');
    } catch (e, stackTrace) {
      AppLogger.error('Send password reset email failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // OWNER VERIFICATION
  // ═══════════════════════════════════════════════════════════

  /// Submit owner verification request with business license
  Future<void> submitOwnerRequest(String userId, String imagePath) async {
    AppLogger.debug('Submitting owner request for user: $userId', tag: 'AuthService');

    try {
      // Upload business license image to Firebase Storage
      final file = File(imagePath);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('owner_requests')
          .child('$userId.jpg');

      await storageRef.putFile(file);
      final imageUrl = await storageRef.getDownloadURL();

      AppLogger.debug('Business license uploaded: $imageUrl', tag: 'AuthService');

      // Create owner request document
      await _firestore.collection('owner_requests').doc(userId).set({
        'userId': userId,
        'email': _auth.currentUser?.email ?? '',
        'displayName': _auth.currentUser?.displayName ?? '',
        'businessLicenseUrl': imageUrl,
        'status': 'pending', // pending, approved, rejected
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'reviewedBy': null,
        'reviewedAt': null,
        'rejectionReason': null,
      });

      AppLogger.success('Owner request submitted', tag: 'AuthService');
    } catch (e, stackTrace) {
      AppLogger.error('Owner request submission failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// Get owner request status
  Future<Map<String, dynamic>?> getOwnerRequestStatus(String userId) async {
    try {
      final doc = await _firestore.collection('owner_requests').doc(userId).get();
      return doc.data();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get owner request status', error: e, stackTrace: stackTrace, tag: 'AuthService');
      return null;
    }
  }

  /// Approve owner request (admin only)
  Future<void> approveOwnerRequest(String userId, int truckId, String adminId) async {
    AppLogger.debug('Approving owner request for user: $userId with truck: $truckId', tag: 'AuthService');

    try {
      final batch = _firestore.batch();

      // Update owner request status
      final requestRef = _firestore.collection('owner_requests').doc(userId);
      batch.update(requestRef, {
        'status': 'approved',
        'reviewedBy': adminId,
        'reviewedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'assignedTruckId': truckId,
      });

      // Update user document with owner role
      final userRef = _firestore.collection('users').doc(userId);
      batch.update(userRef, {
        'role': 'owner',
        'ownedTruckId': truckId,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create notification for user
      final notificationRef = _firestore.collection('notifications').doc();
      batch.set(notificationRef, {
        'userId': userId,
        'type': 'owner_approved',
        'title': '사장님 인증 승인',
        'body': '축하합니다! 사장님 인증이 승인되었습니다. 트럭 #$truckId가 배정되었습니다.',
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      AppLogger.success('Owner request approved', tag: 'AuthService');
    } catch (e, stackTrace) {
      AppLogger.error('Owner request approval failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// Reject owner request (admin only)
  Future<void> rejectOwnerRequest(String userId, String adminId, String reason) async {
    AppLogger.debug('Rejecting owner request for user: $userId', tag: 'AuthService');

    try {
      final batch = _firestore.batch();

      // Update owner request status
      final requestRef = _firestore.collection('owner_requests').doc(userId);
      batch.update(requestRef, {
        'status': 'rejected',
        'reviewedBy': adminId,
        'reviewedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'rejectionReason': reason,
      });

      // Create notification for user
      final notificationRef = _firestore.collection('notifications').doc();
      batch.set(notificationRef, {
        'userId': userId,
        'type': 'owner_rejected',
        'title': '사장님 인증 거절',
        'body': '사장님 인증이 거절되었습니다. 사유: $reason',
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      AppLogger.success('Owner request rejected', tag: 'AuthService');
    } catch (e, stackTrace) {
      AppLogger.error('Owner request rejection failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// Get all pending owner requests (admin only)
  Stream<List<Map<String, dynamic>>> getPendingOwnerRequests() {
    return _firestore
        .collection('owner_requests')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  // ═══════════════════════════════════════════════════════════
  // ADMIN ACCESS CONTROL
  // ═══════════════════════════════════════════════════════════

  /// List of admin email addresses
  static const List<String> _adminEmails = [
    'admin@trucktracker.com',
    'hyunwoooim@gmail.com', // 개발자
  ];

  /// Check if current user is an admin
  Future<bool> isCurrentUserAdmin() async {
    final user = currentUser;
    if (user == null) return false;

    // Check email-based admin list
    if (user.email != null && _adminEmails.contains(user.email!.toLowerCase())) {
      return true;
    }

    // Check Firestore role
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final role = userDoc.data()?['role'] as String?;
      return role == 'admin';
    } catch (e) {
      AppLogger.error('Error checking admin status', error: e, tag: 'AuthService');
      return false;
    }
  }

  /// Check if a specific user ID is an admin
  Future<bool> isUserAdmin(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return false;

      final data = userDoc.data();
      final email = data?['email'] as String?;
      final role = data?['role'] as String?;

      // Check email-based admin list
      if (email != null && _adminEmails.contains(email.toLowerCase())) {
        return true;
      }

      // Check role
      return role == 'admin';
    } catch (e) {
      AppLogger.error('Error checking admin status', error: e, tag: 'AuthService');
      return false;
    }
  }
}

