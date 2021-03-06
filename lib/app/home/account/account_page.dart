import 'package:flutter/material.dart';
import 'package:mifadeschats/app/sign_in/auth_bloc_provider.dart';
import 'package:mifadeschats/widget/card/card_dark_mode_switch.dart';
import 'package:mifadeschats/widget/card/card_notification.dart';
import 'package:mifadeschats/widget/platform_alert_dialog.dart';
import 'package:mifadeschats/widget/utils/restart_app.dart';
import 'package:mifadeschats/models/user.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final authbloc = AuthBlocProvider.of(context);
      authbloc.signOut().then((res) {
        RestartWidget.restartApp(context);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Déconnexion',
      content: 'Êtes-vous sur de vouloir vous déconnecter ?',
      cancelActionText: 'Annuler',
      defaultActionText: 'Déconnexion',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    TextStyle textStyle = TextStyle(
      fontSize: 24,
      fontFamily: 'Apercu',
      fontWeight: FontWeight.w800,
      color: Colors.white70,
    );
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Text(user.name, style: textStyle),
          actions: <Widget>[
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.exit_to_app,
                  size: 40,
                  color: Colors.white70,
                ),
              ),
              onTap: () => _confirmSignOut(context),
            )
          ],
          bottom: null,
        ),
        body: Column(
          children: <Widget>[
            CardDarkModeSwitch(
              onTap: () {},
            ),
            CardNotification()
          ],
        )

        /* ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: AppTheme.values.length,
        itemBuilder: (context, index) {
          final AppTheme itemApptheme = AppTheme.values[index];

          return Card(
            color: appThemeData[itemApptheme].primaryColor,
            child: ListTile(
              title: Text(
                itemApptheme.toString(),
                style: appThemeData[itemApptheme].textTheme.body1,
              ),
              onTap: () {
                _themeChanger.setTheme(appThemeData[itemApptheme]);
              },
            ),
          );
        },
      ), */
        );
  }
}
