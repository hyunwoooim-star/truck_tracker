import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/presentation/auth_provider.dart';

/// 푸시 알림 발송 도구 (사장님용)
class PushNotificationTool extends ConsumerStatefulWidget {
  const PushNotificationTool({super.key});

  @override
  ConsumerState<PushNotificationTool> createState() => _PushNotificationToolState();
}

class _PushNotificationToolState extends ConsumerState<PushNotificationTool> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSending = false;
  String _selectedType = 'announcement'; // announcement, promotion, event

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final truckIdAsync = ref.watch(currentUserTruckIdProvider);

    return truckIdAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('오류: $e')),
      ),
      data: (truckId) {
        if (truckId == null) {
          return const Scaffold(
            body: Center(child: Text('트럭 정보를 찾을 수 없습니다')),
          );
        }
        return _buildContent(truckId.toString());
      },
    );
  }

  Widget _buildContent(String truckId) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 발송'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 팔로워 수 표시
            _FollowerCountCard(truckId: truckId),
            const SizedBox(height: 24),

            // 알림 유형 선택
            const Text(
              '알림 유형',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildTypeSelector(),
            const SizedBox(height: 24),

            // 빠른 템플릿
            const Text(
              '빠른 템플릿',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickTemplates(),
            const SizedBox(height: 24),

            // 제목 입력
            const Text(
              '알림 제목',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '알림 제목을 입력하세요',
                filled: true,
                fillColor: AppTheme.charcoalMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                counterText: '${_titleController.text.length}/50',
              ),
              maxLength: 50,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // 내용 입력
            const Text(
              '알림 내용',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                hintText: '알림 내용을 입력하세요',
                filled: true,
                fillColor: AppTheme.charcoalMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                counterText: '${_bodyController.text.length}/200',
              ),
              maxLength: 200,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // 미리보기
            _buildPreview(),
            const SizedBox(height: 24),

            // 발송 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSend() ? () => _sendNotification(truckId) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.electricBlue,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        '팔로워에게 알림 발송',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // 안내 문구
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.charcoalMedium,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppTheme.textTertiary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '알림은 트럭을 팔로우한 고객에게만 발송됩니다.\n과도한 알림 발송은 고객 이탈을 유발할 수 있습니다.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        _TypeChip(
          label: '공지사항',
          icon: Icons.campaign,
          isSelected: _selectedType == 'announcement',
          onTap: () => setState(() => _selectedType = 'announcement'),
        ),
        const SizedBox(width: 8),
        _TypeChip(
          label: '프로모션',
          icon: Icons.local_offer,
          isSelected: _selectedType == 'promotion',
          onTap: () => setState(() => _selectedType = 'promotion'),
        ),
        const SizedBox(width: 8),
        _TypeChip(
          label: '이벤트',
          icon: Icons.celebration,
          isSelected: _selectedType == 'event',
          onTap: () => setState(() => _selectedType = 'event'),
        ),
      ],
    );
  }

  Widget _buildQuickTemplates() {
    final templates = [
      {'title': '영업 시작!', 'body': '오늘 영업을 시작했어요. 맛있는 음식과 함께 기다리고 있습니다! 🚚'},
      {'title': '신메뉴 출시', 'body': '새로운 메뉴가 출시되었어요! 지금 바로 확인해보세요 🆕'},
      {'title': '오늘만 특가!', 'body': '오늘 하루 특별 할인 이벤트 진행 중! 놓치지 마세요 💰'},
      {'title': '영업 종료 임박', 'body': '곧 영업이 종료됩니다. 서둘러 주문해주세요! ⏰'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: templates.map((template) {
        return ActionChip(
          label: Text(template['title']!),
          backgroundColor: AppTheme.charcoalMedium,
          onPressed: () {
            setState(() {
              _titleController.text = template['title']!;
              _bodyController.text = template['body']!;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPreview() {
    if (_titleController.text.isEmpty && _bodyController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '미리보기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.charcoalLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.electricBlue.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.mustardYellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_shipping, color: Colors.black, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleController.text.isEmpty ? '알림 제목' : _titleController.text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _bodyController.text.isEmpty ? '알림 내용' : _bodyController.text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _canSend() {
    return _titleController.text.isNotEmpty &&
        _bodyController.text.isNotEmpty &&
        !_isSending;
  }

  Future<void> _sendNotification(String truckId) async {
    if (!_canSend()) return;

    setState(() => _isSending = true);

    try {
      // Firestore에 알림 요청 문서 생성 (Cloud Function이 처리)
      await FirebaseFirestore.instance.collection('notificationRequests').add({
        'truckId': truckId,
        'type': _selectedType,
        'title': _titleController.text.trim(),
        'body': _bodyController.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        SnackBarHelper.showSuccess(context, '알림이 발송되었습니다!');
        _titleController.clear();
        _bodyController.clear();
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '알림 발송에 실패했습니다: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.electricBlue.withValues(alpha: 0.2)
              : AppTheme.charcoalMedium,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.electricBlue : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppTheme.electricBlue : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.electricBlue : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 팔로워 수 카드
class _FollowerCountCard extends StatelessWidget {
  final String truckId;

  const _FollowerCountCard({required this.truckId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('follows')
          .where('truckId', isEqualTo: truckId)
          .snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length ?? 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.electricBlue.withValues(alpha: 0.2),
                AppTheme.electricBlue.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.electricBlue.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.people,
                  color: AppTheme.electricBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '알림 수신 대상',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count명의 팔로워',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.electricBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
