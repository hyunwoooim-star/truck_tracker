import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_theme.dart';

part 'theme_provider.g.dart';

/// Theme mode enum for the app
enum AppThemeMode {
  dark,
  light,
  system,
}

/// Provider for managing app theme mode
@riverpod
class AppThemeModeNotifier extends _$AppThemeModeNotifier {
  @override
  AppThemeMode build() {
    // Default to dark theme (original design)
    // TODO: Persist theme preference using shared_preferences
    return AppThemeMode.dark;
  }

  /// Toggle between dark and light theme
  void toggle() {
    state = state == AppThemeMode.dark ? AppThemeMode.light : AppThemeMode.dark;
  }

  /// Set specific theme mode
  void setThemeMode(AppThemeMode mode) {
    state = mode;
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
