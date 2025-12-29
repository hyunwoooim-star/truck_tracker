import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}

