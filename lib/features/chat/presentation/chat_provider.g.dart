// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadChatCountHash() => r'fa8a8c410589c70817f84e409c1e2fd4bac333c0';

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

/// Provider for unread chat count
/// This wraps the totalUnreadCount from chat_repository for consistency
///
/// Copied from [unreadChatCount].
@ProviderFor(unreadChatCount)
const unreadChatCountProvider = UnreadChatCountFamily();

/// Provider for unread chat count
/// This wraps the totalUnreadCount from chat_repository for consistency
///
/// Copied from [unreadChatCount].
class UnreadChatCountFamily extends Family<AsyncValue<int>> {
  /// Provider for unread chat count
  /// This wraps the totalUnreadCount from chat_repository for consistency
  ///
  /// Copied from [unreadChatCount].
  const UnreadChatCountFamily();

  /// Provider for unread chat count
  /// This wraps the totalUnreadCount from chat_repository for consistency
  ///
  /// Copied from [unreadChatCount].
  UnreadChatCountProvider call(String userId) {
    return UnreadChatCountProvider(userId);
  }

  @override
  UnreadChatCountProvider getProviderOverride(
    covariant UnreadChatCountProvider provider,
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
  String? get name => r'unreadChatCountProvider';
}

/// Provider for unread chat count
/// This wraps the totalUnreadCount from chat_repository for consistency
///
/// Copied from [unreadChatCount].
class UnreadChatCountProvider extends AutoDisposeStreamProvider<int> {
  /// Provider for unread chat count
  /// This wraps the totalUnreadCount from chat_repository for consistency
  ///
  /// Copied from [unreadChatCount].
  UnreadChatCountProvider(String userId)
    : this._internal(
        (ref) => unreadChatCount(ref as UnreadChatCountRef, userId),
        from: unreadChatCountProvider,
        name: r'unreadChatCountProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$unreadChatCountHash,
        dependencies: UnreadChatCountFamily._dependencies,
        allTransitiveDependencies:
            UnreadChatCountFamily._allTransitiveDependencies,
        userId: userId,
      );

  UnreadChatCountProvider._internal(
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
    Stream<int> Function(UnreadChatCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UnreadChatCountProvider._internal(
        (ref) => create(ref as UnreadChatCountRef),
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
  AutoDisposeStreamProviderElement<int> createElement() {
    return _UnreadChatCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UnreadChatCountProvider && other.userId == userId;
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
mixin UnreadChatCountRef on AutoDisposeStreamProviderRef<int> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UnreadChatCountProviderElement
    extends AutoDisposeStreamProviderElement<int>
    with UnreadChatCountRef {
  _UnreadChatCountProviderElement(super.provider);

  @override
  String get userId => (origin as UnreadChatCountProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
