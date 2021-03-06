import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String photoUrl;
  final double radius;

  Avatar({this.photoUrl, @required this.radius});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black54, width: 3),
      ),
      child: CircleAvatar(
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
        backgroundColor: Colors.black12,
        radius: radius,
        child: photoUrl == null
            ? Icon(
                Icons.camera_alt,
                size: radius,
              )
            : null,
      ),
    );
  }
}
