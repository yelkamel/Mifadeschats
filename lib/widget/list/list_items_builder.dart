import 'package:flutter/material.dart';

import 'empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  ListItemBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    this.lastItem,
    this.controller,
  }) : super(key: key);

  final ScrollController controller;
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final Widget lastItem;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Connexion internet interrompu',
        message: "Pas possible d'avoir la liste des animaux",
      );
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      controller: controller,
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(
        height: 0.5,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container();
        }
        if (index == items.length + 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 200.0),
            child: lastItem,
          );
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
