import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Meal(
      id: id,
      date: value['date'].toDate(),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': Timestamp.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch),
      'comment': comment,
    };
  }
}
