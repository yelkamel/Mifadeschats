import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mifadeschats/widget/list/carrousel_items_builder.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/models/pet.dart';

import 'package:mifadeschats/app/home/pets/edit_pet_page.dart';
import 'package:mifadeschats/app/home/pets/pet_card.dart';
import 'package:mifadeschats/widget/platform_exception_alert_dialog.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
      final mifa = Provider.of<Mifa>(context);

      await database.deletePet(mifa.id, pet);
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    final mifa = Provider.of<Mifa>(context);

    return FutureBuilder<List<Pet>>(
        future: database.getPetFromMifa(mifa.id),
        builder: (context, snapshot) {
          return CarouselItemBuilder(
            snapshot: snapshot,
            itemBuilder: (context, item, active) {
              return PetCardItem(
                pet: item,
                active: active,
                onTap: () {
                  EditPetPage.show(context, pet: item);
                },
              );
            },
            firstItem: _buildTagPage(context),
            lastItem: PetCardItem.emptyContent(
              context,
              () => EditPetPage.show(context, pet: null),
            ),
          );
        });
  }
}

Widget _buildTagPage(BuildContext context) {
  final mifa = Provider.of<Mifa>(context);

  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'Les  ',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Apercu',
                color: Theme.of(context).primaryColor,
              ),
            ),
            RotateAnimatedTextKit(
              totalRepeatCount: 4,
              pause: Duration(milliseconds: 1000),
              text: ['chats', 'chiens', 'hamsters', 'oiseaux'],
              textStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Apercu',
                color: Theme.of(context).primaryColor,
              ),
              displayFullTextOnTap: true,
            ),
          ],
        ),
        Text(
          'de la mifa ${mifa.name}',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Apercu',
            fontSize: 26,
          ),
        )
      ],
    ),
  );
}
