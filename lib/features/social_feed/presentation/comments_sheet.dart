import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../data/social_repository.dart';
import '../domain/post.dart';

/// Bottom sheet for viewing and adding comments
class CommentsSheet extends ConsumerStatefulWidget {
  const CommentsSheet({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      SnackBarHelper.showWarning(context, AppLocalizations.of(context).loginRequired);
      return;
    }

    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(socialRepositoryProvider);
      final comment = Comment(
        id: '',
        postId: widget.postId,
        authorId: user.uid,
        authorName: user.displayName ?? user.email ?? 'User',
        authorProfileUrl: user.photoURL,
        content: content,
      );

      await repository.addComment(comment);
      _commentController.clear();
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, AppLocalizations.of(context).errorOccurred);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(postCommentsProvider(widget.postId));

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppTheme.midnightCharcoal,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.charcoalLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '댓글',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
            ),
          ),

          const Divider(height: 1, color: AppTheme.charcoalLight),

          // Comments list
          Expanded(
            child: commentsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.electricBlue),
              ),
              error: (e, _) => Center(
                child: Text(
                  AppLocalizations.of(context).errorOccurred,
                  style: TextStyle(color: AppTheme.textTertiary),
                ),
              ),
              data: (comments) {
                if (comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '아직 댓글이 없습니다',
                          style: TextStyle(color: AppTheme.textTertiary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '첫 번째 댓글을 남겨보세요!',
                          style: TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return _CommentTile(comment: comments[index]);
                  },
                );
              },
            ),
          ),

          // Input field
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 8,
            ),
            decoration: const BoxDecoration(
              color: AppTheme.charcoalMedium,
              border: Border(
                top: BorderSide(color: AppTheme.charcoalLight),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요...',
                      hintStyle: TextStyle(color: AppTheme.textTertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.charcoalLight,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isSubmitting ? null : _submitComment,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.electricBlue,
                          ),
                        )
                      : const Icon(
                          Icons.send,
                          color: AppTheme.electricBlue,
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

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.charcoalLight,
            backgroundImage: comment.authorProfileUrl != null
                ? CachedNetworkImageProvider(comment.authorProfileUrl!)
                : null,
            child: comment.authorProfileUrl == null
                ? Text(
                    comment.authorName.isNotEmpty
                        ? comment.authorName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: comment.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: '  '),
                      TextSpan(text: comment.content),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      comment.timeAgo,
                      style: TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                    if (comment.likeCount > 0) ...[
                      const SizedBox(width: 12),
                      Text(
                        '좋아요 ${comment.likeCount}개',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        // TODO: Reply to comment
                      },
                      child: Text(
                        '답글 달기',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Like button
          IconButton(
            icon: Icon(
              comment.isLikedByMe ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: comment.isLikedByMe ? Colors.red : AppTheme.textTertiary,
            ),
            onPressed: () {
              // TODO: Toggle comment like
            },
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
