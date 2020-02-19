import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/data/themes/app_themes.dart';
import 'package:mifadeschats/data/themes/theme_changer.dart';
import 'package:provider/provider.dart';
import 'package:mifadeschats/app/landing_page.dart';
import 'package:mifadeschats/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseApp app = await FirebaseApp.configure(
    name: 'mifadeschats',
    options: FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:736053778621:ios:42c6dcd81e9c79777effd4'
          : '1:736053778621:android:29cebaabbcf852777effd4',
      apiKey: 'AIzaSyAwMRk6Nj3oevO4HJ_nQ6LaBxZgoFh7svA',
      projectID: 'mifadeschats',
    ),
  );

  runApp(MyApp(app: app));
}

class MyApp extends StatelessWidget {
  final FirebaseApp app;

  const MyApp({Key key, this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(appThemeData[AppTheme.OrangeLight]),
      child: MyAppWithTheme(app: app),
    );
  }
}

class MyAppWithTheme extends StatelessWidget {
  final FirebaseApp app;

  const MyAppWithTheme({Key key, this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Mifa Des Chats',
        theme: theme.getTheme(),
        home: LandingPage(app: app),
      ),
    );
  }
}
