import 'package:flutter/material.dart';
import 'package:mifadeschats/themes/theme_changer.dart';
import 'package:provider/provider.dart';

class CardDarkModeSwitch extends StatelessWidget {
  final bool value;
  final Function onTap;

  const CardDarkModeSwitch(
      {Key key, @required this.value, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

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
                  _themeChanger.isDark() ? 'Activer' : 'Désactiver',
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
                  'Mode nuit',
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
                value: _themeChanger.isDark(),
                onChanged: (value) => _themeChanger.switchToDark(value),
              ),
              onTap: () => _themeChanger.switchToDark(!_themeChanger.isDark()),
            )
          ],
        ),
      ),
    );
  }
}
