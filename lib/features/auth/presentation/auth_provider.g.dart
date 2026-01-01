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

String _$currentUserHash() => r'fe1237642e58860e118cf6307a870c8cc3c60d63';

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

/// Owner request status provider (queries Firestore for owner_requests)

@ProviderFor(ownerRequestStatus)
final ownerRequestStatusProvider = OwnerRequestStatusProvider._();

/// Owner request status provider (queries Firestore for owner_requests)

final class OwnerRequestStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>?>,
          Map<String, dynamic>?,
          FutureOr<Map<String, dynamic>?>
        >
    with
        $FutureModifier<Map<String, dynamic>?>,
        $FutureProvider<Map<String, dynamic>?> {
  /// Owner request status provider (queries Firestore for owner_requests)
  OwnerRequestStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ownerRequestStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ownerRequestStatusHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>?> create(Ref ref) {
    return ownerRequestStatus(ref);
  }
}

String _$ownerRequestStatusHash() =>
    r'335a862ceff52e7a23eb85f3081d403540a752aa';

/// Check if owner needs onboarding (truck exists but onboarding not completed)

@ProviderFor(needsOwnerOnboarding)
final needsOwnerOnboardingProvider = NeedsOwnerOnboardingProvider._();

/// Check if owner needs onboarding (truck exists but onboarding not completed)

final class NeedsOwnerOnboardingProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Check if owner needs onboarding (truck exists but onboarding not completed)
  NeedsOwnerOnboardingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'needsOwnerOnboardingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$needsOwnerOnboardingHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return needsOwnerOnboarding(ref);
  }
}

String _$needsOwnerOnboardingHash() =>
    r'8d3bed127126ad6e2af7cd99056f0d79d793f86b';

/// 프로필 완성 여부 확인 (닉네임 설정 여부)

@ProviderFor(isProfileComplete)
final isProfileCompleteProvider = IsProfileCompleteProvider._();

/// 프로필 완성 여부 확인 (닉네임 설정 여부)

final class IsProfileCompleteProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 프로필 완성 여부 확인 (닉네임 설정 여부)
  IsProfileCompleteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isProfileCompleteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isProfileCompleteHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isProfileComplete(ref);
  }
}

String _$isProfileCompleteHash() => r'884821d97f8079fab1079ba337385a89b5c1711c';

/// 현재 사용자 닉네임 가져오기

@ProviderFor(currentUserNickname)
final currentUserNicknameProvider = CurrentUserNicknameProvider._();

/// 현재 사용자 닉네임 가져오기

final class CurrentUserNicknameProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// 현재 사용자 닉네임 가져오기
  CurrentUserNicknameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserNicknameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserNicknameHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return currentUserNickname(ref);
  }
}

String _$currentUserNicknameHash() =>
    r'c1a0314124799c01e6b6cc39e67c42e04542525f';

/// Check if current user is admin and manage FCM topic subscription
/// This provider should be watched in the main app to handle admin notifications

@ProviderFor(isCurrentUserAdmin)
final isCurrentUserAdminProvider = IsCurrentUserAdminProvider._();

/// Check if current user is admin and manage FCM topic subscription
/// This provider should be watched in the main app to handle admin notifications

final class IsCurrentUserAdminProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Check if current user is admin and manage FCM topic subscription
  /// This provider should be watched in the main app to handle admin notifications
  IsCurrentUserAdminProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isCurrentUserAdminProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isCurrentUserAdminHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isCurrentUserAdmin(ref);
  }
}

String _$isCurrentUserAdminHash() =>
    r'd530d2bb9730be690200dd4fd4547bd7f27c2107';

/// 현재 사용자 role 가져오기 (customer, owner, admin)

@ProviderFor(currentUserRole)
final currentUserRoleProvider = CurrentUserRoleProvider._();

/// 현재 사용자 role 가져오기 (customer, owner, admin)

final class CurrentUserRoleProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 현재 사용자 role 가져오기 (customer, owner, admin)
  CurrentUserRoleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserRoleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserRoleHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return currentUserRole(ref);
  }
}

String _$currentUserRoleHash() => r'b39e6d93eafa6f68688d4d09b3bdc20b0debea84';
