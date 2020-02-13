import 'package:flutter/foundation.dart';

class Meal {
  Meal({
    @required this.id,
    @required this.date,
    this.comment,
  });

  String id;
  DateTime date;
  String comment;

  factory Meal.fromMap(Map<dynamic, dynamic> value, String id) {
    final int dateInTimeStamp = value['date'];
    return Meal(
      id: id,
      date: DateTime.fromMillisecondsSinceEpoch(dateInTimeStamp),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
