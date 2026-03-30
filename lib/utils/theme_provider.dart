import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme provider for managing app theme state
class ThemeProvider extends ChangeNotifier {
  String _themeColor = 'green';
  bool _isDarkMode = false;
  
  String get themeColor => _themeColor;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadPreferences();
  }

  /// Load saved theme preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _themeColor = prefs.getString('themeColor') ?? 'green';
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  /// Set theme color
  Future<void> setThemeColor(String color) async {
    _themeColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeColor', color);
    notifyListeners();
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
