// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authServiceHash() => r'3d2d141ca5addcfbfc5c4612d4188b84040459ad';

/// Auth service provider (kept alive to maintain auth state)
///
/// Copied from [authService].
@ProviderFor(authService)
final authServiceProvider = Provider<AuthService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthServiceRef = ProviderRef<AuthService>;
String _$authStateChangesHash() => r'62dfbd5bbbfc2ce68e842d9f9d1528bbbb26c966';

/// Current user stream provider (kept alive to maintain auth state)
///
/// Copied from [authStateChanges].
@ProviderFor(authStateChanges)
final authStateChangesProvider = StreamProvider<User?>.internal(
  authStateChanges,
  name: r'authStateChangesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateChangesRef = StreamProviderRef<User?>;
String _$currentUserHash() => r'6b0cdf66db660333bc7f785159ec5dd86580ccfa';

/// Current user provider (kept alive to maintain auth state)
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = Provider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = ProviderRef<User?>;
String _$currentUserIdHash() => r'1e5fe278e29d1ba8474359614a4d7233c0aa7127';

/// Current user ID provider (kept alive to maintain auth state)
///
/// Copied from [currentUserId].
@ProviderFor(currentUserId)
final currentUserIdProvider = Provider<String?>.internal(
  currentUserId,
  name: r'currentUserIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserIdRef = ProviderRef<String?>;
String _$currentUserEmailHash() => r'2d91c02d3bfe21590fe15eee0fb3fbf520bc1405';

/// Current user email provider (kept alive to maintain auth state)
///
/// Copied from [currentUserEmail].
@ProviderFor(currentUserEmail)
final currentUserEmailProvider = Provider<String>.internal(
  currentUserEmail,
  name: r'currentUserEmailProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserEmailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserEmailRef = ProviderRef<String>;
String _$isAuthenticatedHash() => r'78dc0081ed4cc7780f28000eea1ac908ee5abcab';

/// Is authenticated provider (kept alive to maintain auth state)
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = Provider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = ProviderRef<bool>;
String _$currentUserTruckIdHash() =>
    r'374274a8f38555245f5d9910824f26918fef7215';

/// Current user truck ID provider (queries Firestore for ownedTruckId)
///
/// Copied from [currentUserTruckId].
@ProviderFor(currentUserTruckId)
final currentUserTruckIdProvider = AutoDisposeFutureProvider<int?>.internal(
  currentUserTruckId,
  name: r'currentUserTruckIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserTruckIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserTruckIdRef = AutoDisposeFutureProviderRef<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
