import 'package:flutter/material.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../talk/presentation/talk_widget.dart';

/// 고객 대화 섹션
class OwnerTalkSection extends StatelessWidget {
  final String truckId;

  const OwnerTalkSection({super.key, required this.truckId});

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.chat, color: AppTheme.mustardYellow, size: 20),
              SizedBox(width: 8),
              Text(
                '고객 문의',
                style: TextStyle(
                  color: AppTheme.mustardYellow,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: TalkWidget(
              truckId: truckId,
              isOwner: true,
            ),
          ),
        ],
      ),
    );
  }
}
