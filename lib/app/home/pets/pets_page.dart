import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mifadeschats/models/pet.dart';
import 'package:mifadeschats/app/home/pets/edit_pet_page.dart';
import 'package:mifadeschats/app/home/pets/pet_card.dart';
import 'package:mifadeschats/common_widgets/platform_exception_alert_dialog.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:provider/provider.dart';

class PetsPage extends StatefulWidget {
  @override
  _PetsPageState createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  final PageController _ctrl = PageController(viewportFraction: 0.8);

  int currentPage = 0;

  @override
  void initState() {
    _ctrl.addListener(() {
      int next = _ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

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
          List slideList = snapshot.data.toList();

          return PageView.builder(
              controller: _ctrl,
              itemCount: slideList.length + 2,
              itemBuilder: (context, index) {
                bool active = index == currentPage;
                if (index == 0) {
                  return _buildTagPage();
                } else {
                  Pet pet = index != slideList.length + 1
                      ? slideList[index - 1]
                      : null;
                  return PetCardItem(
                      pet: pet,
                      active: active,
                      onTap: () {
                        /// PetMealsPage.show(context, pet),
                        EditPetPage.show(context, database: database, pet: pet);
                      });
                }
              });
        });
  }
}

Widget _buildTagPage() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Les chats\n de la mifa',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.orange[900],
          ),
        ),
      ],
    ),
  );
}
