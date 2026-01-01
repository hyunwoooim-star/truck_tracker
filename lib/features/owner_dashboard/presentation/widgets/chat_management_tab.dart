import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../chat/data/chat_repository.dart';
import '../../../chat/domain/chat_room.dart';
import '../../../chat/presentation/chat_screen.dart';
import '../../../support/presentation/support_chat_screen.dart';
import '../../../talk/presentation/talk_widget.dart';

const Color _mustard = AppTheme.mustardYellow;

/// Chat management tab for truck owners
/// Displays 1:1 customer chats and public talk section
class ChatManagementTab extends ConsumerWidget {
  final String truckId;

  const ChatManagementTab({
    super.key,
    required this.truckId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chatRoomsAsync = ref.watch(truckChatRoomsProvider(truckId));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Admin Support Section
          _buildAdminSupportSection(context, l10n),

          const SizedBox(height: 24),

          // 1:1 Customer Chat Section
          _buildChatRoomsSection(context, l10n, chatRoomsAsync),

          const SizedBox(height: 24),

          // Public Talk Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.campaign, color: _mustard),
                    const SizedBox(width: 8),
                    Text(
                      l10n.publicTalk,
                      style: const TextStyle(
                        color: _mustard,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.publicTalkDescription,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                TalkWidget(
                  truckId: truckId,
                  isOwner: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAdminSupportSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.electricBlue.withValues(alpha: 0.15),
            AppTheme.electricBlue.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.electricBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.support_agent,
                  color: AppTheme.electricBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.adminSupport,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.contactAdminDescription,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SupportChatScreen(truckId: truckId),
                  ),
                );
              },
              icon: const Icon(Icons.chat, size: 18),
              label: Text(l10n.contactAdmin),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatRoomsSection(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<List<ChatRoom>> chatRoomsAsync,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.chat_bubble_outline, color: _mustard),
              const SizedBox(width: 8),
              Text(
                l10n.customerChats,
                style: const TextStyle(
                  color: _mustard,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.customerChatsDescription,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          chatRoomsAsync.when(
            data: (chatRooms) {
              if (chatRooms.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.charcoalMedium,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.mustardYellow30),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.white30,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.noCustomerChats,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.charcoalMedium,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.mustardYellow30),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chatRooms.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppTheme.mustardYellow30,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final chatRoom = chatRooms[index];
                    return _ChatRoomTile(
                      chatRoom: chatRoom,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(chatRoomId: chatRoom.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
            loading: () => Container(
              padding: const EdgeInsets.all(32),
              child: const Center(
                child: CircularProgressIndicator(color: _mustard),
              ),
            ),
            error: (error, _) => Container(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  l10n.errorLoadingChats,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final VoidCallback onTap;

  const _ChatRoomTile({
    required this.chatRoom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM/dd HH:mm');
    final hasUnread = chatRoom.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // User Avatar
            CircleAvatar(
              backgroundColor: Colors.grey[700],
              radius: 24,
              child: const Icon(Icons.person, color: Colors.white54),
            ),
            const SizedBox(width: 12),

            // Message Preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chatRoom.userName ?? 'Customer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        dateFormat.format(chatRoom.lastMessageAt),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chatRoom.lastMessage,
                          style: TextStyle(
                            color: hasUnread ? Colors.white70 : Colors.white54,
                            fontSize: 14,
                            fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _mustard,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${chatRoom.unreadCount}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}
