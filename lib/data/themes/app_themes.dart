import 'package:flutter/material.dart';

enum AppTheme {
  OrangeLight,
  OrangeDark,
}

// import CustomColorScheme, le fichier pour utiliser ces custome couleur ;)
extension CustomColorScheme on ColorScheme {
  Color get toto => Colors.teal;
  Color get info => const Color(0xFF17a2b8);
  Color get warning => const Color(0xFFffc107);
  Color get danger => const Color(0xFFdc3545);
}

final appThemeData = {
  AppTheme.OrangeLight: ThemeData(
    brightness: Brightness.light,
    errorColor: Colors.red[700],
    primaryColor: Colors.orange,
    canvasColor: Colors.deepOrange,
    primaryColorLight: Colors.orange[600],
    primaryColorDark: Colors.orange[900],
    accentColor: Colors.orangeAccent,
    backgroundColor: Colors.orange[200],
    bottomAppBarColor: Colors.orangeAccent,
    cardColor: Colors.white70,
    buttonColor: Colors.orange[400],
    disabledColor: Colors.deepOrange,
    secondaryHeaderColor: Colors.orangeAccent,
    accentIconTheme: IconThemeData(
      color: Colors.white70,
      size: 25,
    ),
    cardTheme: CardTheme(
      color: Colors.orange[100],
      margin: EdgeInsets.all(20),
      elevation: 8,
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    fontFamily: 'Apercu',
  ),
  AppTheme.OrangeDark: ThemeData(
    brightness: Brightness.dark,
    canvasColor: Colors.deepOrange,
    primaryColor: Colors.orange,
    primaryColorLight: Colors.orange[600],
    primaryColorDark: Colors.orange[900],
    accentColor: Colors.deepOrange,
    backgroundColor: Colors.orange[900],
    cardColor: Colors.white70,
    buttonColor: Colors.orange[400],
    disabledColor: Colors.deepOrange,
    cardTheme: CardTheme(
      color: Colors.orange[400],
      margin: EdgeInsets.all(20),
      elevation: 8,
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    accentIconTheme: IconThemeData(
      color: Colors.white70,
      size: 25,
    ),
  ),
};
