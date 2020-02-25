import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/models/pet.dart';

class PetlistItem extends StatelessWidget {
  const PetlistItem({Key key, @required this.pet, this.onTap, this.active})
      : super(key: key);
  final Pet pet;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: active ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: SizedBox(
        height: 100,
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.5],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                pet.name,
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.orange[300],
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Apercu',
                ),
              ),
              Image.asset(
                genderImages[pet.gender],
                height: 30,
                width: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
