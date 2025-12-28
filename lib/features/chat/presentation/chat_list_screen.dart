import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../data/chat_repository.dart';
import '../domain/chat_room.dart';
import 'chat_screen.dart';

/// Chat list screen showing all active chat rooms
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('채팅'),
          backgroundColor: AppTheme.baeminMint,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 100,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                '로그인이 필요합니다',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.baeminMint,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('로그인'),
              ),
            ],
          ),
        ),
      );
    }

    final chatRoomsAsync = ref.watch(userChatRoomsProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
        backgroundColor: AppTheme.baeminMint,
      ),
      body: chatRoomsAsync.when(
        data: (chatRooms) {
          if (chatRooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '아직 채팅 내역이 없습니다',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '트럭 상세 페이지에서 채팅을 시작해보세요',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final room = chatRooms[index];
              return _ChatRoomTile(room: room);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                '채팅 목록을 불러올 수 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chat room tile widget
class _ChatRoomTile extends StatelessWidget {
  final ChatRoom room;

  const _ChatRoomTile({required this.room});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.baeminMint,
        child: Text(
          room.truckName?.substring(0, 1) ?? 'T',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        room.truckName ?? 'Unknown Truck',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        room.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: room.unreadCount > 0 ? Colors.black87 : Colors.grey[600],
          fontWeight: room.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(room.lastMessageAt),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          if (room.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                room.unreadCount > 99 ? '99+' : '${room.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatRoomId: room.id),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Today: show time
      return DateFormat('HH:mm').format(dateTime);
    } else if (difference.inDays == 1) {
      // Yesterday
      return '어제';
    } else if (difference.inDays < 7) {
      // Within a week: show day of week
      final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      return weekdays[dateTime.weekday - 1];
    } else {
      // Older: show date
      return DateFormat('MM/dd').format(dateTime);
    }
  }
}
