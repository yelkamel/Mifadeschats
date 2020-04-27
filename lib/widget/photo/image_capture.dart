import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mifadeschats/widget/photo/uploader.dart';

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  final String path;

  const ImageCapture({Key key, @required this.path}) : super(key: key);
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_imageFile != null) {
      return (Column(
        children: <Widget>[
          Image.file(_imageFile),
          Uploader(
            file: _imageFile,
            path: widget.path,
          )
        ],
      ));
    }

    return IconButton(
      icon: Icon(
        Icons.photo_library,
        size: 40,
      ),
      onPressed: () => _pickImage(ImageSource.gallery),
    );

    // Preview the image and crop it
  }
}
