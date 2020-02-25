import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class LottieLoading extends StatelessWidget {
  final double height;
  final double width;

  const LottieLoading({Key key, this.height, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Lottie.asset(
          'assets/lottie/loading-cat.json',
          width: width,
          height: height,
        ),
      ),
    );
  }
}
