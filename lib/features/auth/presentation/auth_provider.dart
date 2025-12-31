import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../../notifications/fcm_service.dart';
import '../data/auth_service.dart';

part 'auth_provider.g.dart';

/// Singleton instance of AuthService to prevent multiple instances
final _authServiceInstance = AuthService();

/// Auth service provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return _authServiceInstance;
}

/// Current user stream provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

/// Current user provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
User? currentUser(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (error, stackTrace) => null,
  );
}

/// Current user ID provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
String? currentUserId(Ref ref) {
  final user = ref.watch(currentUserProvider);
  return user?.uid;
}

/// Current user email provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
String currentUserEmail(Ref ref) {
  final user = ref.watch(currentUserProvider);
  return user?.email ?? '';
}

/// Is authenticated provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
bool isAuthenticated(Ref ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
}

/// Current user truck ID provider (queries Firestore for ownedTruckId)
@riverpod
Future<int?> currentUserTruckId(Ref ref) async {
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    return null;
  }

  final authService = ref.watch(authServiceProvider);
  return authService.getOwnedTruckId(userId);
}

/// Owner request status provider (queries Firestore for owner_requests)
@riverpod
Future<Map<String, dynamic>?> ownerRequestStatus(Ref ref) async {
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    return null;
  }

  final authService = ref.watch(authServiceProvider);
  return authService.getOwnerRequestStatus(userId);
}

/// Check if owner needs onboarding (truck exists but onboarding not completed)
@riverpod
Future<bool> needsOwnerOnboarding(Ref ref) async {
  final truckId = await ref.watch(currentUserTruckIdProvider.future);

  if (truckId == null) {
    return false; // Not an owner
  }

  final authService = ref.watch(authServiceProvider);
  return authService.checkNeedsOnboarding(truckId);
}

/// Check if current user is admin and manage FCM topic subscription
/// This provider should be watched in the main app to handle admin notifications
@riverpod
Future<bool> isCurrentUserAdmin(Ref ref) async {
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    return false;
  }

  final authService = ref.watch(authServiceProvider);
  final fcmService = ref.watch(fcmServiceProvider);

  final isAdmin = await authService.isCurrentUserAdmin();

  // Subscribe/unsubscribe from admin notifications based on role
  if (isAdmin) {
    await fcmService.subscribeToAdminNotifications();
    AppLogger.debug('Admin user detected - subscribed to admin notifications', tag: 'AuthProvider');
  } else {
    // Ensure non-admins are not subscribed
    await fcmService.unsubscribeFromAdminNotifications();
  }

  return isAdmin;
}

