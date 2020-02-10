import 'package:flutter/material.dart';
import 'package:mifadeschats/app/home/pet_meals/format.dart';
import 'package:mifadeschats/app/home/models/meal.dart';
import 'package:mifadeschats/app/home/models/pet.dart';

class MealListItem extends StatelessWidget {
  const MealListItem({
    @required this.meal,
    @required this.pet,
    @required this.onTap,
  });

  final Meal meal;
  final Pet pet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dayOfWeek = Format.dayOfWeek(meal.start);
    final startDate = Format.date(meal.start);
    final startTime = TimeOfDay.fromDateTime(meal.start).format(context);
    final endTime = TimeOfDay.fromDateTime(meal.end).format(context);
    final durationFormatted = Format.hours(meal.durationInHours);

    final pay = pet.age * meal.durationInHours;
    final payFormatted = Format.currency(pay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(dayOfWeek, style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          SizedBox(width: 15.0),
          Text(startDate, style: TextStyle(fontSize: 18.0)),
          if (pet.age > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text('$startTime - $endTime', style: TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(durationFormatted, style: TextStyle(fontSize: 16.0)),
        ]),
        if (meal.comment.isNotEmpty)
          Text(
            meal.comment,
            style: TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleMealListItem extends StatelessWidget {
  const DismissibleMealListItem({
    this.key,
    this.meal,
    this.pet,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final Meal meal;
  final Pet pet;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: MealListItem(
        meal: meal,
        pet: pet,
        onTap: onTap,
      ),
    );
  }
}
