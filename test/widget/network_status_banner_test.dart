import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/core/widgets/network_status_banner.dart';

void main() {
  group('NetworkStatus', () {
    test('has all expected values', () {
      expect(NetworkStatus.values.length, 3);
      expect(NetworkStatus.values, contains(NetworkStatus.online));
      expect(NetworkStatus.values, contains(NetworkStatus.offline));
      expect(NetworkStatus.values, contains(NetworkStatus.unknown));
    });
  });

  group('NetworkStatusBanner Widget', () {
    testWidgets('shows nothing when online', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            networkStatusProvider.overrideWithValue(NetworkStatus.online),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  NetworkStatusBanner(),
                  Text('Content'),
                ],
              ),
            ),
          ),
        ),
      );

      // Banner should be collapsed (height 0)
      expect(find.text('오프라인 모드 - 인터넷 연결을 확인하세요'), findsNothing);
      expect(find.byIcon(Icons.wifi_off), findsNothing);
    });

    testWidgets('shows banner when offline', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            networkStatusProvider.overrideWithValue(NetworkStatus.offline),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  NetworkStatusBanner(),
                  Text('Content'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('오프라인 모드 - 인터넷 연결을 확인하세요'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('shows nothing when unknown', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            networkStatusProvider.overrideWithValue(NetworkStatus.unknown),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  NetworkStatusBanner(),
                  Text('Content'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('오프라인 모드 - 인터넷 연결을 확인하세요'), findsNothing);
    });
  });

  group('NetworkAwareScaffold Widget', () {
    testWidgets('includes network status banner', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            networkStatusProvider.overrideWithValue(NetworkStatus.offline),
          ],
          child: const MaterialApp(
            home: NetworkAwareScaffold(
              appBar: null,
              body: Text('Body Content'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Body Content'), findsOneWidget);
      expect(find.text('오프라인 모드 - 인터넷 연결을 확인하세요'), findsOneWidget);
    });

    testWidgets('displays body content correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            networkStatusProvider.overrideWithValue(NetworkStatus.online),
          ],
          child: const MaterialApp(
            home: NetworkAwareScaffold(
              body: Center(
                child: Text('Main Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Main Content'), findsOneWidget);
    });

    testWidgets('includes app bar when provided', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            networkStatusProvider.overrideWithValue(NetworkStatus.online),
          ],
          child: MaterialApp(
            home: NetworkAwareScaffold(
              appBar: AppBar(title: const Text('Test App Bar')),
              body: const Text('Body'),
            ),
          ),
        ),
      );

      expect(find.text('Test App Bar'), findsOneWidget);
    });

    testWidgets('includes floating action button when provided', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            networkStatusProvider.overrideWithValue(NetworkStatus.online),
          ],
          child: MaterialApp(
            home: NetworkAwareScaffold(
              body: const Text('Body'),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
