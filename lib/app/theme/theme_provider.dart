
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'is_dark_mode';

  bool _isDarkMode = false;
  bool _isLoaded = false;

  bool get isDarkMode => _isDarkMode;
  bool get isLoaded => _isLoaded;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      _isDarkMode = preferences.getBool(_themeKey) ?? false;
    } catch (error) {
      debugPrint('Error loading theme preference: $error');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_themeKey, _isDarkMode);
    } catch (error) {
      debugPrint('Error saving theme preference: $error');
    }
  }

  ThemeMode get themeMode =>
      _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}

