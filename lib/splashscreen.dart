import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/app/sign_in/auth_bloc_provider.dart';
import 'package:mifadeschats/landing_page.dart';
import 'package:mifadeschats/models/user.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:provider/provider.dart';
import 'package:mifadeschats/app/sign_in/sign_in_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('SplashScreen');

    final authbloc = AuthBlocProvider.of(context);

    return StreamBuilder(
      stream: authbloc.onAuthStateChanged(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser userAuth = snapshot.data;
          if (userAuth == null) {
            return SignInPage();
          }

          final Database database = FirestoreDatabase(uid: userAuth.uid);

          return MultiProvider(
            providers: [
              Provider<Database>(
                create: (_) => database,
              ),
              StreamProvider<User>(
                create: (_) => database.userStream(),
              ),
            ],
            child: LandingPage(),
          );
        } else {
          return Scaffold(
            body: Center(
              child: SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );

    /*

    return StreamBuilder<UserAuth>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserAuth userAuth = snapshot.data;
          if (userAuth == null) {
            return SignInPage();
          }

          final Database database = FirestoreDatabase(uid: userAuth.uid);

          return Provider<UserAuth>(
            create: (_) => userAuth,
            child: MultiProvider(
              providers: [
                Provider<Database>(
                  create: (_) => database,
                ),
                Provider<Storage>(
                  create: (_) => FirestoreStorage(app: app),
                ),
                StreamProvider<User>(
                  create: (_) => database.userStream(),
                ),
              ],
              child: LandingPage(),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );*/
  }
}
