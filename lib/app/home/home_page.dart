import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/app/home/meals/meals_page.dart';
import 'package:mifadeschats/app/home/pets/pets_page.dart';
import 'package:mifadeschats/common_widgets/menu/slider_side_menu.dart';

import 'account/account_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  Widget _buildPage(BuildContext context) {
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
          _buildPage(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: CurvedNavigationBar(
              color: Colors.orangeAccent,
              buttonBackgroundColor: Colors.orangeAccent,
              backgroundColor: Colors.transparent,
              items: <Widget>[
                Icon(
                  Icons.pets,
                  size: 30,
                  color: Colors.orange[900],
                ),
                Icon(
                  Icons.fastfood,
                  size: 30,
                  color: Colors.orange[900],
                ),
                Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.orange[900],
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
