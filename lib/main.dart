import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mifadeschats/data/notification/local_notification.dart';
import 'package:mifadeschats/data/themes/app_themes.dart';
import 'package:mifadeschats/data/themes/theme_changer.dart';
import 'package:mifadeschats/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:mifadeschats/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Date formating init
  initializeDateFormatting();

  // Blocker l'orientation vertical
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Navigation color change
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.deepOrange,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Firebase Init
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
  // END

  //  Local Notification Init
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: null);
  // END

  runApp(MyApp(
    app: app,
    localNotificationPlugin: flutterLocalNotificationsPlugin,
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseApp app;
  final FlutterLocalNotificationsPlugin localNotificationPlugin;

  const MyApp({Key key, this.app, this.localNotificationPlugin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationChanger>(
      create: (_) => NotificationChanger(service: localNotificationPlugin),
      child: ChangeNotifierProvider<ThemeChanger>(
        create: (_) => ThemeChanger(appThemeData[AppTheme.OrangeLight]),
        child: MyAppWithAppProvider(app: app),
      ),
    );
  }
}

class MyAppWithAppProvider extends StatelessWidget {
  final FirebaseApp app;

  const MyAppWithAppProvider({Key key, this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mifa Des Chats',
        theme: theme.getTheme(),
        home: Container(
          color: Colors.orange[200],
          child: SplashScreen(app: app),
        ),
      ),
    );
  }
}
