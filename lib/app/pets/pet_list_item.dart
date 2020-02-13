import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/app/home/models/pet.dart';

class PetlistItem extends StatelessWidget {
  const PetlistItem({Key key, @required this.pet, this.onTap})
      : super(key: key);
  final Pet pet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            pet.name,
            style: TextStyle(fontSize: 26),
          ),
          Column(
            children: <Widget>[
              Image.asset(
                genderImages[pet.gender],
                height: 30,
                width: 30,
              ),
            ],
          )
        ],
      ),
    );
  }
}
