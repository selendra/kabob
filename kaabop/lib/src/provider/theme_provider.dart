import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  void changeMode() async {
    isDark = !isDark;

    if (isDark) await StorageServices.setData('dark', 'dark');

    if (!isDark) await StorageServices.removeKey('dark');

    notifyListeners();
  }

  static final ThemeData lightTheme = ThemeData.light();
  static final ThemeData darkTheme = ThemeData.dark();
}
