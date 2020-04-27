import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mifadeschats/services/singleton/shared_preferences.dart';

import 'app_themes.dart';

GetIt getIt = GetIt.instance;

class ThemeChanger with ChangeNotifier {
  ThemeData themeData;
  bool darkMode = false;

  ThemeChanger() {
    init();
  }

  void init() async {
    String appTheme = await getIt.get<SharedPref>().getAppTheme();

    print("appTheme $appTheme");

    switch (appTheme) {
      case 'dark':
        themeData = appThemeData[AppTheme.OrangeDark];
        darkMode = true;
        break;
      default:
        themeData = appThemeData[AppTheme.OrangeLight];
        break;
    }

    notifyListeners();
  }

  ThemeData getTheme() => themeData;

  void setTheme(ThemeData theme) {
    themeData = theme;

    notifyListeners();
  }

  bool isDark() => darkMode == true;

  void switchToDark(value) {
    darkMode = value;
    String appTheme = 'dark';
    if (value) {
      themeData = appThemeData[AppTheme.OrangeDark];
    } else {
      appTheme = 'ligth';
      themeData = appThemeData[AppTheme.OrangeLight];
    }
    getIt.get<SharedPref>().setAppTheme(appTheme);
    notifyListeners();
  }
}
