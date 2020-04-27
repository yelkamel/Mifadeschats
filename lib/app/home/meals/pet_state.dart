import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:provider/provider.dart';

enum PetStatus {
  Think,
  Angry,
  Done,
  NotAngry,
}

Map<PetStatus, String> FlareByStatus = {
  PetStatus.Angry: 'assets/animation/rive/angry-cat.flr',
  PetStatus.NotAngry: 'assets/animation/rive/bad-cat.flr',
  PetStatus.Think: 'assets/animation/rive/loading-cat.flr',
};

class PetState extends StatelessWidget {
  final FlareControls controls;

  const PetState({Key key, this.controls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mifa = Provider.of<Mifa>(context);

    var status = PetStatus.Angry;

    if (mifa.lastMealDate.add(Duration(hours: 6)).isAfter(DateTime.now())) {
      status = PetStatus.NotAngry;
    }

    return FlareActor(
      FlareByStatus[status],
      alignment: Alignment.center,
      fit: BoxFit.contain,
      controller: controls,
    );
  }
}
