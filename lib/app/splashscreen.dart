import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/app/landing_page.dart';
import 'package:mifadeschats/models/user.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:mifadeschats/services/storage.dart';
import 'package:provider/provider.dart';
import 'package:mifadeschats/app/sign_in/sign_in_page.dart';
import 'package:mifadeschats/services/auth.dart';

class SplashScreen extends StatelessWidget {
  final FirebaseApp app;

  const SplashScreen({Key key, this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    print('SplashScreen');

    return StreamBuilder<UserAuth>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserAuth userAuth = snapshot.data;
          if (userAuth == null) {
            return SignInPage.create(context);
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
    );
  }
}
