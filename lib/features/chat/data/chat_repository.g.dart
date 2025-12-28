// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'ea9e083da4dcdf131e1c2e9541b05be8efba8977';

@ProviderFor(userChatRooms)
final userChatRoomsProvider = UserChatRoomsFamily._();

final class UserChatRoomsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatRoom>>,
          List<ChatRoom>,
          Stream<List<ChatRoom>>
        >
    with $FutureModifier<List<ChatRoom>>, $StreamProvider<List<ChatRoom>> {
  UserChatRoomsProvider._({
    required UserChatRoomsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userChatRoomsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userChatRoomsHash();

  @override
  String toString() {
    return r'userChatRoomsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ChatRoom>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatRoom>> create(Ref ref) {
    final argument = this.argument as String;
    return userChatRooms(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserChatRoomsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userChatRoomsHash() => r'f25d6bbc069aa1b667479a141bbe61f9c48bf0fc';

final class UserChatRoomsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ChatRoom>>, String> {
  UserChatRoomsFamily._()
    : super(
        retry: null,
        name: r'userChatRoomsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserChatRoomsProvider call(String userId) =>
      UserChatRoomsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userChatRoomsProvider';
}

@ProviderFor(truckChatRooms)
final truckChatRoomsProvider = TruckChatRoomsFamily._();

final class TruckChatRoomsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatRoom>>,
          List<ChatRoom>,
          Stream<List<ChatRoom>>
        >
    with $FutureModifier<List<ChatRoom>>, $StreamProvider<List<ChatRoom>> {
  TruckChatRoomsProvider._({
    required TruckChatRoomsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'truckChatRoomsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$truckChatRoomsHash();

  @override
  String toString() {
    return r'truckChatRoomsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ChatRoom>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatRoom>> create(Ref ref) {
    final argument = this.argument as String;
    return truckChatRooms(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TruckChatRoomsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$truckChatRoomsHash() => r'd6a34c8713adcb104f588fce806e9dda84db80de';

final class TruckChatRoomsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ChatRoom>>, String> {
  TruckChatRoomsFamily._()
    : super(
        retry: null,
        name: r'truckChatRoomsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TruckChatRoomsProvider call(String truckId) =>
      TruckChatRoomsProvider._(argument: truckId, from: this);

  @override
  String toString() => r'truckChatRoomsProvider';
}

@ProviderFor(chatMessages)
final chatMessagesProvider = ChatMessagesFamily._();

final class ChatMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatMessage>>,
          List<ChatMessage>,
          Stream<List<ChatMessage>>
        >
    with
        $FutureModifier<List<ChatMessage>>,
        $StreamProvider<List<ChatMessage>> {
  ChatMessagesProvider._({
    required ChatMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @override
  String toString() {
    return r'chatMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ChatMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatMessage>> create(Ref ref) {
    final argument = this.argument as String;
    return chatMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMessagesHash() => r'efdbbd3b655d1b810a7c856c10cf887a5f233872';

final class ChatMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ChatMessage>>, String> {
  ChatMessagesFamily._()
    : super(
        retry: null,
        name: r'chatMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatMessagesProvider call(String chatRoomId) =>
      ChatMessagesProvider._(argument: chatRoomId, from: this);

  @override
  String toString() => r'chatMessagesProvider';
}

@ProviderFor(totalUnreadCount)
final totalUnreadCountProvider = TotalUnreadCountFamily._();

final class TotalUnreadCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  TotalUnreadCountProvider._({
    required TotalUnreadCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'totalUnreadCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$totalUnreadCountHash();

  @override
  String toString() {
    return r'totalUnreadCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return totalUnreadCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalUnreadCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$totalUnreadCountHash() => r'5d40290911370c4dd80dec20e70269f17f5921be';

final class TotalUnreadCountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  TotalUnreadCountFamily._()
    : super(
        retry: null,
        name: r'totalUnreadCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TotalUnreadCountProvider call(String userId) =>
      TotalUnreadCountProvider._(argument: userId, from: this);

  @override
  String toString() => r'totalUnreadCountProvider';
}
