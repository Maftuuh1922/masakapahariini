// core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  // Colors sesuai design Figma
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color lightPurple = Color(0xFFEDE9FE);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1F2937);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF374151);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textLight = Color(0xFF6B7280);
  static const Color accent = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFFBBF24);

  // Gradients
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8F9FA), Color(0xFFEDE9FE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: MaterialColor(
        primaryPurple.value,
        <int, Color>{
          50: const Color(0xFFF5F3FF),
          100: const Color(0xFFEDE9FE),
          200: const Color(0xFFDDD6FE),
          300: const Color(0xFFC4B5FD),
          400: const Color(0xFFA78BFA),
          500: primaryPurple,
          600: const Color(0xFF7C3AED),
          700: const Color(0xFF6D28D9),
          800: const Color(0xFF5B21B6),
          900: const Color(0xFF4C1D95),
        },
      ),
      primaryColor: primaryPurple,
      scaffoldBackgroundColor: backgroundLight,
      fontFamily: GoogleFonts.inter().fontFamily,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textDark),
        titleTextStyle: GoogleFonts.inter(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: cardLight,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      // ... dark theme configuration
    );
  }
}