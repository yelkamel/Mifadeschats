import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class Storage {
  Future loadImage(String path);
}

class FirestoreStorage implements Storage {
  FirebaseApp app;
  FirebaseStorage storage;

  FirestoreStorage() {
    init();
  }

  init() async {
    // Firebase Init
    FirebaseApp app = await FirebaseApp.configure(
      name: 'mifadeschats',
      options: FirebaseOptions(
        googleAppID: Platform.isIOS
            ? '1:736053778621:ios:0bee8f472c28d5e17effd4'
            : '1:736053778621:android:29cebaabbcf852777effd4',
        apiKey: 'AIzaSyAwMRk6Nj3oevO4HJ_nQ6LaBxZgoFh7svA',
        projectID: 'mifadeschats',
      ),
    );
    storage = FirebaseStorage(
      app: app,
      storageBucket: 'gs://mifadeschats.appspot.com/',
    );
  }

  Future loadImage(String path) async {
    final StorageReference ref = storage.ref().child(path);

    print('PATH $path');
    if (ref != null) {
      return await ref.getDownloadURL();
    }

    return null;
  }
}
