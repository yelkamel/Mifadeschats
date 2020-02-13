import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    this.title = 'Il y a R',
    this.message = 'Ajouter votre animal de compagnie pour commencer',
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 32, color: Colors.black54),
        ),
        Text(
          message,
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ],
    );
  }
}
