import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mifadeschats/app/home/models/pet.dart';
import 'package:mifadeschats/app/pets/edit_pet_page.dart';
import 'package:mifadeschats/app/pets/pet_card.dart';
import 'package:mifadeschats/common_widgets/button/awesome_button.dart';
import 'package:mifadeschats/common_widgets/list/list_items_builder.dart';
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

/*
  Future<void> _addPet(context) async {
    try {
      final database = Provider.of<Database>(context);
      print("addpestts");
      await database.setPet(
        Pet(
          id: 'tete',
          name: 'Fiouu',
          gender: 'male',
        ),
      );
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation Failed',
        exception: e,
      ).show(context);
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
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
          lastItem: Padding(
            padding: EdgeInsets.all(20),
            child: AwesomeButton(
              blurRadius: 10.0,
              splashColor: Colors.orange[400],
              borderRadius: BorderRadius.circular(37.5),
              height: 40.0,
              onTap: () => EditPetPage.show(
                context,
                database: Provider.of<Database>(context),
              ),
              color: Colors.orange[600],
              child: Text(
                "Ajouter un chat ?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          itemBuilder: (context, pet) => PetCardItem(
              pet: pet,
              onTap: () {
                /// PetMealsPage.show(context, pet),
                EditPetPage.show(context, database: database, pet: pet);
              }),
        );
      },
    );
  }
}
