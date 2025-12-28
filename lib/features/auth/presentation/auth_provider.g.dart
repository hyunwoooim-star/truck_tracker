// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth service provider (kept alive to maintain auth state)

@ProviderFor(authService)
final authServiceProvider = AuthServiceProvider._();

/// Auth service provider (kept alive to maintain auth state)

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  /// Auth service provider (kept alive to maintain auth state)
  AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthService>(value),
    );
  }
}

String _$authServiceHash() => r'1c95590ad32559edae196691da64d739ee41ea44';

/// Current user stream provider (kept alive to maintain auth state)

@ProviderFor(authStateChanges)
final authStateChangesProvider = AuthStateChangesProvider._();

/// Current user stream provider (kept alive to maintain auth state)

final class AuthStateChangesProvider
    extends $FunctionalProvider<AsyncValue<User?>, User?, Stream<User?>>
    with $FutureModifier<User?>, $StreamProvider<User?> {
  /// Current user stream provider (kept alive to maintain auth state)
  AuthStateChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateChangesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateChangesHash();

  @$internal
  @override
  $StreamProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<User?> create(Ref ref) {
    return authStateChanges(ref);
  }
}

String _$authStateChangesHash() => r'68ee03e85e9d009c8d76470c92a017e82647c35b';

/// Current user provider (kept alive to maintain auth state)

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// Current user provider (kept alive to maintain auth state)

final class CurrentUserProvider extends $FunctionalProvider<User?, User?, User?>
    with $Provider<User?> {
  /// Current user provider (kept alive to maintain auth state)
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  User? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User?>(value),
    );
  }
}

String _$currentUserHash() => r'4860fc878d28fab0020b28e64a9598e5d8d6ad18';

/// Current user ID provider (kept alive to maintain auth state)

@ProviderFor(currentUserId)
final currentUserIdProvider = CurrentUserIdProvider._();

/// Current user ID provider (kept alive to maintain auth state)

final class CurrentUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Current user ID provider (kept alive to maintain auth state)
  CurrentUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentUserIdHash() => r'b6b0117742f15cce6dec214a2045e0b400741870';

/// Current user email provider (kept alive to maintain auth state)

@ProviderFor(currentUserEmail)
final currentUserEmailProvider = CurrentUserEmailProvider._();

/// Current user email provider (kept alive to maintain auth state)

final class CurrentUserEmailProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Current user email provider (kept alive to maintain auth state)
  CurrentUserEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserEmailProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserEmailHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currentUserEmail(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentUserEmailHash() => r'b4df1f9b05672e26d53d646d895c2664ecf3a550';

/// Is authenticated provider (kept alive to maintain auth state)

@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

/// Is authenticated provider (kept alive to maintain auth state)

final class IsAuthenticatedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Is authenticated provider (kept alive to maintain auth state)
  IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isAuthenticated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAuthenticatedHash() => r'fddebdc2007304fe7096090fb6e944a9842192be';

/// Current user truck ID provider (queries Firestore for ownedTruckId)

@ProviderFor(currentUserTruckId)
final currentUserTruckIdProvider = CurrentUserTruckIdProvider._();

/// Current user truck ID provider (queries Firestore for ownedTruckId)

final class CurrentUserTruckIdProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// Current user truck ID provider (queries Firestore for ownedTruckId)
  CurrentUserTruckIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserTruckIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserTruckIdHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return currentUserTruckId(ref);
  }
}

String _$currentUserTruckIdHash() =>
    r'ddb30fcbfcd51fc634e65e6fbb717bf1c2172761';
