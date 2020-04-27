import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mifadeschats/app/sign_in/auth_bloc_provider.dart';
import 'package:mifadeschats/widget/utils/restart_app.dart';
import 'package:mifadeschats/services/singleton/locator.dart';
import 'package:mifadeschats/splashscreen.dart';
import 'package:provider/provider.dart';

import 'themes/theme_changer.dart';

void main() async {
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();

  // Date formating init
  initializeDateFormatting();

  // Blocker l'orientation vertical
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Navigation color change
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.orangeAccent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(RestartWidget(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin localNotificationPlugin;

  const MyApp({Key key, this.localNotificationPlugin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(),
      child: MyAppWithAppProvider(),
    );
  }
}

class MyAppWithAppProvider extends StatelessWidget {
  const MyAppWithAppProvider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return AuthBlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mifa Des Chats',
        theme: theme.getTheme(),
        home: Container(
          color: Colors.orange[200],
          child: SplashScreen(),
        ),
      ),
    );
  }
}
