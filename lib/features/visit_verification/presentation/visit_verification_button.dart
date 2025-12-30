import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../truck_list/domain/truck.dart';
import '../data/visit_verification_repository.dart';
import 'visit_verification_service.dart';

/// 방문 인증 버튼 위젯
/// 트럭 상세 화면에서 사용
class VisitVerificationButton extends ConsumerStatefulWidget {
  final Truck truck;

  const VisitVerificationButton({
    super.key,
    required this.truck,
  });

  @override
  ConsumerState<VisitVerificationButton> createState() => _VisitVerificationButtonState();
}

class _VisitVerificationButtonState extends ConsumerState<VisitVerificationButton> {
  bool _isLoading = false;
  bool _isCheckingDistance = true;
  double? _distance;
  bool _hasVisitedToday = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isCheckingDistance = false);
      return;
    }

    // 오늘 방문 여부 확인
    final repository = ref.read(visitVerificationRepositoryProvider);
    final hasVisited = await repository.hasVisitedToday(user.uid, widget.truck.id);

    // 거리 확인
    final service = ref.read(visitVerificationServiceProvider);
    final distance = await service.getDistanceToTruck(widget.truck);

    if (mounted) {
      setState(() {
        _hasVisitedToday = hasVisited;
        _distance = distance;
        _isCheckingDistance = false;
      });
    }
  }

  Future<void> _verifyVisit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      SnackBarHelper.showError(context, '로그인이 필요합니다');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(visitVerificationServiceProvider);
      final result = await service.verifyVisit(
        visitorId: user.uid,
        visitorName: user.displayName ?? user.email ?? '방문자',
        visitorPhotoUrl: user.photoURL,
        truck: widget.truck,
      );

      if (!mounted) return;

      switch (result) {
        case VerificationSuccess(:final userVisitCount):
          setState(() => _hasVisitedToday = true);
          _showSuccessDialog(userVisitCount);
        case VerificationFailure(:final error):
          SnackBarHelper.showError(context, error.message);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog(int visitCount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.midnightCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.mustardYellow.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppTheme.mustardYellow,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '방문 인증 완료!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${widget.truck.foodType}에 $visitCount번째 방문이에요',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
            if (visitCount >= 5) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      visitCount >= 10 ? '단골 VIP!' : '단골이 되어가고 있어요!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // 로그인하지 않은 경우
    if (user == null) {
      return _buildButton(
        onPressed: () => SnackBarHelper.showInfo(context, '로그인 후 방문 인증을 할 수 있어요'),
        icon: Icons.location_off,
        label: '방문 인증',
        subtitle: '로그인 필요',
        enabled: false,
      );
    }

    // 로딩 중
    if (_isCheckingDistance) {
      return _buildButton(
        onPressed: null,
        icon: Icons.hourglass_empty,
        label: '확인 중...',
        subtitle: null,
        enabled: false,
        isLoading: true,
      );
    }

    // 이미 오늘 인증함
    if (_hasVisitedToday) {
      return _buildButton(
        onPressed: null,
        icon: Icons.check_circle,
        label: '인증 완료',
        subtitle: '오늘 방문 인증함',
        enabled: false,
        isCompleted: true,
      );
    }

    // 트럭이 영업 중이 아님
    if (!widget.truck.isOpen) {
      return _buildButton(
        onPressed: null,
        icon: Icons.store,
        label: '방문 인증',
        subtitle: '영업 중일 때만 가능',
        enabled: false,
      );
    }

    // 거리 정보가 없음
    if (_distance == null) {
      return _buildButton(
        onPressed: () async {
          setState(() => _isCheckingDistance = true);
          await _checkStatus();
        },
        icon: Icons.refresh,
        label: '위치 확인',
        subtitle: '탭하여 재시도',
        enabled: true,
      );
    }

    // 너무 멀리 있음
    if (_distance! > VisitVerificationRepository.verificationRadiusMeters) {
      return _buildButton(
        onPressed: () async {
          setState(() => _isCheckingDistance = true);
          await _checkStatus();
        },
        icon: Icons.location_searching,
        label: '방문 인증',
        subtitle: '${_distance!.toStringAsFixed(0)}m (50m 이내 필요)',
        enabled: false,
        showRefresh: true,
      );
    }

    // 인증 가능!
    return _buildButton(
      onPressed: _isLoading ? null : _verifyVisit,
      icon: Icons.verified_user,
      label: '방문 인증하기',
      subtitle: '${_distance!.toStringAsFixed(0)}m 거리',
      enabled: true,
      isReady: true,
      isLoading: _isLoading,
    );
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required String? subtitle,
    required bool enabled,
    bool isLoading = false,
    bool isCompleted = false,
    bool isReady = false,
    bool showRefresh = false,
  }) {
    Color backgroundColor;
    Color foregroundColor;
    Color iconColor;

    if (isCompleted) {
      backgroundColor = Colors.green.withValues(alpha: 0.2);
      foregroundColor = Colors.green;
      iconColor = Colors.green;
    } else if (isReady) {
      backgroundColor = AppTheme.mustardYellow;
      foregroundColor = Colors.black;
      iconColor = Colors.black;
    } else if (enabled) {
      backgroundColor = Colors.grey[800]!;
      foregroundColor = Colors.white;
      iconColor = Colors.white70;
    } else {
      backgroundColor = Colors.grey[900]!;
      foregroundColor = Colors.grey[600]!;
      iconColor = Colors.grey[700]!;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(foregroundColor),
                          ),
                        )
                      : Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: foregroundColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: foregroundColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showRefresh)
                  Icon(
                    Icons.refresh,
                    color: foregroundColor.withValues(alpha: 0.5),
                    size: 20,
                  ),
                if (isReady && !isLoading)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: foregroundColor.withValues(alpha: 0.7),
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
