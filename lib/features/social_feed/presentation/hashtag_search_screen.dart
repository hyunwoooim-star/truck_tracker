import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../data/social_repository.dart';
import 'widgets/post_card.dart';

/// Screen for searching and browsing hashtags
class HashtagSearchScreen extends ConsumerStatefulWidget {
  const HashtagSearchScreen({
    super.key,
    this.initialHashtag,
  });

  final String? initialHashtag;

  @override
  ConsumerState<HashtagSearchScreen> createState() => _HashtagSearchScreenState();
}

class _HashtagSearchScreenState extends ConsumerState<HashtagSearchScreen> {
  final _searchController = TextEditingController();
  String? _selectedHashtag;

  @override
  void initState() {
    super.initState();
    if (widget.initialHashtag != null) {
      _selectedHashtag = widget.initialHashtag;
      _searchController.text = widget.initialHashtag!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectHashtag(String hashtag) {
    setState(() {
      _selectedHashtag = hashtag;
      _searchController.text = hashtag;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedHashtag = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final trendingAsync = ref.watch(trendingHashtagsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.charcoalMedium,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.charcoalLight),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: '해시태그 검색...',
                  hintStyle: TextStyle(color: AppTheme.textTertiary),
                  prefixIcon: const Icon(
                    Icons.tag,
                    color: AppTheme.textTertiary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppTheme.textTertiary,
                          ),
                          onPressed: _clearSelection,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _selectHashtag(value.replaceAll('#', '').trim());
                  }
                },
              ),
            ),
          ),

          // Content
          Expanded(
            child: _selectedHashtag != null
                ? _buildHashtagPosts(_selectedHashtag!)
                : _buildTrendingHashtags(trendingAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingHashtags(AsyncValue<List<String>> trendingAsync) {
    return trendingAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppTheme.electricBlue),
      ),
      error: (e, _) => Center(
        child: Text(
          AppLocalizations.of(context).errorOccurred,
          style: TextStyle(color: AppTheme.textTertiary),
        ),
      ),
      data: (hashtags) {
        if (hashtags.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.tag,
                  size: 48,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  '아직 해시태그가 없습니다',
                  style: TextStyle(color: AppTheme.textTertiary),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '인기 해시태그',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: hashtags.length,
                itemBuilder: (context, index) {
                  final hashtag = hashtags[index];
                  return _HashtagTile(
                    hashtag: hashtag,
                    rank: index + 1,
                    onTap: () => _selectHashtag(hashtag),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHashtagPosts(String hashtag) {
    final postsAsync = ref.watch(postsByHashtagProvider(hashtag));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hashtag header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.charcoalMedium,
            border: Border(
              bottom: BorderSide(color: AppTheme.charcoalLight),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.electricBlue,
                      AppTheme.electricBlue.withValues(alpha: 0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tag,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#$hashtag',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    postsAsync.when(
                      loading: () => Text(
                        '로딩 중...',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 14,
                        ),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (posts) => Text(
                        '게시물 ${posts.length}개',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _clearSelection,
                icon: const Icon(
                  Icons.close,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Posts
        Expanded(
          child: postsAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.electricBlue),
            ),
            error: (e, _) => Center(
              child: Text(
                AppLocalizations.of(context).errorOccurred,
                style: TextStyle(color: AppTheme.textTertiary),
              ),
            ),
            data: (posts) {
              if (posts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        size: 48,
                        color: AppTheme.textTertiary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '아직 게시물이 없습니다',
                        style: TextStyle(color: AppTheme.textTertiary),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    post: posts[index],
                    onHashtagTap: _selectHashtag,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HashtagTile extends StatelessWidget {
  const _HashtagTile({
    required this.hashtag,
    required this.rank,
    required this.onTap,
  });

  final String hashtag;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 32,
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rank <= 3 ? AppTheme.electricBlue : AppTheme.textTertiary,
                  fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
            // Hashtag icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.charcoalMedium,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.tag,
                size: 20,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            // Hashtag name
            Expanded(
              child: Text(
                '#$hashtag',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppTheme.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
