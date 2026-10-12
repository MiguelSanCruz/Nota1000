import 'package:flutter/material.dart' as material show ChangeNotifier;

class AppTheme extends material.ChangeNotifier {

  AppTheme._();

  static final AppTheme instance = AppTheme._();

  bool isDarkMode = false;
  changeTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}