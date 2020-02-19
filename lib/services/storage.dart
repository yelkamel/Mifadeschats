import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

abstract class Storage {
  Future loadImage(String path);
}

class FirestoreStorage implements Storage {
  final FirebaseApp app;
  FirebaseStorage storage;

  FirestoreStorage({@required this.app}) {
    storage = FirebaseStorage(
      app: app,
      storageBucket: 'gs://mifadeschats.appspot.com/',
    );
  }

  Future loadImage(String path) async {
    final StorageReference ref = storage.ref().child(path);

    if (ref != null) {
      return await ref.getDownloadURL();
    }

    return null;
  }
}
