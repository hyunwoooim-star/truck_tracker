import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:truck_tracker/generated/l10n/app_localizations.dart';

import '../../../../core/themes/app_theme.dart';
import '../widgets/owner_order_kanban.dart';

/// 주문 탭 - 칸반 보드로 주문 관리
class OwnerOrdersTab extends ConsumerWidget {
  const OwnerOrdersTab({super.key, required this.truckId});

  final String truckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.receipt_long, color: AppTheme.mustardYellow, size: 24),
              const SizedBox(width: 12),
              Text(
                l10n.todayOrders,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.mustardYellow.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.refresh, color: AppTheme.mustardYellow, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      l10n.realtime,
                      style: const TextStyle(
                        color: AppTheme.mustardYellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 칸반 보드
        Expanded(
          child: OwnerOrderKanban(truckId: truckId),
        ),
      ],
    );
  }
}
