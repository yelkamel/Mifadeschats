import 'package:flutter/material.dart';
import 'package:mifadeschats/components/lottie_loading.dart';
import 'package:mifadeschats/models/user.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:provider/provider.dart';

import 'home/home_page.dart';
import 'onboarding/on_boarding.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    final user = Provider.of<User>(context);

    print('LandingPage:');
    if (user == null) {
      return LottieLoading(
        width: 150,
        height: 150,
      );
    }
    if (user.mifaId == null) {
      return OnBoarding();
    }
    database.setMifaId(user.mifaId);

    return HomePage();
  }
}
