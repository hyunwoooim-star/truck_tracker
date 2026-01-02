import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/snackbar_helper.dart';
import '../../auth/presentation/auth_provider.dart';

/// 사장님 신청 다이얼로그 (상호명, 파일 업로드 필수)
class OwnerRequestDialog extends ConsumerStatefulWidget {
  const OwnerRequestDialog({super.key});

  @override
  ConsumerState<OwnerRequestDialog> createState() => _OwnerRequestDialogState();
}

class _OwnerRequestDialogState extends ConsumerState<OwnerRequestDialog> {
  final _businessNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Uint8List? _selectedImageBytes;
  String? _selectedFileName;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedFileName = picked.name;
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '이미지 선택 실패: $e');
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImageBytes == null) {
      SnackBarHelper.showError(context, '사업자등록증 또는 영업허가증을 첨부해주세요');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final authService = ref.read(authServiceProvider);

      // [FIX] 통합 메서드 사용 - 이미지와 정보를 한 번에 저장
      // 60초 타임아웃 추가
      await authService.submitOwnerApplication(
        businessName: _businessNameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        imageData: _selectedImageBytes,
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('업로드 시간이 초과되었습니다. 네트워크를 확인해주세요.');
        },
      );

      ref.invalidate(ownerRequestStatusProvider);

      if (mounted) {
        Navigator.pop(context);
        SnackBarHelper.showSuccess(context, '사장님 인증 신청이 완료되었습니다!');
      }
    } catch (e) {
      if (mounted) {
        // 상세 에러 메시지 표시
        String errorMsg = '신청 실패';
        if (e.toString().contains('permission')) {
          errorMsg = '권한 오류: 로그인 상태를 확인해주세요';
        } else if (e.toString().contains('network') || e.toString().contains('timeout')) {
          errorMsg = '네트워크 오류: 인터넷 연결을 확인해주세요';
        } else {
          errorMsg = '신청 실패: ${e.toString().replaceAll('Exception: ', '')}';
        }
        SnackBarHelper.showError(context, errorMsg);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.store, color: Colors.green),
          SizedBox(width: 8),
          Text('사장님 인증 신청'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '푸드트럭 사장님이시라면 인증을 신청해주세요.\n관리자 검토 후 승인되면 트럭을 등록할 수 있습니다.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),

              // 상호명 (필수)
              TextFormField(
                controller: _businessNameController,
                decoration: InputDecoration(
                  labelText: '상호명 *',
                  hintText: '예: 맛있는 타코야끼',
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.green[700]),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '상호명을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 간단한 소개 (선택)
              TextField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: '간단한 소개 (선택)',
                  hintText: '어떤 메뉴를 판매하시나요?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 파일 업로드 (필수)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedImageBytes != null
                        ? Colors.green
                        : Colors.grey[400]!,
                    width: _selectedImageBytes != null ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.upload_file,
                          color: _selectedImageBytes != null
                              ? Colors.green
                              : Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '사업자등록증 / 영업허가증 *',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_selectedImageBytes != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _selectedFileName ?? '이미지 선택됨',
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => setState(() {
                              _selectedImageBytes = null;
                              _selectedFileName = null;
                            }),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ] else ...[
                      const Text(
                        '인증을 위해 사업자등록증 또는\n영업허가증 사진을 첨부해주세요.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '선명하게 촬영, 최대 5MB (자동 최적화)',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: Text(
                            _selectedImageBytes != null ? '다시 선택' : '파일 선택'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('신청하기'),
        ),
      ],
    );
  }
}

/// 사장님 신청 상태 다이얼로그 (개선된 UI)
class OwnerRequestStatusDialog extends StatelessWidget {
  final Map<String, dynamic> status;

  const OwnerRequestStatusDialog({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusValue = status['status'] as String? ?? 'pending';
    final createdAt = status['createdAt'];
    final businessName = status['businessName'] as String?;
    final businessLicenseUrl = status['businessLicenseUrl'] as String?;
    final rejectReason = status['rejectReason'] as String?;

    String dateStr = '';
    if (createdAt != null) {
      try {
        final date = (createdAt as dynamic).toDate() as DateTime;
        dateStr = '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
      } catch (_) {}
    }

    // 상태별 색상 및 텍스트 정의
    Color stateColor;
    IconData stateIcon;
    String mainTitle;
    String subDescription;

    switch (statusValue) {
      case 'approved':
        stateColor = Colors.green;
        stateIcon = Icons.check_circle;
        mainTitle = '승인 완료';
        subDescription = '이제 사장님 전용 기능을 사용할 수 있습니다!';
        break;
      case 'rejected':
        stateColor = Colors.red;
        stateIcon = Icons.cancel;
        mainTitle = '승인 거절';
        subDescription = '아래 사유를 확인하고 다시 신청해주세요.';
        break;
      default: // pending
        stateColor = Colors.orange;
        stateIcon = Icons.hourglass_top;
        mainTitle = '심사 중';
        subDescription = '관리자가 서류를 검토하고 있어요.\n보통 1-2일 내에 결과를 알려드립니다.';
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. 상태 아이콘
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: stateColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(stateIcon, size: 40, color: stateColor),
            ),
            const SizedBox(height: 16),

            // 2. 메인 타이틀
            Text(
              mainTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subDescription,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 24),

            // 3. 상세 정보 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  if (dateStr.isNotEmpty)
                    _buildInfoRow('신청일', dateStr),
                  if (businessName != null && businessName.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow('상호명', businessName),
                  ],
                  if (businessLicenseUrl != null && businessLicenseUrl.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow('첨부파일', '업로드 완료 ✓'),
                  ],
                  if (statusValue == 'rejected' && rejectReason != null) ...[
                    const Divider(height: 24),
                    const Text(
                      '거절 사유',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rejectReason,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. 닫기 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: stateColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
