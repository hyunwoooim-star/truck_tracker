import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_service.dart';

part 'auth_provider.g.dart';

/// Auth service provider
@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

/// Current user stream provider
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

/// Current user provider
@riverpod
User? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Current user ID provider
@riverpod
String? currentUserId(CurrentUserIdRef ref) {
  final user = ref.watch(currentUserProvider);
  return user?.uid;
}

/// Current user email provider
@riverpod
String currentUserEmail(CurrentUserEmailRef ref) {
  final user = ref.watch(currentUserProvider);
  return user?.email ?? '';
}

/// Is authenticated provider
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
}

/// Current user truck ID provider (queries Firestore for ownedTruckId)
@riverpod
Future<int?> currentUserTruckId(CurrentUserTruckIdRef ref) async {
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    return null;
  }

  final authService = ref.watch(authServiceProvider);
  return authService.getOwnedTruckId(userId);
}

