import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mifadeschats/services/singleton/firebase_storage.dart';

GetIt getIt = GetIt.instance;

class LoadPetDecoratorImage extends StatelessWidget {
  final String path;
  final Widget child;

  const LoadPetDecoratorImage({Key key, this.path, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIt.get<FirestoreStorage>().loadImage(path),
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

        return Container(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
