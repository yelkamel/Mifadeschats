import 'package:flutter/foundation.dart';

import 'meal_pet.dart';

/// Temporary model class to store the time tracked and pay for a job
class PetDetails {
  PetDetails({
    @required this.name,
    @required this.durationInHours,
    @required this.pay,
  });
  final String name;
  double durationInHours;
  double pay;
}

/// Groups together all jobs/entries on a given day
class DailyPetsDetails {
  DailyPetsDetails({@required this.date, @required this.petsDetails});
  final DateTime date;
  final List<PetDetails> petsDetails;

  double get pay => petsDetails
      .map((jobDuration) => jobDuration.pay)
      .reduce((value, element) => value + element);

  double get duration => petsDetails
      .map((jobDuration) => jobDuration.durationInHours)
      .reduce((value, element) => value + element);

  /// splits all entries into separate groups by date
  static Map<DateTime, List<MealPet>> _entriesByDate(List<MealPet> entries) {
    Map<DateTime, List<MealPet>> map = {};
    for (var mealPet in entries) {
      final entryDayStart = DateTime(mealPet.meal.start.year,
          mealPet.meal.start.month, mealPet.meal.start.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [mealPet];
      } else {
        map[entryDayStart].add(mealPet);
      }
    }
    return map;
  }

  /// maps an unordered list of MealPet into a list of DailyPetsDetails with date information
  static List<DailyPetsDetails> all(List<MealPet> entries) {
    final byDate = _entriesByDate(entries);
    List<DailyPetsDetails> list = [];
    for (var date in byDate.keys) {
      final entriesByDate = byDate[date];
      final byPet = _jobsDetails(entriesByDate);
      list.add(DailyPetsDetails(date: date, petsDetails: byPet));
    }
    return list.toList();
  }

  /// groups entries by job
  static List<PetDetails> _jobsDetails(List<MealPet> entries) {
    Map<String, PetDetails> jobDuration = {};
    for (var mealPet in entries) {
      final meal = mealPet.meal;
      final pay = meal.durationInHours * mealPet.pet.age;
      if (jobDuration[meal.petId] == null) {
        jobDuration[meal.petId] = PetDetails(
          name: mealPet.pet.name,
          durationInHours: meal.durationInHours,
          pay: pay,
        );
      } else {
        jobDuration[meal.petId].pay += pay;
        jobDuration[meal.petId].durationInHours += meal.durationInHours;
      }
    }
    return jobDuration.values.toList();
  }
}
