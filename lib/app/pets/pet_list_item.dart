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
    return ListTile(
      title: Text(pet.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
