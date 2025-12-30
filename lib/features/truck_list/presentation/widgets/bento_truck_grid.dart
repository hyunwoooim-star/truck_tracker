import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../domain/truck_with_distance.dart';
import 'bento_truck_card.dart';

/// Bento Grid layout for displaying trucks
/// Uses staggered grid with varying tile sizes for visual interest
class BentoTruckGrid extends StatelessWidget {
  const BentoTruckGrid({
    super.key,
    required this.trucksWithDistance,
    required this.topRanked,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final List<TruckWithDistance> trucksWithDistance;
  final List<dynamic> topRanked;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (trucksWithDistance.isEmpty) {
      return const SizedBox.shrink();
    }

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: padding,
      itemCount: trucksWithDistance.length,
      itemBuilder: (context, index) {
        final truckWithDistance = trucksWithDistance[index];
        final truck = truckWithDistance.truck;

        // Determine rank if in top 3
        final rankIndex = topRanked.indexWhere((t) => t.id == truck.id);
        final rank = rankIndex >= 0 ? rankIndex + 1 : null;

        // Determine card size based on position and ranking
        final size = _determineCardSize(index, rank);
        final height = _getCardHeight(size);

        return SizedBox(
          height: height,
          child: BentoTruckCard(
            truckWithDistance: truckWithDistance,
            size: size,
            rank: rank,
          ),
        );
      },
    );
  }

  /// Determines card size based on index and ranking
  /// Pattern creates visual variety:
  /// - First item: Large (featured)
  /// - Top 3 ranked: Large
  /// - Every 5th item: Medium
  /// - Others: Small or Medium alternating
  BentoCardSize _determineCardSize(int index, int? rank) {
    // First truck is always large (featured)
    if (index == 0) {
      return BentoCardSize.large;
    }

    // Top 3 ranked trucks get large cards
    if (rank != null && rank <= 3) {
      return BentoCardSize.large;
    }

    // Create a pattern for visual variety
    // Pattern: L, S, M, S, M, S, L, S, M...
    final patternIndex = index % 7;
    switch (patternIndex) {
      case 0:
        return BentoCardSize.large;
      case 1:
      case 3:
      case 5:
        return BentoCardSize.small;
      case 2:
      case 4:
      case 6:
        return BentoCardSize.medium;
      default:
        return BentoCardSize.small;
    }
  }

  /// Returns height for each card size
  double _getCardHeight(BentoCardSize size) {
    switch (size) {
      case BentoCardSize.large:
        return 280;
      case BentoCardSize.medium:
        return 140;
      case BentoCardSize.small:
        return 160;
    }
  }
}

/// Alternative grid layout with quilted pattern
/// Uses QuiltedGridView for more complex tile arrangements
class QuiltedTruckGrid extends StatelessWidget {
  const QuiltedTruckGrid({
    super.key,
    required this.trucksWithDistance,
    required this.topRanked,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final List<TruckWithDistance> trucksWithDistance;
  final List<dynamic> topRanked;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (trucksWithDistance.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate the pattern for quilted grid
    final pattern = _generatePattern(trucksWithDistance.length);

    return GridView.custom(
      padding: padding,
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: pattern,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) {
          final truckWithDistance = trucksWithDistance[index];
          final truck = truckWithDistance.truck;

          // Determine rank if in top 3
          final rankIndex = topRanked.indexWhere((t) => t.id == truck.id);
          final rank = rankIndex >= 0 ? rankIndex + 1 : null;

          // Get size from pattern
          final patternIndex = index % pattern.length;
          final tile = pattern[patternIndex];
          final size = _tileSizeToCardSize(tile);

          return BentoTruckCard(
            truckWithDistance: truckWithDistance,
            size: size,
            rank: rank,
          );
        },
        childCount: trucksWithDistance.length,
      ),
    );
  }

  /// Generates quilted grid pattern
  List<QuiltedGridTile> _generatePattern(int itemCount) {
    return const [
      QuiltedGridTile(2, 2), // Large (2x2)
      QuiltedGridTile(1, 2), // Medium (1x2)
      QuiltedGridTile(1, 1), // Small (1x1)
      QuiltedGridTile(1, 1), // Small (1x1)
      QuiltedGridTile(1, 2), // Medium (1x2)
      QuiltedGridTile(2, 2), // Large (2x2)
      QuiltedGridTile(1, 1), // Small (1x1)
      QuiltedGridTile(1, 1), // Small (1x1)
    ];
  }

  /// Converts tile dimensions to card size
  BentoCardSize _tileSizeToCardSize(QuiltedGridTile tile) {
    if (tile.crossAxisCount >= 2 && tile.mainAxisCount >= 2) {
      return BentoCardSize.large;
    } else if (tile.crossAxisCount >= 2 || tile.mainAxisCount >= 2) {
      return BentoCardSize.medium;
    }
    return BentoCardSize.small;
  }
}
