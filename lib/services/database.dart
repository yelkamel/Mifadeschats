import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mifadeschats/models/meal.dart';
import 'package:mifadeschats/models/pet.dart';
import 'package:mifadeschats/services/api_path.dart';
import 'package:mifadeschats/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

abstract class Database {
  Future<void> setPet(Pet pet);
  Future<void> deletePet(Pet pet);
  Stream<List<Pet>> petsStream();
  Stream<Pet> petStream({@required String petId});

  Future<void> setMeal(Meal meal);
  Future<void> deleteMeal(Meal meal);
  Stream<List<Meal>> mealsStream({Pet pet});
}

String documentUniqueId() {
  String id = Uuid().v1();
  return id;
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setPet(Pet pet) async => await _service.setData(
        path: APIPath.pet(uid, pet.id),
        data: pet.toMap(),
      );

  @override
  Future<void> deletePet(Pet pet) async {
    final allMeal = await mealsStream(pet: pet).first;
    for (Meal meal in allMeal) {
      // if (meal.petId == pet.id) {
      //   await deleteMeal(meal);
      // }
    }
    // delete pet
    await _service.deleteData(path: APIPath.pet(uid, pet.id));
  }

  @override
  Stream<Pet> petStream({@required String petId}) => _service.documentStream(
        builder: (data, documentId) => Pet.fromMap(data, documentId),
        path: APIPath.pet(uid, petId),
      );

  @override
  Stream<List<Pet>> petsStream() => _service.collectionStream(
        path: APIPath.pets(uid),
        builder: (data, documentId) => Pet.fromMap(data, documentId),
      );

  @override
  Future<void> setMeal(Meal meal) async => await _service.setData(
        path: APIPath.meal(uid, meal.id),
        data: meal.toMap(),
      );

  @override
  Future<void> deleteMeal(Meal meal) async =>
      await _service.deleteData(path: APIPath.meal(uid, meal.id));

  @override
  Stream<List<Meal>> mealsStream({Pet pet}) => _service.collectionStream<Meal>(
        path: APIPath.meals(uid),
        queryBuilder: pet != null
            ? (query) => query.where('petId', isEqualTo: pet.id)
            : null,
        builder: (data, documentID) {
          // print("documentID: $documentID - data: $data");
          return Meal.fromMap(data, documentID);
        },
        // sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
