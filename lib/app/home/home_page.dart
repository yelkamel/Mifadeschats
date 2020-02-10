import 'package:flutter/cupertino.dart';
import 'package:mifadeschats/app/home/meals/meals_page.dart';
import 'package:mifadeschats/app/home/tab_item.dart';
import 'package:mifadeschats/app/pets/pets_page.dart';

import 'account/account_page.dart';
import 'cupertino_home_scaffold.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.pets;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.pets: GlobalKey<NavigatorState>(),
    TabItem.meals: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.pets: (_) => PetsPage(),
      TabItem.meals: (context) => MealsPage.create(context),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
