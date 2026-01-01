import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/error_state_widget.dart';
import '../../ads/presentation/widgets/banner_ad_widget.dart';
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
          error: (e, _) => ErrorStateWidget(
            error: e,
            onRetry: () => ref.invalidate(feedPostsProvider),
          ),
          data: (posts) {
            if (posts.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.photo_camera,
                title: '아직 게시물이 없습니다',
                subtitle: '첫 번째 게시물을 올려보세요!\n맛있는 음식 사진을 공유해주세요.',
                action: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePostScreen()),
                ),
                actionLabel: '게시물 작성',
              );
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
      // Banner Ad at bottom
      bottomNavigationBar: const SafeArea(
        child: AdaptiveBannerAdWidget(),
      ),
    );
  }
}
