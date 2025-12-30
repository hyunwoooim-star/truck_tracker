import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../shared/widgets/status_tag.dart';
import '../../../truck_detail/presentation/truck_detail_screen.dart';
import '../../../truck_map/presentation/truck_map_screen.dart';
import '../../domain/truck.dart';
import '../../domain/truck_with_distance.dart';
import '../truck_provider.dart';

/// Card size enum for Bento Grid layout
enum BentoCardSize {
  /// Large card (2x2 grid cells) - Featured truck
  large,

  /// Medium card (2x1 grid cells) - Normal truck
  medium,

  /// Small card (1x1 grid cells) - Compact view
  small,
}

/// Bento-style truck card with Glassmorphism effect
class BentoTruckCard extends ConsumerStatefulWidget {
  const BentoTruckCard({
    super.key,
    required this.truckWithDistance,
    required this.size,
    this.rank,
  });

  final TruckWithDistance truckWithDistance;
  final BentoCardSize size;
  final int? rank;

  @override
  ConsumerState<BentoTruckCard> createState() => _BentoTruckCardState();
}

class _BentoTruckCardState extends ConsumerState<BentoTruckCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeScale;
  bool _isLiked = false;

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
    _isLiked = widget.truckWithDistance.truck.isFavorite;
  }

  @override
  void didUpdateWidget(BentoTruckCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.truckWithDistance.truck.isFavorite !=
        widget.truckWithDistance.truck.isFavorite) {
      _isLiked = widget.truckWithDistance.truck.isFavorite;
    }
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _onLikeTap() async {
    final truck = widget.truckWithDistance.truck;
    final l10n = AppLocalizations.of(context);

    // Trigger animation
    _likeController.forward().then((_) => _likeController.reverse());

    setState(() {
      _isLiked = !_isLiked;
    });

    try {
      await ref.read(truckListProvider.notifier).toggleFavorite(truck.id);
    } catch (_) {
      // Revert on error
      setState(() {
        _isLiked = !_isLiked;
      });
      if (mounted) {
        SnackBarHelper.showError(context, l10n.favoriteFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final truck = widget.truckWithDistance.truck;
    final l10n = AppLocalizations.of(context);
    final isClosed = truck.status == TruckStatus.maintenance;

    // Accessibility: Build semantic description
    final statusText = truck.status == TruckStatus.onRoute
        ? l10n.operating
        : truck.status == TruckStatus.resting
            ? l10n.resting
            : l10n.maintenance;
    final distanceText = widget.truckWithDistance.distanceInMeters != double.infinity
        ? ', ${widget.truckWithDistance.distanceText}'
        : '';
    final rankText = widget.rank != null ? ', ${l10n.ranked(widget.rank!)}' : '';
    final semanticLabel = '${truck.truckNumber}, ${truck.foodType}, $statusText$distanceText$rankText. ${l10n.tapToViewDetails}';

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: true,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TruckDetailScreen(truck: truck),
            ),
          );
        },
        child: _buildCardBySize(truck, l10n, isClosed),
      ),
    );
  }

  Widget _buildCardBySize(Truck truck, AppLocalizations l10n, bool isClosed) {
    switch (widget.size) {
      case BentoCardSize.large:
        return _buildLargeCard(truck, l10n, isClosed);
      case BentoCardSize.medium:
        return _buildMediumCard(truck, l10n, isClosed);
      case BentoCardSize.small:
        return _buildSmallCard(truck, l10n, isClosed);
    }
  }

  /// Large card (2x2) - Full image background with glass overlay
  Widget _buildLargeCard(Truck truck, AppLocalizations l10n, bool isClosed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          CachedNetworkImage(
            imageUrl: truck.imageUrl,
            fit: BoxFit.cover,
            memCacheHeight: 400,
            memCacheWidth: 400,
            placeholder: (context, url) => Container(color: AppTheme.charcoalMedium),
            errorWidget: (context, url, error) => Container(
              color: AppTheme.charcoalMedium,
              child: const Icon(Icons.local_shipping, size: 60, color: AppTheme.textTertiary),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
          // Glass info panel at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildGlassPanel(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            truck.truckNumber,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        StatusTag(status: truck.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      truck.foodType,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildDistanceChip(),
                        const SizedBox(width: 8),
                        _buildLocationChip(truck, l10n),
                        const Spacer(),
                        _buildLikeButton(),
                        _buildMapButton(truck, l10n),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Ranking badge
          if (widget.rank != null) _buildRankBadge(),
        ],
      ),
    );
  }

  /// Medium card (2x1) - Horizontal layout
  Widget _buildMediumCard(Truck truck, AppLocalizations l10n, bool isClosed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.charcoalMedium,
          border: Border.all(
            color: isClosed ? Colors.grey : AppTheme.charcoalLight,
          ),
        ),
        child: Row(
          children: [
            // Image section (40% width)
            SizedBox(
              width: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: truck.imageUrl,
                    fit: BoxFit.cover,
                    memCacheHeight: 200,
                    memCacheWidth: 200,
                    placeholder: (context, url) => Container(color: AppTheme.charcoalLight),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.charcoalLight,
                      child: const Icon(Icons.local_shipping, color: AppTheme.textTertiary),
                    ),
                  ),
                  if (widget.rank != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildRankBadge(compact: true),
                    ),
                ],
              ),
            ),
            // Info section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title + Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            truck.truckNumber,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StatusTag(status: truck.status),
                      ],
                    ),
                    // Food type + Location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          truck.foodType,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          truck.locationDescription,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // Distance + Actions
                    Row(
                      children: [
                        _buildDistanceChip(compact: true),
                        const Spacer(),
                        _buildLikeButton(compact: true),
                        _buildMapButton(truck, l10n, compact: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Small card (1x1) - Compact square layout
  Widget _buildSmallCard(Truck truck, AppLocalizations l10n, bool isClosed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          CachedNetworkImage(
            imageUrl: truck.imageUrl,
            fit: BoxFit.cover,
            memCacheHeight: 200,
            memCacheWidth: 200,
            placeholder: (context, url) => Container(color: AppTheme.charcoalMedium),
            errorWidget: (context, url, error) => Container(
              color: AppTheme.charcoalMedium,
              child: const Icon(Icons.local_shipping, color: AppTheme.textTertiary),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.4, 1.0],
              ),
            ),
          ),
          // Info overlay
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  truck.truckNumber,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  truck.foodType,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Like button
          Positioned(
            top: 8,
            right: 8,
            child: _buildLikeButton(compact: true, mini: true),
          ),
          // Status indicator
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: truck.status == TruckStatus.onRoute
                    ? Colors.green
                    : truck.status == TruckStatus.resting
                        ? Colors.orange
                        : Colors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Glassmorphism panel effect
  Widget _buildGlassPanel({required Widget child}) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  /// Distance chip
  Widget _buildDistanceChip({bool compact = false}) {
    final distance = widget.truckWithDistance.distanceInMeters;
    if (distance == double.infinity) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.electricBlue.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.near_me,
            size: compact ? 12 : 14,
            color: AppTheme.electricBlue,
          ),
          SizedBox(width: compact ? 2 : 4),
          Text(
            widget.truckWithDistance.distanceText,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.electricBlue,
            ),
          ),
        ],
      ),
    );
  }

  /// Location chip
  Widget _buildLocationChip(Truck truck, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on,
            size: 14,
            color: Colors.white70,
          ),
          const SizedBox(width: 4),
          Text(
            truck.locationDescription,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  /// Animated like button with micro-interaction
  Widget _buildLikeButton({bool compact = false, bool mini = false}) {
    final l10n = AppLocalizations.of(context);
    final semanticLabel = _isLiked ? l10n.favoriteRemoved : l10n.favoriteSuccess;

    return Semantics(
      label: semanticLabel,
      button: true,
      child: AnimatedBuilder(
        animation: _likeScale,
        builder: (context, child) {
          return Transform.scale(
            scale: _likeScale.value,
            child: mini
                ? GestureDetector(
                    onTap: _onLikeTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: _isLiked ? Colors.red : Colors.white,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: _onLikeTap,
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : AppTheme.textTertiary,
                    ),
                    iconSize: compact ? 20 : 24,
                    padding: compact ? EdgeInsets.zero : null,
                    constraints: compact
                        ? const BoxConstraints(minWidth: 32, minHeight: 32)
                        : null,
                  ),
          );
        },
      ),
    );
  }

  /// Map button
  Widget _buildMapButton(Truck truck, AppLocalizations l10n, {bool compact = false}) {
    return Semantics(
      label: l10n.viewOnMap,
      button: true,
      child: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TruckMapScreen(
                initialTruckId: truck.id,
                initialLatLng: LatLng(truck.latitude, truck.longitude),
              ),
            ),
          );
        },
        icon: const Icon(Icons.location_on, color: AppTheme.electricBlue),
        iconSize: compact ? 20 : 24,
        padding: compact ? EdgeInsets.zero : null,
        constraints: compact
            ? const BoxConstraints(minWidth: 32, minHeight: 32)
            : null,
        tooltip: l10n.viewOnMap,
      ),
    );
  }

  /// Ranking badge for Top 3 trucks
  Widget _buildRankBadge({bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.mustardYellow,
        borderRadius: BorderRadius.circular(compact ? 6 : 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium,
            size: compact ? 14 : 18,
            color: Colors.black87,
          ),
          SizedBox(width: compact ? 2 : 4),
          Text(
            '#${widget.rank}',
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
