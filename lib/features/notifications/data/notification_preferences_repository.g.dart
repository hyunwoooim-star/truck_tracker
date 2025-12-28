// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationPreferencesRepositoryHash() =>
    r'b5ab8e3423c68e453a1031c5dfdec6bdafca7d8c';

/// See also [notificationPreferencesRepository].
@ProviderFor(notificationPreferencesRepository)
final notificationPreferencesRepositoryProvider =
    AutoDisposeProvider<NotificationPreferencesRepository>.internal(
      notificationPreferencesRepository,
      name: r'notificationPreferencesRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationPreferencesRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationPreferencesRepositoryRef =
    AutoDisposeProviderRef<NotificationPreferencesRepository>;
String _$notificationSettingsHash() =>
    r'76eab21b60230376187a34af3d599df8d88cd410';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [notificationSettings].
@ProviderFor(notificationSettings)
const notificationSettingsProvider = NotificationSettingsFamily();

/// See also [notificationSettings].
class NotificationSettingsFamily
    extends Family<AsyncValue<NotificationSettings>> {
  /// See also [notificationSettings].
  const NotificationSettingsFamily();

  /// See also [notificationSettings].
  NotificationSettingsProvider call(String userId) {
    return NotificationSettingsProvider(userId);
  }

  @override
  NotificationSettingsProvider getProviderOverride(
    covariant NotificationSettingsProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'notificationSettingsProvider';
}

/// See also [notificationSettings].
class NotificationSettingsProvider
    extends AutoDisposeFutureProvider<NotificationSettings> {
  /// See also [notificationSettings].
  NotificationSettingsProvider(String userId)
    : this._internal(
        (ref) => notificationSettings(ref as NotificationSettingsRef, userId),
        from: notificationSettingsProvider,
        name: r'notificationSettingsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$notificationSettingsHash,
        dependencies: NotificationSettingsFamily._dependencies,
        allTransitiveDependencies:
            NotificationSettingsFamily._allTransitiveDependencies,
        userId: userId,
      );

  NotificationSettingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<NotificationSettings> Function(NotificationSettingsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotificationSettingsProvider._internal(
        (ref) => create(ref as NotificationSettingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<NotificationSettings> createElement() {
    return _NotificationSettingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationSettingsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NotificationSettingsRef
    on AutoDisposeFutureProviderRef<NotificationSettings> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _NotificationSettingsProviderElement
    extends AutoDisposeFutureProviderElement<NotificationSettings>
    with NotificationSettingsRef {
  _NotificationSettingsProviderElement(super.provider);

  @override
  String get userId => (origin as NotificationSettingsProvider).userId;
}

String _$notificationSettingsStreamHash() =>
    r'8cbd8bf9b434e8b46dbf857c47c3afdbb51879ce';

/// See also [notificationSettingsStream].
@ProviderFor(notificationSettingsStream)
const notificationSettingsStreamProvider = NotificationSettingsStreamFamily();

/// See also [notificationSettingsStream].
class NotificationSettingsStreamFamily
    extends Family<AsyncValue<NotificationSettings>> {
  /// See also [notificationSettingsStream].
  const NotificationSettingsStreamFamily();

  /// See also [notificationSettingsStream].
  NotificationSettingsStreamProvider call(String userId) {
    return NotificationSettingsStreamProvider(userId);
  }

  @override
  NotificationSettingsStreamProvider getProviderOverride(
    covariant NotificationSettingsStreamProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'notificationSettingsStreamProvider';
}

/// See also [notificationSettingsStream].
class NotificationSettingsStreamProvider
    extends AutoDisposeStreamProvider<NotificationSettings> {
  /// See also [notificationSettingsStream].
  NotificationSettingsStreamProvider(String userId)
    : this._internal(
        (ref) => notificationSettingsStream(
          ref as NotificationSettingsStreamRef,
          userId,
        ),
        from: notificationSettingsStreamProvider,
        name: r'notificationSettingsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$notificationSettingsStreamHash,
        dependencies: NotificationSettingsStreamFamily._dependencies,
        allTransitiveDependencies:
            NotificationSettingsStreamFamily._allTransitiveDependencies,
        userId: userId,
      );

  NotificationSettingsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<NotificationSettings> Function(
      NotificationSettingsStreamRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotificationSettingsStreamProvider._internal(
        (ref) => create(ref as NotificationSettingsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<NotificationSettings> createElement() {
    return _NotificationSettingsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationSettingsStreamProvider &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NotificationSettingsStreamRef
    on AutoDisposeStreamProviderRef<NotificationSettings> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _NotificationSettingsStreamProviderElement
    extends AutoDisposeStreamProviderElement<NotificationSettings>
    with NotificationSettingsStreamRef {
  _NotificationSettingsStreamProviderElement(super.provider);

  @override
  String get userId => (origin as NotificationSettingsStreamProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
