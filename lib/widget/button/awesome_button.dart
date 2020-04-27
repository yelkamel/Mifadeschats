import 'package:flutter/material.dart';
import 'package:mifadeschats/widget/button/touchable_particule.dart';

class AwesomeButton extends StatelessWidget {
  AwesomeButton(
      {this.height,
      this.width,
      this.color,
      this.child,
      this.onTap,
      this.borderRadius,
      this.splashColor,
      this.blurRadius = 10.0});
  @required
  final double height;
  @required
  final double width;
  @required
  final Color color;
  @required
  final Widget child;
  @required
  final GestureTapCallback onTap;
  @required
  final BorderRadius borderRadius;
  @required
  final Color splashColor;
  @required
  final double blurRadius;

  @override
  Widget build(BuildContext context) {
    return TouchableParticule(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Material(
          type: MaterialType.transparency,
          child: child,
        ),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey : color,
          borderRadius: borderRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: onTap == null ? Colors.grey : color,
              blurRadius: blurRadius,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
      ),
    );
  }
}
