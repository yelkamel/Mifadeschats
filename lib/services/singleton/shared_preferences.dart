import 'package:shared_preferences/shared_preferences.dart';

class StoragePref {
  static const String allowNotif = "allowNotif";
  static const String appTheme = "appTheme";
}

class SharedPref {
  Future<bool> getAllowsNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StoragePref.allowNotif) ?? false;
  }

  Future<bool> setAllowsNotifications(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(StoragePref.allowNotif, value);
  }

  Future<String> getAppTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(StoragePref.appTheme) ?? 'dark';
  }

  Future<bool> setAppTheme(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(StoragePref.appTheme, value);
  }
}
