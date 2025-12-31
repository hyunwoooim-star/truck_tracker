import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/snackbar_helper.dart';
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

  // Typing indicator
  Timer? _typingTimer;
  bool _isTyping = false;
  StreamSubscription? _typingSubscription;
  Map<String, dynamic> _typingUsers = {};

  @override
  void initState() {
    super.initState();
    // Mark messages as read when entering the chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAsRead();
      _listenToTypingStatus();
    });

    // Listen to text changes for typing indicator
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _typingSubscription?.cancel();
    _setTypingStatus(false); // Clear typing status on exit
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_messageController.text.isNotEmpty && !_isTyping) {
      _setTypingStatus(true);
    }

    // Reset the timer
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () {
      _setTypingStatus(false);
    });
  }

  Future<void> _setTypingStatus(bool isTyping) async {
    if (_isTyping == isTyping) return;
    _isTyping = isTyping;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await ref.read(chatRepositoryProvider).setTypingStatus(
        chatRoomId: widget.chatRoomId,
        userId: user.uid,
        isTyping: isTyping,
      );
    } catch (e) {
      // Typing status is non-critical, just log the error
      AppLogger.warning('Failed to update typing status', tag: 'ChatScreen');
    }
  }

  void _listenToTypingStatus() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _typingSubscription = ref.read(chatRepositoryProvider)
        .watchTypingStatus(widget.chatRoomId)
        .listen((typingUsers) {
      if (mounted) {
        setState(() {
          // Remove current user from typing users
          _typingUsers = Map.from(typingUsers)..remove(user.uid);
        });
      }
    });
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

  /// Show edit message dialog
  Future<void> _showEditDialog(ChatMessage message) async {
    final editController = TextEditingController(text: message.message);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('메시지 수정'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(
            hintText: '메시지를 입력하세요',
          ),
          maxLines: null,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, editController.text.trim()),
            child: const Text('수정'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != message.message) {
      final repository = ref.read(chatRepositoryProvider);
      final success = await repository.editMessage(
        chatRoomId: widget.chatRoomId,
        messageId: message.id,
        newMessage: result,
      );

      if (!mounted) return;
      if (success) {
        SnackBarHelper.showSuccess(context, '메시지가 수정되었습니다');
      } else {
        SnackBarHelper.showError(context, '메시지 수정에 실패했습니다');
      }
    }
  }

  /// Show delete confirmation dialog
  Future<void> _showDeleteConfirmation(ChatMessage message) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('메시지 삭제'),
        content: const Text('이 메시지를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repository = ref.read(chatRepositoryProvider);
      final success = await repository.deleteMessage(
        chatRoomId: widget.chatRoomId,
        messageId: message.id,
      );

      if (!mounted) return;
      if (success) {
        SnackBarHelper.showSuccess(context, '메시지가 삭제되었습니다');
      } else {
        SnackBarHelper.showError(context, '메시지 삭제에 실패했습니다');
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
      SnackBarHelper.showError(context, '이미지 전송에 실패했습니다');
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
                      onEdit: isMe ? () => _showEditDialog(message) : null,
                      onDelete: isMe ? () => _showDeleteConfirmation(message) : null,
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

          // Typing indicator
          if (_typingUsers.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 16,
                    child: _TypingDots(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '상대방이 입력 중...',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Message input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.black10,
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
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    this.onEdit,
    this.onDelete,
  });

  void _showOptionsMenu(BuildContext context) {
    if (!isMe) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Edit option (only for text messages)
              if (message.imageUrl == null)
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('메시지 수정'),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit?.call();
                  },
                ),
              // Delete option
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('메시지 삭제'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: isMe ? () => _showOptionsMenu(context) : null,
      child: Align(
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

                    // Timestamp and status
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edited indicator
                        if (message.isEdited) ...[
                          Text(
                            '수정됨',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: isMe ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '·',
                            style: TextStyle(
                              fontSize: 11,
                              color: isMe ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
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
      ),
    );
  }
}

/// Animated typing dots widget
class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final opacity = value < 0.5 ? value * 2 : (1 - value) * 2;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[600]!.withValues(alpha: 0.4 + opacity * 0.6),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
