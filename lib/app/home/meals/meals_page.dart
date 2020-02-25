import 'package:flutter/material.dart';
import 'package:mifadeschats/components/button/awesome_button.dart';
import 'package:mifadeschats/components/list/list_items_builder.dart';
import 'package:mifadeschats/components/reponsive_safe_area.dart';
import 'package:mifadeschats/models/meal.dart';
import 'package:mifadeschats/utils/format.dart';
import 'package:provider/provider.dart';
import 'package:mifadeschats/services/database.dart';

import 'edit_meal_page.dart';
import 'meal_item.dart';

class MealsPage extends StatelessWidget {
  Widget _buildQuickMealButton(Database database, Size size) {
    return Positioned(
      bottom: size.height / 7,
      left: size.width / 1.5,
      child: AwesomeButton(
        blurRadius: 10.0,
        splashColor: Colors.orange[400],
        borderRadius: BorderRadius.circular(37.5),
        height: 40.0,
        width: 100,
        onTap: () async {
          await database.setMeal(Meal(
            id: documentUniqueId(),
            date: DateTime.now(),
            comment: '',
          ));
        },
        color: Colors.orange[600],
        child: Text(
          "Miam",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 22.0,
          ),
        ),
      ),
    );
  }

  Widget _buildGreatMealButton(
      BuildContext context, Database database, Size size) {
    return Positioned(
      child: AwesomeButton(
        blurRadius: 10.0,
        splashColor: Theme.of(context).buttonColor,
        borderRadius: BorderRadius.circular(37.5),
        height: 40.0,
        width: 100,
        onTap: () {
          EditMealPage.show(context: context, database: database);
        },
        color: Colors.orange[600],
        child: Text(
          "Miam",
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontFamily: 'Apercu',
            fontSize: 14,
          ),
        ),
      ),
      bottom: size.height / 9,
      left: size.width / 9,
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(
          Format.date(new DateTime.now()),
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: ResponsiveSafeArea(builder: (context, size) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            _buildContents(context, database),
            _buildQuickMealButton(database, size),
          ],
        );
      }),
    );
  }

  Widget _buildContents(BuildContext context, Database database) {
    final databe = Provider.of<Database>(context);
    return StreamBuilder<List<Meal>>(
      stream: databe.mealsStream(pet: null),
      builder: (context, snapshot) {
        return ListItemBuilder<Meal>(
          snapshot: snapshot,
          itemBuilder: (context, model) {
            return MealItem(
              meal: model,
              onDelete: () async {
                await database.deleteMeal(model);
              },
            );
          },
        );
      },
    );
  }
}
