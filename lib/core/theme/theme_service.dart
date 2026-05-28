import 'package:flutter/material.dart';
import 'src/app_theme_data.dart';

export 'src/app_colors.dart';
export 'src/app_text_styles.dart';

class ThemeService extends ChangeNotifier {
  // Singleton pattern
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    _saveTheme(isOn);
  }

  // Placeholder for persistence logic (e.g., SharedPreferences)
  void _saveTheme(bool isDark) {
    // TODO: Implement actual storage logic here
  }

  ThemeData get lightTheme => AppThemeData.lightTheme;
  ThemeData get darkTheme => AppThemeData.darkTheme;
}
