import 'package:flutter/material.dart';

class BouncyPageRoute extends PageRouteBuilder {
  final Widget screen;

  BouncyPageRoute({this.screen})
      : super(
            transitionDuration: Duration(seconds: 2),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
                  
              animation = CurvedAnimation(
                parent: animation,
                curve: Curves.elasticInOut,
              );

              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return screen;
            });
}
