import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../review/data/review_repository.dart';
import '../../../review/domain/review.dart';

const Color _mustard = AppTheme.mustardYellow;

/// Review management tab for truck owners
/// Displays review statistics, rating distribution, and review list with reply functionality
class ReviewManagementTab extends ConsumerStatefulWidget {
  final String truckId;

  const ReviewManagementTab({
    super.key,
    required this.truckId,
  });

  @override
  ConsumerState<ReviewManagementTab> createState() => _ReviewManagementTabState();
}

class _ReviewManagementTabState extends ConsumerState<ReviewManagementTab> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reviewsAsync = ref.watch(truckReviewsProvider(widget.truckId));

    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.rate_review, size: 64, color: Colors.white30),
                const SizedBox(height: 16),
                Text(
                  l10n.noReviewsForTruck,
                  style: const TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Section
              _buildStatsSection(reviews, l10n),

              // Rating Distribution
              _buildRatingDistribution(reviews, l10n),

              // Reviews List
              _buildReviewsList(reviews, l10n),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: _mustard),
      ),
      error: (error, _) => Center(
        child: Text(
          l10n.errorLoadingReviews,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildStatsSection(List<Review> reviews, AppLocalizations l10n) {
    final totalReviews = reviews.length;
    final averageRating = reviews.isEmpty
        ? 0.0
        : reviews.fold<int>(0, (sum, r) => sum + r.rating) / reviews.length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.mustardYellow15,
            AppTheme.mustardYellow10,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _mustard, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.rate_review,
              label: l10n.totalReviews,
              value: '$totalReviews',
              color: AppTheme.electricBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              icon: Icons.star,
              label: l10n.averageRating,
              value: averageRating.toStringAsFixed(1),
              color: _mustard,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(List<Review> reviews, AppLocalizations l10n) {
    // Count reviews by rating
    final ratingCounts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in reviews) {
      ratingCounts[review.rating] = (ratingCounts[review.rating] ?? 0) + 1;
    }

    final maxCount = ratingCounts.values.reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ratingDistribution,
            style: const TextStyle(
              color: _mustard,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            final rating = 5 - index;
            final count = ratingCounts[rating] ?? 0;
            final percentage = maxCount > 0 ? count / maxCount : 0.0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      '$rating',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  const Icon(Icons.star, color: _mustard, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: percentage,
                          child: Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: _getRatingColor(rating),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: Text(
                      l10n.starsCount(count),
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.lightGreen;
      case 3:
        return Colors.amber;
      case 2:
        return Colors.orange;
      case 1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildReviewsList(List<Review> reviews, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.allReviews,
            style: const TextStyle(
              color: _mustard,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...reviews.map((review) => _ReviewCard(
                review: review,
                onReply: () => _showReplyDialog(review),
                onEditReply: () => _showReplyDialog(review, isEdit: true),
                onDeleteReply: () => _confirmDeleteReply(review),
              )),
        ],
      ),
    );
  }

  void _showReplyDialog(Review review, {bool isEdit = false}) {
    final l10n = AppLocalizations.of(context);
    final replyController = TextEditingController(
      text: isEdit ? review.ownerReply : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.midnightCharcoal,
        title: Text(
          isEdit ? l10n.editReply : l10n.replyToReview,
          style: const TextStyle(color: _mustard),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show original review
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < review.rating ? Icons.star : Icons.star_border,
                          color: _mustard,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.comment,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: replyController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: l10n.ownerReply,
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: l10n.replyPlaceholder,
                hintStyle: const TextStyle(color: Colors.white30),
                border: const OutlineInputBorder(),
                counterStyle: const TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              final reply = replyController.text.trim();
              if (reply.isEmpty) return;

              try {
                final reviewRepo = ref.read(reviewRepositoryProvider);
                await reviewRepo.addOwnerReply(review.id, reply);

                if (context.mounted) {
                  Navigator.pop(context);
                  SnackBarHelper.showSuccess(context, l10n.replySent);
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarHelper.showError(context, '${l10n.error}: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _mustard,
              foregroundColor: Colors.black,
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteReply(Review review) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.midnightCharcoal,
        title: Text(l10n.deleteReply, style: const TextStyle(color: _mustard)),
        content: Text(
          l10n.confirmDeleteReply,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final reviewRepo = ref.read(reviewRepositoryProvider);
                await reviewRepo.deleteOwnerReply(review.id);

                if (context.mounted) {
                  Navigator.pop(context);
                  SnackBarHelper.showSuccess(context, l10n.replyDeleted);
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarHelper.showError(context, '${l10n.error}: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onReply;
  final VoidCallback onEditReply;
  final VoidCallback onDeleteReply;

  const _ReviewCard({
    required this.review,
    required this.onReply,
    required this.onEditReply,
    required this.onDeleteReply,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.charcoalMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: User info + rating
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[700],
                radius: 20,
                backgroundImage: review.userPhotoURL != null
                    ? NetworkImage(review.userPhotoURL!)
                    : null,
                child: review.userPhotoURL == null
                    ? const Icon(Icons.person, color: Colors.white54)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (review.createdAt != null)
                      Text(
                        dateFormat.format(review.createdAt!),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              // Star rating
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating ? Icons.star : Icons.star_border,
                    color: _mustard,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Review comment
          Text(
            review.comment,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          // Photo thumbnails if any
          if (review.photoUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.photoUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(review.photoUrls[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Owner reply section
          if (review.ownerReply != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.mustardYellow10,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.mustardYellow30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.store, color: _mustard, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        l10n.ownerReply,
                        style: const TextStyle(
                          color: _mustard,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.ownerReply!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEditReply,
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(l10n.editReply),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white54,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDeleteReply,
                  icon: const Icon(Icons.delete, size: 16),
                  label: Text(l10n.deleteReply),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red[300],
                  ),
                ),
              ],
            ),
          ] else ...[
            // Reply button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onReply,
                icon: const Icon(Icons.reply, size: 16),
                label: Text(l10n.replyToReview),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _mustard,
                  side: const BorderSide(color: _mustard),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
