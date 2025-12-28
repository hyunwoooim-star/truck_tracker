import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../data/chat_repository.dart';
import '../domain/chat_message.dart';

/// Chat screen for 1:1 messaging
class ChatScreen extends ConsumerStatefulWidget {
  final String chatRoomId;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Mark messages as read when entering the chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAsRead();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _markAsRead() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final repository = ref.read(chatRepositoryProvider);
    await repository.markAllAsRead(
      chatRoomId: widget.chatRoomId,
      currentUserId: user.uid,
    );
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final repository = ref.read(chatRepositoryProvider);
    final success = await repository.sendMessage(
      chatRoomId: widget.chatRoomId,
      senderId: user.uid,
      senderName: user.displayName ?? 'User',
      message: messageText,
    );

    if (success) {
      _messageController.clear();
      // Scroll to bottom
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  Future<void> _sendImageMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Pick image
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 70,
    );

    if (image == null) return;

    // Show loading indicator
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final repository = ref.read(chatRepositoryProvider);
    final success = await repository.sendImageMessage(
      chatRoomId: widget.chatRoomId,
      senderId: user.uid,
      senderName: user.displayName ?? 'User',
      message: '',
      imageFile: File(image.path),
    );

    if (!mounted) return;
    Navigator.pop(context); // Close loading dialog

    if (success) {
      // Scroll to bottom
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지 전송에 실패했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('채팅'),
          backgroundColor: AppTheme.baeminMint,
        ),
        body: const Center(
          child: Text('로그인이 필요합니다'),
        ),
      );
    }

    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatRoomId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
        backgroundColor: AppTheme.baeminMint,
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '채팅을 시작해보세요',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == user.uid;

                    return _MessageBubble(
                      message: message,
                      isMe: isMe,
                    );
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
                      '메시지를 불러올 수 없습니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    color: AppTheme.baeminMint,
                    onPressed: _sendImageMessage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: AppTheme.baeminMint,
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Message bubble widget
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _MessageBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 8),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? AppTheme.baeminMint : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image if exists
                  if (message.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: message.imageUrl!,
                        width: 200,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                    if (message.message.isNotEmpty) const SizedBox(height: 8),
                  ],

                  // Message text
                  if (message.message.isNotEmpty)
                    Text(
                      message.message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),

                  // Timestamp
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: isMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      if (isMe && message.isRead) ...[
                        const SizedBox(width: 4),
                        Text(
                          '읽음',
                          style: TextStyle(
                            fontSize: 11,
                            color: isMe ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
