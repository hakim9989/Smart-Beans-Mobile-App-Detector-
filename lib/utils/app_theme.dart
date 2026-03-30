import 'package:flutter/material.dart';

/// App theme configurations
class AppTheme {
  // Theme colors
  static const Map<String, Color> themeColors = {
    'green': Colors.green,
    'blue': Colors.blue,
    'purple': Colors.purple,
    'orange': Colors.orange,
    'teal': Colors.teal,
    'pink': Colors.pink,
  };

  static ThemeData getTheme(String colorName, bool isDark) {
    final Color seedColor = themeColors[colorName] ?? Colors.green;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? null : seedColor,
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static LinearGradient getGradient(String colorName, bool isDark) {
    final Color seedColor = themeColors[colorName] ?? Colors.green;
    
    if (isDark) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF212121),
          Colors.black,
        ],
      );
    }
    
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        seedColor.withValues(alpha: 0.1),
        Colors.white,
      ],
    );
  }

  static Color getPrimaryColor(String colorName) {
    return themeColors[colorName] ?? Colors.green;
  }
}
