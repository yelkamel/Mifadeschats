import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FadeTextField extends StatefulWidget {
  final String hintText;
  final Function onSubmitEditing;
  final Function onChanged;
  final bool unFocusOnSubmit;
  final TextInputType keyboardType;

  const FadeTextField(
      {Key key,
      this.hintText,
      this.onChanged,
      this.onSubmitEditing,
      this.unFocusOnSubmit = false,
      this.keyboardType})
      : super(key: key);

  @override
  _FadeTextFieldState createState() => _FadeTextFieldState();
}

class _FadeTextFieldState extends State<FadeTextField>
    with SingleTickerProviderStateMixin {
  final TextEditingController _fieldController = TextEditingController();
  final FocusNode _fieldFocusNode = FocusNode();
  AnimationController animationController;

  Animation<double> animationText;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animationText = Tween<double>(begin: 0, end: 1)
        .animate(animationController) // animationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) => {
                if (status == AnimationStatus.completed)
                  {FocusScope.of(context).requestFocus(_fieldFocusNode)}
              });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationText,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30.0,
            right: 30,
            bottom: 30,
          ),
          child: TextFormField(
            keyboardType: widget.keyboardType,
            controller: _fieldController,
            focusNode: _fieldFocusNode,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Apercu',
              fontSize: 28,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.orange[300]),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            obscureText: false,
            textInputAction: TextInputAction.next,
            onChanged: (value) => widget.onChanged(value),
            onEditingComplete: () {
              widget.onSubmitEditing();

              Timer(Duration(seconds: 1), () {
                if (widget.unFocusOnSubmit) {
                  _fieldFocusNode.unfocus();
                }
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    _fieldController.dispose();
    _fieldFocusNode.dispose();
    super.dispose();
  }
}
