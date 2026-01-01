import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../shared/widgets/skeleton_loading.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../review/data/review_repository.dart';
import '../../review/domain/review.dart';

/// 내가 쓴 리뷰 화면
class MyReviewsScreen extends ConsumerWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 쓴 리뷰'),
      ),
      body: userId == null
          ? const Center(child: Text('로그인이 필요합니다'))
          : _MyReviewsList(userId: userId),
    );
  }
}

class _MyReviewsList extends ConsumerWidget {
  final String userId;

  const _MyReviewsList({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(_myReviewsProvider(userId));

    return reviewsAsync.when(
      loading: () => const SkeletonTruckList(itemCount: 3),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('리뷰를 불러오지 못했습니다\n$error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(_myReviewsProvider(userId)),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
      data: (reviews) {
        if (reviews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 64,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  '작성한 리뷰가 없습니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '트럭을 이용하고 리뷰를 남겨보세요!',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return _ReviewCard(review: review);
          },
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Truck name + Rating
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Truck #${review.truckId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < review.rating ? Icons.star : Icons.star_border,
                      color: AppTheme.mustardYellow,
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Review content
            Text(
              review.content,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),

            // Date
            Text(
              _formatDate(review.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textTertiary,
              ),
            ),

            // Owner reply (if any)
            if (review.ownerReply != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.charcoalMedium,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          size: 16,
                          color: AppTheme.mustardYellow,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '사장님 답변',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.mustardYellow,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review.ownerReply!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

/// Provider for fetching user's reviews
final _myReviewsProvider = FutureProvider.family<List<Review>, String>((ref, userId) async {
  final repository = ref.watch(reviewRepositoryProvider);
  return repository.getUserReviews(userId);
});
