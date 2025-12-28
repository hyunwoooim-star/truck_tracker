// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'7956fc1edca9bb8f22bf4cb09bc189b02b36af89';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = AutoDisposeProvider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRepositoryRef = AutoDisposeProviderRef<ChatRepository>;
String _$userChatRoomsHash() => r'95091e614a357db26f08a9f8ff77c8322fdc274a';

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

/// See also [userChatRooms].
@ProviderFor(userChatRooms)
const userChatRoomsProvider = UserChatRoomsFamily();

/// See also [userChatRooms].
class UserChatRoomsFamily extends Family<AsyncValue<List<ChatRoom>>> {
  /// See also [userChatRooms].
  const UserChatRoomsFamily();

  /// See also [userChatRooms].
  UserChatRoomsProvider call(String userId) {
    return UserChatRoomsProvider(userId);
  }

  @override
  UserChatRoomsProvider getProviderOverride(
    covariant UserChatRoomsProvider provider,
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
  String? get name => r'userChatRoomsProvider';
}

/// See also [userChatRooms].
class UserChatRoomsProvider extends AutoDisposeStreamProvider<List<ChatRoom>> {
  /// See also [userChatRooms].
  UserChatRoomsProvider(String userId)
    : this._internal(
        (ref) => userChatRooms(ref as UserChatRoomsRef, userId),
        from: userChatRoomsProvider,
        name: r'userChatRoomsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userChatRoomsHash,
        dependencies: UserChatRoomsFamily._dependencies,
        allTransitiveDependencies:
            UserChatRoomsFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserChatRoomsProvider._internal(
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
    Stream<List<ChatRoom>> Function(UserChatRoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserChatRoomsProvider._internal(
        (ref) => create(ref as UserChatRoomsRef),
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
  AutoDisposeStreamProviderElement<List<ChatRoom>> createElement() {
    return _UserChatRoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserChatRoomsProvider && other.userId == userId;
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
mixin UserChatRoomsRef on AutoDisposeStreamProviderRef<List<ChatRoom>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserChatRoomsProviderElement
    extends AutoDisposeStreamProviderElement<List<ChatRoom>>
    with UserChatRoomsRef {
  _UserChatRoomsProviderElement(super.provider);

  @override
  String get userId => (origin as UserChatRoomsProvider).userId;
}

String _$truckChatRoomsHash() => r'860afe46cbac4158e11e216adac2bdc1f7fd67ec';

/// See also [truckChatRooms].
@ProviderFor(truckChatRooms)
const truckChatRoomsProvider = TruckChatRoomsFamily();

/// See also [truckChatRooms].
class TruckChatRoomsFamily extends Family<AsyncValue<List<ChatRoom>>> {
  /// See also [truckChatRooms].
  const TruckChatRoomsFamily();

  /// See also [truckChatRooms].
  TruckChatRoomsProvider call(String truckId) {
    return TruckChatRoomsProvider(truckId);
  }

  @override
  TruckChatRoomsProvider getProviderOverride(
    covariant TruckChatRoomsProvider provider,
  ) {
    return call(provider.truckId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'truckChatRoomsProvider';
}

/// See also [truckChatRooms].
class TruckChatRoomsProvider extends AutoDisposeStreamProvider<List<ChatRoom>> {
  /// See also [truckChatRooms].
  TruckChatRoomsProvider(String truckId)
    : this._internal(
        (ref) => truckChatRooms(ref as TruckChatRoomsRef, truckId),
        from: truckChatRoomsProvider,
        name: r'truckChatRoomsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$truckChatRoomsHash,
        dependencies: TruckChatRoomsFamily._dependencies,
        allTransitiveDependencies:
            TruckChatRoomsFamily._allTransitiveDependencies,
        truckId: truckId,
      );

  TruckChatRoomsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.truckId,
  }) : super.internal();

  final String truckId;

  @override
  Override overrideWith(
    Stream<List<ChatRoom>> Function(TruckChatRoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TruckChatRoomsProvider._internal(
        (ref) => create(ref as TruckChatRoomsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        truckId: truckId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ChatRoom>> createElement() {
    return _TruckChatRoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckChatRoomsProvider && other.truckId == truckId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, truckId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TruckChatRoomsRef on AutoDisposeStreamProviderRef<List<ChatRoom>> {
  /// The parameter `truckId` of this provider.
  String get truckId;
}

class _TruckChatRoomsProviderElement
    extends AutoDisposeStreamProviderElement<List<ChatRoom>>
    with TruckChatRoomsRef {
  _TruckChatRoomsProviderElement(super.provider);

  @override
  String get truckId => (origin as TruckChatRoomsProvider).truckId;
}

String _$chatMessagesHash() => r'be11a5253e57c5508e59715309cfba1f63c24ca2';

/// See also [chatMessages].
@ProviderFor(chatMessages)
const chatMessagesProvider = ChatMessagesFamily();

/// See also [chatMessages].
class ChatMessagesFamily extends Family<AsyncValue<List<ChatMessage>>> {
  /// See also [chatMessages].
  const ChatMessagesFamily();

  /// See also [chatMessages].
  ChatMessagesProvider call(String chatRoomId) {
    return ChatMessagesProvider(chatRoomId);
  }

  @override
  ChatMessagesProvider getProviderOverride(
    covariant ChatMessagesProvider provider,
  ) {
    return call(provider.chatRoomId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatMessagesProvider';
}

/// See also [chatMessages].
class ChatMessagesProvider
    extends AutoDisposeStreamProvider<List<ChatMessage>> {
  /// See also [chatMessages].
  ChatMessagesProvider(String chatRoomId)
    : this._internal(
        (ref) => chatMessages(ref as ChatMessagesRef, chatRoomId),
        from: chatMessagesProvider,
        name: r'chatMessagesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chatMessagesHash,
        dependencies: ChatMessagesFamily._dependencies,
        allTransitiveDependencies:
            ChatMessagesFamily._allTransitiveDependencies,
        chatRoomId: chatRoomId,
      );

  ChatMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatRoomId,
  }) : super.internal();

  final String chatRoomId;

  @override
  Override overrideWith(
    Stream<List<ChatMessage>> Function(ChatMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesProvider._internal(
        (ref) => create(ref as ChatMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatRoomId: chatRoomId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ChatMessage>> createElement() {
    return _ChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.chatRoomId == chatRoomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatRoomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatMessagesRef on AutoDisposeStreamProviderRef<List<ChatMessage>> {
  /// The parameter `chatRoomId` of this provider.
  String get chatRoomId;
}

class _ChatMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<ChatMessage>>
    with ChatMessagesRef {
  _ChatMessagesProviderElement(super.provider);

  @override
  String get chatRoomId => (origin as ChatMessagesProvider).chatRoomId;
}

String _$totalUnreadCountHash() => r'7a7314171aa94f438b1ec55786bc5bba625a03af';

/// See also [totalUnreadCount].
@ProviderFor(totalUnreadCount)
const totalUnreadCountProvider = TotalUnreadCountFamily();

/// See also [totalUnreadCount].
class TotalUnreadCountFamily extends Family<AsyncValue<int>> {
  /// See also [totalUnreadCount].
  const TotalUnreadCountFamily();

  /// See also [totalUnreadCount].
  TotalUnreadCountProvider call(String userId) {
    return TotalUnreadCountProvider(userId);
  }

  @override
  TotalUnreadCountProvider getProviderOverride(
    covariant TotalUnreadCountProvider provider,
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
  String? get name => r'totalUnreadCountProvider';
}

/// See also [totalUnreadCount].
class TotalUnreadCountProvider extends AutoDisposeFutureProvider<int> {
  /// See also [totalUnreadCount].
  TotalUnreadCountProvider(String userId)
    : this._internal(
        (ref) => totalUnreadCount(ref as TotalUnreadCountRef, userId),
        from: totalUnreadCountProvider,
        name: r'totalUnreadCountProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$totalUnreadCountHash,
        dependencies: TotalUnreadCountFamily._dependencies,
        allTransitiveDependencies:
            TotalUnreadCountFamily._allTransitiveDependencies,
        userId: userId,
      );

  TotalUnreadCountProvider._internal(
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
    FutureOr<int> Function(TotalUnreadCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TotalUnreadCountProvider._internal(
        (ref) => create(ref as TotalUnreadCountRef),
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
  AutoDisposeFutureProviderElement<int> createElement() {
    return _TotalUnreadCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalUnreadCountProvider && other.userId == userId;
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
mixin TotalUnreadCountRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _TotalUnreadCountProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with TotalUnreadCountRef {
  _TotalUnreadCountProviderElement(super.provider);

  @override
  String get userId => (origin as TotalUnreadCountProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
