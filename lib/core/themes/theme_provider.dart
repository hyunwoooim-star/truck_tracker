import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

part 'theme_provider.g.dart';

/// Theme mode enum for the app
enum AppThemeMode {
  dark,
  light,
  system,
}

/// Key for storing theme preference
const String _themePreferenceKey = 'app_theme_mode';

/// Provider for managing app theme mode with persistence
/// Uses keepAlive to prevent theme reset during navigation
@Riverpod(keepAlive: true)
class AppThemeModeNotifier extends _$AppThemeModeNotifier {
  @override
  AppThemeMode build() {
    // Load saved theme preference asynchronously
    _loadThemePreference();
    // Default to dark theme (original design)
    return AppThemeMode.dark;
  }

  /// Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePreferenceKey);

      if (savedTheme != null) {
        final mode = AppThemeMode.values.firstWhere(
          (e) => e.name == savedTheme,
          orElse: () => AppThemeMode.dark,
        );
        state = mode;
      }
    } catch (e) {
      // If loading fails, keep default dark theme
      debugPrint('Failed to load theme preference: $e');
    }
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveThemePreference(AppThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePreferenceKey, mode.name);
    } catch (e) {
      debugPrint('Failed to save theme preference: $e');
    }
  }

  /// Toggle between dark and light theme
  void toggle() {
    final newMode = state == AppThemeMode.dark ? AppThemeMode.light : AppThemeMode.dark;
    setThemeMode(newMode);
  }

  /// Set specific theme mode and persist it
  void setThemeMode(AppThemeMode mode) {
    state = mode;
    _saveThemePreference(mode);
  }
}

/// Provider that returns the actual ThemeData based on current mode
@riverpod
ThemeData currentTheme(Ref ref) {
  final mode = ref.watch(appThemeModeProvider);

  switch (mode) {
    case AppThemeMode.dark:
      return AppTheme.dark;
    case AppThemeMode.light:
      return AppTheme.light;
    case AppThemeMode.system:
      // For system mode, we'd need to check platform brightness
      // Default to dark for now
      return AppTheme.dark;
  }
}

/// Provider that returns ThemeMode for MaterialApp
@riverpod
ThemeMode appThemeModeForMaterial(Ref ref) {
  final mode = ref.watch(appThemeModeProvider);

  switch (mode) {
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
}
