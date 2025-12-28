// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for unread chat count
/// This wraps the totalUnreadCount from chat_repository for consistency

@ProviderFor(unreadChatCount)
final unreadChatCountProvider = UnreadChatCountFamily._();

/// Provider for unread chat count
/// This wraps the totalUnreadCount from chat_repository for consistency

final class UnreadChatCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Provider for unread chat count
  /// This wraps the totalUnreadCount from chat_repository for consistency
  UnreadChatCountProvider._({
    required UnreadChatCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unreadChatCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unreadChatCountHash();

  @override
  String toString() {
    return r'unreadChatCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as String;
    return unreadChatCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnreadChatCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unreadChatCountHash() => r'acf67154524a4f130eb102fc1bec3ffde35548da';

/// Provider for unread chat count
/// This wraps the totalUnreadCount from chat_repository for consistency

final class UnreadChatCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  UnreadChatCountFamily._()
    : super(
        retry: null,
        name: r'unreadChatCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for unread chat count
  /// This wraps the totalUnreadCount from chat_repository for consistency

  UnreadChatCountProvider call(String userId) =>
      UnreadChatCountProvider._(argument: userId, from: this);

  @override
  String toString() => r'unreadChatCountProvider';
}
