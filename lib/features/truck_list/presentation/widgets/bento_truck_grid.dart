import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../domain/truck_with_distance.dart';
import 'bento_truck_card.dart';

/// Bento Grid layout for displaying trucks
/// Uses clean list layout with featured card for first item
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

    // ✅ OPTIMIZATION: Pre-compute rank lookup map O(n) -> O(1) per lookup
    final rankMap = <String, int>{
      for (var i = 0; i < topRanked.length; i++) topRanked[i].id as String: i + 1
    };

    return ListView.builder(
      padding: padding,
      itemCount: trucksWithDistance.length,
      itemBuilder: (context, index) {
        final truckWithDistance = trucksWithDistance[index];
        final truck = truckWithDistance.truck;

        // O(1) lookup instead of O(n) indexWhere
        final rank = rankMap[truck.id];

        // First item or top 3 ranked: Large card (full width)
        // Others: Medium card (horizontal layout)
        final isLarge = index == 0 || (rank != null && rank <= 3);
        final size = isLarge ? BentoCardSize.large : BentoCardSize.medium;

        return Padding(
          padding: EdgeInsets.only(bottom: index < trucksWithDistance.length - 1 ? 12 : 0),
          child: SizedBox(
            height: isLarge ? 220 : 120,
            child: BentoTruckCard(
              truckWithDistance: truckWithDistance,
              size: size,
              rank: rank,
            ),
          ),
        );
      },
    );
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

    // ✅ OPTIMIZATION: Pre-compute rank lookup map O(n) -> O(1) per lookup
    final rankMap = <String, int>{
      for (var i = 0; i < topRanked.length; i++) topRanked[i].id as String: i + 1
    };

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

          // O(1) lookup instead of O(n) indexWhere
          final rank = rankMap[truck.id];

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
