import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/app_theme.dart';
import '../../truck_map/presentation/map_first_screen.dart';
import 'auth_provider.dart';

/// OAuth callback screen for web
/// Handles redirect from Kakao/Naver OAuth
class OAuthCallbackScreen extends ConsumerStatefulWidget {
  final String provider; // 'kakao' or 'naver'
  final String code;
  final String? state;

  const OAuthCallbackScreen({
    super.key,
    required this.provider,
    required this.code,
    this.state,
  });

  @override
  ConsumerState<OAuthCallbackScreen> createState() => _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends ConsumerState<OAuthCallbackScreen> {
  bool _isProcessing = true;
  String? _error;
  static final Set<String> _processedCodes = {};

  @override
  void initState() {
    super.initState();
    _processCallback();
  }

  Future<void> _processCallback() async {
    // 중복 처리 방지 (동일한 코드가 이미 처리되었으면 스킵)
    if (_processedCodes.contains(widget.code)) {
      setState(() {
        _isProcessing = false;
        _error = '이미 처리된 로그인 요청입니다. 다시 시도해주세요.';
      });
      return;
    }
    _processedCodes.add(widget.code);

    // 오래된 코드들 정리 (10개 이상이면 전체 삭제)
    if (_processedCodes.length > 10) {
      _processedCodes.clear();
      _processedCodes.add(widget.code);
    }

    try {
      final authService = ref.read(authServiceProvider);

      if (widget.provider == 'kakao') {
        await authService.processKakaoCallback(widget.code);
      } else if (widget.provider == 'naver') {
        await authService.processNaverCallback(widget.code, widget.state ?? '');
      } else {
        throw Exception('알 수 없는 로그인 제공자: ${widget.provider}');
      }

      // Refresh auth state
      ref.invalidate(authStateChangesProvider);
      ref.invalidate(currentUserProvider);

      if (mounted) {
        // Navigate to main screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MapFirstScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.charcoalDark,
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppTheme.mustardYellow,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${widget.provider == 'kakao' ? '카카오' : '네이버'} 로그인 처리 중...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '로그인 실패',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _error ?? '알 수 없는 오류가 발생했습니다',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.mustardYellow,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('돌아가기'),
                  ),
                ],
              ),
      ),
    );
  }
}
