
import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF203A2A);
  static const cream = Color(0xFFF2E5C8);
  static const saffron = Color(0xFFE68B22);
  static const charcoal = Color(0xFF171A16);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: green,
        primary: green,
        secondary: saffron,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: green,
        foregroundColor: cream,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          foregroundColor: cream,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
