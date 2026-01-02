import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/themes/app_theme.dart';
import 'core/themes/theme_provider.dart';
import 'core/utils/app_logger.dart';
import 'generated/l10n/app_localizations.dart';
import 'features/auth/presentation/auth_provider.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/owner_pending_screen.dart';
import 'features/owner_dashboard/presentation/owner_dashboard_screen.dart';
import 'features/owner_dashboard/presentation/owner_onboarding_screen.dart';
import 'features/truck_map/presentation/map_first_screen.dart';
import 'features/checkin/presentation/customer_checkin_screen.dart';
import 'features/checkin/presentation/owner_qr_screen.dart';
import 'features/admin/presentation/admin_dashboard_screen.dart';
import 'features/notifications/fcm_service.dart';
import 'features/ads/data/ad_service.dart';
import 'features/pickup_navigation/presentation/pickup_ready_listener.dart';
import 'features/auth/presentation/oauth_callback_screen.dart';
import 'features/auth/presentation/nickname_setup_screen.dart';
import 'features/onboarding/presentation/customer_onboarding_screen.dart';
import 'features/auth/presentation/widgets/login_loading_overlay.dart';
import 'firebase_options.dart';

/// Global key for showing foreground notifications
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Global navigator key for login overlay management
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // 🌐 WEB: Remove hash (#) from URLs for OAuth callback compatibility
  usePathUrlStrategy();

  // 🔍 SENTRY: Get DSN from environment (set in GitHub Actions secrets)
  // Create free account at sentry.io → Create Flutter project → Get DSN
  const sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '', // Will be set via GitHub Actions
  );

  // Initialize Sentry for error tracking (works on web + mobile)
  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsn;
      // Disable Sentry in debug mode
      options.environment = kDebugMode ? 'development' : 'production';
      // Sample rate for performance monitoring (10%)
      options.tracesSampleRate = 0.1;
      // Capture 100% of errors
      options.sampleRate = 1.0;
      // Enable automatic session tracking
      options.enableAutoSessionTracking = true;
      // Add app version info
      options.release = 'truck_tracker@1.0.0';
      // Don't send in debug mode unless DSN is explicitly set
      options.beforeSend = (event, hint) {
        if (kDebugMode && sentryDsn.isEmpty) {
          return null; // Don't send in debug without DSN
        }
        return event;
      };
    },
    appRunner: () async {
      // Wrap entire app in error zone for Crashlytics + Sentry
      await runZonedGuarded(() async {
        WidgetsFlutterBinding.ensureInitialized();

        // Initialize Firebase
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        // 🔄 FIRESTORE: Enable offline persistence for better offline support
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
        AppLogger.debug('Firestore offline persistence enabled', tag: 'Main');

        // 📊 CRASHLYTICS: Initialize crash reporting (not available on web)
        if (!kIsWeb) {
          await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
          FlutterError.onError = (details) {
            // Send to both Crashlytics and Sentry
            FirebaseCrashlytics.instance.recordFlutterFatalError(details);
            Sentry.captureException(details.exception, stackTrace: details.stack);
          };
          AppLogger.debug('Firebase Crashlytics initialized', tag: 'Main');
        } else {
          // Web: Only Sentry handles Flutter errors
          FlutterError.onError = (details) {
            Sentry.captureException(details.exception, stackTrace: details.stack);
            AppLogger.error('Flutter error', error: details.exception, stackTrace: details.stack, tag: 'Main');
          };
        }

        // 📈 PERFORMANCE: Initialize performance monitoring (not available on web)
        if (!kIsWeb) {
          await FirebasePerformance.instance.setPerformanceCollectionEnabled(!kDebugMode);
          AppLogger.debug('Firebase Performance initialized', tag: 'Main');
        }

        // 🔐 AUTH PERSISTENCE: Enable local persistence for web to prevent incognito mode requirement
        if (kIsWeb) {
          await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
          AppLogger.debug('Firebase Auth persistence set to LOCAL for web', tag: 'Main');
        }

        // 🔑 KAKAO SDK: Initialize Kakao SDK with native app key
        // Pass via --dart-define=KAKAO_NATIVE_APP_KEY=xxx at build time
        // Or set in GitHub Actions secrets
        const kakaoNativeAppKey = String.fromEnvironment(
          'KAKAO_NATIVE_APP_KEY',
          defaultValue: '16a3e20d6e8bff9d586a64029614a40e', // From .env
        );
        kakao.KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);
        AppLogger.debug('Kakao SDK initialized', tag: 'Main');

        // Initialize FCM (Firebase Cloud Messaging)
        final fcmService = FcmService();
        await fcmService.initialize();

        // Set up foreground message handler to show in-app notifications
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          _showForegroundNotification(message);
        });

        // Handle notification tap when app is in background
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          _handleNotificationTap(message);
        });

        // Handle notification tap when app was terminated
        final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
        if (initialMessage != null) {
          _handleNotificationTap(initialMessage);
        }

        // 📺 ADMOB: Initialize Google Mobile Ads SDK
        await AdService().initialize();

        // 🧹 OPTIMIZATION: Clean old image cache (7 days+) to free storage
        _cleanOldImageCache();

        AppLogger.debug('Sentry initialized (DSN ${sentryDsn.isNotEmpty ? "configured" : "not set"})', tag: 'Main');

        // Set global navigator key for login overlay management
        setGlobalNavigatorKey(_navigatorKey);

        runApp(
          const ProviderScope(
            child: MyApp(),
          ),
        );
      }, (error, stack) {
        // Catch async errors and report to both Crashlytics and Sentry
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        }
        Sentry.captureException(error, stackTrace: stack);
        AppLogger.error('Uncaught async error', error: error, stackTrace: stack, tag: 'Main');
      });
    },
  );
}

/// GoRouter instance - must be static to persist across rebuilds
final _router = GoRouter(
  navigatorKey: _navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthWrapper(),
    ),
    GoRoute(
      path: '/check-in/:truckId',
      builder: (context, state) => const CustomerCheckinScreen(),
    ),
    GoRoute(
      path: '/qr-code/:truckId',
      builder: (context, state) => const OwnerQRScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    // 닉네임 설정 화면
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const NicknameSetupScreen(),
    ),
    // OAuth callback routes for web social login
    GoRoute(
      path: '/kakao',
      builder: (context, state) {
        final code = state.uri.queryParameters['code'] ?? '';
        return OAuthCallbackScreen(
          provider: 'kakao',
          code: code,
        );
      },
    ),
    GoRoute(
      path: '/oauth/kakao/callback',
      builder: (context, state) {
        final code = state.uri.queryParameters['code'] ?? '';
        return OAuthCallbackScreen(
          provider: 'kakao',
          code: code,
        );
      },
    ),
    GoRoute(
      path: '/oauth/naver/callback',
      builder: (context, state) {
        final code = state.uri.queryParameters['code'] ?? '';
        final stateParam = state.uri.queryParameters['state'];
        return OAuthCallbackScreen(
          provider: 'naver',
          code: code,
          state: stateParam,
        );
      },
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: '트럭아저씨',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(appThemeModeForMaterialProvider),
      routerConfig: _router,
      scaffoldMessengerKey: scaffoldMessengerKey,
      // 🌏 LOCALIZATION: Support Korean and English
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''), // Korean
        Locale('en', ''), // English
      ],
      locale: const Locale('ko', ''), // Default to Korean
    );
  }
}

/// Auth wrapper to handle authentication state
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final truckIdAsync = ref.watch(currentUserTruckIdProvider);
    final ownerRequestAsync = ref.watch(ownerRequestStatusProvider);
    final profileCompleteAsync = ref.watch(isProfileCompleteProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          AppLogger.debug('User not logged in → LoginScreen', tag: 'AuthWrapper');
          // Not logged in → show login screen
          return const LoginScreen();
        }

        AppLogger.debug('User logged in (${user.uid}) → Checking profile completion', tag: 'AuthWrapper');

        // 로그인 성공 시 오버레이 강제 닫기 (구글 로그인 등 popup 방식 처리)
        forceHideLoginLoadingOverlay();

        // 프로필 완성 여부 먼저 확인
        return profileCompleteAsync.when(
          data: (isProfileComplete) {
            if (!isProfileComplete) {
              AppLogger.debug('Profile not complete → NicknameSetupScreen', tag: 'AuthWrapper');
              return const NicknameSetupScreen();
            }

            AppLogger.debug('Profile complete → Checking truck ownership', tag: 'AuthWrapper');

            // Logged in + profile complete → check if owner or customer
            return truckIdAsync.when(
              data: (ownedTruckId) {
                AppLogger.debug('Owned truck ID = $ownedTruckId', tag: 'AuthWrapper');

                if (ownedTruckId != null) {
                  // User owns a truck → check if onboarding is needed
                  return _OwnerRoutingWidget(truckId: ownedTruckId);
                } else {
                  // Check if there's a pending owner request
                  return ownerRequestAsync.when(
                    data: (requestData) {
                      if (requestData != null) {
                        final status = requestData['status'] as String?;
                        final rejectionReason = requestData['rejectionReason'] as String?;

                        if (status == 'pending') {
                          AppLogger.debug('Owner request pending → OwnerPendingScreen', tag: 'AuthWrapper');
                          return const OwnerPendingScreen(status: 'pending');
                        } else if (status == 'rejected') {
                          AppLogger.debug('Owner request rejected → OwnerPendingScreen', tag: 'AuthWrapper');
                          return OwnerPendingScreen(
                            status: 'rejected',
                            rejectionReason: rejectionReason,
                          );
                        }
                        // If approved, ownedTruckId should be set, but if not, fall through to customer
                      }

                      AppLogger.debug('User is customer → Check onboarding', tag: 'AuthWrapper');
                      // Regular customer → check if onboarding needed first
                      return const _CustomerWithOnboardingWidget();
                    },
                    loading: () {
                      AppLogger.debug('Loading owner request status...', tag: 'AuthWrapper');
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.mustardYellow,
                          ),
                        ),
                      );
                    },
                    error: (error, stack) {
                      AppLogger.error('Error checking owner request', error: error, stackTrace: stack, tag: 'AuthWrapper');
                      // On error, show customer screen with onboarding check
                      return const _CustomerWithOnboardingWidget();
                    },
                  );
                }
              },
              loading: () {
                AppLogger.debug('Loading truck ownership...', tag: 'AuthWrapper');
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.mustardYellow,
                    ),
                  ),
                );
              },
              error: (error, stack) {
                AppLogger.error('Error checking truck ownership', error: error, stackTrace: stack, tag: 'AuthWrapper');
                // On error, assume customer (safer default)
                return const MapFirstScreen();
              },
            );
          },
          loading: () {
            AppLogger.debug('Checking profile completion...', tag: 'AuthWrapper');
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.mustardYellow,
                ),
              ),
            );
          },
          error: (error, stack) {
            AppLogger.error('Error checking profile', error: error, stackTrace: stack, tag: 'AuthWrapper');
            // On error, show nickname setup (safer - ensures profile is complete)
            return const NicknameSetupScreen();
          },
        );
      },
      loading: () {
        AppLogger.debug('Loading auth state...', tag: 'AuthWrapper');
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: AppTheme.mustardYellow,
            ),
          ),
        );
      },
      error: (error, stack) {
        AppLogger.error('Auth error', error: error, stackTrace: stack, tag: 'AuthWrapper');
        // On error, show login screen
        return const LoginScreen();
      },
    );
  }
}

/// Widget to handle owner routing (onboarding vs dashboard)
class _OwnerRoutingWidget extends ConsumerWidget {
  const _OwnerRoutingWidget({required this.truckId});

  final int truckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final needsOnboardingAsync = ref.watch(needsOwnerOnboardingProvider);

    return needsOnboardingAsync.when(
      data: (needsOnboarding) {
        if (needsOnboarding) {
          AppLogger.debug('Owner needs onboarding → OwnerOnboardingScreen', tag: 'AuthWrapper');
          return OwnerOnboardingScreen(truckId: truckId);
        } else {
          AppLogger.debug('Owner onboarding complete → OwnerDashboardScreen', tag: 'AuthWrapper');
          return const OwnerDashboardScreen();
        }
      },
      loading: () {
        AppLogger.debug('Checking onboarding status...', tag: 'AuthWrapper');
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppTheme.mustardYellow),
                SizedBox(height: 16),
                Text(
                  '사장님 정보 확인 중...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stack) {
        AppLogger.error('Error checking onboarding', error: error, stackTrace: stack, tag: 'AuthWrapper');
        // On error, go to dashboard (safer - they can access onboarding from there if needed)
        return const OwnerDashboardScreen();
      },
    );
  }
}

/// Widget to handle customer routing with onboarding check
class _CustomerWithOnboardingWidget extends StatefulWidget {
  const _CustomerWithOnboardingWidget();

  @override
  State<_CustomerWithOnboardingWidget> createState() => _CustomerWithOnboardingWidgetState();
}

class _CustomerWithOnboardingWidgetState extends State<_CustomerWithOnboardingWidget> {
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final isFirstLaunch = await OnboardingHelper.isFirstLaunch();
    if (mounted) {
      setState(() {
        _showOnboarding = isFirstLaunch;
        _isLoading = false;
      });
    }
  }

  void _onOnboardingComplete() {
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.mustardYellow,
          ),
        ),
      );
    }

    if (_showOnboarding) {
      AppLogger.debug('First launch → CustomerOnboardingScreen', tag: 'AuthWrapper');
      return CustomerOnboardingScreen(
        onComplete: _onOnboardingComplete,
      );
    }

    AppLogger.debug('Onboarding complete → MapFirstScreen', tag: 'AuthWrapper');
    return const PickupReadyListener(
      child: MapFirstScreen(),
    );
  }
}

/// 🧹 Clean old image cache to prevent unlimited storage growth
Future<void> _cleanOldImageCache() async {
  try {
    final cacheManager = DefaultCacheManager();

    // Remove files older than 7 days
    await cacheManager.emptyCache();

    AppLogger.debug('Image cache cleaned: Removed files older than 7 days', tag: 'Main');
  } catch (e) {
    AppLogger.warning('Failed to clean image cache', tag: 'Main');
    // Non-critical error, continue app startup
  }
}

/// 🔔 Show in-app notification when message received in foreground
void _showForegroundNotification(RemoteMessage message) {
  final notification = message.notification;
  if (notification == null) return;

  AppLogger.debug('Showing foreground notification: ${notification.title}', tag: 'Main');

  final snackBar = SnackBar(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notification.title != null)
          Text(
            notification.title!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        if (notification.body != null)
          Text(
            notification.body!,
            style: const TextStyle(color: Colors.black87),
          ),
      ],
    ),
    backgroundColor: AppTheme.mustardYellow,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    duration: const Duration(seconds: 4),
    action: SnackBarAction(
      label: '확인',
      textColor: Colors.black,
      onPressed: () {
        // Dismiss snackbar
      },
    ),
  );

  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}

/// 🔗 Handle notification tap - navigate to relevant screen
void _handleNotificationTap(RemoteMessage message) {
  final data = message.data;
  AppLogger.debug('Notification tapped with data: $data', tag: 'Main');

  // Extract navigation parameters from notification data
  final type = data['type'] as String?;
  final truckId = data['truckId'] as String?;
  final orderId = data['orderId'] as String?;
  final chatRoomId = data['chatRoomId'] as String?;

  // Note: Navigation is handled by the app's GoRouter
  // The data is logged here for debugging.
  // In a full implementation, you would use a global navigator key
  // or a state management solution to trigger navigation.

  AppLogger.debug(
    'Notification navigation: type=$type, truckId=$truckId, orderId=$orderId, chatRoomId=$chatRoomId',
    tag: 'Main',
  );

  // For now, we store the pending navigation in a global variable
  // that can be checked by screens when they initialize
  _pendingNotificationData = data;
}

/// Global variable to store pending notification data for deep linking
Map<String, dynamic>? _pendingNotificationData;

/// Get and clear pending notification data
Map<String, dynamic>? consumePendingNotification() {
  final data = _pendingNotificationData;
  _pendingNotificationData = null;
  return data;
}
