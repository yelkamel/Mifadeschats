import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mifadeschats/app/sign_in/auth_bloc.dart';
import 'package:mifadeschats/app/sign_in/auth_bloc_provider.dart';
import 'package:mifadeschats/app/sign_in/sign_in_wait_email.dart';
import 'package:mifadeschats/widget/input/fade_text_input.dart';
import 'package:mifadeschats/widget/utils/reponsive_safe_area.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isCatVisible = false;
  AuthBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = AuthBlocProvider.of(context);
    this.initDynamicLinks();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isCatVisible = true;
      });
    });
  }

  @override
  void dispose() {
    // let bloc know to close all the streams
    _bloc.dispose();
    super.dispose();
  }

  void _authenticateUserWithEmail() {
    _bloc.sendSignInWithEmailLink().whenComplete(() => _bloc
        .storeUserEmail()
        .whenComplete(() => _bloc.changeAuthStatus(AuthStatus.emailLinkSent)));
  }

  @override
  Widget build(BuildContext context) {
    print("SignPage");

    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.orange[200],
        body: ResponsiveSafeArea(builder: (context, size) {
          return Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.1),
              Text(
                "Connexion",
                style: TextStyle(
                    fontFamily: "Apercu",
                    fontSize: 30,
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: size.height * 0.1),
              _buildForm(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder(
              stream: _bloc.authStatus,
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case (AuthStatus.emailAuth):
                    return _authForm(true);
                    break;
                  case (AuthStatus.phoneAuth):
                    return _authForm(false);
                    break;
                  case (AuthStatus.emailLinkSent):
                    return SignInWaitEmail();
                    break;
                  case (AuthStatus.isLoading):
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    // By default we will show the email auth form
                    return _authForm(true);
                    break;
                }
              })
        ],
      ),
    );
  }

  Widget _emailInputField(String error) {
    return FadeTextField(
      hintText: "Email",
      onChanged: _bloc.changeEmail,
      keyboardType: TextInputType.emailAddress,
      onSubmitEditing: _authenticateUserWithEmail,
      unFocusOnSubmit: true,
    );
  }

  Widget _authForm(bool isEmail) {
    return StreamBuilder(
      stream: _bloc.email,
      builder: (context, snapshot) {
        return Column(children: <Widget>[
          _emailInputField(snapshot.error),
          SizedBox(height: 32),
          Container(height: 100, child: _buildInputType(isEmail)),
        ]);
      },
    );
  }

  Widget _buildInputType(isEmail) {
    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      opacity: _isCatVisible ? 1 : 0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: _authenticateUserWithEmail,
            child: Lottie.asset("assets/animation/lottie/waiting-cat.json"),
          ),
        ],
      ),
    );
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    print("NEW LINK");

    if (deepLink != null) {
      print("=> deeplink: $deepLink");
      _bloc.changeAuthStatus(AuthStatus.isLoading);
      _bloc.signInWIthEmailLink(
          await _bloc.getUserEmailFromStorage(), deepLink.toString());
    }
  }
}
