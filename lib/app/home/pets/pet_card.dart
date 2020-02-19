import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/models/pet.dart';
import 'package:mifadeschats/services/storage.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

import 'pet_list_item.dart';

class PetCardItem extends StatefulWidget {
  const PetCardItem({
    Key key,
    @required this.pet,
    this.onTap,
    this.active = false,
    this.storage,
  }) : super(key: key);
  final Pet pet;
  final VoidCallback onTap;
  final bool active;
  final Storage storage;

  static Widget emptyContent(BuildContext context, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        color: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              color: Colors.orange[900],
              size: 80,
            ),
          ],
        ),
      ),
    );
  }

  @override
  _PetCardItemState createState() => _PetCardItemState();
}

class _PetCardItemState extends State<PetCardItem> {
  bool _loading = true;
  String _photoUrl;

  @override
  void initState() {
    widget.storage.loadImage('/images/pets/${widget.pet.id}.png').then((res) {
      setState(() {
        _loading = false;
        _photoUrl = res;
      });
    });
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      child: PetlistItem(pet: widget.pet, onTap: widget.onTap),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double blur = widget.active ? 30 : 0;
    final double offset = widget.active ? 20 : 0;
    final double top = widget.active ? 200 : 300;
    return PimpedButton(
      particle: RectangleDemoParticle(),
      pimpedWidgetBuilder: (context, controller) {
        return GestureDetector(
          onTap: () {
            controller.forward(from: 0.0);
            widget.onTap();
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            margin: EdgeInsets.only(top: top, bottom: 200, right: 50),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: _photoUrl != null
                      ? NetworkImage(_photoUrl)
                      : NetworkImage(
                          "https://i.pinimg.com/originals/9d/6c/b4/9d6cb4c732adfa42ed4887e74f20fe3e.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black87,
                      blurRadius: blur,
                      offset: Offset(offset, offset))
                ]),
            child: _buildContent(context),
          ),
        );
      },
    );
  }
}
