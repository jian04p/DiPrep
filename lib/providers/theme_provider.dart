import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get themeMode => _mode;
  bool get isDarkMode => _mode == ThemeMode.dark;

  void setDarkMode() {
    _mode = ThemeMode.dark;
    notifyListeners();
  }

  void setLightMode() {
    _mode = ThemeMode.light;
    notifyListeners();
  }

  void setSystemMode() {
    _mode = ThemeMode.system;
    notifyListeners();
  }

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
