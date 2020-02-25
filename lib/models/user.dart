import 'package:flutter/material.dart';

class User {
  final String uid;
  final String name;
  final String mifaId;

  User({
    this.uid,
    this.name,
    this.mifaId = '',
  });

  factory User.fromMap(Map<String, dynamic> data, String uid) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final String mifaId = data['mifaId'];

    return User(
      uid: uid,
      name: name,
      mifaId: mifaId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'mifaId': mifaId,
    };
  }
}
