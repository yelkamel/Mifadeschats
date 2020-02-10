import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/app/home/models/pet.dart';
import 'package:mifadeschats/app/home/models/meal.dart';
import 'package:mifadeschats/app/pets/edit_pet_page.dart';
import 'package:mifadeschats/app/pets/list_items_builder.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:provider/provider.dart';

import 'meal_list_item.dart';
import 'meal_page.dart';

class PetMealsPage extends StatelessWidget {
  final Database database;
  final Pet pet;

  PetMealsPage({@required this.database, @required this.pet});

  static Future<void> show(BuildContext context, Pet pet) async {
    final Database database = Provider.of<Database>(context);

    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => PetMealsPage(database: database, pet: pet),
      ),
    );
  }

  Future<void> _deleteMeal(BuildContext context, Meal meal) async {
    //try {
    await database.deleteMeal(meal);
    /* } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Pet>(
        stream: database.petStream(
          petId: pet.id,
        ),
        builder: (context, snapshot) {
          final pet = snapshot.data;
          final petName = pet?.name ?? '';

          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(petName),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () =>
                      EditPetPage.show(context, database: database, pet: pet),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => MealPage.show(
                      context: context, database: database, pet: pet),
                ),
              ],
            ),
            body: _buildContent(context, pet),
          );
        });
  }

  Widget _buildContent(BuildContext context, Pet pet) {
    return StreamBuilder<List<Meal>>(
      stream: database.mealsStream(pet: pet),
      builder: (context, snapshot) {
        return ListItemBuilder<Meal>(
          snapshot: snapshot,
          itemBuilder: (context, meal) {
            return DismissibleMealListItem(
              key: Key('entry-${meal.id}'),
              meal: meal,
              pet: pet,
              onDismissed: () => _deleteMeal(context, meal),
              onTap: () => MealPage.show(
                context: context,
                database: database,
                pet: pet,
                meal: meal,
              ),
            );
          },
        );
      },
    );
  }
}
