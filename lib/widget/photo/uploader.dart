import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Uploader extends StatefulWidget {
  final File file;
  final String path;

  const Uploader({Key key, this.file, this.path}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://mifadeschats.appspot.com');

  StorageUploadTask _uploadTask;

    @required
  void initState() {
    super.initState();
    setState(() {
      _uploadTask = _storage.ref().child(widget.path).putFile(widget.file);
    });
      }

  /// Starts an upload task
  /*
  void _startUpload() {
    setState(() {
      _uploadTask = _storage.ref().child(widget.path).putFile(widget.file);
    });
  }
  */

  @override
  Widget build(BuildContext context) {
 //   if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: [
                // if (_uploadTask.isComplete) Text('🎉🎉🎉'),

                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),

                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                // Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              ],
            );
          });
   /* } else {
      // Allows user to decide when to start the upload
      return FlatButton.icon(
        label: Text('Upload to Firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    } */
  }
}
