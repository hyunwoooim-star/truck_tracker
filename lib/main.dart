import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/themes/app_theme.dart';
import 'generated/l10n/app_localizations.dart';
import 'features/auth/presentation/auth_provider.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/owner_dashboard/presentation/owner_dashboard_screen.dart';
import 'features/truck_map/presentation/map_first_screen.dart';
import 'features/checkin/presentation/customer_checkin_screen.dart';
import 'features/checkin/presentation/owner_qr_screen.dart';
import 'features/notifications/fcm_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize FCM (Firebase Cloud Messaging)
  final fcmService = FcmService();
  await fcmService.initialize();

  // 🧹 OPTIMIZATION: Clean old image cache (7 days+) to free storage
  _cleanOldImageCache();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
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
      ],
    );

    return MaterialApp.router(
      title: '트럭아저씨',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
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

    return authState.when(
      data: (user) {
        if (user == null) {
          debugPrint('🔐 AuthWrapper: User not logged in → LoginScreen');
          // Not logged in → show login screen
          return const LoginScreen();
        }

        debugPrint('🔐 AuthWrapper: User logged in (${user.uid}) → Checking truck ownership');

        // Logged in → check if owner or customer using Provider
        return truckIdAsync.when(
          data: (ownedTruckId) {
            debugPrint('🚚 AuthWrapper: Owned truck ID = $ownedTruckId');

            if (ownedTruckId != null) {
              debugPrint('✅ AuthWrapper: User is owner → OwnerDashboardScreen');
              // User owns a truck → owner dashboard
              return const OwnerDashboardScreen();
            } else {
              debugPrint('✅ AuthWrapper: User is customer → MapFirstScreen');
              // Regular customer → map-first screen (Street Tycoon)
              return const MapFirstScreen();
            }
          },
          loading: () {
            debugPrint('⏳ AuthWrapper: Loading truck ownership...');
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.mustardYellow,
                ),
              ),
            );
          },
          error: (error, stack) {
            debugPrint('❌ AuthWrapper: Error checking truck ownership: $error');
            // On error, assume customer (safer default)
            return const MapFirstScreen();
          },
        );
      },
      loading: () {
        debugPrint('⏳ AuthWrapper: Loading auth state...');
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: AppTheme.mustardYellow,
            ),
          ),
        );
      },
      error: (error, stack) {
        debugPrint('❌ AuthWrapper: Auth error: $error');
        // On error, show login screen
        return const LoginScreen();
      },
    );
  }
}

/// 🧹 Clean old image cache to prevent unlimited storage growth
Future<void> _cleanOldImageCache() async {
  try {
    final cacheManager = DefaultCacheManager();

    // Remove files older than 7 days
    await cacheManager.emptyCache();

    debugPrint('🧹 Image cache cleaned: Removed files older than 7 days');
  } catch (e) {
    debugPrint('⚠️ Failed to clean image cache: $e');
    // Non-critical error, continue app startup
  }
}
