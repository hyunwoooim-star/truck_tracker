import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:truck_tracker/generated/l10n/app_localizations.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/password_validator.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../notifications/fcm_service.dart';
import '../../settings/presentation/privacy_policy_screen.dart';
import '../../settings/presentation/terms_of_service_screen.dart';
import '../../truck_map/presentation/map_first_screen.dart';
import 'auth_provider.dart';
import 'email_verification_screen.dart';

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
  bool _isOwnerSignup = false; // true: 사장님 가입, false: 고객 가입
  String? _businessLicenseImagePath; // 사업자등록증 이미지 경로

  @override
  void initState() {
    super.initState();
    AppLogger.debug('LoginScreen initialized', tag: 'LoginScreen');
    AppLogger.debug('_isLogin: $_isLogin', tag: 'LoginScreen');
    AppLogger.debug('_isLoading: $_isLoading', tag: 'LoginScreen');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    // Debug: Print to console for web debugging
    print('🔵 _handleEmailAuth called');
    print('🔵 isLogin: $_isLogin');
    print('🔵 email: ${_emailController.text.trim()}');
    print('🔵 password length: ${_passwordController.text.length}');

    AppLogger.debug('_handleEmailAuth called', tag: 'LoginScreen');
    AppLogger.debug('isLogin: $_isLogin', tag: 'LoginScreen');
    AppLogger.debug('email: ${_emailController.text.trim()}', tag: 'LoginScreen');
    AppLogger.debug('password length: ${_passwordController.text.length}', tag: 'LoginScreen');
    AppLogger.debug('_isLoading: $_isLoading', tag: 'LoginScreen');
    AppLogger.debug('_agreedToTerms: $_agreedToTerms', tag: 'LoginScreen');
    AppLogger.debug('_agreedToPrivacy: $_agreedToPrivacy', tag: 'LoginScreen');

    if (!_formKey.currentState!.validate()) {
      print('🔴 Form validation failed');
      AppLogger.warning('Form validation failed', tag: 'LoginScreen');
      return;
    }
    print('🟢 Form validation passed');

    // Validate legal agreements for sign-up
    if (!_isLogin && (!_agreedToTerms || !_agreedToPrivacy)) {
      AppLogger.warning('Legal agreements not accepted', tag: 'LoginScreen');
      final l10n = AppLocalizations.of(context);
      SnackBarHelper.showError(context, l10n.agreeToTermsRequired);
      return;
    }

    // Validate business license for owner signup
    if (!_isLogin && _isOwnerSignup && _businessLicenseImagePath == null) {
      AppLogger.warning('Business license not uploaded', tag: 'LoginScreen');
      SnackBarHelper.showError(context, '사업자등록증을 업로드해주세요');
      return;
    }

    setState(() => _isLoading = true);
    print('🔵 Loading started');

    try {
      final authService = ref.read(authServiceProvider);
      print('🔵 Got authService');

      if (_isLogin) {
        print('🔵 Attempting email sign in...');
        AppLogger.debug('Attempting email sign in...', tag: 'LoginScreen');
        // Sign in
        await authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        print('🟢 Email sign in successful!');
        AppLogger.success('Email sign in successful', tag: 'LoginScreen');
      } else {
        AppLogger.debug('Attempting email sign up...', tag: 'LoginScreen');
        // Sign up
        final userCredential = await authService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        AppLogger.success('Email sign up successful', tag: 'LoginScreen');

        // If owner signup, submit verification request
        if (_isOwnerSignup && _businessLicenseImagePath != null && userCredential.user != null) {
          AppLogger.debug('Submitting owner verification request...', tag: 'LoginScreen');
          await authService.submitOwnerRequest(
            userCredential.user!.uid,
            _businessLicenseImagePath!,
          );
          AppLogger.success('Owner verification request submitted', tag: 'LoginScreen');
        }

        // Save FCM token for push notifications
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          AppLogger.debug('Saving FCM token for user: ${user.uid}', tag: 'LoginScreen');
          await FcmService().saveFcmTokenToUser(user.uid);
          AppLogger.success('FCM token saved', tag: 'LoginScreen');
        }

        // Show email verification screen for new signups
        if (mounted) {
          final message = _isOwnerSignup
              ? '회원가입이 완료되었습니다!\n이메일 인증 후 사장님 승인 절차가 진행됩니다.'
              : '회원가입이 완료되었습니다!\n이메일을 인증해주세요.';
          SnackBarHelper.showSuccess(context, message);

          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EmailVerificationScreen(
                isOwnerSignup: _isOwnerSignup,
              ),
            ),
          );
        }

        AppLogger.success('Sign up flow completed', tag: 'LoginScreen');
        return; // Return early for signup - don't fall through to login handling
      }

      // Save FCM token for push notifications (for login)
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AppLogger.debug('Saving FCM token for user: ${user.uid}', tag: 'LoginScreen');
        await FcmService().saveFcmTokenToUser(user.uid);
        AppLogger.success('FCM token saved', tag: 'LoginScreen');
      }

      AppLogger.success('Auth completed - refreshing auth state', tag: 'LoginScreen');
      // Force refresh auth state - AuthWrapper will automatically rebuild
      if (mounted) {
        // Invalidate all auth-related providers to trigger rebuild
        ref.invalidate(authStateChangesProvider);
        ref.invalidate(currentUserProvider);
        ref.invalidate(currentUserIdProvider);
        ref.invalidate(currentUserTruckIdProvider);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Auth error', error: e, stackTrace: stackTrace, tag: 'LoginScreen');
      if (mounted) {
        SnackBarHelper.showError(context, _getErrorMessage(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleKakaoLogin() async {
    AppLogger.debug('Kakao login button pressed', tag: 'LoginScreen');
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithKakao();

      AppLogger.success('Kakao login successful', tag: 'LoginScreen');

      // Save FCM token for push notifications
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FcmService().saveFcmTokenToUser(user.uid);
      }

      // Navigate to root - AuthWrapper will handle routing
      if (mounted) {
        ref.invalidate(authStateChangesProvider);
        context.go('/');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Kakao login error', error: e, stackTrace: stackTrace, tag: 'LoginScreen');
      if (mounted) {
        SnackBarHelper.showError(context, _getErrorMessage(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleNaverLogin() async {
    AppLogger.debug('Naver login button pressed', tag: 'LoginScreen');
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithNaver();

      AppLogger.success('Naver login successful', tag: 'LoginScreen');

      // Save FCM token for push notifications
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FcmService().saveFcmTokenToUser(user.uid);
      }

      // Navigate to root - AuthWrapper will handle routing
      if (mounted) {
        ref.invalidate(authStateChangesProvider);
        context.go('/');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Naver login error', error: e, stackTrace: stackTrace, tag: 'LoginScreen');
      if (mounted) {
        SnackBarHelper.showError(context, _getErrorMessage(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  Future<void> _showForgotPasswordDialog() async {
    final resetEmailController = TextEditingController();

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '비밀번호 재설정',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '가입하신 이메일 주소를 입력하시면\n비밀번호 재설정 링크를 보내드립니다.',
              style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'example@email.com',
                hintStyle: const TextStyle(color: Color(0xFF808080)),
                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFB0B0B0)),
                filled: true,
                fillColor: const Color(0xFF121212),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1E1E1E)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1E1E1E)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.mustardYellow, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소', style: TextStyle(color: Color(0xFFB0B0B0))),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = resetEmailController.text.trim();
              if (email.isEmpty) {
                SnackBarHelper.showWarning(context, '이메일을 입력해주세요');
                return;
              }

              Navigator.pop(ctx);
              setState(() => _isLoading = true);

              try {
                final authService = ref.read(authServiceProvider);
                await authService.sendPasswordResetEmail(email);
                if (mounted) {
                  SnackBarHelper.showSuccess(context, '비밀번호 재설정 이메일을 발송했습니다');
                }
              } catch (e) {
                if (mounted) {
                  SnackBarHelper.showError(context, '이메일 발송에 실패했습니다: ${_getErrorMessage(e.toString())}');
                }
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.mustardYellow,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('전송'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickBusinessLicenseImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _businessLicenseImagePath = image.path;
        });
        AppLogger.debug('Business license image selected: ${image.path}', tag: 'LoginScreen');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to pick image', error: e, stackTrace: stackTrace, tag: 'LoginScreen');
      if (mounted) {
        SnackBarHelper.showError(context, '이미지 선택에 실패했습니다');
      }
    }
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
                  // Logo/Title - App Icon with glow effect
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.mustardYellow30,
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        'assets/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
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
                      // RFC 5322 compliant email regex (simplified)
                      final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
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
                      hintText: _isLogin ? '6자 이상 입력' : '8자 이상, 대소문자+숫자+특수문자',
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
                      return PasswordValidator.validate(
                        value ?? '',
                        isSignUp: !_isLogin,
                      );
                    },
                  ),

                  // Forgot Password (only show for login)
                  if (_isLogin) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          '비밀번호 찾기',
                          style: TextStyle(
                            color: AppTheme.mustardYellow,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                  ],

                  // Owner/Customer Selection (only show for sign-up)
                  if (!_isLogin) ...[
                    const Text(
                      '가입 유형',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isOwnerSignup = false;
                                _businessLicenseImagePath = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: !_isOwnerSignup
                                    ? AppTheme.mustardYellow.withValues(alpha: 0.2)
                                    : const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !_isOwnerSignup
                                      ? AppTheme.mustardYellow
                                      : const Color(0xFF1E1E1E),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: !_isOwnerSignup
                                        ? AppTheme.mustardYellow
                                        : const Color(0xFFB0B0B0),
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '일반 고객',
                                    style: TextStyle(
                                      color: !_isOwnerSignup
                                          ? Colors.white
                                          : const Color(0xFFB0B0B0),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isOwnerSignup = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: _isOwnerSignup
                                    ? AppTheme.electricBlue.withValues(alpha: 0.2)
                                    : const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _isOwnerSignup
                                      ? AppTheme.electricBlue
                                      : const Color(0xFF1E1E1E),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.store,
                                    color: _isOwnerSignup
                                        ? AppTheme.electricBlue
                                        : const Color(0xFFB0B0B0),
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '사장님',
                                    style: TextStyle(
                                      color: _isOwnerSignup
                                          ? Colors.white
                                          : const Color(0xFFB0B0B0),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Business License Upload (only for owner signup)
                    if (_isOwnerSignup) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _businessLicenseImagePath != null
                                ? Colors.green
                                : const Color(0xFF1E1E1E),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _businessLicenseImagePath != null
                                  ? Icons.check_circle
                                  : Icons.upload_file,
                              color: _businessLicenseImagePath != null
                                  ? Colors.green
                                  : const Color(0xFFB0B0B0),
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _businessLicenseImagePath != null
                                  ? '사업자등록증 업로드 완료'
                                  : '사업자등록증을 업로드해주세요',
                              style: TextStyle(
                                color: _businessLicenseImagePath != null
                                    ? Colors.green
                                    : const Color(0xFFB0B0B0),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _pickBusinessLicenseImage,
                              icon: const Icon(Icons.camera_alt),
                              label: Text(
                                _businessLicenseImagePath != null
                                    ? '다시 선택'
                                    : '사진 선택',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.electricBlue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '* 승인 후 사장님 기능을 사용할 수 있습니다',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],

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
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: '이용약관',
                                  style: const TextStyle(
                                    color: AppTheme.mustardYellow,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const TermsOfServiceScreen(),
                                        ),
                                      );
                                    },
                                ),
                                const TextSpan(text: '에 동의합니다 (필수)'),
                              ],
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
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: '개인정보 처리방침',
                                  style: const TextStyle(
                                    color: AppTheme.mustardYellow,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const PrivacyPolicyScreen(),
                                        ),
                                      );
                                    },
                                ),
                                const TextSpan(text: '에 동의합니다 (필수)'),
                              ],
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
                            AppLogger.debug('Toggling login/signup mode', tag: 'LoginScreen');
                            AppLogger.debug('Current _isLogin: $_isLogin', tag: 'LoginScreen');
                            AppLogger.debug('New _isLogin: ${!_isLogin}', tag: 'LoginScreen');
                            setState(() {
                              _isLogin = !_isLogin;
                              // Reset checkboxes and owner signup when switching
                              _agreedToTerms = false;
                              _agreedToPrivacy = false;
                              _isOwnerSignup = false;
                              _businessLicenseImagePath = null;
                            });
                            AppLogger.debug('Mode switched to ${_isLogin ? "로그인" : "회원가입"}', tag: 'LoginScreen');
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

                  // Kakao Sign In Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleKakaoLogin,
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
                            color: Colors.black87,
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
                    onPressed: _isLoading ? null : _handleNaverLogin,
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

                  // Skip to main screen (guest mode)
                  TextButton(
                    onPressed: () {
                      AppLogger.debug('Guest mode button pressed', tag: 'LoginScreen');
                      AppLogger.debug('Navigating to MapFirstScreen...', tag: 'LoginScreen');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const MapFirstScreen(),
                        ),
                      );
                      AppLogger.debug('Navigation to MapFirstScreen initiated', tag: 'LoginScreen');
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

