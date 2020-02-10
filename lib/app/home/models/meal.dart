import 'package:flutter/foundation.dart';

class Meal {
  Meal({
    @required this.id,
    @required this.petId,
    @required this.start,
    @required this.end,
    this.comment,
  });

  String id;
  String petId;
  DateTime start;
  DateTime end;
  String comment;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory Meal.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    return Meal(
      id: id,
      petId: value['petId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'petId': petId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
