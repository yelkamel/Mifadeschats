import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:mifadeschats/app/home/pets/edit_pet_page.dart';
import 'package:mifadeschats/components/animation/fade_in.dart';
import 'package:mifadeschats/components/button/awesome_button.dart';
import 'package:mifadeschats/components/reponsive_safe_area.dart';
import 'package:mifadeschats/models/user.dart';
import 'package:mifadeschats/services/database.dart';

import 'cat_lottie_bouncing.dart';
import 'fade_text_input.dart';
import 'mifa_selector.dart';

class OnBoarding extends StatefulWidget {
  final Database database;

  const OnBoarding({Key key, this.database}) : super(key: key);
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

Map<int, Map<String, String>> formText = {
  0: {
    "firstText": 'Bonjour et bienvenu',
    "secondText": "Comment vous vous appelez ?",
    "placeHolder": "Prenom"
  },
  1: {
    "firstText": 'Votre mifa code',
    "secondText": "",
    "placeHolder": "ex: Drogo de paname"
  },
};

class _OnBoardingState extends State<OnBoarding>
    with SingleTickerProviderStateMixin {
  double lottieSize = 120;
  String _name;
  String _mifaName;
  int _step = 0;
  PageController _ctrl = PageController(viewportFraction: 1);
  final FlareControls controls = FlareControls();

  bool validation(int curretStep) {
    switch (curretStep) {
      case 0:
        return _name != null && _name.length > 1;
      case 1:
        return _mifaName != null;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      /*
      int next = _ctrl.page.round();
      if (_step != next) {
        setState(() {
          _step = next;
        });
      }
      */
    });
  }

  void onChanged(String value) {
    setState(() {
      switch (_step) {
        case 0:
          _name = value;
          break;
        case 1:
          _mifaName = value;
          break;
        default:
      }
    });
  }

  void goBack() {
    _ctrl.previousPage(
      curve: Curves.easeIn,
      duration: Duration(seconds: 1),
    );
    controls.play("Animations");
    setState(() {
      _step = _step - 1;
      // widget.database.setUser(User(
      //  name: _name,
      //  mifaId: _mifaName,
      //));
    });
  }

  void onSubmitEditing() {
    if (validation(_step)) {
      _ctrl.nextPage(
        curve: Curves.easeIn,
        duration: Duration(seconds: 1),
      );
      controls.play("Animations");
      print("step$_step");
      setState(() {
        _step = _step + 1;
        // widget.database.setUser(User(
        //  name: _name,
        //  mifaId: _mifaName,
        //));
      });
    }
  }

  Widget _buildInsctructionText(position) {
    return FadeIn(
      delay: 0,
      duration: Duration(seconds: 1),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              formText[position]["firstText"],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Apercu',
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              formText[position]["secondText"],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Apercu',
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInputs(BuildContext context, int position, Size size) {
    if (position == 2) {
      return MifaSelector(
        mifaName: _mifaName,
        database: widget.database,
        goBack: () {
          _ctrl.previousPage(
            curve: Curves.easeIn,
            duration: Duration(seconds: 1),
          );
          setState(() {
            _step = _step - 1;
            _mifaName = "";
          });
        },
        onSelectMifa: (mifaId) {
          widget.database.setUser(User(
            name: _name,
            mifaId: mifaId,
          ));
        },
      );
    }

    if (position < 2) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: size.width * 0.7,
            child: FadeTextField(
              hintText: formText[position]["placeHolder"],
              onChanged: onChanged,
              onSubmitEditing: onSubmitEditing,
              unFocusOnSubmit: position == 1,
            ),
          ),
          if (position > 0)
            GestureDetector(
              onTap: goBack,
              child: Icon(
                Icons.arrow_drop_up,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
            )
        ],
      );
    }

    return AwesomeButton(
      blurRadius: 10.0,
      splashColor: Colors.orange[400],
      borderRadius: BorderRadius.circular(37.5),
      onTap: () => EditPetPage.show(context, pet: null),
      color: Colors.orange[600],
      child: Text(
        formText[position]["placeHolder"],
        style: TextStyle(
          color: Colors.white70,
          fontSize: 22.0,
          fontFamily: 'Apercu',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("onBoarding");
    return Scaffold(
      backgroundColor: Colors.orange[200],
      body: ResponsiveSafeArea(builder: (context, size) {
        return Stack(children: <Widget>[
          Positioned(
            top: size.height * 0.03,
            left: (size.width / 2) - (lottieSize / 2),
            child:
                CatLottieBouncing(lottieSize: lottieSize, controls: controls),
          ),
          Positioned(
            top: lottieSize + size.height * 0.07,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              child: PageView.builder(
                physics: new NeverScrollableScrollPhysics(),
                controller: _ctrl,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, position) {
                  print("PageView.builder");
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (_step < 2) _buildInsctructionText(position),
                      _buildInputs(context, position, size)
                    ],
                  );
                },
                itemCount: 3,
              ),
            ),
          ),
        ]);
      }),
    );
  }
}
