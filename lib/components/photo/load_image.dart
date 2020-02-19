import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mifadeschats/services/storage.dart';
import 'package:provider/provider.dart';

class LoadPetDecoratorImage extends StatelessWidget {
  final String path;
  final Widget child;

  const LoadPetDecoratorImage({Key key, this.path, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<Storage>(context, listen: false);
    return FutureBuilder(
      future: storage.loadImage(path),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.done) if (snapshot.data != null) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(snapshot.data),
                fit: BoxFit.cover,
              ),
            ),
            child: child,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting)
          return Container(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}
