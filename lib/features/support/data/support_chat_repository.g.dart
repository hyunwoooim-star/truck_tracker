// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supportChatRepository)
final supportChatRepositoryProvider = SupportChatRepositoryProvider._();

final class SupportChatRepositoryProvider
    extends
        $FunctionalProvider<
          SupportChatRepository,
          SupportChatRepository,
          SupportChatRepository
        >
    with $Provider<SupportChatRepository> {
  SupportChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportChatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportChatRepositoryHash();

  @$internal
  @override
  $ProviderElement<SupportChatRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupportChatRepository create(Ref ref) {
    return supportChatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupportChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupportChatRepository>(value),
    );
  }
}

String _$supportChatRepositoryHash() =>
    r'a7f39fb05590d3ea9971fe34cb9d2f121517df13';

@ProviderFor(allSupportChats)
final allSupportChatsProvider = AllSupportChatsProvider._();

final class AllSupportChatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SupportChat>>,
          List<SupportChat>,
          Stream<List<SupportChat>>
        >
    with
        $FutureModifier<List<SupportChat>>,
        $StreamProvider<List<SupportChat>> {
  AllSupportChatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allSupportChatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allSupportChatsHash();

  @$internal
  @override
  $StreamProviderElement<List<SupportChat>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SupportChat>> create(Ref ref) {
    return allSupportChats(ref);
  }
}

String _$allSupportChatsHash() => r'd1ef58036444ab02f2cc26710ad8290f936d5aee';

@ProviderFor(ownerSupportChat)
final ownerSupportChatProvider = OwnerSupportChatFamily._();

final class OwnerSupportChatProvider
    extends
        $FunctionalProvider<
          AsyncValue<SupportChat?>,
          SupportChat?,
          Stream<SupportChat?>
        >
    with $FutureModifier<SupportChat?>, $StreamProvider<SupportChat?> {
  OwnerSupportChatProvider._({
    required OwnerSupportChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ownerSupportChatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ownerSupportChatHash();

  @override
  String toString() {
    return r'ownerSupportChatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<SupportChat?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SupportChat?> create(Ref ref) {
    final argument = this.argument as String;
    return ownerSupportChat(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnerSupportChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ownerSupportChatHash() => r'f63f73dd29bf6e2af3b977f7d1299a8a203c157a';

final class OwnerSupportChatFamily extends $Family
    with $FunctionalFamilyOverride<Stream<SupportChat?>, String> {
  OwnerSupportChatFamily._()
    : super(
        retry: null,
        name: r'ownerSupportChatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OwnerSupportChatProvider call(String ownerId) =>
      OwnerSupportChatProvider._(argument: ownerId, from: this);

  @override
  String toString() => r'ownerSupportChatProvider';
}

@ProviderFor(supportMessages)
final supportMessagesProvider = SupportMessagesFamily._();

final class SupportMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SupportMessage>>,
          List<SupportMessage>,
          Stream<List<SupportMessage>>
        >
    with
        $FutureModifier<List<SupportMessage>>,
        $StreamProvider<List<SupportMessage>> {
  SupportMessagesProvider._({
    required SupportMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'supportMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$supportMessagesHash();

  @override
  String toString() {
    return r'supportMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SupportMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SupportMessage>> create(Ref ref) {
    final argument = this.argument as String;
    return supportMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SupportMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$supportMessagesHash() => r'2915f46f1d61ba2d6a7f7189174219cb47bed71e';

final class SupportMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SupportMessage>>, String> {
  SupportMessagesFamily._()
    : super(
        retry: null,
        name: r'supportMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SupportMessagesProvider call(String chatId) =>
      SupportMessagesProvider._(argument: chatId, from: this);

  @override
  String toString() => r'supportMessagesProvider';
}
