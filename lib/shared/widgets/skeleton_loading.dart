import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/themes/app_theme.dart';

/// 다크 테마용 Shimmer 기본 색상
const _baseColor = Color(0xFF2A2A2A);
const _highlightColor = Color(0xFF3A3A3A);

/// 기본 Skeleton 컨테이너
/// 직사각형 shimmer 효과를 표시합니다
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// 원형 Skeleton (아바타, 아이콘 등)
class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({
    super.key,
    this.size = 40,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// 텍스트 라인 Skeleton
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    super.key,
    this.width,
    this.height = 14,
  });

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      borderRadius: 4,
    );
  }
}

/// 트럭 카드 Skeleton (메인 화면용)
class SkeletonTruckCard extends StatelessWidget {
  const SkeletonTruckCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 트럭 이미지
          const SkeletonBox(
            width: 80,
            height: 80,
            borderRadius: 12,
          ),
          const SizedBox(width: 16),
          // 트럭 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 트럭 이름
                const SkeletonLine(width: 120, height: 18),
                const SizedBox(height: 8),
                // 음식 종류
                const SkeletonLine(width: 80, height: 14),
                const SizedBox(height: 12),
                // 거리 및 평점
                Row(
                  children: [
                    const SkeletonBox(width: 60, height: 24, borderRadius: 12),
                    const SizedBox(width: 8),
                    const SkeletonBox(width: 50, height: 24, borderRadius: 12),
                  ],
                ),
              ],
            ),
          ),
          // 즐겨찾기 버튼
          const SkeletonCircle(size: 32),
        ],
      ),
    );
  }
}

/// 트럭 카드 리스트 Skeleton
class SkeletonTruckList extends StatelessWidget {
  const SkeletonTruckList({
    super.key,
    this.itemCount = 5,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (_, index) => const SkeletonTruckCard(),
    );
  }
}

/// 메뉴 아이템 Skeleton
class SkeletonMenuItem extends StatelessWidget {
  const SkeletonMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 메뉴 이미지
          const SkeletonBox(
            width: 60,
            height: 60,
            borderRadius: 8,
          ),
          const SizedBox(width: 12),
          // 메뉴 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLine(width: 100, height: 16),
                const SizedBox(height: 6),
                const SkeletonLine(width: 60, height: 14),
              ],
            ),
          ),
          // 가격
          const SkeletonLine(width: 50, height: 16),
        ],
      ),
    );
  }
}

/// 메뉴 리스트 Skeleton
class SkeletonMenuList extends StatelessWidget {
  const SkeletonMenuList({
    super.key,
    this.itemCount = 6,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (_, index) => const SkeletonMenuItem(),
    );
  }
}

/// 리뷰 카드 Skeleton
class SkeletonReviewCard extends StatelessWidget {
  const SkeletonReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (프로필, 이름, 별점)
          Row(
            children: [
              const SkeletonCircle(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLine(width: 80, height: 14),
                    const SizedBox(height: 4),
                    const SkeletonLine(width: 100, height: 12),
                  ],
                ),
              ),
              const SkeletonBox(width: 60, height: 20, borderRadius: 10),
            ],
          ),
          const SizedBox(height: 12),
          // 리뷰 내용
          const SkeletonLine(height: 14),
          const SizedBox(height: 6),
          const SkeletonLine(width: 200, height: 14),
        ],
      ),
    );
  }
}

/// 주문 카드 Skeleton
class SkeletonOrderCard extends StatelessWidget {
  const SkeletonOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 주문 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SkeletonLine(width: 100, height: 16),
              const SkeletonBox(width: 70, height: 24, borderRadius: 12),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.grey, height: 1),
          const SizedBox(height: 12),
          // 주문 아이템
          ...List.generate(2, (_) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SkeletonLine(width: 120, height: 14),
                const SkeletonLine(width: 50, height: 14),
              ],
            ),
          )),
          const SizedBox(height: 8),
          // 합계
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SkeletonLine(width: 40, height: 16),
              const SkeletonLine(width: 70, height: 18),
            ],
          ),
        ],
      ),
    );
  }
}

/// 통계 카드 Skeleton (대시보드용)
class SkeletonStatsCard extends StatelessWidget {
  const SkeletonStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkeletonCircle(size: 40),
              const SizedBox(width: 12),
              const SkeletonLine(width: 80, height: 14),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonLine(width: 100, height: 32),
          const SizedBox(height: 8),
          const SkeletonLine(width: 60, height: 12),
        ],
      ),
    );
  }
}

/// 채팅 메시지 Skeleton
class SkeletonChatMessage extends StatelessWidget {
  const SkeletonChatMessage({
    super.key,
    this.isMe = false,
  });

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.mustardYellow10 : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLine(width: 150 + (isMe ? 0 : 50), height: 14),
            const SizedBox(height: 4),
            const SkeletonLine(width: 80, height: 14),
          ],
        ),
      ),
    );
  }
}

/// 채팅 리스트 Skeleton
class SkeletonChatList extends StatelessWidget {
  const SkeletonChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SkeletonChatMessage(isMe: false),
        SkeletonChatMessage(isMe: true),
        SkeletonChatMessage(isMe: false),
        SkeletonChatMessage(isMe: true),
        SkeletonChatMessage(isMe: false),
      ],
    );
  }
}

/// 쿠폰 카드 Skeleton
class SkeletonCouponCard extends StatelessWidget {
  const SkeletonCouponCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const SkeletonBox(width: 70, height: 60, borderRadius: 12),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonLine(width: 120, height: 16),
                      const SizedBox(height: 8),
                      const SkeletonLine(width: 150, height: 12),
                      const SizedBox(height: 4),
                      const SkeletonLine(width: 100, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(30),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonLine(width: 60, height: 10),
                      const SizedBox(height: 4),
                      const SkeletonLine(width: 100, height: 16),
                    ],
                  ),
                ),
                const SkeletonBox(width: 80, height: 36, borderRadius: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 전체 화면 로딩 Skeleton (범용)
class SkeletonFullScreen extends StatelessWidget {
  const SkeletonFullScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.midnightCharcoal,
      child: child,
    );
  }
}

/// 프로필 헤더 Skeleton
class SkeletonProfileHeader extends StatelessWidget {
  const SkeletonProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SkeletonCircle(size: 80),
        const SizedBox(height: 16),
        const SkeletonLine(width: 120, height: 20),
        const SizedBox(height: 8),
        const SkeletonLine(width: 160, height: 14),
      ],
    );
  }
}

/// 그리드 Skeleton (음식 종류 필터 등)
class SkeletonChipGrid extends StatelessWidget {
  const SkeletonChipGrid({
    super.key,
    this.itemCount = 6,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        itemCount,
        (_) => const SkeletonBox(width: 70, height: 32, borderRadius: 16),
      ),
    );
  }
}

/// 트럭 상세 정보 Skeleton
class SkeletonTruckDetail extends StatelessWidget {
  const SkeletonTruckDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 이미지
          const SkeletonBox(
            width: double.infinity,
            height: 200,
            borderRadius: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 트럭 이름 및 상태
                Row(
                  children: [
                    const Expanded(child: SkeletonLine(height: 24)),
                    const SizedBox(width: 16),
                    const SkeletonBox(width: 60, height: 28, borderRadius: 14),
                  ],
                ),
                const SizedBox(height: 16),
                // 정보 행들
                ...List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const SkeletonCircle(size: 24),
                      const SizedBox(width: 12),
                      const Expanded(child: SkeletonLine(height: 14)),
                    ],
                  ),
                )),
                const SizedBox(height: 16),
                // 메뉴 섹션
                const SkeletonLine(width: 80, height: 18),
                const SizedBox(height: 12),
                ...List.generate(3, (_) => const SkeletonMenuItem()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
