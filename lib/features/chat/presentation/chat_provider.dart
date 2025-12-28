import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/chat_repository.dart';

part 'chat_provider.g.dart';

/// Provider for unread chat count
/// This wraps the totalUnreadCount from chat_repository for consistency
@riverpod
Stream<int> unreadChatCount(Ref ref, String userId) async* {
  final repository = ref.watch(chatRepositoryProvider);

  // Initial value
  yield await repository.getTotalUnreadCount(userId);

  // Stream updates whenever chat rooms change
  await for (final _ in repository.watchUserChatRooms(userId)) {
    yield await repository.getTotalUnreadCount(userId);
  }
}
