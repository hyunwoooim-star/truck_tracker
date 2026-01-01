import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import '../../../core/utils/app_logger.dart';
import 'web_auth_helper_io.dart'
    if (dart.library.html) 'web_auth_helper.dart';

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

      // Send email verification
      await sendEmailVerification();

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
  // EMAIL VERIFICATION
  // ═══════════════════════════════════════════════════════════

  /// Check if current user's email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  /// Send email verification to current user
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    if (user.emailVerified) {
      AppLogger.info('Email already verified', tag: 'AuthService');
      return;
    }

    try {
      await user.sendEmailVerification();
      AppLogger.success('Verification email sent to: ${user.email}', tag: 'AuthService');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to send verification email', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// Reload user to check email verification status
  Future<bool> checkEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    await user.reload();
    final freshUser = _auth.currentUser;

    final verified = freshUser?.emailVerified ?? false;
    AppLogger.debug('Email verified status: $verified', tag: 'AuthService');

    if (verified) {
      // Update Firestore with verified status
      await _firestore.collection('users').doc(user.uid).update({
        'emailVerified': true,
        'emailVerifiedAt': FieldValue.serverTimestamp(),
      });
    }

    return verified;
  }

  // ═══════════════════════════════════════════════════════════
  // GOOGLE AUTHENTICATION
  // ═══════════════════════════════════════════════════════════

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    AppLogger.debug('Starting Google Sign In (isWeb: $kIsWeb)', tag: 'AuthService');

    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // 웹: Firebase Auth의 signInWithPopup 사용 (redirect_uri 문제 해결)
        AppLogger.debug('Using Firebase signInWithPopup for web', tag: 'AuthService');
        final googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        // 모바일: google_sign_in 패키지 사용
        AppLogger.debug('Using GoogleSignIn package for mobile', tag: 'AuthService');
        final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          AppLogger.warning('Google Sign-In was cancelled by user', tag: 'AuthService');
          throw Exception('Google 로그인이 취소되었습니다');
        }

        AppLogger.debug('Google user obtained: ${googleUser.email}', tag: 'AuthService');

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      AppLogger.success('Google Sign In successful!', tag: 'AuthService');
      AppLogger.debug('User ID: ${userCredential.user?.uid}', tag: 'AuthService');
      AppLogger.debug('Email: ${userCredential.user?.email}', tag: 'AuthService');

      // Update user info in Firestore
      await _updateUserInfo(userCredential.user!, 'google');

      return userCredential;
    } catch (e, stackTrace) {
      AppLogger.error('Google Sign In failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // KAKAO AUTHENTICATION
  // ═══════════════════════════════════════════════════════════

  /// Cloud Functions URL for custom token generation
  static const String _cloudFunctionsUrl =
      'https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/createCustomToken';

  /// Kakao OAuth settings
  static const String _kakaoClientId = '9b29da5ab6db839b37a65c79afe9b52e'; // REST API 키
  static const String _kakaoRedirectUri = 'https://truck-tracker-fa0b0.web.app/kakao';

  /// Sign in with Kakao
  Future<UserCredential> signInWithKakao() async {
    AppLogger.debug('Starting Kakao Sign In (isWeb: $kIsWeb)', tag: 'AuthService');

    if (kIsWeb) {
      return _signInWithKakaoWeb();
    } else {
      return _signInWithKakaoMobile();
    }
  }

  /// Kakao login for mobile (uses SDK)
  Future<UserCredential> _signInWithKakaoMobile() async {
    try {
      // 1. Try Kakao Talk login first, fall back to web login
      if (await kakao.isKakaoTalkInstalled()) {
        AppLogger.debug('Kakao Talk is installed, trying Kakao Talk login', tag: 'AuthService');
        try {
          await kakao.UserApi.instance.loginWithKakaoTalk();
        } catch (e) {
          AppLogger.warning('Kakao Talk login failed, falling back to web login', tag: 'AuthService');
          await kakao.UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        AppLogger.debug('Kakao Talk not installed, using web login', tag: 'AuthService');
        await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      AppLogger.debug('Kakao OAuth token obtained', tag: 'AuthService');

      // 2. Get user info from Kakao
      final kakaoUser = await kakao.UserApi.instance.me();

      final kakaoId = kakaoUser.id.toString();
      final email = kakaoUser.kakaoAccount?.email;
      final displayName = kakaoUser.kakaoAccount?.profile?.nickname ?? '카카오 사용자';
      final photoURL = kakaoUser.kakaoAccount?.profile?.profileImageUrl;

      AppLogger.debug('Kakao user info: id=$kakaoId, email=$email, name=$displayName', tag: 'AuthService');

      // 3. Exchange Kakao token for Firebase custom token via Cloud Functions
      final customToken = await _getFirebaseCustomToken(
        provider: 'kakao',
        socialId: kakaoId,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
      );

      // 4. Sign in to Firebase with custom token
      final userCredential = await _auth.signInWithCustomToken(customToken);

      AppLogger.success('Kakao Sign In successful!', tag: 'AuthService');
      AppLogger.debug('Firebase UID: ${userCredential.user?.uid}', tag: 'AuthService');

      // 5. Update user info in Firestore
      await _updateUserInfo(userCredential.user!, 'kakao');

      return userCredential;
    } catch (e, stackTrace) {
      AppLogger.error('Kakao Sign In (mobile) failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// Kakao login for web (OAuth 2.0 redirect flow)
  Future<UserCredential> _signInWithKakaoWeb() async {
    AppLogger.debug('Starting Kakao Web OAuth flow', tag: 'AuthService');

    // Build OAuth URL (scope 완전 제거 - 기본 로그인만)
    final authUrl = Uri.https('kauth.kakao.com', '/oauth/authorize', {
      'client_id': _kakaoClientId,
      'redirect_uri': _kakaoRedirectUri,
      'response_type': 'code',
    });

    AppLogger.debug('Kakao OAuth URL: $authUrl', tag: 'AuthService');

    // Redirect to Kakao login page
    WebAuthHelper.redirectToOAuth(authUrl.toString());

    // Return a never-completing Future (page will redirect, so this won't matter)
    return Completer<UserCredential>().future;
  }

  /// Process Kakao OAuth callback (called from web callback page)
  Future<UserCredential> processKakaoCallback(String code) async {
    AppLogger.debug('Processing Kakao callback with code: ${code.substring(0, 10)}...', tag: 'AuthService');

    try {
      // Exchange code for token via Cloud Functions
      final response = await http.post(
        Uri.parse('https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/exchangeKakaoCode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'redirectUri': _kakaoRedirectUri,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('카카오 토큰 교환 실패: ${response.body}');
      }

      final data = jsonDecode(response.body);
      final customToken = data['token'] as String;

      // Sign in with custom token
      final userCredential = await _auth.signInWithCustomToken(customToken);

      AppLogger.success('Kakao Web Sign In successful!', tag: 'AuthService');

      await _updateUserInfo(userCredential.user!, 'kakao');

      return userCredential;
    } catch (e, stackTrace) {
      AppLogger.error('Kakao callback processing failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // NAVER AUTHENTICATION
  // ═══════════════════════════════════════════════════════════

  /// Naver OAuth settings
  static const String _naverClientId = '9szh6EOxjf8b40x9ZHKH';
  static const String _naverRedirectUri = 'https://truck-tracker-fa0b0.web.app/oauth/naver/callback';

  /// Sign in with Naver
  Future<UserCredential> signInWithNaver() async {
    AppLogger.debug('Starting Naver Sign In (isWeb: $kIsWeb)', tag: 'AuthService');

    if (kIsWeb) {
      return _signInWithNaverWeb();
    } else {
      return _signInWithNaverMobile();
    }
  }

  /// Naver login for mobile (uses SDK)
  Future<UserCredential> _signInWithNaverMobile() async {
    try {
      // 1. Trigger Naver login
      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status != NaverLoginStatus.loggedIn) {
        AppLogger.warning('Naver login was cancelled or failed: ${result.status}', tag: 'AuthService');
        throw Exception('네이버 로그인이 취소되었습니다');
      }

      AppLogger.debug('Naver login successful', tag: 'AuthService');

      // 2. Get user info from Naver
      final NaverAccountResult accountResult = await FlutterNaverLogin.currentAccount();

      final naverId = accountResult.id;
      final email = accountResult.email;
      final displayName = accountResult.name.isNotEmpty ? accountResult.name : accountResult.nickname;
      final photoURL = accountResult.profileImage;

      AppLogger.debug('Naver user info: id=$naverId, email=$email, name=$displayName', tag: 'AuthService');

      // 3. Exchange Naver token for Firebase custom token via Cloud Functions
      final customToken = await _getFirebaseCustomToken(
        provider: 'naver',
        socialId: naverId,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
      );

      // 4. Sign in to Firebase with custom token
      final userCredential = await _auth.signInWithCustomToken(customToken);

      AppLogger.success('Naver Sign In successful!', tag: 'AuthService');
      AppLogger.debug('Firebase UID: ${userCredential.user?.uid}', tag: 'AuthService');

      // 5. Update user info in Firestore
      await _updateUserInfo(userCredential.user!, 'naver');

      return userCredential;
    } catch (e, stackTrace) {
      AppLogger.error('Naver Sign In (mobile) failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// Naver login for web (OAuth 2.0 redirect flow)
  Future<UserCredential> _signInWithNaverWeb() async {
    AppLogger.debug('Starting Naver Web OAuth flow', tag: 'AuthService');

    // Generate state for CSRF protection
    final state = DateTime.now().millisecondsSinceEpoch.toString();

    // Build OAuth URL
    final authUrl = Uri.https('nid.naver.com', '/oauth2.0/authorize', {
      'client_id': _naverClientId,
      'redirect_uri': _naverRedirectUri,
      'response_type': 'code',
      'state': state,
    });

    AppLogger.debug('Naver OAuth URL: $authUrl', tag: 'AuthService');

    // Redirect to Naver login page
    WebAuthHelper.redirectToOAuth(authUrl.toString());

    // Return a never-completing Future (page will redirect, so this won't matter)
    // Using Completer that never completes to avoid Sentry error reports
    return Completer<UserCredential>().future;
  }

  /// Process Naver OAuth callback (called from web callback page)
  Future<UserCredential> processNaverCallback(String code, String state) async {
    AppLogger.debug('Processing Naver callback with code: ${code.substring(0, 10)}...', tag: 'AuthService');

    try {
      // Exchange code for token via Cloud Functions
      final response = await http.post(
        Uri.parse('https://us-central1-truck-tracker-fa0b0.cloudfunctions.net/exchangeNaverCode'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'state': state,
          'redirectUri': _naverRedirectUri,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('네이버 토큰 교환 실패: ${response.body}');
      }

      final data = jsonDecode(response.body);
      final customToken = data['token'] as String;

      // Sign in with custom token
      final userCredential = await _auth.signInWithCustomToken(customToken);

      AppLogger.success('Naver Web Sign In successful!', tag: 'AuthService');

      await _updateUserInfo(userCredential.user!, 'naver');

      return userCredential;
    } catch (e, stackTrace) {
      AppLogger.error('Naver callback processing failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// Helper method to get Firebase custom token from Cloud Functions
  Future<String> _getFirebaseCustomToken({
    required String provider,
    required String socialId,
    String? email,
    String? displayName,
    String? photoURL,
  }) async {
    AppLogger.debug('Getting Firebase custom token for $provider: $socialId', tag: 'AuthService');

    try {
      final body = {
        'provider': provider,
        if (provider == 'kakao') 'kakaoId': socialId,
        if (provider == 'naver') 'naverId': socialId,
        if (email != null) 'email': email,
        if (displayName != null) 'displayName': displayName,
        if (photoURL != null) 'photoURL': photoURL,
      };

      final response = await http.post(
        Uri.parse(_cloudFunctionsUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        AppLogger.error('Cloud Function error: ${response.statusCode} - ${response.body}', tag: 'AuthService');
        throw Exception('Firebase 토큰 생성에 실패했습니다');
      }

      final data = jsonDecode(response.body);
      final token = data['token'] as String?;

      if (token == null || token.isEmpty) {
        throw Exception('Firebase 토큰이 비어있습니다');
      }

      AppLogger.debug('Firebase custom token obtained successfully', tag: 'AuthService');
      return token;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get Firebase custom token', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
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

  /// Submit simple owner request (without image, just business info)
  Future<void> submitOwnerRequest({
    String? businessName,
    String? description,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('로그인이 필요합니다');
    }

    AppLogger.debug('Submitting simple owner request for user: $userId', tag: 'AuthService');

    try {
      // Create owner request document
      await _firestore.collection('owner_requests').doc(userId).set({
        'userId': userId,
        'email': _auth.currentUser?.email ?? '',
        'displayName': _auth.currentUser?.displayName ?? '',
        'businessName': businessName,
        'description': description,
        'businessLicenseUrl': null, // No image for simple request
        'status': 'pending', // pending, approved, rejected
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'reviewedBy': null,
        'reviewedAt': null,
        'rejectionReason': null,
      });

      AppLogger.success('Simple owner request submitted', tag: 'AuthService');
    } catch (e, stackTrace) {
      AppLogger.error('Owner request submission failed', error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// Submit owner verification request with business license
  /// [imageData] can be either a file path (String) for mobile or Uint8List for web
  Future<void> submitOwnerRequestWithImage(String userId, dynamic imageData) async {
    AppLogger.debug('Submitting owner request for user: $userId', tag: 'AuthService');

    try {
      // Upload business license image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('owner_requests')
          .child('$userId.jpg');

      String imageUrl;

      if (imageData is Uint8List) {
        // Web: Upload bytes directly
        await storageRef.putData(
          imageData,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        imageUrl = await storageRef.getDownloadURL();
      } else if (imageData is String) {
        // Mobile: Upload from file path
        final file = File(imageData);
        await storageRef.putFile(file);
        imageUrl = await storageRef.getDownloadURL();
      } else {
        throw Exception('Invalid image data type');
      }

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

  // ═══════════════════════════════════════════════════════════
  // OWNER ONBOARDING
  // ═══════════════════════════════════════════════════════════

  /// Check if owner needs to complete onboarding
  Future<bool> checkNeedsOnboarding(int truckId) async {
    try {
      final truckDoc = await _firestore
          .collection('trucks')
          .doc(truckId.toString())
          .get();

      if (!truckDoc.exists) {
        // Truck doesn't exist yet - needs onboarding
        return true;
      }

      final data = truckDoc.data();
      if (data == null) return true;

      // Check if onboarding was completed
      final onboardingCompleted = data['onboardingCompleted'] as bool? ?? false;

      // Also check if essential fields are filled
      final truckNumber = data['truckNumber'] as String?;
      final driverName = data['driverName'] as String?;
      final foodType = data['foodType'] as String?;

      // If onboarding not marked complete, or essential fields are empty/default
      if (!onboardingCompleted) return true;
      if (truckNumber == null || truckNumber.isEmpty || truckNumber.contains('호')) return true;
      if (driverName == null || driverName.isEmpty) return true;
      if (foodType == null || foodType.isEmpty || foodType == '미정') return true;

      return false;
    } catch (e, stackTrace) {
      AppLogger.error('Error checking onboarding status',
          error: e, stackTrace: stackTrace, tag: 'AuthService');
      return false; // Default to not requiring onboarding on error
    }
  }

  // ═══════════════════════════════════════════════════════════
  // NICKNAME MANAGEMENT
  // ═══════════════════════════════════════════════════════════

  /// 닉네임 유효성 검사 정규식 (한글/영문/숫자 2-10자)
  static final RegExp _nicknameRegex = RegExp(r'^[가-힣a-zA-Z0-9]{2,10}$');

  /// 닉네임 유효성 검사
  bool isValidNickname(String nickname) {
    if (nickname.length < 2 || nickname.length > 10) return false;
    return _nicknameRegex.hasMatch(nickname);
  }

  /// 닉네임 중복 검사
  Future<bool> isNicknameAvailable(String nickname) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();

      return query.docs.isEmpty;
    } catch (e, stackTrace) {
      AppLogger.error('Nickname availability check failed',
          error: e, stackTrace: stackTrace, tag: 'AuthService');
      return false;
    }
  }

  /// 닉네임 업데이트 및 프로필 완성 처리
  Future<void> updateNickname(String uid, String nickname) async {
    try {
      // 유효성 검사
      if (!isValidNickname(nickname)) {
        throw Exception('Invalid nickname format');
      }

      // 중복 검사
      final isAvailable = await isNicknameAvailable(nickname);
      if (!isAvailable) {
        throw Exception('Nickname already taken');
      }

      // Firestore 업데이트
      await _firestore.collection('users').doc(uid).update({
        'nickname': nickname,
        'isProfileComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Nickname updated: $nickname', tag: 'AuthService');
    } catch (e, stackTrace) {
      AppLogger.error('Nickname update failed',
          error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// 닉네임 및 역할 업데이트 (온보딩 완료 시)
  Future<void> updateNicknameAndRole(String uid, String nickname, String role) async {
    try {
      // 유효성 검사
      if (!isValidNickname(nickname)) {
        throw Exception('Invalid nickname format');
      }

      // 중복 검사
      final isAvailable = await isNicknameAvailable(nickname);
      if (!isAvailable) {
        throw Exception('Nickname already taken');
      }

      // role 검증 (customer 또는 owner만 허용)
      final validRole = (role == 'owner') ? 'pending_owner' : 'customer';

      // Firestore 업데이트
      await _firestore.collection('users').doc(uid).update({
        'nickname': nickname,
        'role': validRole,
        'isProfileComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.success('Nickname and role updated: $nickname ($validRole)', tag: 'AuthService');
    } catch (e, stackTrace) {
      AppLogger.error('Nickname and role update failed',
          error: e, stackTrace: stackTrace, tag: 'AuthService');
      rethrow;
    }
  }

  /// 프로필 완성 여부 확인
  Future<bool> isProfileComplete(String uid) async {
    try {
      AppLogger.debug('🔍 Checking profile completion for uid: $uid', tag: 'AuthService');
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        AppLogger.debug('❌ User doc does not exist → returning false', tag: 'AuthService');
        return false;
      }

      final data = doc.data();
      final isComplete = data?['isProfileComplete'] == true;
      AppLogger.debug('📋 isProfileComplete field = ${data?['isProfileComplete']}, returning: $isComplete', tag: 'AuthService');
      return isComplete;
    } catch (e, stackTrace) {
      AppLogger.error('Profile completion check failed',
          error: e, stackTrace: stackTrace, tag: 'AuthService');
      return false;
    }
  }

  /// 현재 사용자의 닉네임 가져오기
  Future<String?> getCurrentUserNickname() async {
    final uid = currentUserId;
    if (uid == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      return doc.data()?['nickname'] as String?;
    } catch (e, stackTrace) {
      AppLogger.error('Get nickname failed',
          error: e, stackTrace: stackTrace, tag: 'AuthService');
      return null;
    }
  }
}

