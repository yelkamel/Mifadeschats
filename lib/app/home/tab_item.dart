import 'package:flutter/material.dart';

enum TabItem { pets, meals, account }

class TabItemData {
  final String title;
  final IconData icon;

  const TabItemData({this.title, this.icon});

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.pets: TabItemData(title: 'Pets', icon: Icons.pets),
    TabItem.meals: TabItemData(title: 'Repas', icon: Icons.fastfood),
    TabItem.account: TabItemData(title: 'Compte', icon: Icons.person),
  };
}
