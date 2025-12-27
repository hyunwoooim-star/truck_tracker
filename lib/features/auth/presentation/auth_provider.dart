import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_service.dart';

part 'auth_provider.g.dart';

/// Auth service provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

/// Current user stream provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

/// Current user provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
User? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Current user ID provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
String? currentUserId(CurrentUserIdRef ref) {
  final user = ref.watch(currentUserProvider);
  return user?.uid;
}

/// Current user email provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
String currentUserEmail(CurrentUserEmailRef ref) {
  final user = ref.watch(currentUserProvider);
  return user?.email ?? '';
}

/// Is authenticated provider (kept alive to maintain auth state)
@Riverpod(keepAlive: true)
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

