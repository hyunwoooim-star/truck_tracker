import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../auth/presentation/auth_provider.dart';
import '../data/support_chat_repository.dart';

const Color _mustard = AppTheme.mustardYellow;
const Color _charcoal = AppTheme.midnightCharcoal;

/// Support chat screen for owner-admin communication
class SupportChatScreen extends ConsumerStatefulWidget {
  final String? truckId;
  final String? truckName;

  const SupportChatScreen({
    super.key,
    this.truckId,
    this.truckName,
  });

  @override
  ConsumerState<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends ConsumerState<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _chatId;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      setState(() => _isInitializing = false);
      return;
    }

    final repository = ref.read(supportChatRepositoryProvider);
    final chat = await repository.getOrCreateSupportChat(
      ownerId: currentUser.uid,
      ownerName: currentUser.displayName ?? currentUser.email ?? 'Owner',
      truckId: widget.truckId,
      truckName: widget.truckName,
    );

    if (chat != null && mounted) {
      setState(() {
        _chatId = chat.id;
        _isInitializing = false;
      });

      // Mark as read
      await repository.markAsRead(chatId: chat.id, isAdmin: false);
    } else {
      setState(() => _isInitializing = false);
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _chatId == null) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final repository = ref.read(supportChatRepositoryProvider);
    final success = await repository.sendMessage(
      chatId: _chatId!,
      senderId: currentUser.uid,
      senderName: currentUser.displayName ?? 'Owner',
      message: messageText,
      isFromAdmin: false,
    );

    if (success) {
      _messageController.clear();
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isInitializing) {
      return Scaffold(
        backgroundColor: _charcoal,
        appBar: AppBar(
          title: Text(l10n.contactAdmin),
          backgroundColor: _charcoal,
          foregroundColor: _mustard,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: _mustard),
        ),
      );
    }

    if (_chatId == null) {
      return Scaffold(
        backgroundColor: _charcoal,
        appBar: AppBar(
          title: Text(l10n.contactAdmin),
          backgroundColor: _charcoal,
          foregroundColor: _mustard,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                l10n.errorCreatingChat,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() => _isInitializing = true);
                  _initializeChat();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _mustard,
                  foregroundColor: Colors.black,
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    final messagesAsync = ref.watch(supportMessagesProvider(_chatId!));

    return Scaffold(
      backgroundColor: _charcoal,
      appBar: AppBar(
        title: Text(l10n.contactAdmin),
        backgroundColor: _charcoal,
        foregroundColor: _mustard,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(12),
            color: AppTheme.mustardYellow10,
            child: Row(
              children: [
                const Icon(Icons.support_agent, color: _mustard),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.supportChatDescription,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline,
                            size: 64, color: Colors.white30),
                        const SizedBox(height: 16),
                        Text(
                          l10n.startSupportChat,
                          style: const TextStyle(color: Colors.white54),
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
                    return _MessageBubble(message: message);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: _mustard),
              ),
              error: (error, _) => Center(
                child: Text(
                  l10n.errorLoadingMessages,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.charcoalMedium,
              border: Border(top: BorderSide(color: AppTheme.mustardYellow30)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: l10n.typeMessage,
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: _charcoal,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: _mustard),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.mustardYellow20,
                    ),
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

class _MessageBubble extends StatelessWidget {
  final SupportMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isAdmin = message.isFromAdmin;
    final dateFormat = DateFormat('HH:mm');

    return Align(
      alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isAdmin ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.support_agent, size: 14, color: _mustard),
                    const SizedBox(width: 4),
                    Text(
                      '관리자',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAdmin ? Colors.grey[800] : _mustard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isAdmin ? Colors.white : Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: isAdmin ? Colors.white54 : Colors.black54,
                    ),
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
