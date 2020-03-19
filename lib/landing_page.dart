import 'package:flutter/material.dart';
import 'package:mifadeschats/app/home/home_page.dart';
import 'package:mifadeschats/app/onboarding/on_boarding.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/models/user.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _loading = true;
  Mifa _mifa = null;

  @override
  void didChangeDependencies() async {
    final database = Provider.of<Database>(context);
    final user = Provider.of<User>(context);

    var mifa = await database.getMifa(user.mifaId);
    setState(() {
      _loading = false;
      _mifa = mifa;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('LandingPage');

    final database = Provider.of<Database>(context);
    final user = Provider.of<User>(context);

    if (user == null || user.mifaId == null) {
      return OnBoarding(database: database);
    }

    if (_loading) {
      return Center(
          child: Container(
        height: 200,
        width: 200,
        child: CircularProgressIndicator(),
      ));
    }

    return StreamProvider<Mifa>(
      initialData: _mifa,
      create: (_) => database.mifaStream(user.mifaId),
      child: HomePage(),
    );
  }
}
