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

String _$chatRepositoryHash() => r'7956fc1edca9bb8f22bf4cb09bc189b02b36af89';

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

String _$userChatRoomsHash() => r'95091e614a357db26f08a9f8ff77c8322fdc274a';

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

String _$truckChatRoomsHash() => r'860afe46cbac4158e11e216adac2bdc1f7fd67ec';

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

String _$chatMessagesHash() => r'be11a5253e57c5508e59715309cfba1f63c24ca2';

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

String _$totalUnreadCountHash() => r'7a7314171aa94f438b1ec55786bc5bba625a03af';

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
