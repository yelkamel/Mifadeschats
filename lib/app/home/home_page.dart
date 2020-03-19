import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/app/home/meals/meals_page.dart';
import 'package:mifadeschats/app/home/pets/pets_page.dart';


import 'account/account_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex;

  @required
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:
        return PetsPage();
      case 1:
        return MealsPage();
      default:
        return AccountPage();
    }
  }

  void setPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildPage(),
          Align(
            alignment: Alignment.bottomCenter,
            child: CurvedNavigationBar(
              color: Theme.of(context).bottomAppBarColor,
              buttonBackgroundColor: Theme.of(context).bottomAppBarColor,
              backgroundColor: Colors.transparent,
              index: _currentIndex,
              items: <Widget>[
                Icon(
                  Icons.pets,
                  size: Theme.of(context).accentIconTheme.size,
                  color: Theme.of(context).accentIconTheme.color,
                ),
                Icon(
                  Icons.fastfood,
                  size: Theme.of(context).accentIconTheme.size,
                  color: Theme.of(context).accentIconTheme.color,
                ),
                Icon(
                  Icons.person,
                  size: Theme.of(context).accentIconTheme.size,
                  color: Theme.of(context).accentIconTheme.color,
                ),
              ],
              onTap: setPage,
            ),
          )
        ],
      ),
    );
  }
}
