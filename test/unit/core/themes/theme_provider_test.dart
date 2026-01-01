import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_tracker/core/themes/app_theme.dart';
import 'package:truck_tracker/core/themes/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Disable Google Fonts HTTP fetching for tests
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = true;
  });
  group('AppThemeMode', () {
    test('has all expected values', () {
      expect(AppThemeMode.values, contains(AppThemeMode.dark));
      expect(AppThemeMode.values, contains(AppThemeMode.light));
      expect(AppThemeMode.values, contains(AppThemeMode.system));
      expect(AppThemeMode.values.length, 3);
    });
  });

  group('AppThemeModeNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is dark', () {
      final mode = container.read(appThemeModeProvider);
      expect(mode, AppThemeMode.dark);
    });

    test('toggle switches between dark and light', () {
      // Initial state
      expect(container.read(appThemeModeProvider), AppThemeMode.dark);

      // Toggle to light
      container.read(appThemeModeProvider.notifier).toggle();
      expect(container.read(appThemeModeProvider), AppThemeMode.light);

      // Toggle back to dark
      container.read(appThemeModeProvider.notifier).toggle();
      expect(container.read(appThemeModeProvider), AppThemeMode.dark);
    });

    test('setThemeMode sets correct mode', () {
      container.read(appThemeModeProvider.notifier).setThemeMode(AppThemeMode.light);
      expect(container.read(appThemeModeProvider), AppThemeMode.light);

      container.read(appThemeModeProvider.notifier).setThemeMode(AppThemeMode.system);
      expect(container.read(appThemeModeProvider), AppThemeMode.system);

      container.read(appThemeModeProvider.notifier).setThemeMode(AppThemeMode.dark);
      expect(container.read(appThemeModeProvider), AppThemeMode.dark);
    });
  });

  group('currentThemeProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('returns dark theme when mode is dark', () {
      container.read(appThemeModeProvider.notifier).setThemeMode(AppThemeMode.dark);
      final theme = container.read(currentThemeProvider);
      expect(theme.brightness, Brightness.dark);
    });

    test('returns light theme when mode is light', () {
      container.read(appThemeModeProvider.notifier).setThemeMode(AppThemeMode.light);
      final theme = container.read(currentThemeProvider);
      expect(theme.brightness, Brightness.light);
    });

    test('returns dark theme when mode is system (default)', () {
      container.read(appThemeModeProvider.notifier).setThemeMode(AppThemeMode.system);
      final theme = container.read(currentThemeProvider);
      // System defaults to dark in our implementation
      expect(theme.brightness, Brightness.dark);
    });
  });

  group('appThemeModeForMaterialProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('returns ThemeMode.dark when mode is dark', () {
      container.read(appThemeModeProvider.notifier).setThemeMode(AppThemeMode.dark);
      final themeMode = container.read(appThemeModeForMaterialProvider);
      expect(themeMode, ThemeMode.dark);
    });

    test('returns ThemeMode.light when mode is light', () {
      container.read(appThemeModeProvider.notifier).setThemeMode(AppThemeMode.light);
      final themeMode = container.read(appThemeModeForMaterialProvider);
      expect(themeMode, ThemeMode.light);
    });

    test('returns ThemeMode.system when mode is system', () {
      container.read(appThemeModeProvider.notifier).setThemeMode(AppThemeMode.system);
      final themeMode = container.read(appThemeModeForMaterialProvider);
      expect(themeMode, ThemeMode.system);
    });
  });

  group('AppTheme', () {
    test('dark theme has correct brightness', () {
      expect(AppTheme.dark.brightness, Brightness.dark);
    });

    test('light theme has correct brightness', () {
      expect(AppTheme.light.brightness, Brightness.light);
    });

    test('dark theme uses mustard yellow as primary color', () {
      expect(AppTheme.dark.colorScheme.primary, AppTheme.mustardYellow);
    });

    test('dark theme uses midnight charcoal as scaffold background', () {
      expect(AppTheme.dark.scaffoldBackgroundColor, AppTheme.midnightCharcoal);
    });

    test('light theme uses white-based background', () {
      expect(AppTheme.light.scaffoldBackgroundColor, Colors.grey[50]);
    });
  });
}
