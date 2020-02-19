import 'package:flutter/material.dart';

import 'email_sign_in_form_bloc_based.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'Connexion',
          style: TextStyle(
            fontFamily: 'Apercu',
          ),
        ),
        elevation: 2.0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: Theme.of(context).cardTheme.elevation,
            color: Theme.of(context).cardTheme.color,
            margin: Theme.of(context).cardTheme.margin,
            child: EmailSignInFormBlocBased.create(context),
          ),
        ),
      ),
    );
  }
}
