import 'package:cloud_firestore/cloud_firestore.dart';

class Mifa {
  final String id;
  final String name;
  final DateTime lastMealDate;
  final int nbOfMeal;

  Mifa({
    this.id,
    this.name,
    this.lastMealDate,
    this.nbOfMeal = 0,
  });

  factory Mifa.fromMap(Map<String, dynamic> data, String mifaId) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final DateTime lastMealDate = data['lastMealDate'].toDate();
    final int nbOfMeal = data['nbOfMeal'];

    return Mifa(
      name: name,
      id: mifaId,
      lastMealDate: lastMealDate,
      nbOfMeal: nbOfMeal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'lastMealDate': Timestamp.fromMicrosecondsSinceEpoch(
          lastMealDate.microsecondsSinceEpoch),
      'nbOfMeal': nbOfMeal,
    };
  }
}
