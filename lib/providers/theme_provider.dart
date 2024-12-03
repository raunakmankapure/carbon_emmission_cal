import 'package:flutter/material.dart';

import 'package:ridebuddy/config/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  late SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  ThemeData get lightTheme => ThemeConfig.lightTheme;
  ThemeData get darkTheme => ThemeConfig.darkTheme;

  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final isLight = _prefs.getBool(_themeKey) ?? true;
    _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await _prefs.setBool(_themeKey, !isDarkMode);
    notifyListeners();
  }
}
