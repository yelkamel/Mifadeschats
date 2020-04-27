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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 32,
                fontFamily: 'Apercu',
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 15),
          Text(
            message,
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Apercu',
                color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
