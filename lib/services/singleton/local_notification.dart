import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:mifadeschats/services/singleton/shared_preferences.dart';

GetIt getIt = GetIt.instance;

class LocalNotification {
  FlutterLocalNotificationsPlugin service;
  bool allowNotification = false;

  LocalNotification() {
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

    init();
    service = flutterLocalNotificationsPlugin;
  }

  void init() async {
    Future.delayed(Duration(seconds: 2), () async {
      allowNotification =
          await getIt.get<SharedPref>().getAllowsNotifications();
    });
  }

  Future requestIOSPermissions() async {
    await service
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future setNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    DateTime scheduleDate = DateTime.now().add(Duration(days: 1));

    await service.schedule(
        0,
        'Nourir Les Chats',
        'Hier à cette heure ci vous les aviez nouri',
        scheduleDate,
        platformChannelSpecifics);
  }

  void switchNotificationValue(bool value) async {
    allowNotification = value;
    await getIt.get<SharedPref>().setAllowsNotifications(value);

    if (!value) {
      await service.cancelAll();
    }
  }
}
