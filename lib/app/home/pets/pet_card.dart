import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/components/button/touchable_particule.dart';
import 'package:mifadeschats/models/pet.dart';
import 'package:mifadeschats/services/storage.dart';
import 'package:provider/provider.dart';

import 'pet_list_item.dart';

class PetCardItem extends StatefulWidget {
  const PetCardItem({
    Key key,
    @required this.pet,
    this.onTap,
    this.active = false,
  }) : super(key: key);
  final Pet pet;
  final VoidCallback onTap;
  final bool active;

  static Widget emptyContent(BuildContext context, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          height: 400,
          width: 300,
          child: Card(
            elevation: 8,
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.orange[900],
                  size: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  _PetCardItemState createState() => _PetCardItemState();
}

class _PetCardItemState extends State<PetCardItem> {
  bool _loading = true;
  String _photoUrl =
      "https://i.pinimg.com/originals/9d/6c/b4/9d6cb4c732adfa42ed4887e74f20fe3e.png";

  @override
  void initState() {}

  @override
  void didChangeDependencies() async {
    final storage = Provider.of<Storage>(context);

    storage.loadImage('/images/pets/${widget.pet.id}.png').then((res) {
      setState(() {
        _loading = false;
        _photoUrl = res;
      });
    }).catchError((error) {
      print('=>Error:Pas de photo de chat');
    });
  }

  @override
  Widget build(BuildContext context) {
    final double blur = widget.active ? 30 : 0;
    final double offset = widget.active ? 20 : 0;
    final double top = widget.active ? 100 : 200;

    return TouchableParticule(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 200, right: 40),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(_photoUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black87,
                  blurRadius: blur,
                  offset: Offset(offset, offset))
            ]),
        child: PetlistItem(
          pet: widget.pet,
          onTap: widget.onTap,
          active: widget.active,
        ),
      ),
    );
  }
}
