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
      final userId = authService.currentUser?.uid;

      if (userId == null) {
        throw Exception('로그인이 필요합니다');
      }

      // 이미지와 함께 신청
      await authService.submitOwnerRequestWithImage(userId, _selectedImageBytes);

      // 추가 정보 업데이트 (상호명, 설명)
      await authService.submitOwnerRequest(
        businessName: _businessNameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
      );

      ref.invalidate(ownerRequestStatusProvider);

      if (mounted) {
        Navigator.pop(context);
        SnackBarHelper.showSuccess(context, '사장님 인증 신청이 완료되었습니다!');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '신청 실패: $e');
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

/// 사장님 신청 상태 다이얼로그
class OwnerRequestStatusDialog extends StatelessWidget {
  final Map<String, dynamic> status;

  const OwnerRequestStatusDialog({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusValue = status['status'] as String?;
    final createdAt = status['createdAt'];
    final businessName = status['businessName'] as String?;
    final businessLicenseUrl = status['businessLicenseUrl'] as String?;

    String dateStr = '';
    if (createdAt != null) {
      try {
        final date = (createdAt as dynamic).toDate() as DateTime;
        dateStr = '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
      } catch (_) {}
    }

    IconData icon;
    Color iconColor;
    String title;
    String message;

    switch (statusValue) {
      case 'pending':
        icon = Icons.hourglass_top;
        iconColor = Colors.orange;
        title = '검토 중';
        message = '현재 관리자가 신청서를 검토하고 있습니다.\n보통 1-2일 내에 승인 결과를 알려드립니다.';
        break;
      case 'approved':
        icon = Icons.check_circle;
        iconColor = Colors.green;
        title = '승인 완료';
        message = '사장님 인증이 완료되었습니다!\n이제 트럭을 등록하고 관리할 수 있습니다.';
        break;
      case 'rejected':
        icon = Icons.cancel;
        iconColor = Colors.red;
        title = '거절됨';
        message = status['rejectReason'] as String? ?? '신청이 거절되었습니다. 다시 신청해주세요.';
        break;
      default:
        icon = Icons.info;
        iconColor = Colors.grey;
        title = '상태 확인';
        message = '신청 상태를 확인할 수 없습니다.';
    }

    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: const TextStyle(fontSize: 14)),
          if (dateStr.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '신청일: $dateStr',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ],
          if (businessName != null && businessName.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.store, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '상호명: $businessName',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
          if (businessLicenseUrl != null && businessLicenseUrl.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_file, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                const Text(
                  '첨부파일: 업로드됨',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const Icon(Icons.check, size: 16, color: Colors.green),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('확인'),
        ),
      ],
    );
  }
}
