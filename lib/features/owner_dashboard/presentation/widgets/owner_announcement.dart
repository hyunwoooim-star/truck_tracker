import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../truck_list/domain/truck.dart';
import '../../../truck_list/presentation/truck_provider.dart';

/// 오늘의 공지사항 섹션
class OwnerAnnouncementSection extends ConsumerWidget {
  final Truck truck;

  const OwnerAnnouncementSection({super.key, required this.truck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.campaign, color: AppTheme.mustardYellow, size: 20),
              SizedBox(width: 8),
              Text(
                '오늘의 특별 공지',
                style: TextStyle(
                  color: AppTheme.mustardYellow,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            truck.announcement.isEmpty ? '공지사항이 없습니다' : truck.announcement,
            style: TextStyle(
              color: truck.announcement.isEmpty ? Colors.white38 : Colors.white,
              fontSize: 14,
              fontStyle:
                  truck.announcement.isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAnnouncementDialog(context, ref),
              icon:
                  const Icon(Icons.edit, size: 16, color: AppTheme.mustardYellow),
              label: const Text(
                '공지 수정',
                style: TextStyle(color: AppTheme.mustardYellow),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.mustardYellow),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnnouncementDialog(BuildContext context, WidgetRef ref) {
    final announcementController =
        TextEditingController(text: truck.announcement);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.midnightCharcoal,
        title: const Text(
          '오늘의 특별 공지',
          style: TextStyle(color: AppTheme.mustardYellow),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '이 공지는 고객에게 표시됩니다',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: announcementController,
              maxLines: 3,
              maxLength: 200,
              decoration: const InputDecoration(
                labelText: '공지사항',
                labelStyle: TextStyle(color: Colors.white70),
                hintText: '예: 오늘 신메뉴 출시! 타코 20% 할인',
                hintStyle: TextStyle(color: Colors.white30),
                border: OutlineInputBorder(),
                counterStyle: TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              final announcement = announcementController.text.trim();

              try {
                final repository = ref.read(truckRepositoryProvider);
                await repository.updateAnnouncement(truck.id, announcement);

                if (context.mounted) {
                  Navigator.of(context).pop();
                  SnackBarHelper.showSuccess(context, '공지사항이 업데이트되었습니다');
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarHelper.showError(context, '오류: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.mustardYellow,
              foregroundColor: Colors.black,
            ),
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}
