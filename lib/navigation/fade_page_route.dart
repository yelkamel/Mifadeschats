import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder {
  final Widget screen;

  FadePageRoute({this.screen})
      : super(
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              var begin = Offset(0.0, 1.0);
              var end = Offset.zero;
              var tween = Tween(begin: begin, end: end);
              var offsetAnimation = animation.drive(tween);

/*
              animation = CurvedAnimation(
                parent: animation,
                curve: Curves.elasticInOut,
              );
              */

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return screen;
            });
}
