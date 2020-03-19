import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationChanger with ChangeNotifier {
  FlutterLocalNotificationsPlugin service;
  bool allowNotification = false;

  NotificationChanger({@required this.service}) {
    init();
  }

  FlutterLocalNotificationsPlugin getNotificationService() => service;

  bool hasNotification() => allowNotification;

  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    allowNotification = prefs.getBool('hasNotification') ?? false;

    notifyListeners();
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

  void switchNotification(value) async {
    allowNotification = value;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("hasNotification", value).then((bool succ) {
      print("=>sauvegarde SharePreference hasNotification:$succ");
    });

    notifyListeners();
  }
}
