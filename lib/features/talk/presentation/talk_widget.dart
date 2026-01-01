import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../order/data/order_repository.dart';
import '../data/talk_repository.dart';
import '../domain/talk_message.dart';

const Color _mustard = AppTheme.mustardYellow;
const Color _charcoal = AppTheme.midnightCharcoal;

/// Real-time one-line Talk widget for truck-customer communication
class TalkWidget extends ConsumerStatefulWidget {
  final String truckId;
  final bool isOwner; // true if current user is the truck owner

  const TalkWidget({
    super.key,
    required this.truckId,
    required this.isOwner,
  });

  @override
  ConsumerState<TalkWidget> createState() => _TalkWidgetState();
}

class _TalkWidgetState extends ConsumerState<TalkWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final l10n = AppLocalizations.of(context);
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      SnackBarHelper.showWarning(context, l10n.loginRequired);
      return;
    }

    // Verify purchase before allowing comment (owner is always allowed)
    if (!widget.isOwner) {
      final orderRepo = ref.read(orderRepositoryProvider);
      final hasPurchased = await orderRepo.hasCompletedOrder(currentUser.uid, widget.truckId);
      if (!hasPurchased) {
        if (mounted) {
          SnackBarHelper.showWarning(context, l10n.purchaseRequiredForTalk);
        }
        return;
      }
    }

    final message = TalkMessage(
      id: '', // Will be set by Firestore
      truckId: widget.truckId,
      userId: currentUser.uid,
      userName: currentUser.displayName ?? currentUser.email ?? 'Anonymous',
      message: messageText,
      isOwner: widget.isOwner,
      createdAt: DateTime.now(),
    );

    try {
      final repository = ref.read(talkRepositoryProvider);
      await repository.sendMessage(message);
      _messageController.clear();

      // Scroll to bottom after sending
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, l10n.errorOccurred);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final talkAsync = ref.watch(truckTalkProvider(widget.truckId));

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: _charcoal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.mustardYellow10,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble, color: _mustard),
                const SizedBox(width: 8),
                Text(
                  widget.isOwner ? l10n.talkWithCustomers : l10n.talkWithOwner,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: talkAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noMessagesYet,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  );
                }

                // Auto-scroll to bottom when new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                final currentUserId = ref.watch(currentUserIdProvider);
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _MessageBubble(
                      message: message,
                      isCurrentUserOwner: widget.isOwner,
                      isMyMessage: currentUserId != null && message.userId == currentUserId,
                      truckId: widget.truckId,
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: _mustard),
              ),
              error: (error, _) => Center(
                child: Text(
                  l10n.errorLoadingMessages,
                  style: TextStyle(color: Colors.red[300]),
                ),
              ),
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(
                top: BorderSide(color: AppTheme.mustardYellow30),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.typeMessage,
                      hintStyle: const TextStyle(color: Colors.white54),
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
                    maxLines: 1,
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
        ],
      ),
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  final TalkMessage message;
  final bool isCurrentUserOwner;
  final bool isMyMessage;
  final String truckId;

  const _MessageBubble({
    required this.message,
    required this.isCurrentUserOwner,
    required this.isMyMessage,
    required this.truckId,
  });

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMessage),
        content: Text(l10n.deleteMessageConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final repository = ref.read(talkRepositoryProvider);
                await repository.deleteMessage(truckId, message.id);
                if (context.mounted) {
                  SnackBarHelper.showSuccess(context, l10n.messageDeleted);
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarHelper.showError(context, l10n.messageDeleteFailed);
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isOwnerMessage = message.isOwner;
    final timeFormat = DateFormat('HH:mm');

    // Owner messages: Mustard bubble with black text
    // Customer messages: Dark gray bubble with white text
    final bubbleColor = isOwnerMessage ? _mustard : Colors.grey[800]!;
    final textColor = isOwnerMessage ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            backgroundColor: isOwnerMessage ? _mustard : Colors.grey[700],
            radius: 16,
            child: Icon(
              isOwnerMessage ? Icons.store : Icons.person,
              size: 16,
              color: isOwnerMessage ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(width: 8),

          // Message Bubble
          Expanded(
            child: GestureDetector(
              onLongPress: isMyMessage ? () => _showDeleteConfirmation(context, ref) : null,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(12),
                  border: isMyMessage
                      ? Border.all(color: AppTheme.electricBlue.withValues(alpha: 0.5), width: 1)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Name + My Message Indicator
                    Row(
                      children: [
                        Text(
                          message.userName,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isMyMessage) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppTheme.electricBlue.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.me,
                              style: const TextStyle(
                                fontSize: 8,
                                color: AppTheme.electricBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Message Text
                    Text(
                      message.message,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),

                    // Timestamp + Delete hint
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          message.createdAt != null
                              ? timeFormat.format(message.createdAt!)
                              : '',
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.6),
                            fontSize: 10,
                          ),
                        ),
                        if (isMyMessage)
                          Text(
                            l10n.longPressToDelete,
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.4),
                              fontSize: 9,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
