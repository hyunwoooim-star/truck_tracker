import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/themes/app_theme.dart';
import '../../notifications/fcm_service.dart';
import '../../truck_list/presentation/truck_list_screen.dart';
import '../../owner_dashboard/presentation/owner_dashboard_screen.dart';
import 'auth_provider.dart';

/// Login Screen with Email and Google Sign-In
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true; // true: login, false: sign up
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _agreedToPrivacy = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🎬 LoginScreen initialized');
    debugPrint('   _isLogin: $_isLogin');
    debugPrint('   _isLoading: $_isLoading');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🔐 LoginScreen: _handleEmailAuth called');
    debugPrint('   isLogin: $_isLogin');
    debugPrint('   email: ${_emailController.text.trim()}');
    debugPrint('   password length: ${_passwordController.text.length}');
    debugPrint('   _isLoading: $_isLoading');
    debugPrint('   _agreedToTerms: $_agreedToTerms');
    debugPrint('   _agreedToPrivacy: $_agreedToPrivacy');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ Form validation failed');
      return;
    }

    // Validate legal agreements for sign-up
    if (!_isLogin && (!_agreedToTerms || !_agreedToPrivacy)) {
      debugPrint('❌ Legal agreements not accepted');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이용약관 및 개인정보 처리방침에 동의해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);

      if (_isLogin) {
        debugPrint('📧 Attempting email sign in...');
        // Sign in
        await authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        debugPrint('✅ Email sign in successful');
      } else {
        debugPrint('📧 Attempting email sign up...');
        // Sign up
        await authService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        debugPrint('✅ Email sign up successful');
      }

      // Save FCM token for push notifications
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        debugPrint('🔔 Saving FCM token for user: ${user.uid}');
        await FcmService().saveFcmTokenToUser(user.uid);
        debugPrint('✅ FCM token saved');
      }

      debugPrint('✅ Auth completed - AuthWrapper will handle navigation');
      // Don't manually navigate - let AuthWrapper handle it
      // AuthWrapper will automatically detect the login state change
      // and navigate to the appropriate screen
    } catch (e) {
      debugPrint('❌ Auth error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();

      // Don't manually navigate - let AuthWrapper handle it
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleKakaoSignIn() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithKakao();
      // Don't manually navigate - let AuthWrapper handle it
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_getErrorMessage(e.toString())), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleNaverSignIn() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithNaver();
      // Don't manually navigate - let AuthWrapper handle it
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_getErrorMessage(e.toString())), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return '등록되지 않은 이메일입니다';
    } else if (error.contains('wrong-password')) {
      return '비밀번호가 올바르지 않습니다';
    } else if (error.contains('email-already-in-use')) {
      return '이미 사용 중인 이메일입니다';
    } else if (error.contains('weak-password')) {
      return '비밀번호는 최소 6자 이상이어야 합니다';
    } else if (error.contains('invalid-email')) {
      return '올바른 이메일 형식이 아닙니다';
    } else if (error.contains('cancelled')) {
      return '로그인이 취소되었습니다';
    }
    return '로그인 중 오류가 발생했습니다';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Title
                  Icon(
                    Icons.local_shipping,
                    size: 80,
                    color: AppTheme.baeminMint,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '트럭아저씨',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin ? '로그인' : '회원가입',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFB0B0B0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: '이메일',
                      labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                      hintText: 'example@email.com',
                      hintStyle: const TextStyle(color: Color(0xFF808080)),
                      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFB0B0B0)),
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1E1E1E)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.mustardYellow,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력해주세요';
                      }
                      if (!value.contains('@')) {
                        return '올바른 이메일 형식이 아닙니다';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                      hintText: '6자 이상 입력',
                      hintStyle: const TextStyle(color: Color(0xFF808080)),
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFB0B0B0)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFFB0B0B0),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1E1E1E)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.mustardYellow,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요';
                      }
                      if (value.length < 6) {
                        return '비밀번호는 최소 6자 이상이어야 합니다';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Legal Checkboxes (only show for sign-up)
                  if (!_isLogin) ...[
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreedToTerms = value ?? false;
                            });
                          },
                          activeColor: AppTheme.mustardYellow,
                          checkColor: Colors.black,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _agreedToTerms = !_agreedToTerms;
                              });
                            },
                            child: const Text(
                              '이용약관에 동의합니다 (필수)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToPrivacy,
                          onChanged: (value) {
                            setState(() {
                              _agreedToPrivacy = value ?? false;
                            });
                          },
                          activeColor: AppTheme.mustardYellow,
                          checkColor: Colors.black,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _agreedToPrivacy = !_agreedToPrivacy;
                              });
                            },
                            child: const Text(
                              '개인정보 처리방침에 동의합니다 (필수)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Email Login/Sign Up Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleEmailAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.mustardYellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                            ),
                          )
                        : Text(
                            _isLogin ? '로그인' : '회원가입',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Toggle Login/Sign Up
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            debugPrint('🔄 Toggling login/signup mode');
                            debugPrint('   Current _isLogin: $_isLogin');
                            debugPrint('   New _isLogin: ${!_isLogin}');
                            setState(() {
                              _isLogin = !_isLogin;
                              // Reset checkboxes when switching
                              _agreedToTerms = false;
                              _agreedToPrivacy = false;
                            });
                            debugPrint('✅ Mode switched to ${_isLogin ? "로그인" : "회원가입"}');
                          },
                    child: Text(
                      _isLogin
                          ? '계정이 없으신가요? 회원가입'
                          : '이미 계정이 있으신가요? 로그인',
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFF1E1E1E))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '소셜 로그인',
                          style: TextStyle(color: Color(0xFFB0B0B0)),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFF1E1E1E))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Info Text
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
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppTheme.mustardYellow,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kakao/Naver 로그인은 Cloud Functions 배포 후 사용 가능',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Kakao Sign In Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleKakaoSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE500),
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: const Color(0xFFFEE500).withValues(alpha: 0.5),
                      disabledForegroundColor: Colors.black.withValues(alpha: 0.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble,
                            size: 12,
                            color: Color(0xFFFEE500),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '카카오로 계속하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Naver Sign In Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleNaverSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03C75A),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF03C75A).withValues(alpha: 0.5),
                      disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'N',
                              style: TextStyle(
                                color: Color(0xFF03C75A),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '네이버로 계속하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFF1E1E1E))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '또는',
                          style: TextStyle(color: Color(0xFFB0B0B0)),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFF1E1E1E))),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Owner Login Button (테스트용 - 직접 사장님 대시보드로 이동)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.electricBlue.withValues(alpha: 0.5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
                              debugPrint('🚚 Owner test login button pressed');
                              debugPrint('   _isLoading: $_isLoading');
                              debugPrint('   Navigating to OwnerDashboardScreen...');
                              debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
                              // 테스트용: 이메일로 로그인 후 Firestore에서 ownedTruckId가 있으면 사장님 대시보드로 이동
                              // 실제로는 위의 이메일 로그인을 사용하고 Firestore에 ownedTruckId를 설정해야 함
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const OwnerDashboardScreen(),
                                ),
                              );
                              debugPrint('✅ Navigation initiated');
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppTheme.electricBlue,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.store, color: AppTheme.electricBlue),
                          const SizedBox(width: 12),
                          Text(
                            '사장님으로 시작하기 (테스트)',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.electricBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Skip to main screen (guest mode)
                  TextButton(
                    onPressed: () {
                      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
                      debugPrint('👤 Guest mode button pressed');
                      debugPrint('   Navigating to TruckListScreen...');
                      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const TruckListScreen(),
                        ),
                      );
                      debugPrint('✅ Navigation to TruckListScreen initiated');
                    },
                    child: const Text(
                      '둘러보기',
                      style: TextStyle(
                        color: Color(0xFF808080),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

