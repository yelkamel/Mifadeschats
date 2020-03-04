import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CatLottieBouncing extends StatefulWidget {
  final double lottieSize;
  final FlareControls controls;

  const CatLottieBouncing({Key key, this.lottieSize, this.controls})
      : super(key: key);

  @override
  _CatLottieBouncingState createState() => _CatLottieBouncingState();
}

class _CatLottieBouncingState extends State<CatLottieBouncing>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animation = Tween<double>(begin: 0.2, end: 1).animate(animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.controls.play("Animations");
        }
      });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: SizedBox(
        height: widget.lottieSize,
        width: widget.lottieSize,
        child: FlareActor(
          'assets/lottie/loading-cat.flr',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          controller: widget.controls,
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
