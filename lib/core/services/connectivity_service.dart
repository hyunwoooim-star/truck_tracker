import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.dart.g.dart';

/// Network connectivity monitoring service
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Stream of connection status (true = connected, false = offline)
  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map((result) {
      if (result is List<ConnectivityResult>) {
        return !result.contains(ConnectivityResult.none);
      }
      return result != ConnectivityResult.none;
    }).asBroadcastStream();
  }

  /// Check current connection status
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    if (result is List<ConnectivityResult>) {
      return !result.contains(ConnectivityResult.none);
    }
    return result != ConnectivityResult.none;
  }
}

@riverpod
ConnectivityService connectivityService(ConnectivityServiceRef ref) => ConnectivityService();

@riverpod
Stream<bool> connectionStatusStream(ConnectionStatusStreamRef ref) {
  return ref.watch(connectivityServiceProvider).connectionStream;
}
