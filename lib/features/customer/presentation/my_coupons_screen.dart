import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/themes/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../auth/presentation/auth_provider.dart';

/// 내 쿠폰함 - 손님이 보유한 스탬프 쿠폰 목록
class MyCouponsScreen extends ConsumerWidget {
  const MyCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentUser = ref.watch(currentUserProvider);

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: AppTheme.midnightCharcoal,
        appBar: AppBar(
          title: Text(l10n.myCoupons),
          backgroundColor: AppTheme.midnightCharcoal,
          foregroundColor: AppTheme.mustardYellow,
        ),
        body: Center(
          child: Text(
            l10n.loginRequired,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: Text(l10n.myCoupons),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 단일 필드 쿼리로 변경 (인덱스 불필요)
        stream: FirebaseFirestore.instance
            .collection('userCoupons')
            .where('userId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.mustardYellow),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${l10n.error}: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // 클라이언트에서 필터링 및 정렬 (인덱스 불필요)
          final allDocs = snapshot.data?.docs ?? [];
          final coupons = allDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['isUsed'] != true;
          }).toList();

          // createdAt 기준 내림차순 정렬
          coupons.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aCreated = aData['createdAt'] as Timestamp?;
            final bCreated = bData['createdAt'] as Timestamp?;
            if (aCreated == null || bCreated == null) return 0;
            return bCreated.compareTo(aCreated);
          });

          if (coupons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.card_giftcard_outlined,
                    size: 80,
                    color: Colors.white30,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noCoupons,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.earnCouponsHint,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: coupons.length,
            itemBuilder: (context, index) {
              final data = coupons[index].data() as Map<String, dynamic>;
              return _CouponCard(
                couponId: coupons[index].id,
                data: data,
                l10n: l10n,
              );
            },
          );
        },
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final String couponId;
  final Map<String, dynamic> data;
  final AppLocalizations l10n;

  const _CouponCard({
    required this.couponId,
    required this.data,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final truckName = data['truckName'] as String? ?? '';
    final stampCount = data['stampCount'] as int? ?? 0;
    final requiredStamps = data['requiredStamps'] as int? ?? 10;
    final isComplete = stampCount >= requiredStamps;
    final expiresAt = data['expiresAt'] as Timestamp?;
    final dateFormat = DateFormat('yyyy.MM.dd');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isComplete
              ? [AppTheme.mustardYellow, AppTheme.mustardYellow.withValues(alpha: 0.8)]
              : [AppTheme.charcoalMedium, AppTheme.charcoalDark],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isComplete ? AppTheme.mustardYellow : AppTheme.mustardYellow30,
          width: isComplete ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isComplete ? Colors.black26 : AppTheme.mustardYellow20,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_cafe,
                    color: isComplete ? Colors.black : AppTheme.mustardYellow,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truckName,
                        style: TextStyle(
                          color: isComplete ? Colors.black : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isComplete ? l10n.couponReady : '$stampCount / $requiredStamps ${l10n.stamps}',
                        style: TextStyle(
                          color: isComplete ? Colors.black54 : Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isComplete)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.useNow,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Stamp progress
          if (!isComplete)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(requiredStamps, (i) {
                  final isFilled = i < stampCount;
                  return Expanded(
                    child: Container(
                      height: 8,
                      margin: EdgeInsets.only(right: i < requiredStamps - 1 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: isFilled ? AppTheme.mustardYellow : Colors.grey[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (expiresAt != null)
                  Text(
                    '${l10n.expiresOn}: ${dateFormat.format(expiresAt.toDate())}',
                    style: TextStyle(
                      color: isComplete ? Colors.black45 : Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                if (isComplete)
                  TextButton.icon(
                    onPressed: () => _showQRDialog(context),
                    icon: const Icon(Icons.qr_code, size: 18),
                    label: Text(l10n.showQR),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showQRDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.midnightCharcoal,
        title: Text(
          l10n.couponQR,
          style: const TextStyle(color: AppTheme.mustardYellow),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: 'coupon:$couponId',
                version: QrVersions.auto,
                size: 200,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.showQRToOwner,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
