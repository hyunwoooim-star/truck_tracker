import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../data/social_repository.dart';
import '../../domain/post.dart';
import '../comments_sheet.dart';

/// Instagram-style post card
class PostCard extends ConsumerStatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onHashtagTap,
    this.onTruckTap,
  });

  final Post post;
  final void Function(String hashtag)? onHashtagTap;
  final void Function(String truckId)? onTruckTap;

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeScale;
  bool _isLiked = false;
  int _likeCount = 0;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _likeScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.elasticOut),
    );
    _isLiked = widget.post.isLikedByMe;
    _likeCount = widget.post.likeCount;
    _checkLikeStatus();
  }

  Future<void> _checkLikeStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final repository = ref.read(socialRepositoryProvider);
    final liked = await repository.isLikedByUser(widget.post.id, user.uid);
    if (mounted) {
      setState(() {
        _isLiked = liked;
      });
    }
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id) {
      _isLiked = widget.post.isLikedByMe;
      _likeCount = widget.post.likeCount;
      _currentImageIndex = 0;
      _checkLikeStatus();
    }
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  Future<void> _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      SnackBarHelper.showWarning(context, AppLocalizations.of(context).loginRequired);
      return;
    }

    // Optimistic update
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    // Animate
    _likeController.forward().then((_) => _likeController.reverse());

    try {
      final repository = ref.read(socialRepositoryProvider);
      await repository.toggleLike(widget.post.id, user.uid);
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
          _likeCount += _isLiked ? 1 : -1;
        });
        SnackBarHelper.showError(context, AppLocalizations.of(context).errorOccurred);
      }
    }
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(postId: widget.post.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(post),

          // Images
          if (post.imageUrls.isNotEmpty) _buildImageCarousel(post.imageUrls),

          // Actions
          _buildActions(),

          // Like count
          if (_likeCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '좋아요 $_likeCount개',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),

          // Content
          _buildContent(post),

          // Comments preview
          if (post.commentCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: _showComments,
                child: Text(
                  '댓글 ${post.commentCount}개 모두 보기',
                  style: TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

          // Time
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              post.timeAgo,
              style: TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Post post) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Profile image
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.charcoalLight,
            backgroundImage: post.authorProfileUrl != null
                ? CachedNetworkImageProvider(post.authorProfileUrl!)
                : null,
            child: post.authorProfileUrl == null
                ? Text(
                    post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          // Author info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.authorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (post.truckName != null)
                  GestureDetector(
                    onTap: () {
                      if (post.truckId != null && widget.onTruckTap != null) {
                        widget.onTruckTap!(post.truckId!);
                      }
                    },
                    child: Text(
                      '@ ${post.truckName}',
                      style: TextStyle(
                        color: AppTheme.electricBlue,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // More options
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppTheme.textSecondary),
            onPressed: () {
              // TODO: Show options menu
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<String> imageUrls) {
    return Stack(
      children: [
        // Image
        AspectRatio(
          aspectRatio: 1,
          child: PageView.builder(
            itemCount: imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTap: _toggleLike,
                child: CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: AppTheme.charcoalLight,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.electricBlue,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppTheme.charcoalLight,
                    child: const Icon(
                      Icons.broken_image,
                      color: AppTheme.textTertiary,
                      size: 48,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Page indicator
        if (imageUrls.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageUrls.length,
                (index) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentImageIndex
                        ? AppTheme.electricBlue
                        : AppTheme.textTertiary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Like button
          AnimatedBuilder(
            animation: _likeScale,
            builder: (context, child) {
              return Transform.scale(
                scale: _likeScale.value,
                child: IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : AppTheme.textPrimary,
                    size: 28,
                  ),
                ),
              );
            },
          ),
          // Comment button
          IconButton(
            onPressed: _showComments,
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: AppTheme.textPrimary,
              size: 26,
            ),
          ),
          // Share button
          IconButton(
            onPressed: () {
              // TODO: Implement share
            },
            icon: const Icon(
              Icons.send_outlined,
              color: AppTheme.textPrimary,
              size: 26,
            ),
          ),
          const Spacer(),
          // Bookmark button
          IconButton(
            onPressed: () {
              // TODO: Implement bookmark
            },
            icon: const Icon(
              Icons.bookmark_border,
              color: AppTheme.textPrimary,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            height: 1.4,
          ),
          children: _buildContentSpans(post),
        ),
      ),
    );
  }

  List<InlineSpan> _buildContentSpans(Post post) {
    final spans = <InlineSpan>[];
    final content = post.content;
    final hashtagRegex = RegExp(r'#(\w+)');

    int lastEnd = 0;
    for (final match in hashtagRegex.allMatches(content)) {
      // Add text before hashtag
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: content.substring(lastEnd, match.start)));
      }

      // Add hashtag with gesture
      final hashtag = match.group(1)!;
      spans.add(
        WidgetSpan(
          child: GestureDetector(
            onTap: () {
              if (widget.onHashtagTap != null) {
                widget.onHashtagTap!(hashtag);
              }
            },
            child: Text(
              '#$hashtag',
              style: TextStyle(
                color: AppTheme.electricBlue,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < content.length) {
      spans.add(TextSpan(text: content.substring(lastEnd)));
    }

    return spans;
  }
}
