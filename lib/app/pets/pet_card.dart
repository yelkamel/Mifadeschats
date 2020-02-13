import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/app/home/models/pet.dart';
import 'package:mifadeschats/app/pets/pet_list_item.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

class PetCardItem extends StatelessWidget {
  const PetCardItem({Key key, @required this.pet, this.onTap})
      : super(key: key);
  final Pet pet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PimpedButton(
      particle: RectangleDemoParticle(),
      pimpedWidgetBuilder: (context, controller) {
        return GestureDetector(
          onTap: () {
            controller.forward(from: 0.0);
            onTap();
          },
          child: Card(
              elevation: 8,
              color: Colors.white70,
              margin: EdgeInsets.all(30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(children: <Widget>[
                      PetlistItem(pet: pet, onTap: onTap),
                    ]),
                  ),
                ],
              )),
        );
      },
    );
  }
}
