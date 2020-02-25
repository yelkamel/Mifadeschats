import 'package:flutter/material.dart';
import 'package:mifadeschats/components/avatar.dart';
import 'package:mifadeschats/components/card/card_dark_mode_switch.dart';
import 'package:mifadeschats/components/card/card_notification.dart';
import 'package:mifadeschats/components/platform_alert_dialog.dart';
import 'package:mifadeschats/data/themes/theme_changer.dart';
import 'package:mifadeschats/models/user.dart';
import 'package:mifadeschats/services/auth.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
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

  Widget _buildSwitchDark() {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 100,
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
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
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(130),
              child: Container() // _builderUserInfo(user),
              ),
        ),
        body: Column(
          children: <Widget>[
            CardDarkModeSwitch(
              value: _themeChanger.isDark(),
              onTap: (value) => _themeChanger.switchToDark(value),
            ),
            CardNotification(
              value: true,
              onTap: (value) => value,
            )
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
/*
  Widget _builderUserInfo(User user) {
    return Column(children: [
      Avatar(
        photoUrl: user.photoUrl,
        radius: 50,
      ),
      SizedBox(height: 8),
      if (user.name != null)
        Text(user.displayName, style: TextStyle(color: Colors.white)),
      SizedBox(height: 8),
    ]);
  }
  */
}
