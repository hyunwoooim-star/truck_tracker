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
  static const Color mustardYellow05 = Color(0x0DFFC107);  // 5% opacity
  static const Color mustardYellow10 = Color(0x1AFFC107);  // 10% opacity
  static const Color mustardYellow15 = Color(0x26FFC107);  // 15% opacity
  static const Color mustardYellow20 = Color(0x33FFC107);  // 20% opacity
  static const Color mustardYellow30 = Color(0x4DFFC107);  // 30% opacity
  static const Color mustardYellow50 = Color(0x80FFC107);  // 50% opacity
  static const Color mustardYellow70 = Color(0xB3FFC107);  // 70% opacity
  static const Color mustardYellow80 = Color(0xCCFFC107);  // 80% opacity
  static const Color mustardYellow90 = Color(0xE6FFC107);  // 90% opacity

  // Black opacity variants
  static const Color black03 = Color(0x08000000);  // 3% opacity
  static const Color black05 = Color(0x0D000000);  // 5% opacity
  static const Color black10 = Color(0x1A000000);  // 10% opacity
  static const Color black20 = Color(0x33000000);  // 20% opacity
  static const Color black30 = Color(0x4D000000);  // 30% opacity
  static const Color black50 = Color(0x80000000);  // 50% opacity

  // Charcoal opacity variants
  static const Color charcoalMedium95 = Color(0xF21A1A1A);  // charcoalMedium (0xFF1A1A1A) with 95% opacity

  // White opacity variants
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);  // 60% opacity
  static const Color white80 = Color(0xCCFFFFFF);  // 80% opacity

  // Semantic colors
  static const Color error = Color(0xFFE53935);      // Red for errors and danger actions
  static const Color error30 = Color(0x4DE53935);   // 30% opacity
  static const Color success = Color(0xFF4CAF50);    // Green for success states
  static const Color warning = Color(0xFFFF9800);    // Orange for warnings

  // Text color opacity variants
  static const Color textTertiary15 = Color(0x26808080);  // textTertiary (0xFF808080) with 15% opacity
  static const Color textSecondary10 = Color(0x1AB0B0B0);  // textSecondary (0xFFB0B0B0) with 10% opacity
  static const Color textSecondary50 = Color(0x80B0B0B0);  // textSecondary (0xFFB0B0B0) with 50% opacity

  // Grey opacity variants
  static const Color grey15 = Color(0x26808080);
  static const Color grey30 = Color(0x4D808080);

  // Orange opacity variants
  static const Color orange15 = Color(0x26FF9800);
  static const Color orange30 = Color(0x4DFF9800);  // 30% opacity

  // Green opacity variant
  static const Color green30 = Color(0x4D4CAF50);  // 30% opacity

  // Red opacity variant
  static const Color red50 = Color(0x80F44336);  // 50% opacity

  // ═══════════════════════════════════════════════════════════════════════════
  // TOSS DESIGN SYSTEM COLORS
  // 토스 앱 스타일 컬러 시스템
  // ═══════════════════════════════════════════════════════════════════════════

  // Toss Blue - Primary accent color
  static const Color tossBlue = Color(0xFF3182F6);
  static const Color tossBlueDark = Color(0xFF1B64DA);
  static const Color tossBlueLight = Color(0xFFE8F3FF);
  static const Color tossBlue10 = Color(0x1A3182F6);  // 10% opacity
  static const Color tossBlue20 = Color(0x333182F6);  // 20% opacity

  // Toss Neutral Grays
  static const Color tossGray50 = Color(0xFFF9FAFB);   // Lightest
  static const Color tossGray100 = Color(0xFFF2F4F6);
  static const Color tossGray200 = Color(0xFFE5E8EB);
  static const Color tossGray300 = Color(0xFFD1D6DB);
  static const Color tossGray400 = Color(0xFFB0B8C1);
  static const Color tossGray500 = Color(0xFF8B95A1);  // Mid gray
  static const Color tossGray600 = Color(0xFF6B7684);
  static const Color tossGray700 = Color(0xFF4E5968);
  static const Color tossGray800 = Color(0xFF333D4B);
  static const Color tossGray900 = Color(0xFF191F28);  // Darkest

  // Toss Semantic Colors
  static const Color tossRed = Color(0xFFFF5247);
  static const Color tossGreen = Color(0xFF00C48C);
  static const Color tossOrange = Color(0xFFFF9F40);

  // Toss Card Shadows (for BoxShadow)
  static const Color tossShadow = Color(0x0A000000);  // Very subtle shadow
  static const Color tossShadowMedium = Color(0x14000000);  // Medium shadow

  // 레거시 호환성 (기존 코드에서 사용 중)
  static const Color baeminMint = mustardYellow;
  static const Color background = midnightCharcoal;

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: false,  // Disable Material 3 to avoid ink_sparkle shader compilation bug
      splashFactory: NoSplash.splashFactory, // Disable ink sparkle to avoid shader compilation bug
      brightness: Brightness.dark,
      scaffoldBackgroundColor: midnightCharcoal,
      colorScheme: const ColorScheme.dark(
        primary: mustardYellow,
        secondary: mustardYellowLight,
        surface: midnightCharcoal,
        surfaceContainerHighest: charcoalMedium,
        error: Color(0xFFE53935),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textPrimary,
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
      // PopupMenu 테마 - 다크 배경 + 노랑 포인트
      popupMenuTheme: PopupMenuThemeData(
        color: charcoalMedium,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.notoSansKr(color: textPrimary),
        iconColor: mustardYellow,
      ),
      // Dialog 테마 - 다크 배경
      dialogTheme: DialogThemeData(
        backgroundColor: charcoalMedium,
        surfaceTintColor: Colors.transparent,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.notoSansKr(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: GoogleFonts.notoSansKr(
          color: textSecondary,
          fontSize: 14,
        ),
      ),
      // BottomSheet 테마 - 다크 배경
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: charcoalMedium,
        surfaceTintColor: Colors.transparent,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      // ListTile 테마
      listTileTheme: ListTileThemeData(
        iconColor: mustardYellow,
        textColor: textPrimary,
        tileColor: Colors.transparent,
        selectedTileColor: mustardYellow10,
      ),
    );
  }

  // Light Theme - 밝은 테마
  static ThemeData get light {
    return ThemeData(
      useMaterial3: false,
      splashFactory: NoSplash.splashFactory,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.grey[50],
      colorScheme: ColorScheme.light(
        primary: mustardYellowDark,
        secondary: mustardYellow,
        surface: Colors.white,
        surfaceContainerHighest: Colors.grey[100]!,
        error: const Color(0xFFE53935),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.grey[900]!,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[900],
        elevation: 1,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mustardYellowDark, width: 2),
        ),
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mustardYellowDark,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: mustardYellowDark,
          side: const BorderSide(color: mustardYellowDark, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: mustardYellowDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey[300],
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[100],
        selectedColor: mustardYellow,
        labelStyle: TextStyle(color: Colors.grey[900]),
        secondaryLabelStyle: const TextStyle(color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.grey[800],
        size: 24,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.notoSansKr(color: Colors.grey[900], fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.notoSansKr(color: Colors.grey[900], fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.notoSansKr(color: Colors.grey[900], fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.notoSansKr(color: Colors.grey[900], fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.notoSansKr(color: Colors.grey[900], fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.notoSansKr(color: Colors.grey[900], fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.notoSansKr(color: Colors.grey[900], fontWeight: FontWeight.w500),
        titleMedium: GoogleFonts.notoSansKr(color: Colors.grey[900], fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.notoSansKr(color: Colors.grey[900], fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.notoSansKr(color: Colors.grey[900]),
        bodyMedium: GoogleFonts.notoSansKr(color: Colors.grey[900]),
        bodySmall: GoogleFonts.notoSansKr(color: Colors.grey[600]),
        labelLarge: GoogleFonts.notoSansKr(color: Colors.grey[900]),
        labelMedium: GoogleFonts.notoSansKr(color: Colors.grey[600]),
        labelSmall: GoogleFonts.notoSansKr(color: Colors.grey[500]),
      ),
    );
  }
}
