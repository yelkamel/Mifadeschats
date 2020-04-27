import 'package:flutter/widgets.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

class TouchableParticule extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final Duration delay;

  TouchableParticule({
    this.onTap,
    this.child,
    this.delay = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return PimpedButton(
      particle: RectangleDemoParticle(),
      pimpedWidgetBuilder: (context, controller) {
        return GestureDetector(
          onTap: () {
            controller.forward(from: 0.0);
            new Future.delayed(delay, onTap);
          },
          child: child,
        );
      },
    );
  }
}
