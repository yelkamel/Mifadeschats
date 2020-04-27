import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mifadeschats/app/sign_in/auth_bloc_provider.dart';
import 'package:mifadeschats/utils/constants.dart';

class SignInWaitEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = AuthBlocProvider.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            Constants.sentEmail,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontFamily: "Apercu",
            ),
          ),
          SizedBox(height: 5),
          Text(
            authBloc.getEmail,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontFamily: "Apercu",
            ),
          ),
          Lottie.asset("assets/animation/lottie/email-cat.json"),
        ],
      ),
    );
  }
}
