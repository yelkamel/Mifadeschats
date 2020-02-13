import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/models/pet.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

import 'pet_list_item.dart';

class PetCardItem extends StatelessWidget {
  const PetCardItem({
    Key key,
    @required this.pet,
    this.onTap,
    this.active,
  }) : super(key: key);
  final Pet pet;
  final VoidCallback onTap;
  final bool active;

  Widget _buildContent() {
    if (pet == null) {
      return Card(
        elevation: 8,
        color: Colors.orangeAccent,
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
      );
    }

    return Column(
      children: <Widget>[
        Container(
          child: Column(children: <Widget>[
            PetlistItem(pet: pet, onTap: onTap),
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;
    return PimpedButton(
      particle: RectangleDemoParticle(),
      pimpedWidgetBuilder: (context, controller) {
        return GestureDetector(
          onTap: () {
            controller.forward(from: 0.0);
            onTap();
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            margin: EdgeInsets.only(top: top, bottom: 300, right: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: pet != null
                    ? DecorationImage(
                        image: NetworkImage(
                            "https://2.bp.blogspot.com/-o_DFLk2oLLM/UDkRZ4UaD3I/AAAAAAAABEo/tils0p1nS4Y/s1600/Sweeson%27s+Vanir_9.jpg"),
                        fit: BoxFit.cover,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black87,
                      blurRadius: blur,
                      offset: Offset(offset, offset))
                ]),
            child: _buildContent(),
          ),
        );
      },
    );
  }
}
