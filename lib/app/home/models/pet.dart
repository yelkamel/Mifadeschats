import 'package:flutter/material.dart';

const Map<String, String> genderImages = {
  'female': 'assets/images/cat-female.png',
  'male': 'assets/images/cat-male.png',
};

class Pet {
  final String id;
  final String name;
  final int age;
  final String gender;

  factory Pet.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final int age = data['age'];
    final String gender = data['gender'];

    return Pet(id: documentId, gender: gender, age: age, name: name);
  }

  Pet(
      {@required this.id,
      @required this.name,
      @required this.gender,
      this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'age': age,
    };
  }
}
