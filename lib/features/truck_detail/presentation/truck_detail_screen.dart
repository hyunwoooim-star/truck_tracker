import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../analytics/data/analytics_repository.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../visit_verification/presentation/visit_verification_button.dart';
import '../../visit_verification/presentation/visit_count_badge.dart';
import '../../order/data/order_repository.dart';
import '../../order/domain/order.dart' as order_model;
import '../../order/presentation/cart_provider.dart';
import '../../review/data/review_repository.dart';
import '../../review/domain/review.dart';
import '../../review/presentation/review_form_dialog.dart';
import '../../schedule/data/schedule_repository.dart';
import '../../talk/presentation/talk_widget.dart';
import '../../truck_list/domain/truck.dart';
import '../domain/menu_item.dart';
import '../../bank_transfer/presentation/bank_transfer_screen.dart';
import 'truck_detail_provider.dart';

class TruckDetailScreen extends ConsumerWidget {
  const TruckDetailScreen({
    super.key,
    required this.truck,
  });

  final Truck truck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // 🔄 FIXED: Use real Firestore stream instead of mock data
    final detailAsync = ref.watch(truckDetailProvider(truck.id));

    // Track truck click for analytics
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final analyticsRepo = ref.read(analyticsRepositoryProvider);
      analyticsRepo.trackTruckClick(truck.id);
    });

    // 📱 PC 웹 반응형: 화면 너비에 따라 최대 너비 제한
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    final maxContentWidth = isWideScreen ? 600.0 : screenWidth;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stackTrace) => Center(
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
                                error: (error, stackTrace) => const SizedBox.shrink(),
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
                    // Visit Verification Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.verified_user,
                                color: AppTheme.mustardYellow,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '방문 인증',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              VisitCountBadge(truckId: truck.id),
                            ],
                          ),
                          const SizedBox(height: 8),
                          VisitVerificationButton(truck: truck),
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
                          if (detail == null || detail.menuItems.isEmpty)
                            // 메뉴 데이터 없을 때 안내 메시지
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.restaurant_menu, size: 48, color: Colors.grey.shade400),
                                  const SizedBox(height: 12),
                                  Text(
                                    '메뉴 준비 중입니다',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '사장님이 곧 메뉴를 등록할 예정이에요!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...detail.menuItems.map(
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
                          loading: () => Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  l10n.reviewsTitle,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '리뷰를 불러오는 중...',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          error: (e, stackTrace) => Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  l10n.reviewsTitle,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '아직 리뷰가 없습니다',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
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
      )),
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
        onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            SnackBarHelper.showWarning(context, l10n.loginRequired);
            return;
          }

          // Verify purchase before allowing review
          final orderRepo = ref.read(orderRepositoryProvider);
          final hasPurchased = await orderRepo.hasCompletedOrder(user.uid, truck.id);

          if (!hasPurchased) {
            if (context.mounted) {
              SnackBarHelper.showWarning(context, l10n.purchaseRequiredForReview);
            }
            return;
          }

          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => ReviewFormDialog(truckId: truck.id),
            );
          }
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

  final MenuItem item;
  final Truck truck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final formatter = NumberFormat('#,###');
    final cart = ref.watch(cartProvider);

    // Find quantity in cart
    final cartItem = cart.items.where((ci) => ci.menuItemId == item.id).firstOrNull;
    final quantity = cartItem?.quantity ?? 0;

    // Check if sold out
    final isSoldOut = item.isSoldOut;

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
              // 메뉴 이미지 (있으면 표시)
              if (item.imageUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ColorFiltered(
                    colorFilter: isSoldOut
                        ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                        : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 72,
                        height: 72,
                        color: AppTheme.charcoalLight,
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 72,
                        height: 72,
                        color: AppTheme.charcoalLight,
                        child: const Icon(Icons.restaurant, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
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
                                item.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSoldOut ? Colors.grey[600] : AppTheme.textPrimary,
                                  decoration: isSoldOut ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ],
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

class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('yyyy.MM.dd');
    final currentUserId = ref.watch(currentUserIdProvider);
    final isMyReview = currentUserId != null && review.userId == currentUserId;

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
                      Row(
                        children: [
                          Text(
                            review.userName,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                          if (isMyReview) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.electricBlue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.myReview,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.electricBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
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
                            review.createdAt != null
                                ? dateFormat.format(review.createdAt!)
                                : '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Edit/Delete menu for own reviews
                if (isMyReview)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) => _handleMenuAction(context, ref, value),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 20),
                            const SizedBox(width: 8),
                            Text(l10n.edit),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, size: 20, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
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

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    final l10n = AppLocalizations.of(context);

    if (action == 'edit') {
      _showEditDialog(context, ref);
    } else if (action == 'delete') {
      _showDeleteConfirmation(context, ref, l10n);
    }
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _ReviewEditDialog(review: review),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteReview),
        content: Text(l10n.deleteReviewConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final repository = ref.read(reviewRepositoryProvider);
                await repository.deleteReview(review.id);
                if (context.mounted) {
                  SnackBarHelper.showSuccess(context, l10n.reviewDeleted);
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarHelper.showError(context, l10n.reviewDeleteFailed);
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
}

/// Dialog for editing a review
class _ReviewEditDialog extends ConsumerStatefulWidget {
  const _ReviewEditDialog({required this.review});

  final Review review;

  @override
  ConsumerState<_ReviewEditDialog> createState() => _ReviewEditDialogState();
}

class _ReviewEditDialogState extends ConsumerState<_ReviewEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _commentController;
  late int _rating;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.review.comment);
    _rating = widget.review.rating;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _updateReview() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context);

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(reviewRepositoryProvider);
      await repository.updateReview(widget.review.id, {
        'rating': _rating,
        'comment': _commentController.text.trim(),
      });

      if (mounted) {
        Navigator.of(context).pop();
        SnackBarHelper.showSuccess(context, l10n.reviewUpdated);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, l10n.reviewUpdateFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.editReview,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: 24),

              // Star Rating
              Text(
                l10n.starRating,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  return IconButton(
                    onPressed: () => setState(() => _rating = starValue),
                    icon: Icon(
                      starValue <= _rating ? Icons.star : Icons.star_border,
                      size: 40,
                      color: starValue <= _rating
                          ? AppTheme.electricBlue
                          : AppTheme.textTertiary,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Comment Field
              Text(
                l10n.reviewContent,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: l10n.reviewPlaceholder,
                  hintStyle: const TextStyle(color: AppTheme.textTertiary),
                  filled: true,
                  fillColor: AppTheme.charcoalMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.charcoalLight,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.electricBlue,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.pleaseEnterReviewContent;
                  }
                  if (value.trim().length < 5) {
                    return l10n.pleaseEnterAtLeast5Chars;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _updateReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.electricBlue,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(l10n.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Navigation Dialog Helper Function
void _showNavigationDialog(BuildContext context, Truck truck, AppLocalizations l10n) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.baeminMint.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.navigation, color: AppTheme.baeminMint, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truck.foodType,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        truck.locationDescription,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Navigation Options
            _NavigationOptionTile(
              icon: Icons.map,
              iconColor: const Color(0xFF03C75A),
              title: l10n.naverMap,
              subtitle: '네이버 지도 앱으로 열기',
              onTap: () {
                Navigator.pop(context);
                _launchNaverMap(context, truck, l10n);
              },
            ),
            const SizedBox(height: 8),
            _NavigationOptionTile(
              icon: Icons.location_on,
              iconColor: const Color(0xFFFFE500),
              iconBgColor: const Color(0xFFFEE500),
              title: l10n.kakaoMap,
              subtitle: '카카오맵 앱으로 열기',
              onTap: () {
                Navigator.pop(context);
                _launchKakaoMap(context, truck, l10n);
              },
            ),
            const SizedBox(height: 8),
            _NavigationOptionTile(
              icon: Icons.public,
              iconColor: AppTheme.baeminMint,
              title: l10n.googleMaps,
              subtitle: '구글 지도로 열기',
              onTap: () {
                Navigator.pop(context);
                _launchGoogleMaps(context, truck, l10n);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

/// Navigation option tile widget
class _NavigationOptionTile extends StatelessWidget {
  const _NavigationOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconBgColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color? iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconBgColor ?? iconColor).withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
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
  
  // Web fallback - 좌표 기반 목적지로 길찾기
  final naverWebUrl = Uri.parse(
    'https://map.naver.com/v5/directions/-/-/-/transit?c=${truck.longitude},${truck.latitude},15,0,0,0,dh&destination=${truck.latitude},${truck.longitude},${Uri.encodeComponent(destinationName)}',
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
      SnackBarHelper.showError(context, l10n.cannotOpenNaverMap);
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
      SnackBarHelper.showError(context, l10n.cannotOpenKakaoMap);
    }
  }
}

// Google Maps URL Launcher (Web Fallback)
Future<void> _launchGoogleMaps(BuildContext context, Truck truck, AppLocalizations l10n) async {
  final destinationName = '${truck.foodType} ${truck.locationDescription}';

  // Google Maps with place name query (shows name instead of coordinates)
  final googleUrl = Uri.parse(
    'https://www.google.com/maps/dir/?api=1'
    '&destination=${Uri.encodeComponent(destinationName)}'
    '&destination_place_id='
    '&travelmode=transit',
  );

  // Fallback with coordinates if name doesn't work
  final googleCoordsUrl = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=${truck.latitude},${truck.longitude}',
  );

  try {
    // Try with destination name first
    final launched = await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    if (!launched) {
      await launchUrl(googleCoordsUrl, mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    if (context.mounted) {
      SnackBarHelper.showError(context, l10n.cannotOpenGoogleMaps);
    }
  }
}

// Place Order Function - Now with Payment Integration
Future<void> _placeOrder(BuildContext context, WidgetRef ref, Truck truck, AppLocalizations l10n) async {
  final cart = ref.read(cartProvider);
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    SnackBarHelper.showWarning(context, l10n.loginRequiredToOrder);
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

  // Generate order ID
  final tempOrderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';

  // Navigate to bank transfer screen
  if (!context.mounted) return;

  final transferResult = await Navigator.push<Map<String, dynamic>>(
    context,
    MaterialPageRoute(
      builder: (_) => BankTransferScreen(
        truckId: truck.id,
        truckName: truck.foodType,
        totalAmount: cart.totalAmount,
        items: cart.items,
        orderId: tempOrderId,
      ),
    ),
  );

  // Handle transfer result
  if (transferResult == null || transferResult['confirmed'] != true) {
    // User cancelled
    return;
  }

  final depositorName = transferResult['depositorName'] as String;

  // Create order with bank transfer payment method
  try {
    final order = order_model.Order(
      id: tempOrderId,
      userId: user.uid,
      userName: user.displayName ?? user.email ?? 'Anonymous',
      truckId: cart.truckId!,
      truckName: cart.truckName!,
      items: cart.items,
      totalAmount: cart.totalAmount,
      status: order_model.OrderStatus.pending, // Pending until payment confirmed by owner
      paymentMethod: 'bank_transfer', // Bank transfer
      createdAt: DateTime.now(),
      note: '입금자명: $depositorName', // Include depositor name in order note
    );

    // Place order
    final repository = ref.read(orderRepositoryProvider);
    final orderId = await repository.placeOrder(order);

    // Clear cart
    ref.read(cartProvider.notifier).clear();

    // Show success message
    if (context.mounted) {
      SnackBarHelper.showSuccess(
        context,
        '주문이 접수되었습니다!\n사장님이 입금 확인 후 주문을 준비합니다.',
      );
      Navigator.pop(context);
    }
  } catch (e) {
    if (context.mounted) {
      SnackBarHelper.showError(context, l10n.orderFailed);
    }
  }
}


