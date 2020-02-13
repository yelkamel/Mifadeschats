import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/common_widgets/format.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mifadeschats/models/meal.dart';

class MealItem extends StatelessWidget {
  const MealItem({@required this.meal, this.onDelete});
  final Meal meal;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Supprimer',
          color: Colors.red[400],
          icon: Icons.delete,
          onTap: onDelete,
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(Format.date(meal.date),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    )),
                if (meal.comment != null)
                  Text(
                    meal.comment,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
              ],
            ),
            Text(Format.time(meal.date), style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
