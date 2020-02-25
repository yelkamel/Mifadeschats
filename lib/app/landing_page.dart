import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:mifadeschats/services/storage.dart';
import 'package:provider/provider.dart';
import 'package:mifadeschats/app/sign_in/sign_in_page.dart';
import 'package:mifadeschats/services/auth.dart';

import 'home/home_page.dart';
import 'onboarding/on_boarding.dart';

class LandingPage extends StatelessWidget {
  final FirebaseApp app;

  const LandingPage({Key key, this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            return Provider<User>.value(
              value: user,
              child: MultiProvider(
                providers: [
                  Provider<Database>(
                    create: (_) => FirestoreDatabase(uid: user.uid),
                  ),
                  Provider<Storage>(
                    create: (_) => FirestoreStorage(app: app),
                  ),
                ],
                child: OnBoarding(),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
