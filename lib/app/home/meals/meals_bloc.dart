import 'package:flutter/foundation.dart';
import 'package:mifadeschats/app/home/meals/daily_pets_details.dart';
import 'package:mifadeschats/app/home/meals/meals_list_tile.dart';
import 'package:mifadeschats/app/home/models/meal.dart';
import 'package:mifadeschats/app/home/models/pet.dart';
import 'package:mifadeschats/app/home/pet_meals/format.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:rxdart/rxdart.dart';

import 'meal_pet.dart';

class MealsBloc {
  MealsBloc({@required this.database});
  final Database database;

  /// combine List<Job>, List<Entry> into List<MealPet>
  Stream<List<MealPet>> get _allMealsStream => Observable.combineLatest2(
        database.mealsStream(),
        database.petsStream(),
        _mealsJobsCombiner,
      );

  static List<MealPet> _mealsJobsCombiner(List<Meal> meals, List<Pet> pets) {
    return meals.map((meal) {
      final pet = pets.firstWhere((pet) => pet.id == meal.petId);
      return MealPet(meal, pet);
    }).toList();
  }

  /// Output stream
  Stream<List<MealsListTileModel>> get mealsTileModelStream =>
      _allMealsStream.map(_createModels);

  static List<MealsListTileModel> _createModels(List<MealPet> allMeals) {
    final allDailyMealsDetails = DailyPetsDetails.all(allMeals);

    // total duration across all jobs
    final totalDuration = allDailyMealsDetails
        .map((dateJobsDuration) => dateJobsDuration.duration)
        .reduce((value, element) => value + element);

    // total pay across all jobs
    final totalPay = allDailyMealsDetails
        .map((dateJobsDuration) => dateJobsDuration.pay)
        .reduce((value, element) => value + element);

    return <MealsListTileModel>[
      MealsListTileModel(
        leadingText: 'All Meals',
        middleText: Format.currency(totalPay),
        trailingText: Format.hours(totalDuration),
      ),
      for (DailyPetsDetails dailyJobsDetails in allDailyMealsDetails) ...[
        MealsListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyJobsDetails.date),
          middleText: Format.currency(dailyJobsDetails.pay),
          trailingText: Format.hours(dailyJobsDetails.duration),
        ),
        for (PetDetails jobDuration in dailyJobsDetails.petsDetails)
          MealsListTileModel(
            leadingText: jobDuration.name,
            middleText: Format.currency(jobDuration.pay),
            trailingText: Format.hours(jobDuration.durationInHours),
          ),
      ]
    ];
  }
}
