import 'package:flutter/material.dart';

/// Tema claro: rosa suave, branco e cinzas — identidade delicada da QBonita.
class AppTheme {
  AppTheme._();

  static const Color primaryPink = Color(0xFFC2186B);
  static const Color primaryPinkDark = Color(0xFFA62164);
  static const Color surfaceTint = Color(0xFFFFF5F9);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color pageBackground = Color(0xFFF5F5F7);

  static ThemeData get light {
    final base = ColorScheme.fromSeed(
      seedColor: primaryPink,
      brightness: Brightness.light,
      primary: primaryPink,
      onPrimary: Colors.white,
      secondary: primaryPinkDark,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: pageBackground,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1F2937),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF25D366),
        foregroundColor: Colors.white,
      ),
    );
  }
}
