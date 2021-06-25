import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{
  bool isDark = false;

  void changeMode(){
    isDark = !isDark;
    print(isDark);
    notifyListeners();
  }
  
  static final ThemeData lightTheme = ThemeData.light();
  static final ThemeData darkTheme = ThemeData.dark();
}