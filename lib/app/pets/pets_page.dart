import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mifadeschats/app/home/pet_meals/pet_meal_page.dart';
import 'package:mifadeschats/app/home/models/pet.dart';
import 'package:mifadeschats/app/pets/edit_pet_page.dart';
import 'package:mifadeschats/app/pets/list_items_builder.dart';
import 'package:mifadeschats/app/pets/pet_list_item.dart';
import 'package:mifadeschats/common_widgets/platform_exception_alert_dialog.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:provider/provider.dart';

class PetsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Pet pet) async {
    try {
      final database = Provider.of<Database>(context);
      await database.deletePet(pet);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'une Erreur est survenu',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _addPet(context) async {
    try {
      final database = Provider.of<Database>(context);
      print("addpestts");
      await database.setPet(
        Pet(
          id: 'tete',
          name: 'Fiouu',
          gender: gender.male.toString(),
        ),
      );
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation Failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pets Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EditPetPage.show(
              context,
              database: Provider.of<Database>(context),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Pet>>(
      stream: database.petsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Pet>(
          snapshot: snapshot,
          itemBuilder: (context, pet) => Dismissible(
            key: Key("pet-${pet.id}"),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, pet),
            child: PetlistItem(
              pet: pet,
              onTap: () => PetMealsPage.show(context, pet),
            ),
          ),
        );
      },
    );
  }
}
