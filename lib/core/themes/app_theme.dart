import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 앱 전체에 사용하는 기본 테마.
/// - Primary: Mustard Yellow (#FFC107) - Street Tycoon Theme
/// - Background: Midnight Charcoal (#121212)
/// - Dark Theme: Hip & Clean Design
class AppTheme {
  // Mustard Yellow - 포인트 컬러 (Street Tycoon Theme)
  static const Color mustardYellow = Color(0xFFFFC107);
  static const Color mustardYellowDark = Color(0xFFFFA000);
  static const Color mustardYellowLight = Color(0xFFFFD54F);

  // Legacy aliases (기존 코드 호환성)
  static const Color electricBlue = mustardYellow;
  static const Color electricBlueDark = mustardYellowDark;
  static const Color electricBlueLight = mustardYellowLight;

  // Midnight Charcoal - 배경 컬러
  static const Color midnightCharcoal = Color(0xFF121212);
  static const Color charcoalDark = Color(0xFF000000);
  static const Color charcoalLight = Color(0xFF1E1E1E);
  static const Color charcoalMedium = Color(0xFF1A1A1A);

  // 텍스트 컬러
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);

  // ✅ OPTIMIZATION: Pre-computed opacity variants to avoid creating Color objects in build methods
  // Mustard Yellow opacity variants
  static const Color mustardYellow10 = Color(0x1AFFC107);  // 10% opacity
  static const Color mustardYellow15 = Color(0x26FFC107);  // 15% opacity
  static const Color mustardYellow20 = Color(0x33FFC107);  // 20% opacity
  static const Color mustardYellow30 = Color(0x4DFFC107);  // 30% opacity
  static const Color mustardYellow50 = Color(0x80FFC107);  // 50% opacity

  // Black opacity variants
  static const Color black10 = Color(0x1A000000);
  static const Color black20 = Color(0x33000000);
  static const Color black30 = Color(0x4D000000);
  static const Color black50 = Color(0x80000000);

  // White opacity variants
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white50 = Color(0x80FFFFFF);

  // Grey opacity variants
  static const Color grey15 = Color(0x26808080);
  static const Color grey30 = Color(0x4D808080);

  // Orange opacity variant
  static const Color orange15 = Color(0x26FF9800);

  // 레거시 호환성 (기존 코드에서 사용 중)
  static const Color baeminMint = mustardYellow;
  static const Color background = midnightCharcoal;

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: midnightCharcoal,
      colorScheme: const ColorScheme.dark(
        primary: mustardYellow,
        secondary: mustardYellowLight,
        surface: charcoalMedium,
        background: midnightCharcoal,
        error: Color(0xFFE53935),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: midnightCharcoal,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: charcoalMedium,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: charcoalMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: charcoalLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mustardYellow, width: 2),
        ),
        hintStyle: const TextStyle(color: textTertiary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mustardYellow,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: mustardYellow,
          side: const BorderSide(color: mustardYellow, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: mustardYellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: charcoalLight,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: charcoalMedium,
        selectedColor: mustardYellow,
        labelStyle: const TextStyle(color: textPrimary),
        secondaryLabelStyle: const TextStyle(color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.notoSansKr(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.notoSansKr(color: textPrimary, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.notoSansKr(color: textPrimary, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.notoSansKr(color: textPrimary, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.notoSansKr(color: textPrimary, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.notoSansKr(color: textPrimary, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.notoSansKr(color: textPrimary, fontWeight: FontWeight.w500),
        titleMedium: GoogleFonts.notoSansKr(color: textPrimary, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.notoSansKr(color: textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.notoSansKr(color: textPrimary),
        bodyMedium: GoogleFonts.notoSansKr(color: textPrimary),
        bodySmall: GoogleFonts.notoSansKr(color: textSecondary),
        labelLarge: GoogleFonts.notoSansKr(color: textPrimary),
        labelMedium: GoogleFonts.notoSansKr(color: textSecondary),
        labelSmall: GoogleFonts.notoSansKr(color: textTertiary),
      ),
    );
  }

  // 레거시 호환성
  static ThemeData get light => dark;
}
