import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../themes/app_theme.dart';
import '../utils/app_logger.dart';

part 'network_status_banner.g.dart';

/// Network connectivity status
enum NetworkStatus {
  online,
  offline,
  unknown,
}

/// Provider for network connectivity status
@riverpod
class NetworkStatusNotifier extends _$NetworkStatusNotifier {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  NetworkStatus build() {
    // Start listening to connectivity changes
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.isNotEmpty &&
          !results.contains(ConnectivityResult.none);

      final newStatus = hasConnection ? NetworkStatus.online : NetworkStatus.offline;

      if (state != newStatus) {
        AppLogger.debug(
          'Network status changed: $newStatus',
          tag: 'NetworkStatus',
        );
        state = newStatus;
      }
    });

    // Clean up subscription on dispose
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // Initial check
    _checkInitialStatus();

    return NetworkStatus.unknown;
  }

  Future<void> _checkInitialStatus() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final hasConnection = results.isNotEmpty &&
          !results.contains(ConnectivityResult.none);

      state = hasConnection ? NetworkStatus.online : NetworkStatus.offline;

      AppLogger.debug(
        'Initial network status: $state',
        tag: 'NetworkStatus',
      );
    } catch (e) {
      AppLogger.error('Error checking connectivity', error: e, tag: 'NetworkStatus');
      state = NetworkStatus.unknown;
    }
  }
}

/// Banner widget that shows when offline
class NetworkStatusBanner extends ConsumerWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(networkStatusProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: status == NetworkStatus.offline ? 32 : 0,
      child: status == NetworkStatus.offline
          ? Container(
              color: Colors.red[700],
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    '오프라인 모드 - 인터넷 연결을 확인하세요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

/// Wrapper widget that adds network status banner to any screen
class NetworkAwareScaffold extends ConsumerWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const NetworkAwareScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppTheme.midnightCharcoal,
      appBar: appBar,
      body: Column(
        children: [
          const NetworkStatusBanner(),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
