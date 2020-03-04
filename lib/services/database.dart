import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mifadeschats/models/meal.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/models/pet.dart';
import 'package:mifadeschats/models/user.dart';
import 'package:mifadeschats/services/api_path.dart';
import 'package:mifadeschats/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

abstract class Database {
  Future<void> setPet(String mifaId, Pet pet);
  Future<void> deletePet(String mifaId, Pet pet);
  Stream<List<Pet>> petsStream(String mifaId);
  Stream<Pet> petStream(String mifaId, String petId);
  Future<List<Pet>> getPetFromMifa(String mifaId);

  Stream<Mifa> mifaStream(String mifaId);
  Stream<List<Mifa>> allMifaStream();
  Future<void> setMifa(Mifa mifa);
  Stream<List<Mifa>> mifaLikeStream(String mifaName);
  Future<List<Mifa>> getAllMifa();

  Stream<User> userStream();
  Future<void> setUser(User user);

  Future<void> setMeal(String mifaId, Meal meal);
  Future<void> deleteMeal(String mifaId, Meal meal);
  Stream<List<Meal>> mealsStream(String mifaId, Pet pet);
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
  Future<void> setUser(User user) async => await _service.setData(
        path: APIPath.user(uid),
        data: user.toMap(),
      );

  @override
  Stream<User> userStream() => _service.documentStream(
        builder: (data, uid) => User.fromMap(data, uid),
        path: APIPath.user(uid),
      );

  @override
  Future<void> setMifa(Mifa mifa) async => await _service.setData(
        path: APIPath.mifa(mifa.id),
        data: mifa.toMap(),
      );

  @override
  Stream<Mifa> mifaStream(String mifaId) => _service.documentStream(
        builder: (data, mifaId) => Mifa.fromMap(data, mifaId),
        path: APIPath.mifa(mifaId),
      );

  @override
  Future<List<Pet>> getPetFromMifa(String mifaId) => _service.getCollection(
        builder: (data, documentId) => Pet.fromMap(data, documentId),
        path: APIPath.pets(mifaId),
      );

  @override
  Future<List<Mifa>> getAllMifa() => _service.getCollection(
        builder: (data, documentId) => Mifa.fromMap(data, documentId),
        path: APIPath.mifas(),
      );

  @override
  Stream<List<Mifa>> allMifaStream() => _service.collectionStream(
        builder: (data, documentId) => Mifa.fromMap(data, documentId),
        path: APIPath.mifas(),
      );

  @override
  Stream<List<Mifa>> mifaLikeStream(String mifaName) =>
      _service.collectionStream<Mifa>(
        sort: (mifa1, mifa2) => mifa1.name.compareTo(mifa2.name),
        path: APIPath.mifas(),
        queryBuilder: mifaName != null
            ? (query) => query.where('name', isLessThanOrEqualTo: mifaName)
            : null,
        builder: (data, documentId) {
          return Mifa.fromMap(data, documentId);
        },
      );

  @override
  Future<void> setPet(String mifaId, Pet pet) async => await _service.setData(
        path: APIPath.pet(mifaId, pet.id),
        data: pet.toMap(),
      );

  @override
  Future<void> deletePet(String mifaId, Pet pet) async {
    final allMeal = await mealsStream(mifaId, pet).first;
    for (Meal meal in allMeal) {
      // if (meal.petId == pet.id) {
      //   await deleteMeal(meal);
      // }
    }
    // delete pet
    await _service.deleteData(path: APIPath.pet(mifaId, pet.id));
  }

  @override
  Stream<Pet> petStream(String mifaId, String petId) => _service.documentStream(
        builder: (data, documentId) => Pet.fromMap(data, documentId),
        path: APIPath.pet(mifaId, petId),
      );

  @override
  Stream<List<Pet>> petsStream(String mifaId) => _service.collectionStream(
        builder: (data, documentId) => Pet.fromMap(data, documentId),
        path: APIPath.pets(mifaId),
      );

  @override
  Future<void> setMeal(String mifaId, Meal meal) async =>
      await _service.setData(
        path: APIPath.meal(mifaId, meal.id),
        data: meal.toMap(),
      );

  @override
  Future<void> deleteMeal(String mifaId, Meal meal) async =>
      await _service.deleteData(path: APIPath.meal(mifaId, meal.id));

  @override
  Stream<List<Meal>> mealsStream(String mifaId, Pet pet) =>
      _service.collectionStream<Meal>(
        path: APIPath.meals(mifaId),
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
