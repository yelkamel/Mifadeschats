import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mifadeschats/app/landing_page.dart';
import 'package:mifadeschats/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Mifa Des Chats',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}
