import 'package:flutter/material.dart';
import 'package:mifadeschats/services/singleton/local_notification.dart';

class CardNotification extends StatefulWidget {
  const CardNotification({Key key}) : super(key: key);

  @override
  _CardNotificationState createState() => _CardNotificationState();
}

class _CardNotificationState extends State<CardNotification> {
  bool _enable;
  final LocalNotification localNotif = getIt.get<LocalNotification>();

  @override
  void initState() {
    super.initState();
    _enable = localNotif.allowNotification;
  }

  void onPressNotification(bool value) {
    if (!localNotif.allowNotification) {
      localNotif.requestIOSPermissions();
    }

    localNotif.switchNotificationValue(value);
    setState(() {
      _enable = value;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  localNotif.allowNotification ? 'Activer' : 'Désactiver',
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
            GestureDetector(
              child: Switch(
                activeColor: Theme.of(context).accentColor,
                value: _enable,
                onChanged: (value) => onPressNotification(value),
              ),
              onTap: () => onPressNotification(!_enable),
            )
          ],
        ),
      ),
    );
  }
}
