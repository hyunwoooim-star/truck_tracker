import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../analytics/data/analytics_repository.dart';
import '../../order/data/order_repository.dart';
import '../../order/domain/order.dart' as order_model;
import '../../order/presentation/cart_provider.dart';
import '../../review/data/review_repository.dart';
import '../../review/presentation/review_form_dialog.dart';
import '../../schedule/data/schedule_repository.dart';
import '../../social/data/follow_repository.dart';
import '../../talk/presentation/talk_widget.dart';
import '../../truck_list/domain/truck.dart';
import 'truck_detail_provider.dart';

class TruckDetailScreen extends ConsumerWidget {
  const TruckDetailScreen({
    super.key,
    required this.truck,
  });

  final Truck truck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // 🔄 FIXED: Use real Firestore stream instead of mock data
    final detailAsync = ref.watch(truckDetailNotifierProvider(truck.id));

    // Track truck click for analytics
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final analyticsRepo = ref.read(analyticsRepositoryProvider);
      analyticsRepo.trackTruckClick(truck.id);
    });

    return Scaffold(
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(
          child: Text(l10n.errorLoadingData),
        ),
        data: (detail) {
          return CustomScrollView(
            slivers: [
              // Hero Image with AppBar
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppTheme.baeminMint,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'truck_image_${truck.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: CachedNetworkImage(
                        imageUrl: truck.imageUrl,
                        maxHeightDiskCache: 800,  // 🚀 OPTIMIZATION: Limit header image size
                        maxWidthDiskCache: 800,   // 🚀 OPTIMIZATION: Limit header image size
                        memCacheHeight: 800,      // 🚀 OPTIMIZATION: Limit memory cache
                        memCacheWidth: 800,       // 🚀 OPTIMIZATION: Limit memory cache
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.mustardYellow10,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.local_shipping,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Announcement Box (if exists)
                    if (truck.announcement.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107), // Mustard yellow
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.black10,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.campaign,
                              color: Colors.black87,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.todaysSpecialAnnouncement,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    truck.announcement,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Header Section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      truck.foodType,
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      truck.truckNumber,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Rating
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.mustardYellow10,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: AppTheme.baeminMint,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      (detail?.averageRating ?? 0.0).toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppTheme.baeminMint,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Location
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                truck.locationDescription,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Operating Hours
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                detail?.operatingHours ?? 'N/A',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.electricBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          // Today's Schedule
                          Consumer(
                            builder: (context, ref, _) {
                              final todayScheduleAsync = ref.watch(
                                todayScheduleProvider(truck.id),
                              );
                              
                              return todayScheduleAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (_, __) => const SizedBox.shrink(),
                                data: (schedule) {
                                  if (schedule == null || !schedule.isOpen || schedule.location.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 20,
                                          color: AppTheme.electricBlue,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            l10n.todayLocation(schedule.location),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                              color: AppTheme.electricBlue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                    // Menu Section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.menu,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...?detail?.menuItems?.map(
                            (item) => _MenuItemCard(
                              item: item,
                              truck: truck,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                    // Reviews Section (Live from Firestore)
                    Consumer(
                      builder: (context, ref, _) {
                        final reviewsAsync = ref.watch(truckReviewsProvider(truck.id));

                        return reviewsAsync.when(
                          loading: () => const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, __) => Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(l10n.errorLoadingReviews),
                          ),
                          data: (reviews) => Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      l10n.reviewsTitle,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(${reviews.length})',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (reviews.isEmpty)
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(l10n.noReviewsYet),
                                    ),
                                  )
                                else
                                  ...reviews.map((review) => _ReviewCard(review: review)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                    // Talk Section (Customer-Owner Chat)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.talkWithOwner,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 400,
                            child: TalkWidget(
                              truckId: truck.id,
                              isOwner: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80), // Space for button
                  ],
                ),
              ),
            ],
          );
        },
      ),
      // Bottom Bar: Cart or Navigate Button
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
          final cart = ref.watch(cartProvider);

          if (cart.isEmpty) {
            // Show navigation button when cart is empty
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.black05,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () => _showNavigationDialog(context, truck, l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.baeminMint,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.navigation, size: 20, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        l10n.navigation,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Show cart when items exist
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.charcoalMedium,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.black20,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.totalItems('${cart.totalItems}'),
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₩${NumberFormat('#,###').format(cart.totalAmount)}',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _placeOrder(context, ref, truck, l10n),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.electricBlue,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.placeOrder,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ReviewFormDialog(truckId: truck.id),
          );
        },
        backgroundColor: AppTheme.electricBlue,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.rate_review, color: Colors.black),
        label: Text(
          l10n.writeReview,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _MenuItemCard extends ConsumerWidget {
  const _MenuItemCard({
    required this.item,
    required this.truck,
  });

  final item;
  final Truck truck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat('#,###');
    final cart = ref.watch(cartProvider);

    // Find quantity in cart
    final cartItem = cart.items.where((ci) => ci.menuItemId == item.id).firstOrNull;
    final quantity = cartItem?.quantity ?? 0;

    // Check if sold out
    final isSoldOut = item.isSoldOut ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Opacity(
        opacity: isSoldOut ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSoldOut ? Colors.grey[800] : AppTheme.charcoalMedium,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSoldOut ? Colors.grey[700]! : AppTheme.charcoalLight,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSoldOut ? Colors.grey[600] : AppTheme.textPrimary,
                              decoration: isSoldOut ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        if (isSoldOut)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red[900],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.soldOut,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (item.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSoldOut ? Colors.grey[700] : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      l10n.priceWon(formatter.format(item.price)),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSoldOut ? Colors.grey[700] : AppTheme.electricBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Cart Controls - disabled if sold out
              if (!isSoldOut && quantity == 0)
                ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).addItem(
                          truckId: truck.id,
                          truckName: truck.foodType,
                          menuItemId: item.id,
                          menuItemName: item.name,
                          price: item.price,
                          imageUrl: item.imageUrl,
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.electricBlue,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.addToCart,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              else if (!isSoldOut && quantity > 0)
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.charcoalLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                    IconButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).decreaseQuantity(item.id);
                      },
                      icon: const Icon(Icons.remove, size: 20),
                      color: AppTheme.electricBlue,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    Container(
                      constraints: const BoxConstraints(minWidth: 24),
                      alignment: Alignment.center,
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).addItem(
                              truckId: truck.id,
                              truckName: truck.foodType,
                              menuItemId: item.id,
                              menuItemName: item.name,
                              price: item.price,
                              imageUrl: item.imageUrl,
                            );
                      },
                      icon: const Icon(Icons.add, size: 20),
                      color: AppTheme.electricBlue,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    ));
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final review;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yyyy.MM.dd');
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.mustardYellow10,
                  child: Text(
                    review.userName.substring(0, 1),
                    style: const TextStyle(
                      color: AppTheme.baeminMint,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < review.rating.floor()
                                  ? Icons.star
                                  : (index < review.rating
                                      ? Icons.star_half
                                      : Icons.star_border),
                              size: 16,
                              color: Colors.amber,
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            dateFormat.format(review.createdAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[800],
              ),
            ),

            // Review Photos
            if (review.photoUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.photoUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: review.photoUrls[index],
                          width: 100,
                          height: 100,
                          maxHeightDiskCache: 200,  // 🚀 OPTIMIZATION: Limit thumbnail size
                          maxWidthDiskCache: 200,   // 🚀 OPTIMIZATION: Limit thumbnail size
                          memCacheHeight: 200,      // 🚀 OPTIMIZATION: Limit memory cache
                          memCacheWidth: 200,       // 🚀 OPTIMIZATION: Limit memory cache
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            // Owner Reply
            if (review.ownerReply != null && review.ownerReply!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.mustardYellow10,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.mustardYellow30,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.store,
                          size: 16,
                          color: Color(0xFFFFC107),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.ownerReply,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFC107),
                          ),
                        ),
                        const Spacer(),
                        if (review.ownerReplyAt != null)
                          Text(
                            dateFormat.format(review.ownerReplyAt!),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.ownerReply!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[800],
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
}

// Navigation Dialog Helper Function
void _showNavigationDialog(BuildContext context, Truck truck, AppLocalizations l10n) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.navigation, color: AppTheme.baeminMint),
          const SizedBox(width: 8),
          Text(l10n.navigation),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            truck.locationDescription,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.location}: ${truck.latitude.toStringAsFixed(4)}, ${truck.longitude.toStringAsFixed(4)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.chooseNavigationApp,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _launchNaverMap(context, truck, l10n);
          },
          icon: const Icon(Icons.map, color: Color(0xFF03C75A)),
          label: Text(l10n.naverMap, style: const TextStyle(color: Color(0xFF03C75A))),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _launchKakaoMap(context, truck, l10n);
          },
          icon: const Icon(Icons.location_on, color: Color(0xFFFEE500)),
          label: Text(l10n.kakaoMap, style: const TextStyle(color: Colors.black87)),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _launchGoogleMaps(context, truck, l10n);
          },
          icon: Icon(Icons.public, color: AppTheme.baeminMint),
          label: Text(l10n.googleMaps, style: TextStyle(color: AppTheme.baeminMint)),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    ),
  );
}

// Naver Map URL Launcher
Future<void> _launchNaverMap(BuildContext context, Truck truck, AppLocalizations l10n) async {
  final destinationName = '${l10n.truckUncle} - ${truck.foodType} (${truck.locationDescription})';
  
  // Android intent:// scheme for better app launching
  final androidIntentUrl = Uri.parse(
    'intent://route/destination?'
    'dlat=${truck.latitude}&dlng=${truck.longitude}'
    '&dname=${Uri.encodeComponent(destinationName)}'
    '&appname=com.example.truck_tracker'
    '#Intent;'
    'scheme=nmap;'
    'action=android.intent.action.VIEW;'
    'category=android.intent.category.BROWSABLE;'
    'package=com.nhn.android.nmap;'
    'end',
  );
  
  // iOS/Standard URL scheme
  final naverUrl = Uri.parse(
    'nmap://route/destination?dlat=${truck.latitude}&dlng=${truck.longitude}&dname=${Uri.encodeComponent(destinationName)}&appname=com.example.truck_tracker',
  );
  
  // Web fallback
  final naverWebUrl = Uri.parse(
    'https://map.naver.com/v5/directions/-/-/${truck.latitude},${truck.longitude}/-/',
  );

  try {
    // Try Android intent first (works best on Android 11+)
    bool launched = false;
    
    try {
      if (await canLaunchUrl(androidIntentUrl)) {
        launched = await launchUrl(androidIntentUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // Android intent not supported, try standard URL
    }
    
    // Try standard URL scheme
    if (!launched) {
      if (await canLaunchUrl(naverUrl)) {
        launched = await launchUrl(naverUrl, mode: LaunchMode.externalApplication);
      }
    }
    
    // Fallback to web version
    if (!launched) {
      await launchUrl(naverWebUrl, mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cannotOpenNaverMap),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }
}

// Kakao Map URL Launcher
Future<void> _launchKakaoMap(BuildContext context, Truck truck, AppLocalizations l10n) async {
  final destinationName = '${l10n.truckUncle} - ${truck.foodType} (${truck.locationDescription})';
  
  // Android intent:// scheme for better app launching
  final androidIntentUrl = Uri.parse(
    'intent://route?'
    'ep=${truck.latitude},${truck.longitude}'
    '&by=PUBLICTRANSIT'
    '#Intent;'
    'scheme=kakaomap;'
    'action=android.intent.action.VIEW;'
    'category=android.intent.category.BROWSABLE;'
    'package=net.daum.android.map;'
    'end',
  );
  
  // iOS/Standard URL scheme
  final kakaoUrl = Uri.parse(
    'kakaomap://route?ep=${truck.latitude},${truck.longitude}&by=PUBLICTRANSIT',
  );
  
  // Web fallback with destination name
  final kakaoWebUrl = Uri.parse(
    'https://map.kakao.com/link/to/${Uri.encodeComponent(destinationName)},${truck.latitude},${truck.longitude}',
  );

  try {
    // Try Android intent first (works best on Android 11+)
    bool launched = false;
    
    try {
      if (await canLaunchUrl(androidIntentUrl)) {
        launched = await launchUrl(androidIntentUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // Android intent not supported, try standard URL
    }
    
    // Try standard URL scheme
    if (!launched) {
      if (await canLaunchUrl(kakaoUrl)) {
        launched = await launchUrl(kakaoUrl, mode: LaunchMode.externalApplication);
      }
    }
    
    // Fallback to web version
    if (!launched) {
      await launchUrl(kakaoWebUrl, mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cannotOpenKakaoMap),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }
}

// Google Maps URL Launcher (Web Fallback)
Future<void> _launchGoogleMaps(BuildContext context, Truck truck, AppLocalizations l10n) async {
  final googleUrl = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=${truck.latitude},${truck.longitude}&travelmode=transit',
  );

  try {
    await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cannotOpenGoogleMaps),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }
}

// Place Order Function
Future<void> _placeOrder(BuildContext context, WidgetRef ref, Truck truck, AppLocalizations l10n) async {
  final cart = ref.read(cartProvider);
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.loginRequiredToOrder),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (cart.isEmpty) {
    return;
  }

  // Show confirmation dialog
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(l10n.confirmOrder),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${cart.truckName}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(l10n.totalMenuItems('${cart.totalItems}')),
          const SizedBox(height: 4),
          Text(
            '₩${NumberFormat('#,###').format(cart.totalAmount)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.electricBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.wouldYouLikeToOrder,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.electricBlue,
            foregroundColor: Colors.black,
          ),
          child: Text(
            l10n.placeOrder,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    // Create order
    final order = order_model.Order(
      id: '',
      userId: user.uid,
      userName: user.displayName ?? user.email ?? 'Anonymous',
      truckId: cart.truckId!,
      truckName: cart.truckName!,
      items: cart.items,
      totalAmount: cart.totalAmount,
      status: order_model.OrderStatus.pending,
      createdAt: DateTime.now(),
    );

    // Place order
    final repository = ref.read(orderRepositoryProvider);
    final orderId = await repository.placeOrder(order);

    // Clear cart
    ref.read(cartProvider.notifier).clear();

    // Show success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.orderCompleted(orderId.substring(0, 8))),
          backgroundColor: AppTheme.electricBlue,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.orderFailed('$e')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

