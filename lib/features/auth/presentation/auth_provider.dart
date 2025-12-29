import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

