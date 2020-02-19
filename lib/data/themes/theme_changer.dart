import 'package:flutter/material.dart';

import 'app_themes.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  bool darkMode = false;

  ThemeChanger(this._themeData);

  ThemeData getTheme() => _themeData;

  void setTheme(ThemeData theme) {
    _themeData = theme;

    notifyListeners();
  }

  bool isDark() => darkMode == true;

  void switchToDark(value) {
    darkMode = value;
    if (value) {
      _themeData = appThemeData[AppTheme.OrangeDark];
    } else {
      _themeData = appThemeData[AppTheme.OrangeLight];
    }
    notifyListeners();
  }
}
