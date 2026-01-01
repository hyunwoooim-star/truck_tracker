import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../shared/widgets/skeleton_loading.dart';
import '../../coupon/domain/coupon.dart';
import '../../coupon/presentation/coupon_provider.dart';
// Use providers from coupon_provider.dart (avoid duplicate from coupon_repository.dart)
import 'owner_status_provider.dart';

/// 사장님용 쿠폰 관리 화면
class CouponManagementScreen extends ConsumerWidget {
  const CouponManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownerTruckAsync = ref.watch(ownerTruckProvider);

    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      appBar: AppBar(
        title: const Text('쿠폰 관리'),
        backgroundColor: AppTheme.midnightCharcoal,
        foregroundColor: AppTheme.mustardYellow,
        elevation: 0,
      ),
      body: ownerTruckAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 3,
          itemBuilder: (_, index) => const SkeletonCouponCard(),
        ),
        error: (e, _) => Center(
          child: Text('오류: $e', style: const TextStyle(color: Colors.white70)),
        ),
        data: (truck) {
          if (truck == null) {
            return const Center(
              child: Text(
                '트럭 정보를 찾을 수 없습니다',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return _CouponListView(truckId: truck.id);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final truck = ref.read(ownerTruckProvider).value;
          if (truck != null) {
            _showCouponDialog(context, ref, truck.id, null);
          } else {
            SnackBarHelper.showError(context, '트럭 정보를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
          }
        },
        backgroundColor: AppTheme.mustardYellow,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('쿠폰 추가'),
      ),
    );
  }

  void _showCouponDialog(
    BuildContext context,
    WidgetRef ref,
    String truckId,
    Coupon? existingCoupon,
  ) {
    showDialog(
      context: context,
      builder: (context) => _CouponFormDialog(
        truckId: truckId,
        existingCoupon: existingCoupon,
      ),
    );
  }
}

class _CouponListView extends ConsumerWidget {
  const _CouponListView({required this.truckId});

  final String truckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(truckCouponsProvider(truckId));

    return couponsAsync.when(
      loading: () => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (_, index) => const SkeletonCouponCard(),
      ),
      error: (e, _) => Center(
        child: Text('오류: $e', style: const TextStyle(color: Colors.white70)),
      ),
      data: (coupons) {
        if (coupons.isEmpty) {
          return _buildEmptyState();
        }

        // 유효한 쿠폰과 만료된 쿠폰 분리
        final validCoupons = coupons.where((c) => c.isValid).toList();
        final expiredCoupons = coupons.where((c) => !c.isValid).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 통계
            _buildStats(coupons),
            const SizedBox(height: 24),

            // 유효한 쿠폰
            if (validCoupons.isNotEmpty) ...[
              _buildSectionHeader('유효한 쿠폰', validCoupons.length),
              const SizedBox(height: 12),
              ...validCoupons.map((c) => _CouponManageCard(
                    coupon: c,
                    truckId: truckId,
                  )),
            ],

            // 만료된 쿠폰
            if (expiredCoupons.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('만료/사용 완료', expiredCoupons.length),
              const SizedBox(height: 12),
              ...expiredCoupons.map((c) => _CouponManageCard(
                    coupon: c,
                    truckId: truckId,
                    isExpired: true,
                  )),
            ],

            const SizedBox(height: 80), // FAB 공간
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            '등록된 쿠폰이 없습니다',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '+ 버튼을 눌러 첫 쿠폰을 만들어보세요',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(List<Coupon> coupons) {
    final valid = coupons.where((c) => c.isValid).length;
    final totalUsed = coupons.fold<int>(0, (sum, c) => sum + c.currentUses);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.mustardYellow10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mustardYellow30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('전체', coupons.length, Icons.local_offer),
          _buildStatItem('유효', valid, Icons.check_circle, Colors.green),
          _buildStatItem('사용됨', totalUsed, Icons.people, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon, [Color? color]) {
    return Column(
      children: [
        Icon(icon, color: color ?? AppTheme.mustardYellow, size: 24),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            color: color ?? AppTheme.mustardYellow,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.mustardYellow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _CouponManageCard extends ConsumerWidget {
  const _CouponManageCard({
    required this.coupon,
    required this.truckId,
    this.isExpired = false,
  });

  final Coupon coupon;
  final String truckId;
  final bool isExpired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('yy.MM.dd');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isExpired ? Colors.grey[900] : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpired ? Colors.grey[800]! : AppTheme.mustardYellow30,
        ),
      ),
      child: Column(
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 할인 배지
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isExpired ? Colors.grey[700] : AppTheme.mustardYellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    coupon.discountText,
                    style: TextStyle(
                      color: isExpired ? Colors.grey[400] : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 쿠폰 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon.code,
                        style: TextStyle(
                          color: isExpired ? Colors.grey[500] : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      if (coupon.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          coupon.description!,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // 상태 배지
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    coupon.validityText,
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 하단 정보
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(30),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // 기간
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${dateFormat.format(coupon.validFrom)} ~ ${dateFormat.format(coupon.validUntil)}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(width: 16),
                // 사용량
                Icon(Icons.people, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${coupon.currentUses}/${coupon.maxUses}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const Spacer(),
                // 액션 버튼들
                if (!isExpired) ...[
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    color: Colors.grey[400],
                    onPressed: () => _showEditDialog(context),
                    tooltip: '수정',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: Icon(
                      coupon.isActive ? Icons.pause : Icons.play_arrow,
                      size: 20,
                    ),
                    color: Colors.grey[400],
                    onPressed: () => _toggleActive(context, ref),
                    tooltip: coupon.isActive ? '비활성화' : '활성화',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red[400],
                  onPressed: () => _showDeleteDialog(context, ref),
                  tooltip: '삭제',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (coupon.validityText) {
      case 'Valid':
        return Colors.green;
      case 'Expired':
        return Colors.red;
      case 'Sold out':
        return Colors.orange;
      case 'Inactive':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _CouponFormDialog(
        truckId: truckId,
        existingCoupon: coupon,
      ),
    );
  }

  Future<void> _toggleActive(BuildContext context, WidgetRef ref) async {
    try {
      final repo = ref.read(couponRepositoryProvider);
      final updated = coupon.copyWith(isActive: !coupon.isActive);
      await repo.updateCoupon(coupon.id, updated);
      if (context.mounted) {
        SnackBarHelper.showSuccess(
          context,
          coupon.isActive ? '쿠폰이 비활성화되었습니다' : '쿠폰이 활성화되었습니다',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showError(context, '오류가 발생했습니다');
      }
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('쿠폰 삭제', style: TextStyle(color: Colors.white)),
        content: Text(
          '${coupon.code} 쿠폰을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.',
          style: TextStyle(color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소', style: TextStyle(color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final repo = ref.read(couponRepositoryProvider);
                await repo.deleteCoupon(coupon.id);
                if (context.mounted) {
                  SnackBarHelper.showSuccess(context, '쿠폰이 삭제되었습니다');
                }
              } catch (e) {
                if (context.mounted) {
                  SnackBarHelper.showError(context, '삭제 중 오류가 발생했습니다');
                }
              }
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _CouponFormDialog extends ConsumerStatefulWidget {
  const _CouponFormDialog({
    required this.truckId,
    this.existingCoupon,
  });

  final String truckId;
  final Coupon? existingCoupon;

  @override
  ConsumerState<_CouponFormDialog> createState() => _CouponFormDialogState();
}

class _CouponFormDialogState extends ConsumerState<_CouponFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _discountValueController;
  late final TextEditingController _maxUsesController;
  late final TextEditingController _freeItemController;

  CouponType _selectedType = CouponType.percentage;
  DateTime _validFrom = DateTime.now();
  DateTime _validUntil = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  bool get isEditing => widget.existingCoupon != null;

  @override
  void initState() {
    super.initState();
    final coupon = widget.existingCoupon;
    _codeController = TextEditingController(text: coupon?.code ?? _generateCode());
    _descriptionController = TextEditingController(text: coupon?.description ?? '');
    _discountValueController = TextEditingController(
      text: coupon?.type == CouponType.percentage
          ? coupon?.discountPercent?.toString() ?? '10'
          : coupon?.discountAmount?.toString() ?? '1000',
    );
    _maxUsesController = TextEditingController(text: coupon?.maxUses.toString() ?? '100');
    _freeItemController = TextEditingController(text: coupon?.freeItemName ?? '');

    if (coupon != null) {
      _selectedType = coupon.type;
      _validFrom = coupon.validFrom;
      _validUntil = coupon.validUntil;
    }
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(6, (i) => chars[(random + i * 7) % chars.length]).join();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _maxUsesController.dispose();
    _freeItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.mustardYellow10,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer, color: AppTheme.mustardYellow),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? '쿠폰 수정' : '새 쿠폰 만들기',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // 폼
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 쿠폰 코드
                      _buildLabel('쿠폰 코드'),
                      TextFormField(
                        controller: _codeController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          letterSpacing: 2,
                        ),
                        decoration: _inputDecoration('예: WELCOME10'),
                        textCapitalization: TextCapitalization.characters,
                        validator: (v) => v == null || v.isEmpty ? '코드를 입력하세요' : null,
                      ),
                      const SizedBox(height: 16),

                      // 쿠폰 타입
                      _buildLabel('할인 유형'),
                      _buildTypeSelector(),
                      const SizedBox(height: 16),

                      // 할인 값
                      _buildLabel(_selectedType == CouponType.freeItem ? '무료 아이템' : '할인 값'),
                      if (_selectedType == CouponType.freeItem)
                        TextFormField(
                          controller: _freeItemController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('예: 음료 1잔'),
                          validator: (v) => v == null || v.isEmpty ? '아이템을 입력하세요' : null,
                        )
                      else
                        TextFormField(
                          controller: _discountValueController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(
                            _selectedType == CouponType.percentage ? '예: 10 (%)' : '예: 1000 (원)',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return '값을 입력하세요';
                            final value = int.tryParse(v);
                            if (value == null || value <= 0) return '올바른 값을 입력하세요';
                            if (_selectedType == CouponType.percentage && value > 100) {
                              return '100% 이하로 입력하세요';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 16),

                      // 설명
                      _buildLabel('설명 (선택)'),
                      TextFormField(
                        controller: _descriptionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('예: 신규 고객 환영 쿠폰'),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // 기간
                      _buildLabel('유효 기간'),
                      Row(
                        children: [
                          Expanded(child: _buildDatePicker('시작', _validFrom, (d) {
                            setState(() => _validFrom = d);
                          })),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDatePicker('종료', _validUntil, (d) {
                            setState(() => _validUntil = d);
                          })),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 최대 사용 횟수
                      _buildLabel('최대 사용 횟수'),
                      TextFormField(
                        controller: _maxUsesController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('예: 100'),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return '값을 입력하세요';
                          final value = int.tryParse(v);
                          if (value == null || value <= 0) return '1 이상의 값을 입력하세요';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 저장 버튼
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.mustardYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          isEditing ? '저장' : '쿠폰 만들기',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[800]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.mustardYellow),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: CouponType.values.map((type) {
        final isSelected = _selectedType == type;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedType = type),
            child: Container(
              margin: EdgeInsets.only(right: type != CouponType.freeItem ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.mustardYellow : Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppTheme.mustardYellow : Colors.grey[800]!,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _getTypeIcon(type),
                    size: 20,
                    color: isSelected ? Colors.black : Colors.grey[500],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTypeLabel(type),
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getTypeIcon(CouponType type) {
    switch (type) {
      case CouponType.percentage:
        return Icons.percent;
      case CouponType.fixed:
        return Icons.attach_money;
      case CouponType.freeItem:
        return Icons.card_giftcard;
    }
  }

  String _getTypeLabel(CouponType type) {
    switch (type) {
      case CouponType.percentage:
        return '% 할인';
      case CouponType.fixed:
        return '금액 할인';
      case CouponType.freeItem:
        return '무료 증정';
    }
  }

  Widget _buildDatePicker(String label, DateTime date, ValueChanged<DateTime> onChanged) {
    final dateFormat = DateFormat('yyyy.MM.dd');
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now().subtract(const Duration(days: 1)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppTheme.mustardYellow,
                  surface: Color(0xFF1E1E1E),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                Text(
                  dateFormat.format(date),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCoupon() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(couponRepositoryProvider);

      final coupon = Coupon(
        id: widget.existingCoupon?.id ?? '',
        truckId: widget.truckId,
        code: _codeController.text.toUpperCase().trim(),
        type: _selectedType,
        discountPercent: _selectedType == CouponType.percentage
            ? int.parse(_discountValueController.text)
            : null,
        discountAmount: _selectedType == CouponType.fixed
            ? int.parse(_discountValueController.text)
            : null,
        freeItemName: _selectedType == CouponType.freeItem
            ? _freeItemController.text.trim()
            : null,
        validFrom: _validFrom,
        validUntil: _validUntil,
        maxUses: int.parse(_maxUsesController.text),
        currentUses: widget.existingCoupon?.currentUses ?? 0,
        usedBy: widget.existingCoupon?.usedBy ?? [],
        isActive: true,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
      );

      if (isEditing) {
        await repo.updateCoupon(widget.existingCoupon!.id, coupon);
      } else {
        await repo.createCoupon(coupon);
      }

      if (mounted) {
        Navigator.pop(context);
        SnackBarHelper.showSuccess(
          context,
          isEditing ? '쿠폰이 수정되었습니다' : '쿠폰이 생성되었습니다',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '오류: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
