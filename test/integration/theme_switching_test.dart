import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truck_tracker/core/themes/app_theme.dart';
import 'package:truck_tracker/core/themes/theme_provider.dart';

void main() {
  group('Theme Switching Integration', () {
    testWidgets('theme changes reflect in MaterialApp', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              final themeMode = ref.watch(appThemeModeForMaterialProvider);

              return MaterialApp(
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                home: Scaffold(
                  body: Builder(
                    builder: (context) {
                      return Column(
                        children: [
                          Text(
                            'Brightness: ${Theme.of(context).brightness}',
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(appThemeModeProvider.notifier).toggle();
                            },
                            child: const Text('Toggle Theme'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial state is dark
      expect(find.text('Brightness: Brightness.dark'), findsOneWidget);

      // Toggle to light
      await tester.tap(find.text('Toggle Theme'));
      await tester.pumpAndSettle();

      expect(find.text('Brightness: Brightness.light'), findsOneWidget);

      // Toggle back to dark
      await tester.tap(find.text('Toggle Theme'));
      await tester.pumpAndSettle();

      expect(find.text('Brightness: Brightness.dark'), findsOneWidget);
    });

    testWidgets('theme colors update correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              final themeMode = ref.watch(appThemeModeForMaterialProvider);

              return MaterialApp(
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                home: Scaffold(
                  body: Builder(
                    builder: (context) {
                      final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
                      final isDark = scaffoldColor == AppTheme.midnightCharcoal;

                      return Column(
                        children: [
                          Text('Is Dark: $isDark'),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(appThemeModeProvider.notifier)
                                  .setThemeMode(AppThemeMode.light);
                            },
                            child: const Text('Set Light'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(appThemeModeProvider.notifier)
                                  .setThemeMode(AppThemeMode.dark);
                            },
                            child: const Text('Set Dark'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial state is dark
      expect(find.text('Is Dark: true'), findsOneWidget);

      // Set to light
      await tester.tap(find.text('Set Light'));
      await tester.pumpAndSettle();

      expect(find.text('Is Dark: false'), findsOneWidget);

      // Set back to dark
      await tester.tap(find.text('Set Dark'));
      await tester.pumpAndSettle();

      expect(find.text('Is Dark: true'), findsOneWidget);
    });

    testWidgets('provider state persists across rebuilds', (tester) async {
      final container = ProviderContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              final mode = ref.watch(appThemeModeProvider);
              return MaterialApp(
                home: Scaffold(
                  body: Text('Mode: ${mode.name}'),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Mode: dark'), findsOneWidget);

      // Change theme via container
      container.read(appThemeModeProvider.notifier).setThemeMode(AppThemeMode.light);
      await tester.pumpAndSettle();

      expect(find.text('Mode: light'), findsOneWidget);

      // Rebuild widget tree
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              final mode = ref.watch(appThemeModeProvider);
              return MaterialApp(
                home: Scaffold(
                  body: Text('Mode: ${mode.name}'),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // State should persist
      expect(find.text('Mode: light'), findsOneWidget);

      container.dispose();
    });
  });
}
