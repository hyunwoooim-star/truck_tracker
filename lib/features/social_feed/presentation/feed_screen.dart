import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../data/social_repository.dart';
import 'create_post_screen.dart';
import 'hashtag_search_screen.dart';
import 'widgets/post_card.dart';

/// Instagram-style social feed screen
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(feedPostsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '피드',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          // Search hashtags
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HashtagSearchScreen(),
                ),
              );
            },
          ),
          // Notifications
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Show notifications/activity
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(feedPostsProvider);
          await Future.delayed(const Duration(milliseconds: 500));
        },
        color: AppTheme.electricBlue,
        backgroundColor: AppTheme.charcoalMedium,
        child: feedAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.electricBlue),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.errorLoadingData,
                  style: TextStyle(color: AppTheme.textTertiary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(feedPostsProvider);
                  },
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
          data: (posts) {
            if (posts.isEmpty) {
              return _buildEmptyState(context);
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: posts[index],
                  onHashtagTap: (hashtag) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HashtagSearchScreen(
                          initialHashtag: hashtag,
                        ),
                      ),
                    );
                  },
                  onTruckTap: (truckId) {
                    // TODO: Navigate to truck detail
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreatePostScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.electricBlue,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.charcoalMedium,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.photo_camera,
                size: 48,
                color: AppTheme.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '아직 게시물이 없습니다',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '첫 번째 게시물을 올려보세요!\n맛있는 음식 사진을 공유해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textTertiary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreatePostScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('게시물 작성'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
