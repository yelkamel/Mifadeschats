import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mifadeschats/services/auth.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<UserAuth> _signIn(Future<UserAuth> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<UserAuth> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<UserAuth> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);

  Future<UserAuth> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);

  Future<UserAuth> signInWithAppleStore() async =>
      await _signIn(auth.signInWithAppleStore);
}
