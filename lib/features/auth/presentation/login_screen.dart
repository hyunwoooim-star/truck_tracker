import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'package:truck_tracker/generated/l10n/app_localizations.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/password_validator.dart';
import '../../../core/utils/snackbar_helper.dart';
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
    AppLogger.debug('_handleEmailAuth called', tag: 'LoginScreen');
    AppLogger.debug('isLogin: $_isLogin', tag: 'LoginScreen');
    AppLogger.debug('email: ${_emailController.text.trim()}', tag: 'LoginScreen');
    AppLogger.debug('password length: ${_passwordController.text.length}', tag: 'LoginScreen');
    AppLogger.debug('_isLoading: $_isLoading', tag: 'LoginScreen');
    AppLogger.debug('_agreedToTerms: $_agreedToTerms', tag: 'LoginScreen');
    AppLogger.debug('_agreedToPrivacy: $_agreedToPrivacy', tag: 'LoginScreen');

    if (!_formKey.currentState!.validate()) {
      AppLogger.warning('Form validation failed', tag: 'LoginScreen');
      return;
    }

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

    try {
      final authService = ref.read(authServiceProvider);

      if (_isLogin) {
        AppLogger.debug('Attempting email sign in...', tag: 'LoginScreen');
        // Sign in
        await authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
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

          if (mounted) {
            SnackBarHelper.showSuccess(
              context,
              '사장님 인증 요청이 접수되었습니다. 승인 후 사장님 기능을 사용할 수 있습니다.',
            );
          }
        }
      }

      // Save FCM token for push notifications
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AppLogger.debug('Saving FCM token for user: ${user.uid}', tag: 'LoginScreen');
        await FcmService().saveFcmTokenToUser(user.uid);
        AppLogger.success('FCM token saved', tag: 'LoginScreen');
      }

      AppLogger.success('Auth completed - AuthWrapper will handle navigation', tag: 'LoginScreen');
      // Don't manually navigate - let AuthWrapper handle it
      // AuthWrapper will automatically detect the login state change
      // and navigate to the appropriate screen
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

  Future<void> _handleKakaoSignIn() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithKakao();
      // Don't manually navigate - let AuthWrapper handle it
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, _getErrorMessage(e.toString()));
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
        SnackBarHelper.showError(context, _getErrorMessage(e.toString()));
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
                  const SizedBox(height: 16),

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

                  // Kakao Sign In Button (Coming Soon)
                  Stack(
                    children: [
                      ElevatedButton(
                        onPressed: null, // Disabled - Coming Soon
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEE500),
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: const Color(0xFFFEE500).withValues(alpha: 0.3),
                          disabledForegroundColor: Colors.black.withValues(alpha: 0.4),
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
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chat_bubble,
                                size: 12,
                                color: const Color(0xFFFEE500).withValues(alpha: 0.5),
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
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '준비 중',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Naver Sign In Button (Coming Soon)
                  Stack(
                    children: [
                      ElevatedButton(
                        onPressed: null, // Disabled - Coming Soon
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF03C75A),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF03C75A).withValues(alpha: 0.3),
                          disabledForegroundColor: Colors.white.withValues(alpha: 0.4),
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
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  'N',
                                  style: TextStyle(
                                    color: const Color(0xFF03C75A).withValues(alpha: 0.5),
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
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '준비 중',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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

                  // Owner Login Button (DEBUG ONLY - bypasses auth in debug mode)
                  if (kDebugMode) ...[
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
                                AppLogger.debug('[DEBUG ONLY] Owner test login button pressed', tag: 'LoginScreen');
                                AppLogger.debug('[DEBUG ONLY] Bypassing authentication - navigating to OwnerDashboardScreen', tag: 'LoginScreen');
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const OwnerDashboardScreen(),
                                  ),
                                );
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
                              '[DEBUG ONLY] 사장님 모드 바로가기',
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
                  ],

                  // Skip to main screen (guest mode)
                  TextButton(
                    onPressed: () {
                      AppLogger.debug('Guest mode button pressed', tag: 'LoginScreen');
                      AppLogger.debug('Navigating to TruckListScreen...', tag: 'LoginScreen');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const TruckListScreen(),
                        ),
                      );
                      AppLogger.debug('Navigation to TruckListScreen initiated', tag: 'LoginScreen');
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

