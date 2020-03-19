import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mifadeschats/data/notification/local_notification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardNotification extends StatefulWidget {
  final bool value;
  final Function onTap;

  const CardNotification({Key key, @required this.value, @required this.onTap})
      : super(key: key);

  @override
  _CardNotificationState createState() => _CardNotificationState();
}

class _CardNotificationState extends State<CardNotification> {
  @override
  Widget build(BuildContext context) {
    final notificationService =
        Provider.of<NotificationChanger>(context, listen: false);
    return Card(
      margin: Theme.of(context).cardTheme.margin,
      shape: Theme.of(context).cardTheme.shape,
      elevation: Theme.of(context).cardTheme.elevation,
      color: Theme.of(context).cardTheme.color,
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 15, top: 15, left: 15, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.value ? 'Désactiver' : 'Activer',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontFamily: 'Apercu',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Notification',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontFamily: 'Apercu',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Switch(
              value: notificationService.allowNotification,
              onChanged: (value) {
                notificationService.switchNotification(value);
                if (value) {
                  notificationService.requestIOSPermissions();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
