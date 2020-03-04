import 'package:flutter/material.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/models/user.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:provider/provider.dart';

import 'home/home_page.dart';
import 'onboarding/on_boarding.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('LandingPage');

    final database = Provider.of<Database>(context);
    final user = Provider.of<User>(context);

    if (user == null || user.mifaId == null) {
      return OnBoarding(database: database);
    }

    return StreamProvider<Mifa>(
      create: (context) => database.mifaStream(user.mifaId),
      child: HomePage(),
    );
  }
}
