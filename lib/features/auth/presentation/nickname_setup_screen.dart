import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import 'auth_provider.dart';

/// 닉네임 설정 화면
/// 소셜 로그인 후 닉네임을 설정하는 온보딩 화면
class NicknameSetupScreen extends ConsumerStatefulWidget {
  const NicknameSetupScreen({super.key});

  @override
  ConsumerState<NicknameSetupScreen> createState() =>
      _NicknameSetupScreenState();
}

class _NicknameSetupScreenState extends ConsumerState<NicknameSetupScreen> {
  final _nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isCheckingAvailability = false;
  bool? _isNicknameAvailable;
  String? _validationError;

  // 역할 선택 (customer = 손님, owner = 사장님)
  String _selectedRole = 'customer';

  // 닉네임 유효성 검사 정규식
  static final RegExp _nicknameRegex = RegExp(r'^[가-힣a-zA-Z0-9]{2,10}$');

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  /// 닉네임 유효성 검사
  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요';
    }
    if (value.length < 2) {
      return '닉네임은 2자 이상이어야 합니다';
    }
    if (value.length > 10) {
      return '닉네임은 10자 이하여야 합니다';
    }
    if (!_nicknameRegex.hasMatch(value)) {
      return '한글, 영문, 숫자만 사용 가능합니다';
    }
    return null;
  }

  /// 닉네임 중복 확인
  Future<void> _checkAvailability() async {
    final nickname = _nicknameController.text.trim();
    final error = _validateNickname(nickname);

    if (error != null) {
      setState(() {
        _validationError = error;
        _isNicknameAvailable = null;
      });
      return;
    }

    setState(() {
      _isCheckingAvailability = true;
      _validationError = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final isAvailable = await authService.isNicknameAvailable(nickname);

      if (mounted) {
        setState(() {
          _isNicknameAvailable = isAvailable;
          _isCheckingAvailability = false;
          if (!isAvailable) {
            _validationError = '이미 사용 중인 닉네임입니다';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingAvailability = false;
          _validationError = '중복 확인 중 오류가 발생했습니다';
        });
      }
    }
  }

  /// 닉네임 저장
  Future<void> _saveNickname() async {
    final nickname = _nicknameController.text.trim();
    final error = _validateNickname(nickname);

    if (error != null) {
      SnackBarHelper.showWarning(context, error);
      return;
    }

    // 중복 확인 안 했으면 먼저 확인
    if (_isNicknameAvailable == null) {
      await _checkAvailability();
      if (_isNicknameAvailable != true) return;
    }

    if (_isNicknameAvailable != true) {
      SnackBarHelper.showWarning(context, '사용할 수 없는 닉네임입니다');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final uid = authService.currentUserId;

      if (uid == null) {
        throw Exception('로그인이 필요합니다');
      }

      await authService.updateNicknameAndRole(uid, nickname, _selectedRole);

      if (mounted) {
        final roleText = _selectedRole == 'owner' ? '사장' : '';
        SnackBarHelper.showSuccess(context, '$nickname$roleText님, 환영합니다!');
        // Invalidate auth state to trigger redirect
        ref.invalidate(authStateChangesProvider);
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        if (e.toString().contains('already taken')) {
          SnackBarHelper.showError(context, '이미 사용 중인 닉네임입니다');
          setState(() {
            _isNicknameAvailable = false;
            _validationError = '이미 사용 중인 닉네임입니다';
          });
        } else {
          SnackBarHelper.showError(context, '닉네임 저장에 실패했습니다');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightCharcoal,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 아이콘
                    const Icon(
                      Icons.person_outline,
                      size: 80,
                      color: AppTheme.baeminMint,
                    ),
                    const SizedBox(height: 24),

                    // 제목
                    Text(
                      '닉네임을 설정해주세요',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // 설명
                    Text(
                      '트럭아저씨에서 사용할 닉네임을 입력해주세요\n한글, 영문, 숫자 2-10자',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // 역할 선택
                    Text(
                      '가입 유형을 선택해주세요',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment<String>(
                          value: 'customer',
                          label: Text('손님'),
                          icon: Icon(Icons.person),
                        ),
                        ButtonSegment<String>(
                          value: 'owner',
                          label: Text('사장님'),
                          icon: Icon(Icons.store),
                        ),
                      ],
                      selected: {_selectedRole},
                      onSelectionChanged: (Set<String> selected) {
                        setState(() {
                          _selectedRole = selected.first;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppTheme.baeminMint;
                          }
                          return AppTheme.charcoalMedium;
                        }),
                      ),
                    ),
                    if (_selectedRole == 'owner') ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.mustardYellow.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.mustardYellow.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: AppTheme.mustardYellow,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '사장님 가입 후 설정에서 사업자등록증을 제출하면\n트럭 관리 기능을 사용할 수 있습니다.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.mustardYellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // 닉네임 입력 필드
                    TextFormField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        labelText: '닉네임',
                        hintText: '예: 맛집탐방러',
                        prefixIcon: const Icon(Icons.badge_outlined),
                        suffixIcon: _buildSuffixIcon(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _validationError,
                      ),
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[가-힣a-zA-Z0-9]'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _isNicknameAvailable = null;
                          _validationError = null;
                        });
                      },
                      onFieldSubmitted: (_) => _checkAvailability(),
                    ),
                    const SizedBox(height: 16),

                    // 중복 확인 버튼
                    OutlinedButton.icon(
                      onPressed:
                          _isCheckingAvailability ? null : _checkAvailability,
                      icon: _isCheckingAvailability
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(
                        _isCheckingAvailability ? '확인 중...' : '중복 확인',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 시작하기 버튼
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveNickname,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.baeminMint,
                        foregroundColor: Colors.white,
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
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              '시작하기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // 안내 문구
                    Text(
                      '닉네임은 리뷰 작성 등에 표시됩니다',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 입력 필드 오른쪽 아이콘
  Widget? _buildSuffixIcon() {
    if (_isCheckingAvailability) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_isNicknameAvailable == true) {
      return const Icon(Icons.check_circle, color: Colors.green);
    }

    if (_isNicknameAvailable == false) {
      return const Icon(Icons.cancel, color: Colors.red);
    }

    return null;
  }
}
