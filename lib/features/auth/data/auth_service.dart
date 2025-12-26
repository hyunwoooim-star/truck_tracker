import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    if (kDebugMode) {
      debugPrint('🔐 AuthService: Signing in with email: $email');
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        debugPrint('✅ AuthService: Email sign in successful!');
        debugPrint('   User ID: ${userCredential.user?.uid}');
        debugPrint('   Email: ${userCredential.user?.email}');
      }

      // Update user info in Firestore
      await _updateUserInfo(userCredential.user!, 'email');

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ AuthService: Email sign in failed: $e');
      }
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    if (kDebugMode) {
      debugPrint('🔐 AuthService: Signing up with email: $email');
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await userCredential.user?.updateDisplayName(displayName);
      }

      if (kDebugMode) {
        debugPrint('✅ AuthService: Email sign up successful!');
        debugPrint('   User ID: ${userCredential.user?.uid}');
        debugPrint('   Email: ${userCredential.user?.email}');
      }

      // Create user document in Firestore
      await _createUserDocument(userCredential.user!, 'email');

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ AuthService: Email sign up failed: $e');
      }
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // GOOGLE AUTHENTICATION
  // ═══════════════════════════════════════════════════════════

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    if (kDebugMode) {
      debugPrint('🔐 AuthService: Google sign in - DISABLED FOR BUILD');
      debugPrint('⚠️ Google Sign-In implementation needs google_sign_in_web configuration');
    }

    throw UnimplementedError('Google Sign-In temporarily disabled - requires web platform configuration');
  }

  // ═══════════════════════════════════════════════════════════
  // KAKAO AUTHENTICATION (Prepared structure)
  // ═══════════════════════════════════════════════════════════

  /// Sign in with Kakao (requires kakao_flutter_sdk setup)
  Future<UserCredential?> signInWithKakao() async {
    if (kDebugMode) {
      debugPrint('🔐 AuthService: Kakao sign in - NOT AVAILABLE');
      debugPrint('⚠️ Requires: kakao_flutter_sdk_user dependency');
    }

    throw UnimplementedError('Kakao login requires kakao_flutter_sdk_user dependency');
  }

  // ═══════════════════════════════════════════════════════════
  // NAVER AUTHENTICATION (Prepared structure)
  // ═══════════════════════════════════════════════════════════

  /// Sign in with Naver (requires flutter_naver_login setup)
  Future<UserCredential?> signInWithNaver() async {
    if (kDebugMode) {
      debugPrint('🔐 AuthService: Naver sign in - NOT AVAILABLE');
      debugPrint('⚠️ Requires: flutter_naver_login dependency');
    }

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

    if (kDebugMode) {
      debugPrint('✅ User document created in Firestore');
      debugPrint('   Collection: users/${user.uid}');
    }
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

      if (kDebugMode) {
        debugPrint('✅ User document updated in Firestore');
      }
    }
  }

  /// Get user role from Firestore
  Future<String> getUserRole(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.data()?['role'] ?? 'customer';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting user role: $e');
      }
      return 'customer';
    }
  }

  /// Get user's owned truck ID
  Future<int?> getOwnedTruckId(String userId) async {
    try {
      if (kDebugMode) {
        debugPrint('🔍 Checking owned truck ID for user: $userId');
      }

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        if (kDebugMode) {
          debugPrint('❌ User document does not exist');
        }
        return null;
      }

      final data = userDoc.data();
      final ownedTruckId = data?['ownedTruckId'];

      if (kDebugMode) {
        debugPrint('📋 User data: $data');
        debugPrint('🚚 Owned truck ID: $ownedTruckId (type: ${ownedTruckId.runtimeType})');
      }

      // Handle different possible types from Firestore
      if (ownedTruckId == null) {
        return null;
      } else if (ownedTruckId is int) {
        return ownedTruckId;
      } else if (ownedTruckId is String) {
        return int.tryParse(ownedTruckId);
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ Unexpected type for ownedTruckId: ${ownedTruckId.runtimeType}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting owned truck ID: $e');
      }
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // SIGN OUT
  // ═══════════════════════════════════════════════════════════

  /// Sign out from all providers
  Future<void> signOut() async {
    if (kDebugMode) {
      debugPrint('🔐 AuthService: Signing out');
    }

    try {
      // Sign out from Firebase
      await _auth.signOut();

      if (kDebugMode) {
        debugPrint('✅ AuthService: Sign out successful');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ AuthService: Sign out failed: $e');
      }
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    if (kDebugMode) {
      debugPrint('🔐 AuthService: Sending password reset email to: $email');
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (kDebugMode) {
        debugPrint('✅ AuthService: Password reset email sent');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ AuthService: Send password reset email failed: $e');
      }
      rethrow;
    }
  }
}

